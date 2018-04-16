import Html exposing (..)
import Html.Events exposing (..)
import Char exposing (fromCode)
import WebSocket
import Helpers exposing (..)
import Keyboard exposing (downs, KeyCode)
import String
import Result exposing (withDefault)
import Json.Decode exposing (..)

import String

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

host : String
host = "ws://127.0.0.1:3000/ws"

-- MODEL

type alias Model =
  {
    message : String,
    clientName : String
  }


init : (Model, Cmd Msg)
init =
  (Model "" "", Cmd.none)


-- UPDATE

type Msg
  = NewMessage String
  | KeyPressed KeyCode


update : Msg -> Model -> (Model, Cmd Msg)
update msg {message, clientName} =
  case msg of
    KeyPressed key ->
      (Model message clientName, WebSocket.send host ("{\"Author\":\"" ++ clientName ++"\",\"Body\":\"" ++ toString ( fromCode key ) ++ "\"}") )

    NewMessage str ->
      (Model (withDefault "" (decodeString (field "Body" string) str)) (withDefault "" (decodeString (field "Author" string) str)), Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch[ Keyboard.downs KeyPressed, WebSocket.listen host NewMessage]


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ div [] [ text (String.append "You are: "  model.clientName ) ]
    , div [] [ text (String.append ""  model.message ) ]
    ]


viewMessage : Float -> Html msg
viewMessage msg =
  div [] [ text ( toString msg ) ]
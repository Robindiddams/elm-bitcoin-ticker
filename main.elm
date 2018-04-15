import Html exposing (..)
import Html.Events exposing (..)
import WebSocket
import Helpers exposing (..)
import Keyboard exposing (downs, KeyCode)

import String

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

host : String
host = "ws://127.0.0.1:3000"

-- MODEL

type alias Model =
  { message : String}


init : (Model, Cmd Msg)
init =
  (Model "", Cmd.none)


-- UPDATE

type Msg
  = NewMessage String
  | KeyPressed KeyCode


update : Msg -> Model -> (Model, Cmd Msg)
update msg {message} =
  case msg of
    KeyPressed key ->
      (Model message, WebSocket.send host "{\"Author\":\"Robin\"\"Body\":\"Hello\"}" )

    NewMessage str ->
      (Model str, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch[ Keyboard.downs KeyPressed, WebSocket.listen "wss://ws-feed.gdax.com" NewMessage]


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ div [] [ text (String.append "Message: "  model.message ) ]
    -- , div [] [ text (String.append "Moving Average: " ( toString ( average model.messages ) ) ) ]
    -- , button [onClick Start] [text "Start"]
    -- , button [onClick Stop] [text "Stop"]
    ]


viewMessage : Float -> Html msg
viewMessage msg =
  div [] [ text ( toString msg ) ]
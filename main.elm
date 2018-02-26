import Html exposing (..)
import Html.Events exposing (..)
import WebSocket
import Helpers exposing (..)

import String

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { price : String
  , messages : List Float
  }


init : (Model, Cmd Msg)
init =
  (Model "" [], Cmd.none)


-- UPDATE

type Msg
  = Start
  | Stop
  | NewMessage String


update : Msg -> Model -> (Model, Cmd Msg)
update msg {price, messages} =
  case msg of
    Start ->
      (Model "" messages, WebSocket.send "wss://ws-feed.gdax.com" "{\"type\": \"subscribe\", \"product_ids\": [\"BTC-USD\"], \"channels\": [ {\"name\": \"ticker\", \"product_ids\": [\"BTC-USD\"]}]}")
      
    Stop ->
      (Model "" messages, WebSocket.send "wss://ws-feed.gdax.com" "{\"type\": \"unsubscribe\", \"product_ids\": [\"BTC-USD\"], \"channels\": [ {\"name\": \"ticker\", \"product_ids\": [\"BTC-USD\"]}]}")

    NewMessage str ->
      (Model ( parse str ) ( safelyConcatList messages (parse str) ) , Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen "wss://ws-feed.gdax.com" NewMessage


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ div [] [ text (String.append "Current Price: "  model.price ) ]
    , div [] [ text (String.append "Moving Average: " ( toString ( average model.messages ) ) ) ]
    , button [onClick Start] [text "Start"]
    , button [onClick Stop] [text "Stop"]
    , div [] [ text "Recent Prices: " ]
    , div [] (List.map viewMessage model.messages)
    ]


viewMessage : Float -> Html msg
viewMessage msg =
  div [] [ text ( toString msg ) ]
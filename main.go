package main

import (
	"net/http"

	"github.com/Robindiddams/elm-bitcoin-ticker/wordplay"

	"golang.org/x/net/websocket"
)

type Message struct {
	Author string
	Body   string
}

func main() {
	// set word
	wordToGuess = wordplay.RandomWord()
	http.HandleFunc("/ws", broadcastHandler)
	http.ListenAndServe(":3000", nil)
}

func broadcastHandler(w http.ResponseWriter, req *http.Request) {
	s := websocket.Server{Handler: websocket.Handler(wsHandler)}
	s.ServeHTTP(w, req)
}

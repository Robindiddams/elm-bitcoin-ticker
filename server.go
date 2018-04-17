package main

import (
	"fmt"
	"time"

	"github.com/Robindiddams/elm-bitcoin-ticker/wordplay"
	"golang.org/x/net/websocket"
)

var clients []Client
var wordToGuess string

var wsHandler = websocket.Handler(onWsConnect)

func onWsConnect(ws *websocket.Conn) {
	defer ws.Close()
	client := NewClient(ws)
	client.Name = fmt.Sprintf("Player %d", len(clients)+1)
	clients = addClientAndGreet(clients, client)
	client.listen()
}

func broadcast(msg *Message) {
	fmt.Printf("Broadcasting %+v\n", msg)
	for _, c := range clients {
		c.ch <- msg
	}
}

func addClientAndGreet(list []Client, client Client) []Client {
	clients = append(list, client)
	client.ch <- &Message{
		Author: "Server",
		Body:   "welcome",
	}
	return clients
}

func clientWon(winnerName string) {
	broadcast(&Message{
		Author: "Server",
		Body:   fmt.Sprintf("%s won! The word was: %s", winnerName, wordToGuess),
	})
	time.Sleep(time.Second * 3)
	wordToGuess = wordplay.RandomWord()
}

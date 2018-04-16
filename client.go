package main

import (
	"fmt"
	"io"
	"log"
	"strings"

	"github.com/Robindiddams/elm-bitcoin-ticker/wordplay"

	"golang.org/x/net/websocket"
)

type Client struct {
	connection     *websocket.Conn
	ch             chan *Message
	close          chan bool
	Name           string
	guessedLetters []rune
}

func NewClient(ws *websocket.Conn) Client {
	ch := make(chan *Message, 100)
	close := make(chan bool)

	return Client{
		connection: ws,
		ch:         ch,
		close:      close,
	}
}

func (c *Client) listen() {
	go c.listenToWrite()
	c.listenToRead()
}

func (c *Client) listenToWrite() {
	for {
		select {
		case msg := <-c.ch:
			log.Println("Send:", msg)
			websocket.JSON.Send(c.connection, msg)

		case <-c.close:
			c.close <- true
			return
		}
	}
}

func (c *Client) listenToRead() {
	log.Println("Listening read from client")
	for {
		select {
		case <-c.close:
			c.close <- true
			return

		default:
			var msg Message
			err := websocket.JSON.Receive(c.connection, &msg)
			fmt.Printf("Received: %+v\n", msg)
			if err == io.EOF {
				fmt.Println("disconnection")
				c.close <- true
			} else if err != nil {
				// c.server.Err(err)
			} else {
				if !strings.ContainsRune(string(c.guessedLetters), rune(msg.Body[1])) {
					c.guessedLetters = append(c.guessedLetters, rune(msg.Body[1]))

				}
				obfuscatedWord := wordplay.ObfuscateWord(c.guessedLetters, wordToGuess)

				if !strings.Contains(obfuscatedWord, "?") {
					//player won
					clientWon(c.Name)
					c.guessedLetters = make([]rune, 0)
				} else {
					m := Message{
						Author: c.Name,
						Body:   fmt.Sprintf("hint: %s", obfuscatedWord),
					}
					c.ch <- &m
				}
			}
		}
	}
}

package wordplay

import (
	"math/rand"
	"strings"
	"time"
)

var words = []string{
	"hello",
	"goodbye",
	"golang",
	"elm",
}

// RandomWord returns one of a few specific words, randomly
func RandomWord() string {
	rand.Seed(time.Now().Unix())
	return strings.ToUpper(words[rand.Intn(len(words))])
}

// ObfuscateWord adds ? to word for unguessed letters
func ObfuscateWord(letters []rune, word string) string {
	cleanWord := make([]rune, len(word))
	for i, _ := range cleanWord {
		cleanWord[i] = '?'
	}
	for i, char := range word {
		for _, guessedChar := range letters {
			if guessedChar == char {
				cleanWord[i] = char
			}
		}
	}
	return string(cleanWord)
}

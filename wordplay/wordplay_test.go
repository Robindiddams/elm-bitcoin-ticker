package wordplay

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestObfuscatedWord(t *testing.T) {
	assert := assert.New(t)
	word := "hello world"
	guessedLetters := []rune{'h', 'l', 'o'}
	assert.Equal("h?llo??o?l?", ObfuscateWord(guessedLetters, word))
}

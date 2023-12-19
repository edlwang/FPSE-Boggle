# FPSE Boggle

An implementation of Boggle for the Functional Programming in Software Engineering final project.

## Installation

1. Install dependencies using `opam install . --deps-only --working-dir`
2. Build the program using `dune build`
3. Run the program 

    1. Use `dune exec -- ./src/aplusproject.exe [--time-limit TIME-LIMIT] [--board-size BOARD-SIZE] [--num-players NUM-PLAYERS]` for the standalone game.
    2. Use `dune exec -- ./src/aplusproject.exe [--solve BOARD]` to input a board as a string with no spaces and get all possible solutions. (The board in "Overview" would be represented as "itpermaysrehtubn")
    3. For client server, run the server with `dune exec -- ./src/server.exe [--time-limit TIME] [--board-size BOARD-SIZE]` and run the client with `dune exec -- ./src/client.exe <name> http://localhost:8080`
    4. additional flags can be found using `-h` with the executable

4. Test the program using `dune test` (NOTE: dictionary_tests is implemented but currently stalls all tests due to an unknown issue. When running on dune utop, the tests run fine. However, when dune test is run, the test runs forever. As a result, they are commented out)

## Overview

In this project, we implement the game Boggle in OCaml. Boggle is a game where players are presented with a grid of letters and words must be formed by sequences of letters that are connected to each other without using the same letter position twice. For example, if we have the following board:

```
+---+---+---+---+
| I | T | P | E |
+---+---+---+---+
| R | M | A | Y |
+---+---+---+---+
| S | R | E | H |
+---+---+---+---+
| T | U | B | N |
+---+---+---+---+
```

One word that could be solved for is ARM because all the letters are next to each other sequentially. An invalid word would be REAR since we use the same R twice in the word. The goal of the game is to find as many words as possible on the board, scoring points based on the length of the word. If multiple players get the same word, then those points cancel out and do not contribute to the players' scores. Only words that the player uniquely gets counts towards the score. The player with the most points wins.

The scoring is calculated from the length of the word:
0-2 letters: 0 pts
3-4 letters: 1 pt
5 letters: 2 pts
6 letters: 3 pts
7 letters: 5 pts
8+ letters: 7 pts

We plan on implementing the functionality of playing Boggle using dictionary APIs (Merriam-Webster) to check if words are valid as well as solvers for the game to find all possible words in a Boggle grid. This will be done using a data structure to hold all possible words (trie) and implement a non-trivial search algorithm on the game board. 

To extend the complexity of our project, we plan to make it possible for multiple players to compete to see who gets the most words possible and implement automatic scoring. We also want to allow users to ask for different types of hints for words that they haven't gotten yet (starts with this letter, look at this part of the board, this word's definition is _, etc). We could also control the generation of the board using more complicated methods such as using N-grams or English letter distributions to make the board more playable. 

### Disclaimer: 
words that are considered valid are derived from the dictionary.txt file in the top level directory. We have used a file with many words in the english language (370105 words), but there may be words missing, or words included that are real english words. Feel free to add and remove words in the file, or replace it entirely with your desired Boggle dictionary.

## Libraries

We plan to use Cohttp in order to pull data down from the dictionary API and Yojson to parse the JSON response. We are also using Lwt to handle promises.

## Mock Use

We are using the > symbol to denote what the user is inputting in the app
```
$ dune exec -- ./src/aplusproject.exe --time-limit 60 --board-size 5
Welcome to Boggle                   

Number of players: 1
Time limit: 60

Instructions (source: https://en.wikipedia.org/wiki/Boggle):
1. Each player will take turns finding words on the board
2. Words must be at least three letters long
3. Each letter after the first must be a horizontal, vertical, or diagonal neighbor of the one before it
4. No letter square may be used more than once within a single word
5. No capitalized or hyphenated words are allowed
6. The scoring is calculated from the length of the word:
    0-2 letters: 0 pts
    3-4 letters: 1 pt
    5 letters: 2 pts
    6 letters: 3 pts
    7 letters: 5 pts
    8+ letters: 7 pts

During your turn, the following commands can be used

- !done : end turn early
- !hint : obtain a hint (there are no penalties!)

+---+---+---+---+---+
| i | s | h | u | r |
+---+---+---+---+---+
| l | i | z | o | g |
+---+---+---+---+---+
| i | t | o | m | i |
+---+---+---+---+---+
| z | o | s | i | d |
+---+---+---+---+---+
| e | s | c | t | l |
+---+---+---+---+---+

Enter Player 1's Words (type !done to end turn):
Hit enter to start:     
You have 60 seconds to find words
> room
> rooms
> midig
> !hint
Hint: A thin skin membrane that covers and moves over an eye.
> eyelid
> lid
You got the hint!
> !done


Player 1 wins with the most points!

Player 1 Score: 3
- room          (1)
- rooms         (2)
- midig         (Not a word on the board)
- eyelid        (Not a word on the board)
- lid           (1)

Here are the top scoring words of the solution!

idiotish, idiotize, moistish, scotize, sosoish, cossid, dimiss, huzoor, iotize, itoism, itoist, limoid, 
otiose, ugroid, coost, cosse, dicot, digor, dimit, groom, groot, idiom, idiot, idism, idist, mohur, moist,
moose, moost, ogmic
```

## Implementation Order
Libraries (+ unit tests):
- Trie - Mason
- Ngram - Edward
- Dictionary - Edward
- Boggle - Mason, Edward
- Game - Mason, Edward

Game:
- Command line parsing - Edward
- Print game information - Mason
- User IO (commands and user input) - Edward
At this point the game should be fully functional without async waiting/timer part
- Asynchronous waiting - Mason

Reach Goals:
- Server running the game with two players connecting through terminal to play at the same time (Done)
- Frontend using ReScript (Not done)
- Use different language dictionaries to generate the boards (Done - Users can just input different language dictionary file)
# FPSE Boggle

An implementation of Boggle for the Functional Programming in Software Engineering final project.

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

We plan on implementing the functionality of playing Boggle using dictionary APIs (Merriam-Webster) to check if words are valid as well as solvers for the game to find all possible words in a Boggle grid. This will be done using a data structure to hold all possible words (trie) and implement a non-trivial search algorithm on the game board. 

To extend the complexity of our project, we plan to make it possible for multiple players to compete to see who gets the most words possible and implement automatic scoring. We also want to allow users to ask for different types of hints for words that they haven't gotten yet (starts with this letter, look at this part of the board, this word's definition is _, etc). We could also control the generation of the board using more complicated methods such as using N-grams or English letter distributions to make the board more playable. 

## Libraries

We plan to use Cohttp in order to pull data down from the dictionary API. 

## Mock Use

We are using the > symbol to denote what the user is inputting in the app

```
$ ./boggle.exe --num-players 2 --time-limit 180

--------------------------------------------------
------------ Game Start Instructions -------------
--------------------------------------------------

During your turn, the following commands can be used

- !done : end turn early
- !hint : obtain a hint

+---+---+---+---+
| I | T | P | E |
+---+---+---+---+
| R | M | A | Y |
+---+---+---+---+
| S | R | E | H |
+---+---+---+---+
| T | U | B | N |
+---+---+---+---+

--------------------------------------------------
------------------ User Gameplay -----------------
--------------------------------------------------

Enter Player 1s Words (type !done to end turn):
Hit enter to start
>
You have 3m0s to find as many words as possible
> pet
> tube
> hay
> tamers
> rim
> !

Enter Player 2s Words (type !done to end turn):
Hit enter to start
>
You have 3m0s to find as many words as possible
> timer
> yhn
> may
> !hint
    a long, hollow cylinder
> tube
    You got the hint!

--------------------------------------------------
------------ Final Results and Scoring -----------
--------------------------------------------------

Your time has run up!

Player 1 Wins!

Player 1 Score: 5
- pet       (invalid)
- tube      (duplicate)
- hay       (1)
- tamers    (3)
- rim       (1)

Player 2 Score: 3
- tube      (duplicate)
- timer     (2)
- yhn       (invalid)
- may       (1)

Players found 6 words out of 299 words for 9 points out of 425.
Here are some of the top scoring words:
- IMPARTS
- SURBEAT
- TRIMERA
...
```

## Implementation Order

Reach Goals:
- Server running the game with two players connecting through terminal to play at the same time
- Frontend using ReScript
- Use different language dictionaries to generate the boards
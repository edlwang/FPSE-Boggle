# FPSE Boggle

An implementation of Boggle for the Functional Programming in Software Engineering final project.

## Overview

In this project, we implement the game Boggle in OCaml. Boggle is a game where players are presented with a grid of letters and words must be formed by sequences of letters that are connected to each other. We plan on implementing the functionality of playing Boggle using dictionary APIs (Merriam-Webster) to check if words are valid as well as solvers for the game to find all possible words in a Boggle grid. This will be done using a data structure to hold all possible words (trie) and implement a non-trivial search algorithm on the game board. 

To extend the complexity of our project, we plan to make it possible for multiple players to compete to see who gets the most words possible and implement automatic scoring. We also want to allow users to ask for different types of hints for words that they haven't gotten yet (starts with this letter, look at this part of the board, this word's definition is _, etc). We could also control the generation of the board using more complicated methods such as using N-grams or English letter distributions to make the board more playable. 

## Libraries

We plan to use Cohttp in order to pull data down from the dictionary API. 
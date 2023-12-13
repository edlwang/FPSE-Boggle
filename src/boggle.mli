(* This module implements a representation of a Boggle board and the functions that would be associated with a Boggle board*)

open Trie
open Ngram
module Boggle: sig
  type t (* the type of a Boggle board; likely a functional array *) [@@deriving sexp]
  val create_board: ?init: string -> dist:Ngram.t -> int -> t (* Generates a board by weighting characters in the English language and then using bigrams*)
  val solve: t -> Trie.t -> string list (* find all words on the board *)
  val get_hint: string list -> string list -> (string * string) (* given a list of all the words on the board from the solver, and a list of words the user has already found, returns a pair of strings representing a new word and the hint for it *)
  val compute_scores: string list -> string list list -> (string * int * string) list list (* given a list of all possible words on the board, a list of list of user inputs, compute the score for each player's word and an explanation of the scoring for each word *)
  val print_board: t -> unit
end
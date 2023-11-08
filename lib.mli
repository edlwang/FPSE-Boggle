(* Boggle Module *)
  (* fun API call wrapper *)
  (* fun Create Trie *)
  (* fun Process player turn *)
  (* fun Compute all player scores *)
  (* fun Get hint (based on hint type) *)
  (* fun/module Board generation *)
(* Trie Module *)
  (* fun Insert word*)
  (* fun Lookup word*)


(*
1. Grab all dict words
2. Compute 2-grams
3. Generate board with random weights + common letter pairs
4. Generate Trie with all words
5. User 1 turn:
    Enter words
6. Other users' turns
7. Output each user's score and which words counted and why
*)


module Trie: sig
  type t
  val insert: t -> string -> t
  val is_word: t -> string -> bool
end

module Boggle: sig
  type t
  val create_board: ?board: string -> int -> t
  val solve: t -> string list (* find all words *)
  val get_hint: 
  val compute_scores
end

module Game : sig (* functor with parameters (time, size, players) *)
  val start_game
  val add_word
  val end_game
end

module Dictionary: sig
  val get_all_words
  val get_definitions
end

module Ngram: sig
  val make_distribution
  val get_random
  val get_next
end





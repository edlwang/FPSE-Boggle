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


module Ngram: sig
  type t
  val make_distribution: string list -> t
  val get_random: t -> string
  val get_next: string -> string
end





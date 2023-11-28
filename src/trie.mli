(* Trie module (prefix tree) to be used for storing words and efficiently computing which words can be found on the board *)
(* 
  If we insert words "app", "apple", and "append", the trie would be as follows:
  
                            'a'
                            /
                          'p' 
                           |
           (is_word=true) 'p'
                         /   \
                       'l'   'e'
                        |     |
        (is_word=true) 'e'   'n'
                              |
                             'd' (is_word=true)

*)
module Trie: sig
  (* module CharMap = Map.Make(Char) *)
  (* type t = {is_word: bool; children: (char, t, Core.Map.Make(Core.Char).Key.comparator_witness) Core.Map.t }Trie data type, likely a record like { is_word: bool; children: (char, t, char_cmp) Map.t } [@@deriving sexp] *)
  type t
  val empty: unit -> t (* Create empty trie *)
  val insert: t -> word:string -> t (* Inserts a word into the trie *)
  val is_word: t -> word:string -> bool (* Check if a given word exists in the trie *)
  val get_child: t -> char -> t option (* return the child of the root node that char maps to (wrapped in Some) if it exists, else None *)
end
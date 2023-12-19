(*
   module to compute useful data structures based on the dictionary file
   at build time rather than runtime
*)

val words : string list
val distribution : Ngram.Ngram.t
val trie : Trie.Trie.t

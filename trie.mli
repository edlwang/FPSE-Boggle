module Trie: sig
  type t
  val insert: t -> string -> t
  val is_word: t -> string -> bool
end
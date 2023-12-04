(* This module is a wrapper to interact with the dictionary API using Cohttp*)
module Dictionary: sig
  val get_all_words: unit -> string list (* Get all words in the english language *)
  val get_definition: string -> string option (* Get definition for a single word, returning either Some definition or None if the word isn't found *)
  val get_definitions: string list -> string option list (* Get definitions for selected words (those that we're giving hints for) *)
end
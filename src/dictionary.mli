(* This module is a wrapper to interact with the Merriam-Webster dictionary API using Cohttp*)
module Dictionary: sig
  val get_all_words: unit -> string list (* Get all words in the english language *)
  val get_definition: string -> string option
  val get_definitions: string list -> string list (* Get definitions for selected words (those that we're giving hints for) *)
end
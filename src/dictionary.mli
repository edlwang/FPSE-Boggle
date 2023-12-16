(* This module is a wrapper to interact with the dictionary API using Cohttp*)
module Dictionary: sig
  val get_all_words: string -> string list (* Get all words in the english language provided as a file *)
  val get_definition: string -> string option Lwt.t (* Get definition for a single word, returning either Some definition or None if the word isn't found *)
end
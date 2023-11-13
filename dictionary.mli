module Dictionary: sig
  val get_all_words: unit -> string list
  val get_definitions: string list -> string list
end
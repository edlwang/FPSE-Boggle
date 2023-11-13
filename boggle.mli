module Boggle: sig
  type t
  val create_board: ?board: string -> int -> t
  val solve: t -> string list (* find all words *)
  val get_hint: string list -> string
  val compute_scores: string list list -> (int * string list) list
end
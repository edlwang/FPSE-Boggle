(*
   Make_game functor takes in a parametrized module with a player number and time limit
    to create a game module with an appropriate "run" function
    The workflow in the main file will be to parse command line inputs, call the functor with appropriate inputs,
    and then call the run function in the resulting module
*)

(* Module type of Game that contains a single function to run the game *)
module type Game = sig
  val print_instructions : unit -> unit
  val get_user_words_async : string list -> string list Lwt.t
  val calculate_score : (string * int * string) list -> int
  val run : unit -> unit
end

(* Module type of Game_config which stores all the data involving the game configuration *)
module type Game_config = sig
  val players : int (* Number of players that are competing *)

  val time :
    int option (* The time limit players have to find words on the goard*)

  val size : int (* The size of the board *)
end

(*
   A functor that takes the game configruation and creates a module of type Game
   If we add more configuration options, this design pattern using a functor will easily allow us to update the game
   by extending the Game_config module type and updating the functor
*)
module Make_game (_ : Game_config) : Game

val solve : string -> unit

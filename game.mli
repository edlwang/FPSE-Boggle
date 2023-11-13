(* 
  Make_game functor takes in a parametrized module with a player number and time limit 
   to create a game module with an appropriate "run" function
*)
module type Game = sig
  val run: unit -> unit
end

module type Game_config = sig
  val players: int
  val time: int
end

module Make_game (_: Game_config): Game
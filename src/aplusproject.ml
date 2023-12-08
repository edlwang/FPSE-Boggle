open Core

let main (num_players : int option) (time_limit : int option) : _ =
  let module Config = struct
    let players = match num_players with Some v -> v | None -> 1
    let time = time_limit
  end in
  let module Boggle_game = Game.Make_game (Config) in
  Boggle_game.run ()

let command =
  Command.basic ~summary:"Play a game of Boggle!"
    ~readme:(fun () -> "More detailed information")
    (let%map_open.Command num_players =
       flag "--num-players" (optional int)
         ~doc:"NUM-PLAYERS Number of players playing the game"
     and time_limit =
       flag "--time-limit" (optional int)
         ~doc:"TIME-LIMIT Time limit for the game in seconds"
     in
     fun () -> main num_players time_limit)

let () = Command_unix.run ~version:"1.0" ~build_info:"RWO" command

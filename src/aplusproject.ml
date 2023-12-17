open Core

let main (solve : string option) (num_players : int option)
    (time_limit : int option) (board_size : int option) : _ =
  match solve with
  | Some board -> Game.solve board
  | None ->
      let module Config = struct
        let players = match num_players with Some v -> v | None -> 1
        let size = match board_size with Some v -> v | None -> 4
        let time = time_limit
      end in
      let module Boggle_game = Game.Make_game (Config) in
      Boggle_game.run ()

let command =
  Command.basic ~summary:"Play a game of Boggle!"
    ~readme:(fun () -> "More detailed information")
    (let%map_open.Command solve =
       flag "--solve" (optional string)
         ~doc:"SOLVE Board written as a string with no spaces"
     and num_players =
       flag "--num-players" (optional int)
         ~doc:"NUM-PLAYERS Number of players playing the game"
     and time_limit =
       flag "--time-limit" (optional int)
         ~doc:"TIME-LIMIT Time limit for the game in seconds"
     and board_size =
       flag "--board-size" (optional int) ~doc:"BOARD-SIZE Size of the board"
     in
     fun () -> main solve num_players time_limit board_size)

let () = Command_unix.run ~version:"1.0" ~build_info:"RWO" command

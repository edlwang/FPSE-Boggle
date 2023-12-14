open Core
open Boggle

let main (time_limit : int option) (board_size : int option) : _ =
  let size = match board_size with Some size -> size | None -> 4 in
  let time = match time_limit with Some time -> time | None -> -1 in
  let board = Boggle.create_board ~dist:Data.distribution size in
  Dream.run @@ Dream.logger
  @@ Dream.router
       [
         Dream.get "/" (fun _ ->
             Dream.respond
               (Sexp.List [ board |> Boggle.sexp_of_t; Int.sexp_of_t time ]
               |> Sexp.to_string));
         Dream.get "/solve" (fun _ ->
             Dream.respond
               (Boggle.solve board Data.trie |> String.concat ~sep:"\n"));
       ]

let command =
  Command.basic ~summary:"Start a Boggle server!"
    ~readme:(fun () -> "More detailed information")
    (let%map_open.Command time_limit =
       flag "--time-limit" (optional int)
         ~doc:"TIME-LIMIT Time limit for the game in seconds"
     and board_size =
       flag "--board-size" (optional int) ~doc:"BOARD-SIZE Size of the board"
     in
     fun () -> main time_limit board_size)

let () = Command_unix.run ~version:"1.0" ~build_info:"RWO" command

open Core
open Boggle
open Lwt.Syntax

let main (time_limit : int option) (board_size : int option) : _ =
  let size = match board_size with Some size -> size | None -> 4 in
  let time = match time_limit with Some time -> time | None -> -1 in
  let board = Boggle.create_board ~dist:Data.distribution size in
  let results = Hashtbl.create (module String) in
  let get_results _ =
    let response =
      Sexp.List
        [
          Sexp.Atom "results";
          ( results |> Hashtbl.to_alist |> fun l ->
            List.sexp_of_t
              (fun (k, v) ->
                Sexp.List [ Sexp.Atom k; List.sexp_of_t String.sexp_of_t v ])
              l );
        ]
    in
    Dream.respond (Sexp.to_string response)
  in
  let get_newgame _ =
    Dream.respond
      (Sexp.List
         [
           Sexp.Atom "newgame";
           Sexp.List [ board |> Boggle.sexp_of_t; Int.sexp_of_t time ];
         ]
      |> Sexp.to_string)
  in
  let get_allboardwords _ =
    let all_board_words = Boggle.solve board Data.trie in
    Sexp.List
      [
        Sexp.Atom "allboardwords";
        List.sexp_of_t String.sexp_of_t all_board_words;
      ]
    |> Sexp.to_string |> Dream.respond
  in
  let post_game req =
    let* body = Dream.body req in
    match Sexp.of_string body with
    | Sexp.List [ Sexp.Atom name; Sexp.List words ] -> (
        let str_list = List.map ~f:String.t_of_sexp words in
        match Hashtbl.add results ~key:name ~data:str_list with
        | `Ok -> get_results ()
        | `Duplicate ->
            Dream.respond ~status:`Bad_Request
              (Sexp.to_string (Sexp.Atom "Duplicate name")))
    | _ ->
        Dream.respond ~status:`Bad_Request
          (Sexp.to_string (Sexp.Atom "Invalid request"))
  in
  Dream.run ~interface:"0.0.0.0"
  @@ Dream.logger
  @@ Dream.router
       [
         Dream.get "/game/:name" (fun req ->
             let name = Dream.param req "name" in
             if Hashtbl.mem results name then get_results () else get_newgame ());
         Dream.post "/game" post_game;
         Dream.get "/allboardwords" get_allboardwords;
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

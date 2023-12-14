open Core
open Cohttp_lwt_unix
open Lwt.Syntax
open Boggle

let get_all_board_words (server : string) : string list Lwt.t =
  let* _, body =
    Client.call `GET (Uri.of_string @@ server ^ "/allboardwords")
  in
  let* body_str = body |> Cohttp_lwt.Body.to_string in
  match Sexp.of_string body_str with
  | Sexp.List [ Sexp.Atom "allboardwords"; Sexp.List words ] ->
      Lwt.return (List.map words ~f:String.t_of_sexp)
  | _ -> Lwt.return []

let handle_result (server : string) (res : Sexp.t list) : unit Lwt.t =
  let module Config = struct
    let players = 1
    let time = None
    let size = 4
  end in
  let module NewGame = Game.Make_game (Config) in
  let* all_board_words = get_all_board_words server in
  let l =
    List.map res ~f:(fun s ->
        match s with
        | Sexp.List [ Sexp.Atom name; words_sexp ] ->
            (name, List.t_of_sexp String.t_of_sexp words_sexp)
        | _ -> ("", []))
  in
  let players, all_player_words = List.unzip l in

  let player_word_scores =
    Boggle.compute_scores all_board_words all_player_words
  in
  let winners =
    List.fold2_exn players player_word_scores ~init:([], 0)
      ~f:(fun (winners, max_score) player word_scores ->
        let player_score = NewGame.calculate_score word_scores in
        if player_score > max_score then ([ player ], player_score)
        else if player_score = max_score then (player :: winners, max_score)
        else (winners, max_score))
    |> fun (winners, _) -> List.rev winners
  in
  if List.length winners = 1 then
    Stdio.printf "Player %s is currently winning with the most points!\n"
      (List.hd_exn winners)
  else
    Stdio.printf "Players %s tie for the most points!\n"
      (String.concat ~sep:", " winners);
  Stdio.print_endline "";
  List.iter2_exn players player_word_scores ~f:(fun player word_scores ->
      let total_score =
        List.fold word_scores ~init:0 ~f:(fun acc (_, score, _) -> acc + score)
      in
      Stdio.printf "Player %s Score: %d\n" player total_score;
      List.iter word_scores ~f:(fun (word, score, comment) ->
          match score with
          | 0 -> Stdio.printf "- %s\t\t(%s)\n" word comment
          | _ -> Stdio.printf "- %s\t\t(%d)\n" word score);
      Stdio.print_endline "");

  Stdio.printf "Here are the top scoring words of the solution!\n\n";
  Stdio.printf "%s\n"
    ( all_board_words
    |> List.sort ~compare:(fun s1 s2 -> String.(length s2 - length s1))
    |> fun l -> List.take l 30 |> String.concat ~sep:" " );
  Stdio.Out_channel.flush Stdio.stdout;
  Lwt.return ()

let handle_newgame (board : Boggle.t) (time : int) (name : string)
    (server : string) : unit Lwt.t =
  let module Config = struct
    let players = 1
    let time = if time < 0 then None else Some time
    let size = 4
  end in
  let module NewGame = Game.Make_game (Config) in
  NewGame.print_instructions ();
  Boggle.print_board board;
  Stdio.print_endline "Enter your words (type !done to end turn):\n";
  Stdio.print_string "Hit enter to start: ";
  Stdio.Out_channel.flush Stdio.stdout;
  (let _ = Stdio.In_channel.input_line Stdio.stdin in
   match Config.time with
   | Some t -> Stdio.printf "You have %d seconds to find words\n" t
   | None -> Stdio.printf "You have unlimited time to find words\n");
  Stdio.Out_channel.flush Stdio.stdout;
  let* all_board_words = get_all_board_words server in
  let* user_words = NewGame.get_user_words_async all_board_words in
  let* _, body =
    Client.call `POST
      ~body:
        (Sexp.List
           [
             Sexp.Atom name;
             List.sexp_of_t String.sexp_of_t (List.rev user_words);
           ]
        |> Sexp.to_string |> Cohttp_lwt.Body.of_string)
      (Uri.of_string @@ server ^ "/game")
  in
  let* body_str = body |> Cohttp_lwt.Body.to_string in
  match Sexp.of_string body_str with
  | Sexp.List [ Sexp.Atom "results"; Sexp.List res ] -> handle_result server res
  | _ -> Lwt.return ()

let main (name : string) (server : string) : _ =
  Lwt_main.run
    (Stdio.printf "Hello %s! Connecting to %s\n%!" name server;
     let* _, body =
       Client.call `GET
         (Uri.of_string @@ server ^ "/game/" ^ name)
         ~body:(Cohttp_lwt.Body.of_string name)
     in
     let* body_str = body |> Cohttp_lwt.Body.to_string in
     match Sexp.of_string body_str with
     | Sexp.List [ Sexp.Atom "newgame"; Sexp.List [ board_sexp; time_sexp ] ] ->
         let board = Boggle.t_of_sexp board_sexp in
         let time = Int.t_of_sexp time_sexp in
         handle_newgame board time name server
     | Sexp.List [ Sexp.Atom "results"; Sexp.List res ] ->
         handle_result server res
     | _ -> Lwt.return ())

let command =
  Command.basic ~summary:"Start a Boggle client!"
    ~readme:(fun () -> "More detailed information")
    (let%map_open.Command name = anon ("name" %: string)
     and server = anon ("server" %: string) in
     fun () -> main name server)

let () = Command_unix.run ~version:"1.0" ~build_info:"RWO" command

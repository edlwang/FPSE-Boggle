(* Module type of Game that contains a single function to run the game *)

open Boggle
open Core

module type Game = sig
  val run : unit -> unit
end

(* Module type of Game_config which stores all the data involving the game configuration *)
module type Game_config = sig
  val players : int (* Number of players that are competing *)

  val time :
    int option (* The time limit players have to find words on the goard*)

  val size : int (* The size of the board *)
end

module Make_game (Config : Game_config) : Game = struct
  let print_instructions () =
    Stdio.printf "Welcome to Boggle\n\n";
    Stdio.printf "Number of players: %d\n" Config.players;
    Stdio.printf "Time limit: %s\n\n"
      (match Config.time with
      | Some time -> Int.to_string time
      | None -> "None");
    Stdio.printf
      "Instructions (source: https://en.wikipedia.org/wiki/Boggle):\n";
    Stdio.printf "1. Each player will take turns finding words on the board\n";
    Stdio.printf "2. Words must be at least three letters long\n";
    Stdio.printf
      "3. Each letter after the first must be a horizontal, vertical, or \
       diagonal neighbor of the one before it\n";
    Stdio.printf
      "4. No letter square may be used more than once within a single word\n";
    Stdio.printf "5. No capitalized or hyphenated words are allowed\n";
    Stdio.printf "6. The scoring is calculated from the length of the word:\n";
    Stdio.printf "    0-2 letters: 0 pts\n";
    Stdio.printf "    3-4 letters: 1 pt\n";
    Stdio.printf "    5 letters: 2 pts\n";
    Stdio.printf "    6 letters: 3 pts\n";
    Stdio.printf "    7 letters: 5 pts\n";
    Stdio.printf "    8+ letters: 7 pts\n\n";
    Stdio.printf "During your turn, the following commands can be used\n";
    Stdio.print_endline "";
    Stdio.printf "- !done : end turn early\n";
    Stdio.printf "- !hint : obtain a hint (there are no penalties!)\n";
    Stdio.print_endline ""

  (* let get_all_words () : string list =
     let rec helper acc =
       Stdio.printf "> ";
       Stdio.Out_channel.flush Stdio.stdout;
       match Stdio.In_channel.input_line Stdio.stdin with
       | Some word when String.(word = "!done") -> acc
       | Some word when String.(word = "!hint") -> acc
       | Some word -> helper (word :: acc)
       | None -> acc
     in
     Stdio.Out_channel.flush Stdio.stdout;
     helper [] |> List.rev *)

  let get_user_words_async () : string list =
    let open Lwt.Syntax in
    let words = ref [] in
    let get_input =
      let rec process acc =
        let _ = Lwt_io.print "> " in
        let _ = Lwt_io.(flush stdout) in
        let* line = Lwt_io.(read_line stdin) in
        let* acc_str = acc in
        match line with
        | word when String.(word = "!done") -> Lwt.return acc_str
        | word when String.(word = "!hint") -> Lwt.return acc_str
        | word ->
            words := word :: !words;
            process @@ Lwt.return (word :: acc_str)
      in
      (* CLEAN UP SYNTAX FOR MONAD PIPE LIST.REV *)
      let* lst = process (Lwt.return []) in
      Lwt.return (lst |> List.rev)
    in

    let timeout =
      let* _ = Lwt_unix.sleep 10. in (* don't hardcode time*)
      Lwt.return !words
    in
    let result = Lwt.pick [ get_input; timeout ] in

    Lwt_main.run result

  let run _ =
    print_instructions ();
    let board = Boggle.create_board ~dist:Data.distribution Config.size in
    Boggle.print_board board;
    Stdio.print_endline "";

    let players = List.range 1 (Config.players + 1) in
    let all_player_words =
      List.fold players ~init:[] ~f:(fun acc player ->
             Stdio.printf "Enter Player %d's Words (type !done to end turn):\n"
               player;
             Stdio.printf "Hit enter to start:\n";
             (* Stdio.printf "> "; *)
             Stdio.Out_channel.flush Stdio.stdout;
             (let _ = Stdio.In_channel.input_line Stdio.stdin in
              match Config.time with
              | Some t -> Stdio.printf "You have %d seconds to find words\n" t
              | None -> Stdio.printf "You have 10 seconds to find words\n"); (* fix this for time constraint *)
             Stdio.Out_channel.flush Stdio.stdout;
             get_user_words_async () :: acc)
         |> List.rev
    in
    Stdio.print_endline "\n";
    let all_board_words = Boggle.solve board Data.trie in
    let player_word_scores =
      Boggle.compute_scores all_board_words all_player_words
    in
    (match
       List.iter2 players player_word_scores ~f:(fun player word_scores ->
           let total_score =
             List.fold word_scores ~init:0 ~f:(fun acc (_, score, _) ->
                 acc + score)
           in
           Stdio.printf "Player %d Score: %d\n" player total_score;
           List.iter word_scores ~f:(fun (word, score, comment) ->
               match score with
               | 0 -> Stdio.printf "- %s\t\t(%s)\n" word comment
               | _ -> Stdio.printf "- %s\t\t(%d)\n" word score);
           Stdio.print_endline "")
     with
    | Ok () -> ()
    | Unequal_lengths -> failwith "Error: Unequal lengths\n");

    Stdio.printf "And here are the first 30 words of the solution!\n\n";
    Stdio.printf "%s\n"
      (String.concat (List.take (Boggle.solve board Data.trie) 30) ~sep:" ");
    Stdio.Out_channel.flush Stdio.stdout

  (* ASYNC STUFF START *)
  (* let get_words_async () =
     Stdio.Out_channel.flush Stdio.stdout;
     let open Lwt.Syntax in

     let so_far = ref [] in
     let p1 =

       let rec helper acc =
         let _ = Lwt_io.print "> " in
         let _ = Lwt_io.(flush stdout) in
         let* line = Lwt_io.(read_line stdin) in
         let* acc = acc in
         match line with
         | word when String.(word = "!done") -> Lwt.return (acc)
         | word when String.(word = "!hint") -> Lwt.return (acc)
         | word ->
           so_far := word :: !so_far;
           helper @@ Lwt.return (word :: acc)
       in
       (* CLEAN UP SYNTAX FOR MONAD PIPE LIST.REV *)
       let* lst = helper (Lwt.return([])) in
       Lwt.return (lst |> List.rev) in

       let p2 =
         let* _ = Lwt_unix.sleep 8. in
         Lwt.return (!so_far) in
       let p3 = Lwt.pick [p1;p2] in

     let entered = Lwt_main.run p3 in

     Stdio.printf "\nUser entered: [%s]\n\n" (String.concat ~sep:"; " entered);
     Stdio.printf "The end.\n\n"; *)
end

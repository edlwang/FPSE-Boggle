(* Module type of Game that contains a single function to run the game *)

open Boggle
open Core

module type Game = sig
  val run: unit -> unit
end

(* Module type of Game_config which stores all the data involving the game configuration *)
module type Game_config = sig
  val players: int (* Number of players that are competing *)
  val time: int option(* The time limit players have to find words on the goard*)
  val size: int (* The size of the board *)
end

module Make_game(Config: Game_config) : Game = struct
  let run _ = (
    Stdio.printf "Welcome to Boggle\n\n";
    Stdio.printf "Number of players: %d\n" Config.players;
    Stdio.printf "Time limit: %s\n\n" (match Config.time with
        | Some time -> Int.to_string time
        | None -> "None");
    Stdio.printf "Instructions (source: https://en.wikipedia.org/wiki/Boggle):\n";
    Stdio.printf "1. Each player will take turns finding words on the board\n";
    Stdio.printf "2. Words must be at least three letters long\n";
    Stdio.printf "3. Each letter after the first must be a horizontal, vertical, or diagonal neighbor of the one before it\n";
    Stdio.printf "4. No letter square may be used more than once within a single word\n";
    Stdio.printf "5. No capitalized or hyphenated words are allowed\n";
    Stdio.printf "6. The scoring is calculated from the length of the word:\n";
    Stdio.printf "    0-2 letters: 0 pts\n";
    Stdio.printf "    3-4 letters: 1 pt\n";
    Stdio.printf "    5 letters: 2 pts\n";
    Stdio.printf "    6 letters: 3 pts\n";
    Stdio.printf "    7 letters: 5 pts\n";
    Stdio.printf "    8+ letters: 7 pts\n\n";
    Stdio.printf "For this checkpoint, here is a 4x4 Boggle board generated from an ngram distribution of the entire English language!\n\n";

    let board = (Boggle.create_board ~dist:Data.distribution Config.size) in
    Boggle.print_board board;
    Stdio.printf "\n";
    Stdio.printf "And here are the first 25 words of the solution!\n\n";
    Stdio.printf "%s\n" (String.concat (List.take (Boggle.solve board Data.trie) 40) ~sep:" ")

  )
end
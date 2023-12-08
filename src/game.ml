(* Module type of Game that contains a single function to run the game *)
module type Game = sig
  val run: unit -> unit
end

(* Module type of Game_config which stores all the data involving the game configuration *)
module type Game_config = sig
  val players: int (* Number of players that are competing *)
  val time: int option(* The time limit players have to find words on the goard*)
end

module Make_game(Config: Game_config) : Game = struct
  let run _ = (
    Stdio.printf "Welcome to Boggle\n";
    Stdio.printf "Number of players: %d\n" Config.players;
    Stdio.printf "Time limit: %s\n" (match Config.time with
        | Some time -> Int.to_string time
        | None -> "None");
    Stdio.printf "Instructions (source: https://en.wikipedia.org/wiki/Boggle):\n";
    Stdio.printf "1. Each player will take turns finding words on the board\n";
    Stdio.printf "2. Words must be at least three letters long\n";
    Stdio.printf "3. Each letter after the first must be a horizontal, vertical, or diagonal neighbor of the one before it\n";
    Stdio.printf "4. No letter square may be used more than once within a single word\n";
    Stdio.printf "5. No capitalized or hyphenated words are allowed\n"
  )
end
open Core
open Trie
open Ngram

(*
    You must run in the '.../FPSE-Boggle/' directory to use the Data module!
    In a later iteration there will be an according error message when the module is used improperly
*)

let words = "words.txt" |> In_channel.read_lines
let distribution = Ngram.make_distribution words

let trie =
  List.fold words ~init:(Trie.empty ()) ~f:(fun acc word ->
      if String.length word >= 3 then Trie.insert acc ~word else acc)

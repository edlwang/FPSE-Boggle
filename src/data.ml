open Core
open Trie
open Ngram

let words =
  try "dictionary.txt" |> In_channel.read_lines
  with _ ->
    failwith
      " You must run in the '.../FPSE-Boggle/' directory to use the Data \
       module!"

let distribution = Ngram.make_distribution words

let trie =
  List.fold words ~init:(Trie.empty ()) ~f:(fun acc word ->
      if String.length word >= 3 then Trie.insert acc ~word else acc)

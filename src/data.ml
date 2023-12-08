open Core
open Trie
open Ngram
let words = "words.txt" |> In_channel.read_lines

let distribution = Ngram.make_distribution words

let trie = List.fold words ~init:(Trie.empty ()) ~f:Trie.insert
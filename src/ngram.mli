(* 
   This module will be used to create a bi-gram distribution over the english language.
   For example, over the words ["app"; "apple"; "application"], the following distribution would be generated:
      (
        ('a', [('p', 3); ('t', 1)]),
        ('p', [('p', 3); ('l', 2)]),
        ('l', [('e', 1); ('i', 1)]),
        ...
      )
  This will be used to generate a reasonable Boggle board, with a variety of possible words, rather than
  random nonsense with no possibilities.
*)

module Ngram: sig
  type t (* the map holding the distribution *)
  val make_distribution: string list -> t (* generate the distribution from a list of strings *)
  val get_random: t -> char (* get single letter weighted by frequency in the english language *)
  val get_next: t -> char -> char (* get a random second letter in the bigram given the prefix, weighted by frequency *)
end





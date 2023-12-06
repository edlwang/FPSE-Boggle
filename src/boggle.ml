open Core
open Ngram
open Trie

module Boggle = struct
  module Pair = struct
    type t = int * int [@@deriving compare, sexp]
  end

  module Pair_set = Set.Make_plain (Pair)
  module String_set = Set.Make (String)

  type t = char array array [@@deriving sexp]

  let create_board ?(board : string = "") (size : int) : t =
    let len = String.length board in
    if len <> 0 && len <> size * size then
      failwith "Board not valid for desired size"
    else
      let board = Array.make_matrix ~dimx:size ~dimy:size ' ' in
      let dist =
        Ngram.make_distribution
          [
            "apple";
            "app";
            "application";
            "sentence";
            "loving";
            "going";
            "concert";
          ]
        (* replace with english language lol *)
      in

      let next_char (row : int) (col : int) : char =
        let rand = Random.float 1. in
        match Float.(rand > 0.75) with
        | true -> Ngram.get_random dist
        | false -> (
            match (row, col) with
            | 0, 0 -> Ngram.get_random dist
            | _, 0 -> Ngram.get_next dist board.(row - 1).(col)
            | _, _ -> Ngram.get_next dist board.(row).(col - 1))
      in
      let f i row = Array.iteri row ~f:(fun j _ -> row.(j) <- next_char i j) in
      Array.iteri board ~f;
      board

  (* Possibly add more efficient search, removing found words from search space *)
  let solve (board : t) (dict : Trie.t) : string list =
    let dirs =
      [ (1, 0); (-1, 0); (0, 1); (0, -1); (1, 1); (1, -1); (-1, 1); (-1, -1) ]
    in
    let num_rows, num_cols = (Array.length board, Array.length board.(0)) in
    let rec dfs (cur : char list) (words : String_set.t) (dict : Trie.t)
        (visit : Pair_set.t) (row : int) (col : int) =
      if
        row < 0 || row >= num_rows || col < 0 || col >= num_cols
        || Set.mem visit (row, col)
      then words
      else
        let ch = board.(row).(col) in
        match Trie.get_child dict ch with
        | None -> words
        | Some node ->
            let visit = Set.add visit (row, col) in
            let cur = ch :: cur in
            let words =
              if Trie.is_endpoint node then
                let word = cur |> List.rev |> String.of_list in
                Set.add words word
              else words
            in
            List.fold dirs ~init:words ~f:(fun acc (x, y) ->
                dfs cur acc node visit (row + x) (col + y))
    in

    Array.foldi board ~init:String_set.empty ~f:(fun i words row ->
        Array.foldi row ~init:words ~f:(fun j acc _ ->
            dfs [] acc dict Pair_set.empty i j))
    |> Set.to_list
end

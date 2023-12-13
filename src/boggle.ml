open Core
open Ngram
open Trie
open Dictionary
open Lwt.Syntax

module Boggle = struct
  module Pair = struct
    type t = int * int [@@deriving compare, sexp]
  end

  module Pair_set = Set.Make_plain (Pair)

  type t = char array array [@@deriving sexp]

  (* To be implemented later -- create a board from pre-defined "board" string *)
  let create_board ?(init : string = "") ~(dist : Ngram.t) (size : int) : t =
    let len = String.length init in
    match len with
    | 0 ->
        let board = Array.make_matrix ~dimx:size ~dimy:size ' ' in
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
        let f i row =
          Array.iteri row ~f:(fun j _ -> row.(j) <- next_char i j)
        in
        Array.iteri board ~f;
        board
    | x when x = size * size ->
        let init_list = init |> String.to_list |> List.chunks_of ~length:size in
        Array.init size ~f:(fun i -> Array.of_list @@ List.nth_exn init_list i)
    | _ -> failwith "Board not valid for desired size"

  (* Possibly add more efficient search, removing found words from search space *)
  let get_hint (all_words : string list) (user_words : string list) :
      (string * string) Lwt.t =
    let rec get_hint_from_words (words : string list) : (string * string) Lwt.t
        =
      match words with
      | [] -> Lwt.return ("", "No more words to find!")
      | _ -> (
          let word = List.nth_exn words (Random.int (List.length words)) in
          let* def = Dictionary.get_definition word in
          match def with
          | None ->
              get_hint_from_words
                (List.filter words ~f:(fun w -> not (String.equal w word)))
          | Some def ->
              Lwt.return
                (word, String.substr_replace_all def ~pattern:word ~with_:"____")
          )
    in
    let possible_words =
      List.filter all_words ~f:(fun w ->
          not (List.mem user_words w ~equal:String.equal))
    in
    get_hint_from_words possible_words

  let compute_scores (all_words : string list)
      (all_user_words : string list list) : (string * int * string) list list =
    let get_point_value (word : string) : int =
      match String.length word with
      | 0 | 1 | 2 -> 0
      | 3 | 4 -> 1
      | 5 -> 2
      | 6 -> 3
      | 7 -> 5
      | _ -> 11
    in
    let to_lowercase (words : string list) : string list =
      List.map words ~f:String.lowercase
    in
    let remove_duplicates (words : string list) : string list =
      List.fold words ~init:[] ~f:(fun acc w ->
          if List.mem acc w ~equal:String.equal then acc else w :: acc)
      |> List.rev
    in
    let standardized_words =
      all_user_words |> List.map ~f:to_lowercase
      |> List.map ~f:remove_duplicates
    in
    let duplicates =
      standardized_words |> List.concat
      |> List.fold ~init:String.Map.empty ~f:(fun acc w ->
             Map.update acc w ~f:(fun v ->
                 match v with None -> 1 | Some n -> n + 1))
      |> Map.filter ~f:(fun v -> v > 1)
      |> Map.key_set
    in
    standardized_words
    |> List.map ~f:(fun words ->
           List.map words ~f:(fun w ->
               if List.mem all_words w ~equal:String.equal |> not then
                 (w, 0, "Not a word on the board")
               else if Set.mem duplicates w then (w, 0, "Duplicate word")
               else (w, get_point_value w, "")))

  let solve (board : t) (dict : Trie.t) : string list =
    let dirs =
      [ (1, 0); (-1, 0); (0, 1); (0, -1); (1, 1); (1, -1); (-1, 1); (-1, -1) ]
    in
    let num_rows, num_cols = (Array.length board, Array.length board.(0)) in
    let rec dfs (cur : char list) (words : String.Set.t) (dict : Trie.t)
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

    Array.foldi board ~init:String.Set.empty ~f:(fun i words row ->
        Array.foldi row ~init:words ~f:(fun j acc _ ->
            dfs [] acc dict Pair_set.empty i j))
    |> Set.to_list

  let print_board (board : t) : unit =
    let size = Array.length board in
    let board_list =
      board |> List.of_array
      |> List.map ~f:(fun row ->
             row |> List.of_array |> List.map ~f:String.of_char)
    in

    let range = List.range 0 size in
    let s =
      String.concat
        [
          List.fold range ~init:"+" ~f:(fun acc _ ->
              String.concat [ acc; "---+" ]);
          "\n";
        ]
    in

    List.fold board_list ~init:() ~f:(fun _ row ->
        Stdio.print_string s;
        Stdio.printf "| %s |\n" (String.concat row ~sep:" | "));
    Stdio.print_string s
end

open Core
open Ngram
open Trie
open Dictionary

module Boggle = struct
  type t = char array array [@@deriving sexp]
  
  let create_board ?(board: string = "") (size: int) : t = 


    let len = String.length board in
    if len <> 0 && len <> (size * size) then failwith "Board not valid for desired size"
    else 
      let board = Array.make_matrix ~dimx: size ~dimy: size ' ' in
      let dist = Ngram.make_distribution ["apple";"app";"application"] (* replace with english language lol *) in

      let next_char (row: int) (col: int) : char = 
        let rand = Random.float 1. in
        match Float.(rand > 0.75) with
        | true -> Ngram.get_random dist
        | false -> 
          match row, col with
          | 0,0 -> Ngram.get_random dist
          | _,0 -> Ngram.get_next dist (board.(row-1).(col))
          | _,_ -> Ngram.get_next dist (board.(row).(col-1))
      in
      let f i row = Array.iteri row ~f: (fun j _ -> row.(j) <- next_char i j) in
      Array.iteri board ~f;
      board
    

  (* Possibly add more efficient search, removing found words from search space *)
  (* let solve (board: t) (dict: Trie.t): string list = 
    (* let dirs = [(1,0); (-1,0); (0,1); (0,-1)] in *)
    let num_rows, num_cols = Array.length board, Array.length board.(0) in
    let rec dfs (cur: char list) (words: string list) (dict: Trie.t) (visit: (int * int) Hash_set.t) (row: int) (col: int) = 
      if row < 0 || row >= num_rows || col < 0 || col >= num_cols (* || (row, col) in visit *) then words
      else 
        let ch = board.(row).(col) in
        match Trie.get_child dict ch with
        | None -> words
        | Some node -> 
          Hash_set.add visit (row, col);
          let cur = ch :: cur in
          let words = 
            if Trie.is_endpoint node then 
              let word = cur |> List.rev |> String.of_list in
              word :: words
            else words in
          (* recurse dfs *)
          Hash_set.remove visit (row, col); words
    in Array.iter *)

    let get_hint (all_words : string list) (user_words : string list) : string * string =
      List.fold_until all_words ~init:("", "") ~f:(fun (word, hint) w -> 
        if List.mem user_words w ~equal:String.equal then
          Continue_or_stop.Continue (w, hint)
        else
          Continue_or_stop.Stop (w, Dictionary.get_definition w)
        )
        ~finish:Fn.id
      
end
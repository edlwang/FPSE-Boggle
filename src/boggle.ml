open Core
open Ngram
open Trie

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
    
  (* let solve (board: t) (dict: Trie.t): string  list =  *)
      
      
end
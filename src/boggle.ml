open Core
open Ngram

module Boggle = struct
  type t = char array array
  let create_board ?(board: string = "") (size: int) : t = 
    let len = String.length board in
    if len <> 0 && len <> (size * size) then failwith "Board not valid for desired size"
    else 
      let board = Array.make_matrix ~dimx: size ~dimy: size ' ' in
      let dist = Ngram.make_distribution [] (* replace with english language lol *) in
      
      board
end
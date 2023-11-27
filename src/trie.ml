open Core

module Trie = struct 
  module CharMap = Map.Make(Char)
  type t = {is_word: bool; children: t CharMap.t}

  let get_child (trie: t) (c: char) : t option = 
    match Map.find trie.children c with
    | Some node -> Some node
    | None -> None
  let insert (trie: t) ~(word: string) : t = 
    let rec helper (trie: t) ~(word: char list) : t = 
      match word with 
      | [] -> trie
      | c :: [] -> 
        (match get_child trie c with 
        | Some {is_word; children} -> trie (* let children = Map.set *) (* update existing child to have is_word=true and keep children *)
        | None -> 
          let children = Map.add_exn trie.children ~key:c ~data:{is_word=true; children=CharMap.empty} in 
          {is_word=trie.is_word; children}
        ) 
      | _ -> trie (* recurse *)
    in trie (* call helper *)


  
    
end
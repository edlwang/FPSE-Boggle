open Core

module Trie = struct
  module CharMap = Map.Make (Char)

  type t = { is_word : bool; children : t CharMap.t }

  let empty () : t = { is_word = false; children = CharMap.empty }

  let get_child (trie : t) (c : char) : t option =
    match Map.find trie.children c with Some node -> Some node | None -> None

  let insert (trie : t) ~(word : string) : t =
    let rec helper (trie : t) (word : char list) : t =
      match word with
      | [] -> { is_word = true; children = trie.children }
      | c :: tl ->
          let next =
            match get_child trie c with
            | Some next -> next
            | None -> { is_word = false; children = CharMap.empty }
          in
          let children = Map.set trie.children ~key:c ~data:(helper next tl) in
          { is_word = trie.is_word; children }
    in
    helper trie @@ String.to_list word

  let is_word (trie : t) ~(word : string) : bool =
    let rec helper (trie : t) (word : char list) : bool =
      match word with
      | [] -> trie.is_word
      | c :: tl -> (
          match get_child trie c with
          | None -> false
          | Some node -> helper node tl)
    in
    helper trie @@ String.to_list word

  let is_endpoint (trie : t) : bool = trie.is_word
end

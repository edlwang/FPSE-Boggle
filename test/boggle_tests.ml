open OUnit2
open Boggle
open Core
open Trie

let test_create_board _ =
  let board_to_list (board : Boggle.t) : char list =
    board |> Boggle.sexp_of_t |> Sexp.to_string
    |> String.filter ~f:(fun c -> Char.(c <> ' ' && c <> '(' && c <> ')'))
    |> String.to_list
  in
  let cases = List.range 1 10 in
  cases
  |> List.iter ~f:(fun i ->
         assert_equal
           (i |> Boggle.create_board |> board_to_list |> List.length)
           (i * i));
  cases
  |> List.iter ~f:(fun i ->
         i |> Boggle.create_board |> board_to_list
         |> List.iter ~f:(fun c -> assert_equal (Char.is_alpha c) true))

let test_solve _ =
  let trie =
    [ "apple"; "banana"; "pear" ]
    |> List.fold ~init:(Trie.empty ()) ~f:(fun acc word ->
           Trie.insert acc ~word)
  in
  let board1 =
    "((a p p l) (x n n e) (y a v a) (z l b r))" |> Sexp.of_string
    |> Boggle.t_of_sexp
  in
  assert_equal (Boggle.solve board1 trie) [ "apple"; "banana"; "pear" ];
  let board2 =
    "((a p p l) (x n n e) (y a v a) (z l b z))" |> Sexp.of_string
    |> Boggle.t_of_sexp
  in
  assert_equal (Boggle.solve board2 trie) [ "apple"; "banana" ];
  let board3 =
    "((a p p l) (x n n z) (y a v a) (z l b r))" |> Sexp.of_string
    |> Boggle.t_of_sexp
  in
  assert_equal (Boggle.solve board3 trie) [ "banana" ]

let test_get_hint _ =
  let all_words = [ "apple"; "banana"; "pear" ] in
  let user_words1 = [] in
  let word, hint = Boggle.get_hint all_words user_words1 in
  assert_equal word "apple";
  assert_equal (String.substr_replace_all hint ~pattern:word ~with_:"") hint;
  let user_words2 = [ "apple" ] in
  let word, hint = Boggle.get_hint all_words user_words2 in
  assert_equal word "banana";
  assert_equal (String.substr_replace_all hint ~pattern:word ~with_:"") hint;
  let user_words3 = [ "apple"; "banana" ] in
  let word, hint = Boggle.get_hint all_words user_words3 in
  assert_equal word "pear";
  assert_equal (String.substr_replace_all hint ~pattern:word ~with_:"") hint

let test_compute_scores _ =
  let all_words = [ "apple"; "banana"; "pear" ] in
  let all_user_words1 = [ [ "apple" ]; [ "banana" ]; [ "pear" ] ] in
  assert_equal
    (Boggle.compute_scores all_words all_user_words1)
    [ [ ("apple", 2, "") ]; [ ("banana", 3, "") ]; [ ("pear", 1, "") ] ];
  let all_user_words2 = [ [ "apple"; "bruh" ]; [ "apple"; "pear" ] ] in
  assert_equal
    (Boggle.compute_scores all_words all_user_words2)
    [
      [ ("apple", 0, "Duplicate word"); ("bruh", 0, "Not a word on the board") ];
      [ ("apple", 0, "Duplicate word"); ("pear", 1, "") ];
    ]

let boggle_tests =
  "Boggle Tests"
  >::: [
         "Test create_board" >:: test_create_board;
         "Test solve" >:: test_solve;
         "Test get_hint" >:: test_get_hint;
         "Test compute_scores" >:: test_compute_scores;
       ]

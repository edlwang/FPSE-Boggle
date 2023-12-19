open OUnit2
open Boggle
open Core
open Trie
open Ngram
open Lwt.Syntax

let dist =
  Ngram.make_distribution
    [ "apple"; "app"; "application"; "sentence"; "loving"; "going"; "concert" ]

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
           (i |> Boggle.create_board ~dist |> board_to_list |> List.length)
           (i * i));
  cases
  |> List.iter ~f:(fun i ->
         i |> Boggle.create_board ~dist |> board_to_list
         |> List.iter ~f:(fun c -> assert_equal (Char.is_alpha c) true));
  (* test manual board input *)
  let board_str =
    4
    |> Boggle.create_board ~init:"abcdefghijklmnop" ~dist
    |> Boggle.sexp_of_t |> Sexp.to_string
  in
  assert_equal board_str "((a b c d)(e f g h)(i j k l)(m n o p))";
  assert_raises (Failure "Board not valid for desired size") (fun () ->
      4 |> Boggle.create_board ~init:"a" ~dist)

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
  Lwt_main.run
    (let all_words = [ "apple"; "banana"; "pear"; "blarg" ] in
     let user_words1 = [] in
     let* word, hint = Boggle.get_hint all_words user_words1 in
     assert_equal (List.mem all_words word ~equal:String.( = )) true;
     assert_equal (List.mem user_words1 word ~equal:String.( = )) false;
     assert_equal (String.substr_replace_all hint ~pattern:word ~with_:"") hint;
     let user_words2 = [ "apple" ] in
     let* word, hint = Boggle.get_hint all_words user_words2 in
     assert_equal (List.mem all_words word ~equal:String.( = )) true;
     assert_equal (List.mem user_words2 word ~equal:String.( = )) false;
     assert_equal (String.substr_replace_all hint ~pattern:word ~with_:"") hint;
     let user_words3 = [ "apple"; "banana" ] in
     let* word, hint = Boggle.get_hint all_words user_words3 in
     assert_equal (List.mem all_words word ~equal:String.( = )) true;
     assert_equal (List.mem user_words3 word ~equal:String.( = )) false;
     assert_equal (String.substr_replace_all hint ~pattern:word ~with_:"") hint;
     let user_words4 = [ "apple"; "banana"; "pear" ] in
     let* word, hint = Boggle.get_hint all_words user_words4 in
     assert_equal "No more words to hint!" hint;
     assert_equal "" word;
     Lwt.return_unit)

let test_compute_scores _ =
  let all_words =
    [
      "apple"; "banana"; "pear"; ""; "a"; "an"; "and"; "application"; "bananas";
    ]
  in
  let all_user_words1 = [ [ "apple"; "apple" ]; [ "banana" ]; [ "pear" ] ] in
  assert_equal
    (Boggle.compute_scores all_words all_user_words1)
    [ [ ("apple", 2, "") ]; [ ("banana", 3, "") ]; [ ("pear", 1, "") ] ];
  let all_user_words2 =
    [
      [ "apple"; "and"; "bruh" ];
      [ "application"; "bananas"; ""; "a"; "an"; "apple"; "pear" ];
    ]
  in
  assert_equal
    (Boggle.compute_scores all_words all_user_words2)
    [
      [
        ("apple", 0, "Duplicate word");
        ("and", 1, "");
        ("bruh", 0, "Not a word on the board");
      ];
      [
        ("application", 11, "");
        ("bananas", 5, "");
        ("", 0, "");
        ("a", 0, "");
        ("an", 0, "");
        ("apple", 0, "Duplicate word");
        ("pear", 1, "");
      ];
    ]

let test_string_of_t _ =
  let board1 =
    "((a p p l) (x n n e) (y a v a) (z l b r))" |> Sexp.of_string
    |> Boggle.t_of_sexp
  in
  let board1_str =
    "+---+---+---+---+\n\
     | a | p | p | l |\n\
     +---+---+---+---+\n\
     | x | n | n | e |\n\
     +---+---+---+---+\n\
     | y | a | v | a |\n\
     +---+---+---+---+\n\
     | z | l | b | r |\n\
     +---+---+---+---+\n"
  in
  assert_equal board1_str (board1 |> Boggle.string_of_t);
  let board2 = "((a p) (x n))" |> Sexp.of_string |> Boggle.t_of_sexp in
  let board2_str = "+---+---+\n| a | p |\n+---+---+\n| x | n |\n+---+---+\n" in
  assert_equal board2_str (board2 |> Boggle.string_of_t)

let boggle_tests =
  "Boggle Tests"
  >::: [
         "Test create_board" >:: test_create_board;
         "Test solve" >:: test_solve;
         "Test get_hint" >:: test_get_hint;
         "Test compute_scores" >:: test_compute_scores;
         "Test string_of_t" >:: test_string_of_t;
       ]

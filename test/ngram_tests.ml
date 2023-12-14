open OUnit2
open Ngram

let test_get_random _ =
  let d = Ngram.make_distribution [ "a"; "aa"; "aaa" ] in
  assert_equal (Ngram.get_random d) 'a';
  let d = Ngram.make_distribution [ "a"; "b"; "c" ] in
  assert_equal (List.mem (Ngram.get_random d) [ 'a'; 'b'; 'c' ]) true

let test_get_next _ =
  let alpha = "abcdefghijklmnopqrstuvwxyz" in
  let d = Ngram.make_distribution [ "a"; "aa"; "aaa" ] in
  assert_equal (Ngram.get_next d 'a') 'a';
  let d = Ngram.make_distribution [ ] in
  assert_equal true @@ String.contains alpha (Ngram.get_next d 'a');
  let d = Ngram.make_distribution [ "apple"; "banana"; "pear" ] in
  assert_equal (List.mem (Ngram.get_next d 'a') [ 'p'; 'n'; 'r' ]) true;
  assert_equal (Ngram.get_next d 'b') 'a';
  assert_equal (Ngram.get_next d 'e') 'a';
  assert_equal (Ngram.get_next d 'l') 'e';
  assert_equal (Ngram.get_next d 'n') 'a';
  assert_equal (List.mem (Ngram.get_next d 'p') [ 'p'; 'l'; 'e' ]) true

let ngram_tests = "N-gram Tests" >::: [ "Test get_random" >:: test_get_random; "Test get_next" >:: test_get_next ]

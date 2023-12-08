open OUnit2
open Boggle_tests
(* open Dictionary_tests *)
open Ngram_tests

let () = run_test_tt_main ("Tests" >::: [boggle_tests; ngram_tests (*dictionary_tests*)])
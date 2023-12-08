open OUnit2
open Boggle_tests

let () = run_test_tt_main ("Tests" >::: [boggle_tests])
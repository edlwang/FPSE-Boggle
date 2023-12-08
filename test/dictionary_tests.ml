open OUnit2
open Dictionary

(* let test_get_definition _ =
  assert_equal
    (Dictionary.get_definition "apple")
    (Some
       "A common, round fruit produced by the tree Malus domestica, cultivated \
        in temperate climates.");
  assert_equal
    (Dictionary.get_definition "banana")
    (Some
       "An elongated curved tropical fruit that grows in bunches and has a \
        creamy flesh and a smooth skin.");
  assert_equal (Dictionary.get_definition "aawaga") None

let test_get_definitions _ =
  assert_equal
    (Dictionary.get_definitions [ "apple"; "banana"; "aawaga" ])
    [
      Some
        "A common, round fruit produced by the tree Malus domestica, \
         cultivated in temperate climates.";
      Some
        "An elongated curved tropical fruit that grows in bunches and has a \
         creamy flesh and a smooth skin.";
      None;
    ]

let dictionary_tests =
  "Dictionary Tests" >::: [ "test_get_definition" >:: test_get_definition; "test_get_definitions" >:: test_get_definitions ] *)

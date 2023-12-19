(* open OUnit2
   open Dictionary
   open Lwt.Syntax

   let test_get_definition _ =
     Lwt_main.run
       (let* def = Dictionary.get_definition "apple" in
        assert_equal def
          (Some
             "A common, round fruit produced by the tree Malus domestica, \
              cultivated in temperate climates.");
        let* def = Dictionary.get_definition "banana" in
        assert_equal def
          (Some
             "An elongated curved tropical fruit that grows in bunches and has a \
              creamy flesh and a smooth skin.");
        let* def = Dictionary.get_definition "aawaga" in
        assert_equal def None;
        Lwt.return_unit)

   let dictionary_tests =
     "Dictionary Tests"
     >::: [
            "test_get_definition" >:: test_get_definition;
          ] *)

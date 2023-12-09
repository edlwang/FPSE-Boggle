open OUnit2
open Trie


let is_some x = match x with | Some _ -> true | None -> false
let default = Trie.empty ()
let test_basic _ = (* This tests empty, get_child, is_endpoint *)
  let mp = Trie.empty () in
  assert_equal None (Trie.get_child mp 'a');
  assert_equal None (Trie.get_child mp 'b');
  assert_equal None (Trie.get_child mp 'c');
  assert_bool "failure" (not (Trie.is_endpoint mp))

let test_insert _ =
  let trie = Trie.empty () |> Trie.insert ~word:"mason" |> Trie.insert ~word:"max" in
  let trie = Trie.get_child trie 'm' in
  assert_bool "failure" @@ is_some trie;
  assert_bool "failure" (not (Trie.is_endpoint @@ Option.value trie ~default));
  let trie = Trie.get_child (Option.value trie ~default) 'a' in
  assert_bool "failure" @@ is_some trie;
  assert_bool "failure" @@ is_some (Trie.get_child (Option.value trie ~default) 'x');
  let trie = Trie.get_child (Option.value trie ~default) 's' in
  assert_bool "failure" @@ is_some trie;
  let trie = Trie.get_child (Option.value trie ~default) 'o' in
  assert_bool "failure" @@ is_some trie;
  let trie = Trie.get_child (Option.value trie ~default) 'n' in
  assert_bool "failure" @@ is_some trie;
  assert_bool "failure" @@ Trie.is_endpoint (Option.value trie ~default)

let test_is_word _ =
  let trie = Trie.empty () in
  assert_bool "failure" (not @@ Trie.is_word trie ~word:"");
  let trie = trie |> Trie.insert ~word:"" in
  assert_bool "failure" @@ Trie.is_word trie ~word:"";
  let trie = trie |> Trie.insert ~word:"app" |> Trie.insert ~word:"apple" in
  assert_bool "failure" @@ Trie.is_word trie ~word:"app";
  assert_bool "failure" @@ Trie.is_word trie ~word:"apple";
  assert_bool "failure" (not @@ Trie.is_word trie ~word:"appl");
  assert_bool "failure" (not @@ Trie.is_word trie ~word:"ap")




let trie_tests = "Trie Tests" >::: [ "Test basic" >:: test_basic; "Test insert" >:: test_insert; "Test is_word" >:: test_is_word ]

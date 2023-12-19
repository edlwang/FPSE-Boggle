(lang dune 3.10)

(generate_opam_files true)

(authors "Mason Albert" "Edward Wang")

(maintainers "malber20@jhu.edu" "ewang43@jhu.edu")

(package
 (allow_empty)
 (name fpse_boggle)
 (synopsis "Boggle game implemented in OCaml")
 (description
  "A command line Boggle program that allows users to specify the number of players and the time limit each player gets to play the game. The game then guides the players and allows them to play Boggle, automatically scoring the game at the end. The game also implements a Boggle solver using a Trie in order to find all possible words and gives users the option to request hints, where information about the word is pulled from a Dictionary API")
 (depends
  (core
   (>= 0.16.1))
  (ounit2
   (>= 2.2.7))
  (yojson
   (>= 2.1.0))
  (lwt
   (>= 5.7.0))
  (cohttp
   (>= 5.3.0))
  (cohttp-lwt-unix
   (>= 5.3.0))
  (cohttp-async
   (>= 5.3.0))
  (lwt_ssl
   (>= 1.2.0))
  (base
   (>= 0.16.3))
  (base_quickcheck
   (>= 0.16.0))
  (ppx_jane
   (>= 0.16.0))
  (ppx_deriving
   (>= 5.2.1))
  (bisect_ppx
   (>= 2.8.3))
  (dream
   (>= 1.0.0~alpha5))))

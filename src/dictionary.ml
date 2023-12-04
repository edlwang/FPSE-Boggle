open Core
open Lwt
open Cohttp
open Cohttp_lwt_unix

module Dictionary = struct
  let get_all_words _ = []

  let get_definition (word : string) : string option =
    let call =
      Client.get
        (Uri.of_string
           ("https://api.dictionaryapi.dev/api/v2/entries/en/" ^ word))
      >>= fun (resp, body) ->
      match resp |> Response.status |> Code.code_of_status with
      | 200 ->
          body |> Cohttp_lwt.Body.to_string >|= fun body ->
          let json =
            Yojson.Basic.(body |> from_string |> Util.to_list |> List.hd_exn)
          in
          let first_meaning =
            Yojson.Basic.Util.(
              json |> member "meanings" |> to_list |> List.hd_exn)
          in
          let first_definition =
            Yojson.Basic.Util.(
              first_meaning |> member "definitions" |> to_list |> List.hd_exn)
          in
          let definition =
            Yojson.Basic.Util.(
              first_definition |> member "definition" |> to_string)
          in
          Some definition
      | _ -> Lwt.return_none
    in
    Lwt_main.run call

  let get_definitions (l : string list) : string option list =
    List.map l ~f:get_definition
end

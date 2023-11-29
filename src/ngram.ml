open Core

module Ngram = struct
  module CharMap = Map.Make (Char)

  type value = int CharMap.t
  type t = value CharMap.t

  let make_distribution (ls : string list) : t =
    let update_value_map (distr : t) ~(key : char) ~(value : char) : t =
      let value_map =
        match Map.find distr key with
        | Some m ->
            Map.update m value ~f:(fun opt ->
                match opt with Some v -> v + 1 | None -> 1)
        | None -> Map.add_exn CharMap.empty ~key:value ~data:1
      in
      Map.update distr key ~f:(fun _ -> value_map)
    in
    let update_with_word (distr : t) (word : string) : t =
      let updated, _ =
        String.fold word ~init:(distr, []) ~f:(fun (acc_distr, acc_bigram) c ->
            let acc_distr = update_value_map acc_distr ~key:c ~value:'*' in
            let acc_bigram =
              match List.length acc_bigram with
              | 0 -> [ c ]
              | 1 -> acc_bigram @ [ c ]
              | _ -> acc_bigram @ [ c ] |> List.tl_exn
            in
            match acc_bigram with
            | key :: value :: _ ->
                ( acc_distr
                  |> update_value_map ~key ~value
                  |> update_value_map ~key ~value:'+',
                  acc_bigram )
            | _ -> (acc_distr, acc_bigram))
      in
      updated
    in
    List.fold ls ~init:CharMap.empty ~f:(fun acc word ->
        update_with_word acc word)

  let get_random (distr : t) : char =
    let total =
      Map.fold distr ~init:0 ~f:(fun ~key:_ ~data acc ->
          acc + (Map.find data '*' |> Option.value ~default:0))
    in
    let rand = Random.int total in
    Map.fold_until distr ~init:(0, 'a')
      ~f:(fun ~key ~data (acc, c) ->
        let acc = acc + (Map.find data '*' |> Option.value ~default:0) in
        if acc > rand then Stop key else Continue (acc, c))
      ~finish:(fun (_, c) -> c)

  let get_next (distr : t) (c : char) : char =
    match Map.find distr c with
    | Some m ->
        let total = Map.find m '+' |> Option.value ~default:0 in
        let rand = Random.int total in
        Map.fold_until m ~init:(0, 'a')
          ~f:(fun ~key ~data (acc, c) ->
            if Char.(key = '+' || key = '*') then Continue (acc, c)
            else
              let acc = acc + data in
              if acc > rand then Stop key else Continue (acc, c))
          ~finish:(fun (_, c) -> c)
    | None -> get_random distr
end

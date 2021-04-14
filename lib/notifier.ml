open Core
open Async

let select_expired (titles: Proto.title_full list) =
  let has_passed timestamp = (
    let date, _ = Dateformat.date_of_epoch timestamp in
    let open Date.Replace_polymorphic_compare in
    date <= Date.today ~zone:(Lazy.force Time.Zone.local)
  ) in
  List.filter titles ~f:(fun tl -> has_passed tl.detail.next_timestamp)

let force_fetch_details (titles: Proto.title_full list) =
  List.map titles ~f:(fun tl -> 
    Api.fetch_detail ~use_cache:false tl.title >>| fun detail ->
    Proto.{ title = tl.title; detail }
  )
  |> Deferred.all

let diff_last_release (a1: Proto.title_full list) (a2: Proto.title_full list) =
  List.map2_exn a1 a2 ~f:(fun t1 t2 ->
    if t1.detail.next_timestamp < t2.detail.next_timestamp then 
      Some t2 
    else None)
  |> List.filter_opt


let update_outdated (titles: Proto.title_full list) =
  let maybe_expired =
    List.filter titles ~f:(fun tl -> not (Proto.is_completed tl.detail))
    |> select_expired in
  force_fetch_details maybe_expired >>| fun fetched ->
  diff_last_release maybe_expired fetched

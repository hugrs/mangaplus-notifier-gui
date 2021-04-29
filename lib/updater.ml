open Core
open Async

let not_completed (title: Proto.title_full) =
  not (Proto.Title.is_completed title.detail)

let has_new_release (title: Proto.title_full) =
  let has_passed timestamp =
    let open Date.Replace_polymorphic_compare in
    let date = Dateformat.date_of_epoch timestamp in
    let today = Date.today ~zone:(Lazy.force Time.Zone.local) in
    date <= today in
  has_passed title.detail.next_timestamp

let fetch_all_details (titles: Proto.title_full list) =
  List.map titles ~f:(fun tl -> 
    Api.fetch_detail ~use_cache:false tl.title >>| fun detail ->
    Proto.{ title = tl.title; detail }
  )
  |> Deferred.all

let diff_last_release a1 a2 =
  List.map2_exn a1 a2 ~f:(fun t1 t2 ->
    let open Proto in
    if t1.detail.next_timestamp < t2.detail.next_timestamp then 
      Some t2 
    else None)
  |> List.filter_opt


let update_outdated titles =
  let expired_local = List.filter titles 
    ~f:(fun t -> not_completed t && has_new_release t) in
  fetch_all_details expired_local >>| fun fetched ->
  diff_last_release expired_local fetched

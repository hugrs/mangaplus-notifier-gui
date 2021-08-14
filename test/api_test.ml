open Core
open Async
open Lib

let fake_title = Proto.Mangaplus_types.{
  title_id = 100004;
  name = "Bleach";
  author = "author";
  portrait_image_url = "url";
  landscape_image_url = "url";
  view_count = 200;
  language = English;
}

(* response from all_titles contains the correct proto type *)
let test_fetch_all () =
  Api.fetch_all () >>| fun titles ->
  assert (List.length titles > 150)

(* response from detail contains the correct proto type *)
(* title option field in detail is never none *)
let test_fetch_detail () =
  Api.fetch_detail fake_title >>| fun detail ->
  assert (List.length detail.first_chapter_list > 2);
  assert (is_some detail.title);
  let fetched_title = Option.value_exn detail.title in
  assert (String.equal fetched_title.name "Bleach");
  assert (fetched_title.title_id = 100004)

(* all ids are unique *)
let test_unique_ids () =
  Api.fetch_all () >>| fun titles ->
  let ids = List.map titles ~f:(fun title -> title.title_id) in
  assert (not (List.contains_dup ~compare:Int.compare ids))

(* titles have an associated detail *)
(* details are cached on the filesystem *)
  (*/!\ tests are run from a different temporary directory (_build/default/test)
  so the cache will be stored there *)
let test_detail_exists () =
  Api.fetch_all () >>= fun titles ->
  let details = List.map titles ~f:Api.fetch_detail in
  Deferred.all details >>| fun details ->
  assert (List.length titles = List.length details);
  List.iter titles ~f:(fun title ->
    let cached_detail = Cache.load_title_detail title in
    assert (Option.is_some cached_detail)  
  )

(* all titles have a chapter in last_chapter_list or first_chapter_list *)
let test_chapters () =
  Api.fetch_all () >>= fun titles ->
  Deferred.all (List.map titles ~f:Api.fetch_detail) >>| fun details ->
  List.iter details ~f:(fun detail ->
    assert (List.length detail.first_chapter_list > 0 || List.length detail.last_chapter_list > 0)
  )

(* every file is saved in global root *)

let main_test () =
  Deferred.all_unit [
    test_fetch_all () ;
    test_fetch_detail () ;
    test_unique_ids () ;
    test_detail_exists () ;
    (* test_chapters () *) (* disabled by default as this makes a lot of requests *)
  ] >>> fun () -> shutdown 0

let () =
  Core.never_returns (Scheduler.go_main ~main:main_test ())

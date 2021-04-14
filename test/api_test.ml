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

let test_fetch_all () =
  Api.fetch_all () >>| fun titles ->
  assert (List.length titles > 150)

let test_fetch_detail () =
  Api.fetch_detail fake_title >>| fun detail ->
  assert (List.length detail.first_chapter_list > 2);
  assert (is_some detail.title);
  let fetched_title = Option.value_exn detail.title in
  assert (String.equal fetched_title.name "Bleach");
  assert (fetched_title.title_id = 100004)

let main_test () =
  Deferred.all_unit [
    test_fetch_all () ;
    test_fetch_detail ()
  ] >>> fun () -> shutdown 0

let () =
  Core.never_returns (Scheduler.go_main ~main:main_test ())

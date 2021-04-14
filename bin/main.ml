open Core
open Async
open Lib

let main () =
  let selection_ids = Prefs.load_selected () in
  Api.fetch_all () >>= fun all_titles ->
  Data.title_detail_of_ids ~all_titles selection_ids >>= fun selection_with_detail ->
  Notifier.update_outdated selection_with_detail >>| fun updated ->
  (match (List.length updated) with
  | 0 -> "Nothing to do"
  | _ -> "update!")
  |> Out_channel.print_endline

let () =
  Deferred.upon (main ()) (fun () -> Async.shutdown 0);
  Core.never_returns (Scheduler.go ())
  
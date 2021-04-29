open Core
open Async
open Lib

let pp_list_int = 
  Format.pp_print_list ~pp_sep:Format.pp_print_space Int.pp
  
let pp_list_detail =
  let pp_detail fmt (det: Proto.title_full) = Format.pp_print_string fmt det.title.name in
  Format.pp_print_list ~pp_sep:(Format.pp_print_newline) pp_detail

let main () =
  Logs.set_reporter (Logs_fmt.reporter ());
  let subscribed_ids = Prefs.load_selected () in
  Logs.app (fun m -> m "Read saved ids: %a" pp_list_int subscribed_ids);
  Api.fetch_all () >>= fun all_titles ->
  Data.title_detail_of_ids ~all_titles subscribed_ids >>= fun subs_with_detail ->
  Logs.app (fun m -> m "Updating titles:\n%a" pp_list_detail subs_with_detail);
  Updater.update_outdated subs_with_detail >>= fun updated ->
  Logs.app (fun m -> m "Was updated:\n%a" pp_list_detail updated);
  Notifier.notify (Data.make_notification_body updated) ()

let () =
  Deferred.upon (main ()) (fun () -> Async.shutdown 0);
  Core.never_returns (Scheduler.go ())
  
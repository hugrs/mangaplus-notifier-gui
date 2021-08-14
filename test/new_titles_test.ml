open Core
open Lib

let test_new_titles () =
  Logs.set_level (Some Logs.Debug);
  Logs.set_reporter (Logs_fmt.reporter ());

  let stub = "titles.cache.test" in
  let cache_file = Cache.Debug.title_cache_path in
  Logs.debug (fun m -> m "source file: %s" stub);
  Logs.debug (fun m -> m "dest file: %s" cache_file);
  Utils.copy ~src:stub ~dest:cache_file;
  
  ignore (GMain.init ());
  let _ = GtkThread.start () in
  let titles = Api.fetch_all ()
    |> Async.Deferred.map ~f:(fun ts -> List.filter ts ~f:Proto.Title.is_english) in
  let window = Ui.Window.create ~titles () in
  window#show ();
  Core.never_returns (Async.Scheduler.go ())

let () = test_new_titles ()

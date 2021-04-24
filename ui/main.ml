open Core
open Lib


let () =
  ignore (GMain.init ());
  let _ = GtkThread.start () in
  let titles = Api.fetch_all ()
    |> Async.Deferred.map ~f:(fun ts ->
      List.filter ts ~f:Proto.Title.is_english
    ) in
  let window = Window.create ~titles () in
  window#show ();
  Core.never_returns (Async.Scheduler.go ())
  
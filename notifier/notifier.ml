let notify_async ~summary ~body () =
  Async.In_thread.run (fun () ->
    Lwt_main.run begin
      let%lwt _ = Notification.notify
        ~app_name:"this app"
        ~summary
        ~body
        () in
      Lwt.return_unit
    end
  )

let notify entries () =
  if List.length entries = 0 then Async.return () else
  let summary = Printf.sprintf "%i titles updated" (List.length entries) in
  let body = String.concat "\n" entries in
  notify_async ~summary ~body ()

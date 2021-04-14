open Core
open Async.Deferred.Infix
open Cohttp_async

exception Api_pb_unexpected of string
exception Api_pb_error of Proto.Mangaplus_types.error_result [@@ deriving sexp]
exception Api_http_error of string


(* TODO
  when fetching all the images at once
("unhandled exception"
  ((monitor.ml.Error ("connection attempt timeout" 52.85.155.126:443)
    ("Raised at Base__Error.raise in file \"src/error.ml\" (inlined), line 8, characters 14-30"
     "Called from Base__Error.raise_s in file \"src/error.ml\", line 9, characters 19-40"
     "Called from Async_kernel__Job_queue.run_jobs in file \"src/job_queue.ml\", line 167, characters 6-47"
     "Caught by monitor main"))
   ((pid 11483) (thread_id 0)))))
  retry 3 times?
 *)
let request_get_exn uri =
  Client.get (Uri.of_string uri) >>= fun (resp, body) ->
  let status_code = Response.status resp in
  if Cohttp.Code.is_success (Cohttp.Code.code_of_status status_code) then
    Body.to_string body
  else
    raise (Api_http_error (Cohttp.Code.string_of_status status_code))


let make_request_pb uri =
  request_get_exn uri >>| fun body ->
  let decoder = Pbrt.Decoder.of_string body in
  Proto.Mangaplus_pb.decode_response decoder

let unwrap_response_exn (response: Proto.Mangaplus_types.response) =
  match response with
  | Success resp -> resp
  | Error err -> raise (Api_pb_error err)

(* fetch and cache need to be functions, because if the cache succeeds we do
  not want to call fetch (i.e. make the request). In the same way if `use_cache` 
  is disabled, we do not search the cache  *)
let load_cache_or_fetch use_cache ~cache ~fetch =
  if use_cache then
    match cache () with
    | Some data -> Async.return data
    | None -> fetch ()
  else
    fetch ()

let webpage_uri (title: Proto.title) =
  Printf.sprintf "https://mangaplus.shueisha.co.jp/titles/%i" title.title_id


(* all titles view *)

let request_all = make_request_pb "https://jumpg-webapi.tokyo-cdn.com/api/title_list/all"

let unwrap_all_exn response =
  match (unwrap_response_exn response).view with
  | All_titles_view view -> view.titles
  | _ -> raise (Api_pb_unexpected "api: title_list/all did not contain a list of titles")

let fetch_all ?(use_cache=true) () =
  load_cache_or_fetch use_cache
    ~cache: Cache.load_all_titles
    ~fetch: (fun () ->
      request_all >>| fun response ->
      let titles = unwrap_all_exn response in
      Cache.save_all_titles titles;
      titles
    )

(* title detail view *)

let detail_uri (title: Proto.title) =
  Printf.sprintf "https://jumpg-webapi.tokyo-cdn.com/api/title_detail?title_id=%i" title.title_id
  
let request_detail title = make_request_pb (detail_uri title)

let unwrap_detail_exn response =
  match (unwrap_response_exn response).view with
  | Title_detail_view view -> view
  | _ -> raise (Api_pb_unexpected "api: unexpected response from title_detail")

let fetch_detail ?(use_cache=true) title =
  load_cache_or_fetch use_cache
    ~cache:(fun () -> Cache.load_title_detail title)
    ~fetch: (fun () ->
      request_detail title >>| fun resp ->
      let detail_view = unwrap_detail_exn resp in
      Cache.save_title_detail title detail_view;
      detail_view
    )


let fetch_image ?(use_cache=true) (title: Proto.title) =
  load_cache_or_fetch use_cache
  ~cache: (fun () -> Cache.get_image_file title)
  ~fetch: (fun () ->
    request_get_exn title.landscape_image_url >>| fun body ->
    Cache.save_image title ~data:body
  )

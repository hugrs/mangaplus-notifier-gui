exception Api_pb_unexpected of string
exception Api_pb_error      of Proto.Mangaplus_types.error_result
exception Api_http_error    of string

val fetch_all : ?use_cache:bool -> unit -> Proto.title list Async.Deferred.t
val fetch_detail : ?use_cache:bool -> Proto.title -> Proto.title_detail Async.Deferred.t
val fetch_image : ?use_cache:bool -> Proto.title -> string Async.Deferred.t

val webpage_uri : Proto.title -> string

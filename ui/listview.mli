type t

val create : packing:(GObj.widget -> unit) -> t
val connect_entry_clicked : t -> (string -> unit) -> unit

val set_selected : t -> Proto.title -> bool -> unit
(* We have to pass the whole title list here. This is because we need to map
the plain ids in the selection to titles in protobuf form *)
val update_selection : t -> all_titles:Proto.title list Async.Deferred.t -> 
  int list -> unit Async.Deferred.t
  
val refresh : t -> Proto.title list -> unit Async.Deferred.t

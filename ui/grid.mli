type t

(* require titles when creating the grid as it doesn't make sense to create
an empty grid *)
val create :
  Proto.title list Async.Deferred.t ->
  packing:(GObj.widget -> unit) -> t

val connect_entries : 
  Titlewdg.event_type -> t -> (Proto.title -> bool -> unit) -> unit

val refresh : t -> Proto.title list -> 
  on_click_cb:Titlewdg.click_event_callback -> unit -> unit Async.Deferred.t

val restore_selection : t -> int list -> unit Async.Deferred.t
val selection : t -> Proto.title list Async.Deferred.t

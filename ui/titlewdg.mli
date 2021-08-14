type t

type event_type = [
  `clicked
]

(* callback receives the title that was clicked, and the checkbox state *)
type click_event_callback = Proto.title -> bool -> unit

val selected : t -> bool
val set_selected : t -> bool -> unit

val create : Proto.title -> t
val create_with_listener : Proto.title -> click_event_callback -> selected:bool -> t
val coerce : t -> GObj.widget
val get_data : t -> Proto.title
val get_id : t -> int
val connect : t -> click_event_callback -> unit

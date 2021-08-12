type t

type event_type = [
  `clicked
]

(* callback receives the title that was clicked, and the checkbox state *)
type click_event_callback = Proto.title -> bool -> unit
val create : Proto.title -> t
val coerce : t -> GObj.widget
val get_data : t -> Proto.title
val connect : event_type -> (Proto.title -> bool -> unit) -> t -> unit
val selected : t -> bool
val set_selected : t -> bool -> unit

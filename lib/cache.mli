val save_all_titles : Proto.title list -> unit
val load_all_titles : unit -> Proto.title list option
val save_title_detail : Proto.title -> Proto.title_detail -> unit
val load_title_detail : Proto.title -> Proto.title_detail option
val save_image : Proto.title -> data:string -> string
val get_image_file : Proto.title -> string option

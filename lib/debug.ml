open Base
open Stdio

let print_titles (ts:Proto.title list) =
  List.iter ts ~f:(fun t -> Out_channel.print_endline t.name)

let print_tfs (ts:Proto.title_full list) =
  List.map ts ~f:(fun t -> t.title)
  |> print_titles

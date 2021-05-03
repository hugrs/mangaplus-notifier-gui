open Core

type selection = int list

let selected_filename = Fs.path_from_root "selected.conf"

let make_selection titles =
  List.map titles ~f:(fun t -> Proto.Title.id t |> Int.to_string)
  |> String.concat ~sep:","

let save_selected titles () =
  let data = make_selection titles in
  Out_channel.write_all selected_filename ~data

let parse_selection data = data
  |> String.rstrip
  |> String.split ~on:','
  |> List.map ~f:Int.of_string

let try_parse contents =
  if String.length contents = 0 then Or_error.error_string "selection is empty" else
  Or_error.try_with (fun () -> parse_selection contents)

let load_selected () =
  match Sys.file_exists selected_filename with
  | `No | `Unknown -> []
  | `Yes ->
    match In_channel.read_all selected_filename |> try_parse with
    | Ok ids -> ids
    | Error err -> Out_channel.prerr_endline (Error.to_string_mach err); []

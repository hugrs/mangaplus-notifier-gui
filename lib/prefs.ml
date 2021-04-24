open Core

type selection = int list

let selected_filename = Fs.path_from_root "selected.conf"

let save_selected (titles: Proto.title list) () =
  let data = List.map titles ~f:(fun t -> Int.to_string t.title_id)
  |> String.concat ~sep:"," in
  Out_channel.write_all selected_filename ~data

let load_selected () =
  match Sys.file_exists selected_filename with
  | `Yes ->
    In_channel.read_all selected_filename
    |> String.rstrip
    |> String.split ~on:','
    |> List.map ~f:Int.of_string
  | `No | `Unknown -> []

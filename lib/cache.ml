open Core
module Mangaplus_pb = Proto.Mangaplus_pb

let cache_dir = "cache"
let create_cache_dir () =
  match Sys.is_directory cache_dir with
  | `Yes -> ()
  | `No | `Unknown -> begin
    Unix.mkdir cache_dir
  end

let cache_full_path filename =
  Filename.concat cache_dir filename


let filename_title = "titles.cache"

let save_all_titles titles =
  Fs.save_pb ~encode_f:Mangaplus_pb.encode_all_titles_view 
    ~file:(cache_full_path filename_title) { titles }

let load_all_titles () =
  Fs.if_exists (cache_full_path filename_title) ~f:(fun file ->
    let all_title_view = Fs.load_pb ~decode_f:Mangaplus_pb.decode_all_titles_view file in
    all_title_view.titles
  )


let filename_detail id =
  Printf.sprintf "detail_%i.cache" id

let save_title_detail (title: Proto.title) view =
  ignore title; ignore view
  (* Fs.save_pb ~encode_f:Mangaplus_pb.encode_title_detail_view ~file:(filename_detail title.title_id |> cache_full_path) view *)

let load_title_detail (title: Proto.title) =
  Fs.if_exists (filename_detail title.title_id |> cache_full_path) ~f:(fun file ->
    Fs.load_pb ~decode_f:Mangaplus_pb.decode_title_detail_view file
  )


let filename_image id =
  Printf.sprintf "img_%i.jpeg" id

let save_image (title: Proto.title) ~data =
  let filename = filename_image title.title_id |> cache_full_path in
  Out_channel.write_all filename ~data;
  filename

let get_image_file (title: Proto.title) =
  Fs.if_exists (filename_image title.title_id |> cache_full_path) ~f:ident


(* FIXME: this seems bad *)
let () = create_cache_dir ()

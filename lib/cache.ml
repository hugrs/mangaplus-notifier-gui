open Core
module Mangaplus_pb = Proto.Mangaplus_pb

let cache_dir = Fs.path_from_root ~create_dir:true "cache"

let cache_path filename =
  Filename.concat cache_dir filename


let filename_title = cache_path "titles.cache"

let save_all_titles titles =
  Fs.save_pb ~encode_f:Mangaplus_pb.encode_all_titles_view 
    ~file:filename_title { titles }

let load_all_titles () =
  Fs.if_exists_do filename_title ~f:(fun file ->
    let all_title_view = Fs.load_pb ~decode_f:Mangaplus_pb.decode_all_titles_view file in
    all_title_view.titles
  )


let filename_detail id =
  cache_path @@ Printf.sprintf "detail_%i.cache" id

let save_title_detail (title: Proto.title) view =
  Fs.save_pb ~encode_f:Mangaplus_pb.encode_title_detail_view 
    ~file:(filename_detail title.title_id) view

let load_title_detail (title: Proto.title) =
  Fs.if_exists_do (filename_detail title.title_id) ~f:(fun file ->
    Fs.load_pb ~decode_f:Mangaplus_pb.decode_title_detail_view file
  )


let filename_image id =
  cache_path @@ Printf.sprintf "img_%i.jpeg" id

let save_image (title: Proto.title) ~data =
  let filename = filename_image title.title_id in
  Out_channel.write_all filename ~data;
  filename

let get_image_file (title: Proto.title) =
  Fs.if_exists_do (filename_image title.title_id) ~f:ident


module Debug = struct
  let title_cache_path = filename_title
end

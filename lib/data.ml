open Core
open Async

(** Functions to manipulate Api protobuf data  *)

(* The module will hold its own version of the title list.
  It can get out of sync with the one that the gui holds. To keep in mind *)
(* let titles = Api.fetch_all ~use_cache:true () *)

type id_title_map = (int, Proto.title, Int.comparator_witness) Map.t

(* we expect Mangaplus to have unique title ids *)
let id_map (titles:Proto.title list) : id_title_map =
  List.map titles ~f:(fun t -> (t.title_id, t))
  |> Map.of_alist_exn (module Int)

let titles_of_ids ~(all_titles:Proto.title list) ids =
  let map = id_map all_titles in
  List.map ids ~f:(Map.find map)
  |> List.filter_opt

let ids_of_titles titles = List.map titles ~f:Proto.Title.id

module TitleFull = struct
  type t = Proto.title_full

  let of_title title =
    Api.fetch_detail ~use_cache:true title >>| fun detail ->
    Proto.{ title; detail }

  let of_titles titles : t list Async.Deferred.t =
    List.map titles ~f:of_title 
    |> Async.Deferred.all
end

let title_detail_of_ids ~(all_titles:Proto.title list) ids =
  titles_of_ids ~all_titles ids
  |> TitleFull.of_titles


let last_chapter detail =
  Option.value (List.last (detail: Proto.title_detail).last_chapter_list)
    ~default:(List.last_exn detail.first_chapter_list)

let describe_last_chapter title =
  let last_chapter = last_chapter (title: Proto.title_full).detail in
  sprintf "%s : %s" title.title.name last_chapter.name

let make_notification_body titles =
  List.map titles ~f:describe_last_chapter

let chapter_url (chapter: Proto.Mangaplus_types.chapter) =
  sprintf "https://mangaplus.shueisha.co.jp/viewer/%i" chapter.chapter_id

let last_chapter_url detail = last_chapter detail |> chapter_url

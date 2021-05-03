open Core
open Async.Deferred.Infix
open Lib
open Helper


(* title of the manga
  author(s)
  latest chapter n#
  date of latest chapter
  date of next chapter
  *)
let cols = new GTree.column_list
let name = cols#add Gobject.Data.string
let author = cols#add Gobject.Data.string
let last_chapter = cols#add Gobject.Data.string
let last_date = cols#add Gobject.Data.string
let next_date = cols#add Gobject.Data.string
let url = cols#add Gobject.Data.string
let visible = cols#add Gobject.Data.boolean
let bgcolor = cols#add Gobject.Data.string


module Row = struct
  type t = {
    data: Gtk.tree_iter
  }
  type store_t = GTree.list_store

  let set_last_release_info ~(store:store_t) row (detail_view: Proto.title_detail) =
    let chapter = Data.last_chapter detail_view in
    store#set ~row ~column:last_chapter chapter.name;
    store#set ~row ~column:url (Data.chapter_url chapter);
    let last_date_str = Printf.sprintf "%s (%s)"
      (Dateformat.Date_relative.of_epoch_from_today chapter.start_time_stamp
        ~lang: Dateformat.Date_relative.french)
      (Dateformat.epoch_to_human_string chapter.start_time_stamp) in
    store#set ~row ~column:last_date last_date_str;
    store#set ~row ~column:next_date (match detail_view.next_timestamp with
      | 0 -> "-"
      | _ -> Dateformat.epoch_to_human_string detail_view.next_timestamp)  
    
  let create ~(store: store_t) (title: Proto.title) =
    let row = store#append () in
    (* set fields that won't change upon refresh *)
    store#set ~row ~column:name title.name; 
    store#set ~row ~column:author title.author;
    (* store#set ~row ~column:bgcolor "#888888"; *)
    (* fill detail when we have it *)
    Async.upon (Api.fetch_detail title) (fun detail ->
      set_last_release_info ~store:store row detail;
    );
    { data = row }

  let update ~(store:store_t) t (detail: Proto.title_detail) =
    set_last_release_info ~store t.data detail

  let set ~(store:store_t) row column value =
    store#set ~row ~column value
end

type listview = {
  view: GTree.view;
  store: GTree.list_store;
  table: (int, Row.t) Hashtbl.t
}
type t = listview


let create ~packing =
  let list_store = GTree.list_store cols in
  let filter = GTree.model_filter list_store in
  filter#set_visible_column visible;
  let list_view = GTree.view ~model:filter ~packing () in

  let renderer = GTree.cell_renderer_text [] in
  let create_column title gcol =
    let col = GTree.view_column ~title ~renderer:(renderer, [
      ("text", gcol);
      ("background", bgcolor)
    ]) () in
    ignore (list_view#append_column col) in
  
  create_column "Title" name;
  create_column "Author" author;
  create_column "Last chapter" last_chapter;
  create_column "Last release" last_date;
  create_column "Next release" next_date;

  let table = Hashtbl.create (module Int) in
  { view = list_view; store = list_store ; table }


let connect_entry_clicked t callback =
  let view, store = t.view, t.store in
  (* FIXME: path doesnt reflect the correct row if the rows have changed
    I think i'm supposed to delete/add the rows instead of hiding them *)
  view#connect#row_activated <~ (fun path _column ->
    let row = store#get_iter path in
    let uri = store#get ~row ~column:url in
    Row.set ~store row bgcolor "#ffffff";
    callback uri
  )

let set_selected t (title: Proto.title) selected =
  let store = t.store in
  let row = Hashtbl.find_or_add t.table title.title_id
    ~default:(fun () -> Row.create ~store title) in
  store#set ~row:row.data ~column:visible selected

let update_selection t ~all_titles selection_ids =
  all_titles >>| fun all_titles ->
  Data.titles_of_ids ~all_titles selection_ids
  |> List.iter ~f:(fun tl -> set_selected t tl true)

let yellow = "#f9ff7c"

let refresh t selection =
  Data.TitleFull.of_titles selection >>= fun titles ->
  Updater.update_outdated titles >>= fun updated ->
  List.iter updated ~f:(fun (tf:Proto.title_full) ->
    (* we know the title is in the map because the grid selection must match the list *)
    let row = Hashtbl.find_exn t.table tf.title.title_id in
    Row.update ~store:t.store row tf.detail;
    Row.set ~store:t.store row.data bgcolor yellow
  );
  Notifier.notify (Data.make_notification_body updated) ()

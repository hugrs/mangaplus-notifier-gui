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
    store#set ~row ~column:last_date (Int.to_string chapter.start_time_stamp);
    store#set ~row ~column:next_date (Int.to_string detail_view.next_timestamp)
    
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
    col#set_resizable true;
    col#set_clickable true;
    col#connect#clicked <~ (fun () ->
      let order = match list_store#get_sort_column_id with
        | Some (_, `ASCENDING) -> `DESCENDING
        | Some (_, `DESCENDING) -> `ASCENDING
        | None -> `ASCENDING in
      list_store#set_sort_column_id gcol.index order);
    col in

  let create_date_column title gcol =
    (* Change the render function for date columns, the underlying data is a (string) timestamp, *)
    (* so convert it to a readable date *)
    let col = create_column title gcol in
    col#set_cell_data_func renderer (fun model row ->
        match model#get ~row ~column:gcol with
        | "" | "0" -> renderer#set_properties [ `TEXT "-" ]
        | ts ->
          let last_date_str = Dateformat.datetime_for_display (Int.of_string ts) in
          renderer#set_properties [ `TEXT last_date_str ]
      );
    col in

  let columns = [
    create_column "Title" name;
    create_column "Author" author;
    create_column "Last chapter" last_chapter;
    create_date_column "Last release" last_date;
    create_date_column "Next release" next_date;
  ] in
  (* insert all columns with side-effect *)
  List.iter columns ~f:(fun c -> list_view#append_column c |> ignore);

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

let set_selected_to t (title: Proto.title) selected =
  let store = t.store in
  let row = Hashtbl.find_or_add t.table title.title_id
    ~default:(fun () -> Row.create ~store title) in
  store#set ~row:row.data ~column:visible selected

let update_selection t ~all_titles selection_ids =
  let open Async in
  let%map all_titles = all_titles in (* <- wait for Deferred *)
  let selected_titles = Data.titles_of_ids ~all_titles selection_ids in
  let entry_set_selected_true title = set_selected_to t title true in
  List.iter selected_titles ~f:entry_set_selected_true

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

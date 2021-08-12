open Core
open Async
module Api = Lib.Api

type grid = {
  container: GPack.box;
  mutable widget: GPack.grid;
  mutable entries: Titlewdg.t list Deferred.t
}
type t = grid

let connect_entries evt_type grid ~cb =
  match evt_type with `clicked ->
    Deferred.upon grid.entries (fun titles ->
      List.iter titles ~f:(fun entry ->
        Titlewdg.connect entry cb
      )
    )

let titles_per_row = 3

let fill_grid_widget (widget: GPack.grid) titles =
  let rows = List.chunks_of ~length:titles_per_row titles in
  List.iteri rows ~f:(fun row_idx row ->
    List.iteri row ~f:(fun item_idx title ->
      widget#attach ~left:item_idx ~top:row_idx (Titlewdg.coerce title)
    )
  )

let make_display_widget ?(show=true) ~packing () =
  GPack.grid ~row_spacings:15 ~col_spacings:10
    ~border_width:10 ~col_homogeneous:true ~show ~packing ()

let create (titles_async: Proto.title list Async.Deferred.t) ~packing =
  (* build Gtk layout *)
  let scrollbox = GBin.scrolled_window ~hpolicy:`NEVER ~packing () in
  let layout = GPack.box `VERTICAL ~width:600 ~packing:scrollbox#add () in
  let infolabel = GMisc.label ~text:"Fetching titles..." ~packing:layout#add () in
  let grid_w = make_display_widget ~show:false ~packing:layout#add () in
  
  (* map protobuf titles to Titlewdg objects *)
  let titles = Deferred.map titles_async ~f:(fun ts ->
    List.map ts ~f:(fun title_data -> Titlewdg.create title_data)
  ) in
  
  let grid = { container = layout ; widget = grid_w ; entries = titles } in
  Deferred.upon titles (fun ts -> 
    fill_grid_widget grid_w ts;
    infolabel#misc#hide ();
    grid_w#misc#show ()
  );
  grid


(* attention n^2 loop here - max iter is length of titles^2 = 22500 *)
let apply_selection (title_widgets: Titlewdg.t list) selection =
  List.iter title_widgets ~f:(fun wdg ->
    let id = (Titlewdg.get_data wdg).title_id in
    List.exists selection ~f:(fun selected_id -> selected_id = id)
    |> Titlewdg.set_selected wdg
  )

let restore_selection grid selection =
  Deferred.map grid.entries
    ~f:(fun entries -> apply_selection entries selection)

let selection grid =
  Deferred.map grid.entries ~f:(fun entries ->
    List.filter entries ~f:Titlewdg.selected
    |> List.map ~f:Titlewdg.get_data
  )

let refresh t fresh_titles ~on_click_cb () =
  (* build new widgets for all titles *)
  let%map entries = t.entries in
  let cached_titles = List.map entries ~f:Titlewdg.get_data in
  let added = Lib.Updater.diff_keep_only_new cached_titles fresh_titles 
    |> List.sort ~compare:Proto.Title.compare_alpha in
  
  (* we want the final list to be sorted alphabetically. I can think of a few methods:
  - append new titles at the end and sort everything
  - knowing that the past list is sorted, sort the new elements and iterate through the
    original list, inserting the new ones where they fit
  - a "merge" function that combines 2 lists with a comparator? => Base has List.merge *)
  let combined_list = List.merge cached_titles added ~compare:Proto.Title.compare_alpha in
  let new_widgets = List.map combined_list ~f:(fun t -> Titlewdg.create_with_listener t on_click_cb) in
  t.entries <- return new_widgets;
  
  (* destroy the old grid *)
  t.container#remove t.widget#coerce;
  t.widget#destroy ();

  (* create the new grid and attach it *)
  let new_grid = make_display_widget ~packing:t.container#add () in
  fill_grid_widget new_grid new_widgets;

  (* save a reference *)
  t.widget <- new_grid;
  Out_channel.print_endline "grid has been refreshed";
  ()

open Core
open Async

type grid = {
  container: GBin.scrolled_window;
  widget: GPack.grid;
  entries: Titlewdg.t list Deferred.t
}
type t = grid

let connect_entries evt_type grid callback =
  Deferred.upon grid.entries (fun titles ->
    List.iter titles ~f:(fun entry ->
      Titlewdg.connect evt_type callback entry
    )
  )

let titles_per_row = 3

let fill_grid grid titles =
  let rows = List.chunks_of ~length:titles_per_row titles in
  List.iteri rows ~f:(fun row_idx row ->
    List.iteri row ~f:(fun item_idx title ->
      grid.widget#attach ~left:item_idx ~top:row_idx (Titlewdg.coerce title)
    )
  )

let create (titles_async: Proto.title list Async.Deferred.t) ~packing =
  (* build Gtk layout *)
  let scrollbox = GBin.scrolled_window ~hpolicy:`NEVER ~packing () in
  let layout = GPack.box `VERTICAL ~width:600 ~packing:scrollbox#add () in
  let infolabel = GMisc.label ~text:"Fetching titles..." ~packing:layout#add () in
  let grid_w = GPack.grid ~row_spacings:15 ~col_spacings:10
    ~border_width:10 ~col_homogeneous:true ~show:false ~packing:layout#add () in
  
  (* map protobuf titles to Titlewdg objects *)
  let titles = Deferred.map titles_async ~f:(fun ts ->
    List.map ts ~f:(fun title_data -> Titlewdg.create title_data)
  ) in
  
  let grid = { container = scrollbox ; widget = grid_w ; entries = titles } in
  Deferred.upon titles (fun ts -> 
    fill_grid grid ts;
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

let set_selection grid selection =
  Deferred.map grid.entries
    ~f:(fun entries -> apply_selection entries selection)

let selection grid =
  Deferred.map grid.entries ~f:(fun entries ->
    List.filter entries ~f:Titlewdg.selected
    |> List.map ~f:Titlewdg.get_data
  )

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

let make_display_widget ?(show=true) ?packing () =
  GPack.grid ~row_spacings:15 ~col_spacings:10
    ~border_width:10 ~col_homogeneous:true ~show ?packing ()

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

(* attention n^2 loop here - max iter is length of titles^2 = 22500
although the selection should usually be small (around 10 titles), the
average search will be (150*10)/2 *)
let apply_selection (title_widgets: Titlewdg.t list) selection =
  List.iter title_widgets ~f:(fun wdg ->
    let id = (Titlewdg.get_data wdg).title_id in
    List.exists selection ~f:(fun selected_id -> selected_id = id)
    |> Titlewdg.set_selected wdg
  )

let restore_selection grid selection =
  Debug.amf [%here] "refresh selection...";
  let%map entries = grid.entries in
  apply_selection entries selection

let selection grid =
  let%map entries = grid.entries in
  List.filter entries ~f:Titlewdg.selected
  |> List.map ~f:Titlewdg.get_data

let refresh t fresh_titles ~on_click_cb () =
  (* build new widgets for all titles *)
  let%map entries = t.entries in
  let cached_titles = List.map entries ~f:Titlewdg.get_data in
  let added = Lib.Updater.difference fresh_titles cached_titles in
  Debug.amf [%here] "new titles length: %d" (List.length added);
  if List.length added > 0 then
    (* TODO: fix sorting of new titles *)
    (* let cached_titles = List.sort cached_titles ~compare:Proto.Title.compare_alpha in
    let added = List.sort added ~compare:Proto.Title.compare_alpha in *)
    
    (* I believe cached_titles is already sorted alphabetically
      FUTURE: might not be true for all languages *)
    let refreshed_list = List.merge cached_titles added ~compare:Proto.Title.compare_alpha in

    let entries_prev_selected = 
      List.filter entries ~f: Titlewdg.selected 
      |> List.map ~f: Titlewdg.get_id in
    let new_widgets = List.map refreshed_list ~f:(fun t ->
      let was_selected = List.exists entries_prev_selected ~f:(fun sid -> t.title_id = sid) in
      Titlewdg.create_with_listener t on_click_cb ~selected:was_selected
    ) in
    (* build the new grid in the background *)
    let new_grid = make_display_widget () in
    fill_grid_widget new_grid new_widgets;

    (* destroy the old grid and attach the new *)
    t.container#remove t.widget#coerce;
    t.widget#destroy ();
    t.container#add new_grid#coerce;

    (* update references *)
    t.widget <- new_grid;
    t.entries <- return new_widgets;
    Out_channel.print_endline "grid has been refreshed";

    let summary = List.map added ~f: Proto.Title.name
      |> String.concat ~sep:"\n" in
    let message = Printf.sprintf "%d new titles added!\n\n%s"
      (List.length added)
      summary in
    let dialog = GWindow.message_dialog
      ~buttons: GWindow.Buttons.close
      ~title: "Notification"
      ~message
      ~show:true () in
    dialog#connect#response ~callback:(fun _ -> dialog#destroy ()) |> ignore;
    ()

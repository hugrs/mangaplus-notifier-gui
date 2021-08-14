open Core
open Helper

let create ~titles () =
  (* ui setup *)
  let window = GWindow.window ~title:"Main window" ~height:650 () in
  let root_layout = GPack.box `VERTICAL ~spacing:10 ~homogeneous:false ~packing:window#add () in
  
  let stack = GPack.stack ~transition_type:`SLIDE_LEFT_RIGHT () in
  
  let header = GPack.box `HORIZONTAL () in
  let refresh = GButton.button ~label:"Refresh" () in
  header#pack ~expand:false refresh#coerce;
  let switcher = GPack.stack_switcher ~stack:stack#as_stack ~packing:header#add () in
  switcher#set_halign `CENTER;

  header#set_margin 10;
  header#set_margin_bottom 0;

  root_layout#pack ~expand:false header#coerce;
  root_layout#pack ~expand:true ~fill:true stack#coerce;
  
  (* the main views *)
  let list_view = Listview.create ~packing:(fun w -> stack#add_titled w "home" "Subscriptions") in
  let grid = Grid.create titles ~packing:(fun w -> stack#add_titled w "titles" "Manga list") in

  (* setup callbacks for when grid cells are clicked *)
  let click_gridcell_callback title is_selected =
    Listview.set_selected_to list_view title is_selected in
  Grid.connect_entries `clicked grid ~cb:click_gridcell_callback;
  Listview.connect_entry_clicked list_view GWindow.show_uri;

  let restore_selection ~grid ~list_view selection () =
    (* restore user selection of titles from the filesystem *)
    Grid.restore_selection grid selection |> ignore;
    Listview.update_selection list_view ~all_titles:titles selection |> ignore in
  let saved_selection = Lib.Prefs.load_selected () in
  restore_selection ~grid ~list_view saved_selection ();

  (* refresh button *)
  refresh#connect#clicked <~ (fun () ->
    refresh#set_sensitive false;
    refresh#set_label "...";
    (* FUTURE: add a variant for the stack types if adding a new page to the stack
      or using the names outside of this file *)
    let open Async in
    begin
      match stack#visible_child_name with
      | "home" -> 
        let%bind selection = Grid.selection grid in
        Listview.refresh list_view selection
      | "titles" -> 
        Debug.amf [%here] "refresh titles";
        let%bind all_titles = Lib.Api.fetch_all ~use_cache:false () in
        let all_titles_en = List.filter all_titles ~f: Proto.Title.is_english in 
        Grid.refresh grid all_titles_en ~on_click_cb:click_gridcell_callback ()
      | x -> return (Debug.amf [%here] "WARNING: Attempted to refresh an unknown page type: %s" x)
    end >>> fun () ->
    Debug.amf [%here] "refresh selection done";
    refresh#set_label "Refresh";
    refresh#set_sensitive true
  );

  window#connect#destroy <~ (fun () ->
    (* window wont close until the grid has filled the selection *)
    Async.upon (Grid.selection grid) (fun selection ->
      Lib.Prefs.save_selected selection ();
      Async.shutdown 0
    )
  );
  window

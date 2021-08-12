open Core
open Helper

let create ~titles () =
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
  
  let list_view = Listview.create ~packing:(fun w -> stack#add_titled w "home" "Subscriptions") in
  let grid = Grid.create titles ~packing:(fun w -> stack#add_titled w "titles" "Manga list") in

  let update_listview_callback title selected =
    Listview.set_selected list_view title selected in

  Grid.connect_entries `clicked grid update_listview_callback;
  Listview.connect_entry_clicked list_view GWindow.show_uri;

  let saved_selection = Lib.Prefs.load_selected () in
  Grid.restore_selection grid saved_selection |> ignore;
  Listview.update_selection list_view ~all_titles:titles saved_selection |> ignore;

  refresh#connect#clicked <~ (fun () ->
    refresh#set_sensitive false;
    refresh#set_label "...";
    let open Async in
    (* TODO: add a variant for the stack types if adding a new page to the stack
      or using the names outside of this file *)
    begin match stack#visible_child_name with
    | "home" -> 
      Grid.selection grid >>= fun selection ->
      Listview.refresh list_view selection
    | "titles" -> 
      Out_channel.print_endline "refresh titles";
      let%bind all_titles = Lib.Api.fetch_all ~use_cache:false () in
      let all_titles_en = List.filter all_titles ~f: Proto.Title.is_english in 
      Grid.refresh grid all_titles_en ~on_click_cb:update_listview_callback ()
    | x -> return (Debug.amf [%here] "WARNING: Attempted to refresh an unknown page type: %s" x)
    end >>> fun () ->
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

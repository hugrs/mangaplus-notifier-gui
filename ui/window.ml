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

  Grid.connect_entries `clicked grid (fun title selected ->
    Out_channel.print_endline title.name;
    Out_channel.print_endline (Bool.to_string selected);
    Listview.set_selected list_view title selected
  );

  Listview.connect_entry_clicked list_view (fun url ->
    GWindow.show_uri url
  );

  let saved_selection = Lib.Prefs.load_selected () in
  Grid.set_selection grid saved_selection |> ignore;
  Listview.update_selection list_view ~all_titles:titles saved_selection |> ignore;

  refresh#connect#clicked <~ (fun () ->
    refresh#set_sensitive false;
    refresh#set_label "...";
    let open Async in
    Grid.selection grid >>> fun selection ->
    Listview.refresh list_view selection >>> fun () ->
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

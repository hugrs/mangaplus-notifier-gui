open Core
open Helper

let image_height = 200

type t = {
  title: Proto.title;
  widget: GBin.event_box;
  checkbox: GButton.toggle_button
}

type event_type = [
  `clicked
]
type click_event_callback = Proto.title -> bool -> unit

let get_data t = t.title
let coerce t = t.widget#coerce
let selected t = t.checkbox#active
let set_selected t value = t.checkbox#set_active value

let connect t callback =
  let eventbox = t.widget in
  let checkbox = t.checkbox in
  eventbox#event#connect#button_press <~ (fun evt ->
    (* redirect clicks to the checkbox widget *)
    let open Poly in
    if GdkEvent.get_type evt = `BUTTON_PRESS then
      checkbox#clicked ();
    false
  );
  checkbox#connect#clicked <~ (fun () ->
    callback t.title checkbox#active
  )

let create (title: Proto.title) =
  let eventbox = GBin.event_box () in
  let layout = GPack.box `VERTICAL ~spacing:5 ~packing:eventbox#add () in
  let image = GMisc.image ~stock:`MISSING_IMAGE ~height:image_height 
    ~packing:layout#add () in
  Async.Deferred.upon (Lib.Api.fetch_image title) (fun file ->
    let pixbuf = GdkPixbuf.from_file_at_size file 
      ~width:800(* doesnt matter *) 
      ~height:image_height in
    image#set_pixbuf pixbuf
  );

  let hbox = GPack.box `HORIZONTAL ~spacing:7 ~packing:layout#add () in
  let checkbox = GButton.check_button ~packing:hbox#add () in
  let name = GMisc.label ~text:(Lib.Utils.break_string ~limit:40 title.name) () in
  hbox#pack ~expand:true ~fill:true name#coerce;
  name#set_halign `START;
  checkbox#set_halign `END;

  (* let _ = GMisc.label ~text:(String.length title.name |> Int.to_string) ~packing:layout#add() in *)
  { title ; widget = eventbox ; checkbox }

let create_with_listener title callback =
  let widget = create title in
  connect widget callback;
  widget

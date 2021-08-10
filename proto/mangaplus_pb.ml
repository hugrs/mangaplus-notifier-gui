[@@@ocaml.warning "-27-30-39"]

type title_mutable = {
  mutable title_id : int;
  mutable name : string;
  mutable author : string;
  mutable portrait_image_url : string;
  mutable landscape_image_url : string;
  mutable view_count : int;
  mutable language : Mangaplus_types.title_language;
}

let default_title_mutable () : title_mutable = {
  title_id = 0;
  name = "";
  author = "";
  portrait_image_url = "";
  landscape_image_url = "";
  view_count = 0;
  language = Mangaplus_types.default_title_language ();
}

type all_titles_view_mutable = {
  mutable titles : Mangaplus_types.title list;
}

let default_all_titles_view_mutable () : all_titles_view_mutable = {
  titles = [];
}

type chapter_mutable = {
  mutable title_id : int;
  mutable chapter_id : int;
  mutable name : string;
  mutable sub_title : string;
  mutable thumbnail_url : string;
  mutable start_time_stamp : int;
  mutable end_time_stamp : int;
  mutable already_viewed : bool;
  mutable is_vertical_only : bool;
}

let default_chapter_mutable () : chapter_mutable = {
  title_id = 0;
  chapter_id = 0;
  name = "";
  sub_title = "";
  thumbnail_url = "";
  start_time_stamp = 0;
  end_time_stamp = 0;
  already_viewed = false;
  is_vertical_only = false;
}

type title_detail_view_mutable = {
  mutable title : Mangaplus_types.title option;
  mutable title_image_url : string;
  mutable overview : string;
  mutable background_image_url : string;
  mutable next_timestamp : int;
  mutable update_timing : Mangaplus_types.title_detail_view_update_timing;
  mutable viewing_period_description : string;
  mutable non_appearance_info : string;
  mutable first_chapter_list : Mangaplus_types.chapter list;
  mutable last_chapter_list : Mangaplus_types.chapter list;
  mutable recommended_title_list : Mangaplus_types.title list;
  mutable is_simul_released : bool;
  mutable is_subscribed : bool;
  mutable rating : Mangaplus_types.title_detail_view_rating;
  mutable chapters_descending : bool;
  mutable number_of_views : int;
}

let default_title_detail_view_mutable () : title_detail_view_mutable = {
  title = None;
  title_image_url = "";
  overview = "";
  background_image_url = "";
  next_timestamp = 0;
  update_timing = Mangaplus_types.default_title_detail_view_update_timing ();
  viewing_period_description = "";
  non_appearance_info = "";
  first_chapter_list = [];
  last_chapter_list = [];
  recommended_title_list = [];
  is_simul_released = false;
  is_subscribed = false;
  rating = Mangaplus_types.default_title_detail_view_rating ();
  chapters_descending = false;
  number_of_views = 0;
}

type title_updated_mutable = {
  mutable title : Mangaplus_types.title option;
  mutable updated_title_timestamp : string;
}

let default_title_updated_mutable () : title_updated_mutable = {
  title = None;
  updated_title_timestamp = "";
}

type title_updated_view_mutable = {
  mutable latest_title : Mangaplus_types.title_updated list;
}

let default_title_updated_view_mutable () : title_updated_view_mutable = {
  latest_title = [];
}

type success_result_mutable = {
  mutable is_featured_updated : bool;
  mutable view : Mangaplus_types.success_result_view;
}

let default_success_result_mutable () : success_result_mutable = {
  is_featured_updated = false;
  view = Mangaplus_types.All_titles_view (Mangaplus_types.default_all_titles_view ());
}

type error_result_mutable = {
  mutable action : Mangaplus_types.error_result_action;
  mutable debug_info : string;
}

let default_error_result_mutable () : error_result_mutable = {
  action = Mangaplus_types.default_error_result_action ();
  debug_info = "";
}

type coming_soon_title_mutable = {
  mutable title : Mangaplus_types.title option;
  mutable next_chapter_name : string;
  mutable next_chapter_start_timestamp : int;
}

let default_coming_soon_title_mutable () : coming_soon_title_mutable = {
  title = None;
  next_chapter_name = "";
  next_chapter_start_timestamp = 0;
}


let rec decode_title_language d = 
  match Pbrt.Decoder.int_as_varint d with
  | 0 -> (Mangaplus_types.English:Mangaplus_types.title_language)
  | 1 -> (Mangaplus_types.Spanish:Mangaplus_types.title_language)
  | 2 -> (Mangaplus_types.French:Mangaplus_types.title_language)
  | 3 -> (Mangaplus_types.Indonesian:Mangaplus_types.title_language)
  | 4 -> (Mangaplus_types.Portuguese_br:Mangaplus_types.title_language)
  | 5 -> (Mangaplus_types.Russian:Mangaplus_types.title_language)
  | 6 -> (Mangaplus_types.Thai:Mangaplus_types.title_language)
  | _ -> Pbrt.Decoder.malformed_variant "title_language"

let rec decode_title d =
  let v = default_title_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Varint) -> begin
      v.title_id <- Pbrt.Decoder.int_as_varint d;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title), field(1)" pk
    | Some (2, Pbrt.Bytes) -> begin
      v.name <- Pbrt.Decoder.string d;
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title), field(2)" pk
    | Some (3, Pbrt.Bytes) -> begin
      v.author <- Pbrt.Decoder.string d;
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title), field(3)" pk
    | Some (4, Pbrt.Bytes) -> begin
      v.portrait_image_url <- Pbrt.Decoder.string d;
    end
    | Some (4, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title), field(4)" pk
    | Some (5, Pbrt.Bytes) -> begin
      v.landscape_image_url <- Pbrt.Decoder.string d;
    end
    | Some (5, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title), field(5)" pk
    | Some (6, Pbrt.Varint) -> begin
      v.view_count <- Pbrt.Decoder.int_as_varint d;
    end
    | Some (6, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title), field(6)" pk
    | Some (7, Pbrt.Varint) -> begin
      v.language <- decode_title_language d;
    end
    | Some (7, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title), field(7)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Mangaplus_types.title_id = v.title_id;
    Mangaplus_types.name = v.name;
    Mangaplus_types.author = v.author;
    Mangaplus_types.portrait_image_url = v.portrait_image_url;
    Mangaplus_types.landscape_image_url = v.landscape_image_url;
    Mangaplus_types.view_count = v.view_count;
    Mangaplus_types.language = v.language;
  } : Mangaplus_types.title)

let rec decode_all_titles_view d =
  let v = default_all_titles_view_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
      v.titles <- List.rev v.titles;
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.titles <- (decode_title (Pbrt.Decoder.nested d)) :: v.titles;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(all_titles_view), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Mangaplus_types.titles = v.titles;
  } : Mangaplus_types.all_titles_view)

let rec decode_title_detail_view_update_timing d = 
  match Pbrt.Decoder.int_as_varint d with
  | 0 -> (Mangaplus_types.Not_regularly:Mangaplus_types.title_detail_view_update_timing)
  | 1 -> (Mangaplus_types.Monday:Mangaplus_types.title_detail_view_update_timing)
  | 2 -> (Mangaplus_types.Tuesday:Mangaplus_types.title_detail_view_update_timing)
  | 3 -> (Mangaplus_types.Wednesday:Mangaplus_types.title_detail_view_update_timing)
  | 4 -> (Mangaplus_types.Thursday:Mangaplus_types.title_detail_view_update_timing)
  | 5 -> (Mangaplus_types.Friday:Mangaplus_types.title_detail_view_update_timing)
  | 6 -> (Mangaplus_types.Saturday:Mangaplus_types.title_detail_view_update_timing)
  | 7 -> (Mangaplus_types.Sunday:Mangaplus_types.title_detail_view_update_timing)
  | 8 -> (Mangaplus_types.Day:Mangaplus_types.title_detail_view_update_timing)
  | _ -> Pbrt.Decoder.malformed_variant "title_detail_view_update_timing"

let rec decode_chapter d =
  let v = default_chapter_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Varint) -> begin
      v.title_id <- Pbrt.Decoder.int_as_varint d;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(chapter), field(1)" pk
    | Some (2, Pbrt.Varint) -> begin
      v.chapter_id <- Pbrt.Decoder.int_as_varint d;
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(chapter), field(2)" pk
    | Some (3, Pbrt.Bytes) -> begin
      v.name <- Pbrt.Decoder.string d;
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(chapter), field(3)" pk
    | Some (4, Pbrt.Bytes) -> begin
      v.sub_title <- Pbrt.Decoder.string d;
    end
    | Some (4, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(chapter), field(4)" pk
    | Some (5, Pbrt.Bytes) -> begin
      v.thumbnail_url <- Pbrt.Decoder.string d;
    end
    | Some (5, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(chapter), field(5)" pk
    | Some (6, Pbrt.Varint) -> begin
      v.start_time_stamp <- Pbrt.Decoder.int_as_varint d;
    end
    | Some (6, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(chapter), field(6)" pk
    | Some (7, Pbrt.Varint) -> begin
      v.end_time_stamp <- Pbrt.Decoder.int_as_varint d;
    end
    | Some (7, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(chapter), field(7)" pk
    | Some (8, Pbrt.Varint) -> begin
      v.already_viewed <- Pbrt.Decoder.bool d;
    end
    | Some (8, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(chapter), field(8)" pk
    | Some (9, Pbrt.Varint) -> begin
      v.is_vertical_only <- Pbrt.Decoder.bool d;
    end
    | Some (9, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(chapter), field(9)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Mangaplus_types.title_id = v.title_id;
    Mangaplus_types.chapter_id = v.chapter_id;
    Mangaplus_types.name = v.name;
    Mangaplus_types.sub_title = v.sub_title;
    Mangaplus_types.thumbnail_url = v.thumbnail_url;
    Mangaplus_types.start_time_stamp = v.start_time_stamp;
    Mangaplus_types.end_time_stamp = v.end_time_stamp;
    Mangaplus_types.already_viewed = v.already_viewed;
    Mangaplus_types.is_vertical_only = v.is_vertical_only;
  } : Mangaplus_types.chapter)

let rec decode_title_detail_view_rating d = 
  match Pbrt.Decoder.int_as_varint d with
  | 0 -> (Mangaplus_types.Allage:Mangaplus_types.title_detail_view_rating)
  | 1 -> (Mangaplus_types.Teen:Mangaplus_types.title_detail_view_rating)
  | 2 -> (Mangaplus_types.Teenplus:Mangaplus_types.title_detail_view_rating)
  | 3 -> (Mangaplus_types.Mature:Mangaplus_types.title_detail_view_rating)
  | _ -> Pbrt.Decoder.malformed_variant "title_detail_view_rating"

let rec decode_title_detail_view d =
  let v = default_title_detail_view_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
      v.recommended_title_list <- List.rev v.recommended_title_list;
      v.last_chapter_list <- List.rev v.last_chapter_list;
      v.first_chapter_list <- List.rev v.first_chapter_list;
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.title <- Some (decode_title (Pbrt.Decoder.nested d));
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_detail_view), field(1)" pk
    | Some (2, Pbrt.Bytes) -> begin
      v.title_image_url <- Pbrt.Decoder.string d;
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_detail_view), field(2)" pk
    | Some (3, Pbrt.Bytes) -> begin
      v.overview <- Pbrt.Decoder.string d;
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_detail_view), field(3)" pk
    | Some (4, Pbrt.Bytes) -> begin
      v.background_image_url <- Pbrt.Decoder.string d;
    end
    | Some (4, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_detail_view), field(4)" pk
    | Some (5, Pbrt.Varint) -> begin
      v.next_timestamp <- Pbrt.Decoder.int_as_varint d;
    end
    | Some (5, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_detail_view), field(5)" pk
    | Some (6, Pbrt.Varint) -> begin
      v.update_timing <- decode_title_detail_view_update_timing d;
    end
    | Some (6, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_detail_view), field(6)" pk
    | Some (7, Pbrt.Bytes) -> begin
      v.viewing_period_description <- Pbrt.Decoder.string d;
    end
    | Some (7, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_detail_view), field(7)" pk
    | Some (8, Pbrt.Bytes) -> begin
      v.non_appearance_info <- Pbrt.Decoder.string d;
    end
    | Some (8, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_detail_view), field(8)" pk
    | Some (9, Pbrt.Bytes) -> begin
      v.first_chapter_list <- (decode_chapter (Pbrt.Decoder.nested d)) :: v.first_chapter_list;
    end
    | Some (9, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_detail_view), field(9)" pk
    | Some (10, Pbrt.Bytes) -> begin
      v.last_chapter_list <- (decode_chapter (Pbrt.Decoder.nested d)) :: v.last_chapter_list;
    end
    | Some (10, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_detail_view), field(10)" pk
    | Some (12, Pbrt.Bytes) -> begin
      v.recommended_title_list <- (decode_title (Pbrt.Decoder.nested d)) :: v.recommended_title_list;
    end
    | Some (12, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_detail_view), field(12)" pk
    | Some (14, Pbrt.Varint) -> begin
      v.is_simul_released <- Pbrt.Decoder.bool d;
    end
    | Some (14, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_detail_view), field(14)" pk
    | Some (15, Pbrt.Varint) -> begin
      v.is_subscribed <- Pbrt.Decoder.bool d;
    end
    | Some (15, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_detail_view), field(15)" pk
    | Some (16, Pbrt.Varint) -> begin
      v.rating <- decode_title_detail_view_rating d;
    end
    | Some (16, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_detail_view), field(16)" pk
    | Some (17, Pbrt.Varint) -> begin
      v.chapters_descending <- Pbrt.Decoder.bool d;
    end
    | Some (17, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_detail_view), field(17)" pk
    | Some (18, Pbrt.Varint) -> begin
      v.number_of_views <- Pbrt.Decoder.int_as_varint d;
    end
    | Some (18, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_detail_view), field(18)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Mangaplus_types.title = v.title;
    Mangaplus_types.title_image_url = v.title_image_url;
    Mangaplus_types.overview = v.overview;
    Mangaplus_types.background_image_url = v.background_image_url;
    Mangaplus_types.next_timestamp = v.next_timestamp;
    Mangaplus_types.update_timing = v.update_timing;
    Mangaplus_types.viewing_period_description = v.viewing_period_description;
    Mangaplus_types.non_appearance_info = v.non_appearance_info;
    Mangaplus_types.first_chapter_list = v.first_chapter_list;
    Mangaplus_types.last_chapter_list = v.last_chapter_list;
    Mangaplus_types.recommended_title_list = v.recommended_title_list;
    Mangaplus_types.is_simul_released = v.is_simul_released;
    Mangaplus_types.is_subscribed = v.is_subscribed;
    Mangaplus_types.rating = v.rating;
    Mangaplus_types.chapters_descending = v.chapters_descending;
    Mangaplus_types.number_of_views = v.number_of_views;
  } : Mangaplus_types.title_detail_view)

let rec decode_title_updated d =
  let v = default_title_updated_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.title <- Some (decode_title (Pbrt.Decoder.nested d));
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_updated), field(1)" pk
    | Some (2, Pbrt.Bytes) -> begin
      v.updated_title_timestamp <- Pbrt.Decoder.string d;
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_updated), field(2)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Mangaplus_types.title = v.title;
    Mangaplus_types.updated_title_timestamp = v.updated_title_timestamp;
  } : Mangaplus_types.title_updated)

let rec decode_title_updated_view d =
  let v = default_title_updated_view_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
      v.latest_title <- List.rev v.latest_title;
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.latest_title <- (decode_title_updated (Pbrt.Decoder.nested d)) :: v.latest_title;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(title_updated_view), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Mangaplus_types.latest_title = v.latest_title;
  } : Mangaplus_types.title_updated_view)

let rec decode_success_result_view d = 
  let rec loop () = 
    let ret:Mangaplus_types.success_result_view = match Pbrt.Decoder.key d with
      | None -> Pbrt.Decoder.malformed_variant "success_result_view"
      | Some (5, _) -> (Mangaplus_types.All_titles_view (decode_all_titles_view (Pbrt.Decoder.nested d)) : Mangaplus_types.success_result_view) 
      | Some (8, _) -> (Mangaplus_types.Title_detail_view (decode_title_detail_view (Pbrt.Decoder.nested d)) : Mangaplus_types.success_result_view) 
      | Some (20, _) -> (Mangaplus_types.Title_updated_view (decode_title_updated_view (Pbrt.Decoder.nested d)) : Mangaplus_types.success_result_view) 
      | Some (n, payload_kind) -> (
        Pbrt.Decoder.skip d payload_kind; 
        loop () 
      )
    in
    ret
  in
  loop ()

and decode_success_result d =
  let v = default_success_result_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Varint) -> begin
      v.is_featured_updated <- Pbrt.Decoder.bool d;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(success_result), field(1)" pk
    | Some (5, Pbrt.Bytes) -> begin
      v.view <- Mangaplus_types.All_titles_view (decode_all_titles_view (Pbrt.Decoder.nested d));
    end
    | Some (5, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(success_result), field(5)" pk
    | Some (8, Pbrt.Bytes) -> begin
      v.view <- Mangaplus_types.Title_detail_view (decode_title_detail_view (Pbrt.Decoder.nested d));
    end
    | Some (8, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(success_result), field(8)" pk
    | Some (20, Pbrt.Bytes) -> begin
      v.view <- Mangaplus_types.Title_updated_view (decode_title_updated_view (Pbrt.Decoder.nested d));
    end
    | Some (20, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(success_result), field(20)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Mangaplus_types.is_featured_updated = v.is_featured_updated;
    Mangaplus_types.view = v.view;
  } : Mangaplus_types.success_result)

let rec decode_error_result_action d = 
  match Pbrt.Decoder.int_as_varint d with
  | 0 -> (Mangaplus_types.Default:Mangaplus_types.error_result_action)
  | 1 -> (Mangaplus_types.Unauthorized:Mangaplus_types.error_result_action)
  | 2 -> (Mangaplus_types.Maintenance:Mangaplus_types.error_result_action)
  | 3 -> (Mangaplus_types.Geoip_blocking:Mangaplus_types.error_result_action)
  | _ -> Pbrt.Decoder.malformed_variant "error_result_action"

let rec decode_error_result d =
  let v = default_error_result_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Varint) -> begin
      v.action <- decode_error_result_action d;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(error_result), field(1)" pk
    | Some (4, Pbrt.Bytes) -> begin
      v.debug_info <- Pbrt.Decoder.string d;
    end
    | Some (4, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(error_result), field(4)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Mangaplus_types.action = v.action;
    Mangaplus_types.debug_info = v.debug_info;
  } : Mangaplus_types.error_result)

let rec decode_response d = 
  let rec loop () = 
    let ret:Mangaplus_types.response = match Pbrt.Decoder.key d with
      | None -> Pbrt.Decoder.malformed_variant "response"
      | Some (1, _) -> (Mangaplus_types.Success (decode_success_result (Pbrt.Decoder.nested d)) : Mangaplus_types.response) 
      | Some (2, _) -> (Mangaplus_types.Error (decode_error_result (Pbrt.Decoder.nested d)) : Mangaplus_types.response) 
      | Some (n, payload_kind) -> (
        Pbrt.Decoder.skip d payload_kind; 
        loop () 
      )
    in
    ret
  in
  loop ()

let rec decode_coming_soon_title d =
  let v = default_coming_soon_title_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.title <- Some (decode_title (Pbrt.Decoder.nested d));
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(coming_soon_title), field(1)" pk
    | Some (2, Pbrt.Bytes) -> begin
      v.next_chapter_name <- Pbrt.Decoder.string d;
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(coming_soon_title), field(2)" pk
    | Some (3, Pbrt.Varint) -> begin
      v.next_chapter_start_timestamp <- Pbrt.Decoder.int_as_varint d;
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(coming_soon_title), field(3)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Mangaplus_types.title = v.title;
    Mangaplus_types.next_chapter_name = v.next_chapter_name;
    Mangaplus_types.next_chapter_start_timestamp = v.next_chapter_start_timestamp;
  } : Mangaplus_types.coming_soon_title)

let rec encode_title_language (v:Mangaplus_types.title_language) encoder =
  match v with
  | Mangaplus_types.English -> Pbrt.Encoder.int_as_varint (0) encoder
  | Mangaplus_types.Spanish -> Pbrt.Encoder.int_as_varint 1 encoder
  | Mangaplus_types.French -> Pbrt.Encoder.int_as_varint 2 encoder
  | Mangaplus_types.Indonesian -> Pbrt.Encoder.int_as_varint 3 encoder
  | Mangaplus_types.Portuguese_br -> Pbrt.Encoder.int_as_varint 4 encoder
  | Mangaplus_types.Russian -> Pbrt.Encoder.int_as_varint 5 encoder
  | Mangaplus_types.Thai -> Pbrt.Encoder.int_as_varint 6 encoder

let rec encode_title (v:Mangaplus_types.title) encoder = 
  Pbrt.Encoder.key (1, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int_as_varint v.Mangaplus_types.title_id encoder;
  Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Mangaplus_types.name encoder;
  Pbrt.Encoder.key (3, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Mangaplus_types.author encoder;
  Pbrt.Encoder.key (4, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Mangaplus_types.portrait_image_url encoder;
  Pbrt.Encoder.key (5, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Mangaplus_types.landscape_image_url encoder;
  Pbrt.Encoder.key (6, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int_as_varint v.Mangaplus_types.view_count encoder;
  Pbrt.Encoder.key (7, Pbrt.Varint) encoder; 
  encode_title_language v.Mangaplus_types.language encoder;
  ()

let rec encode_all_titles_view (v:Mangaplus_types.all_titles_view) encoder = 
  List.iter (fun x -> 
    Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_title x) encoder;
  ) v.Mangaplus_types.titles;
  ()

let rec encode_title_detail_view_update_timing (v:Mangaplus_types.title_detail_view_update_timing) encoder =
  match v with
  | Mangaplus_types.Not_regularly -> Pbrt.Encoder.int_as_varint (0) encoder
  | Mangaplus_types.Monday -> Pbrt.Encoder.int_as_varint 1 encoder
  | Mangaplus_types.Tuesday -> Pbrt.Encoder.int_as_varint 2 encoder
  | Mangaplus_types.Wednesday -> Pbrt.Encoder.int_as_varint 3 encoder
  | Mangaplus_types.Thursday -> Pbrt.Encoder.int_as_varint 4 encoder
  | Mangaplus_types.Friday -> Pbrt.Encoder.int_as_varint 5 encoder
  | Mangaplus_types.Saturday -> Pbrt.Encoder.int_as_varint 6 encoder
  | Mangaplus_types.Sunday -> Pbrt.Encoder.int_as_varint 7 encoder
  | Mangaplus_types.Day -> Pbrt.Encoder.int_as_varint 8 encoder

let rec encode_chapter (v:Mangaplus_types.chapter) encoder = 
  Pbrt.Encoder.key (1, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int_as_varint v.Mangaplus_types.title_id encoder;
  Pbrt.Encoder.key (2, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int_as_varint v.Mangaplus_types.chapter_id encoder;
  Pbrt.Encoder.key (3, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Mangaplus_types.name encoder;
  Pbrt.Encoder.key (4, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Mangaplus_types.sub_title encoder;
  Pbrt.Encoder.key (5, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Mangaplus_types.thumbnail_url encoder;
  Pbrt.Encoder.key (6, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int_as_varint v.Mangaplus_types.start_time_stamp encoder;
  Pbrt.Encoder.key (7, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int_as_varint v.Mangaplus_types.end_time_stamp encoder;
  Pbrt.Encoder.key (8, Pbrt.Varint) encoder; 
  Pbrt.Encoder.bool v.Mangaplus_types.already_viewed encoder;
  Pbrt.Encoder.key (9, Pbrt.Varint) encoder; 
  Pbrt.Encoder.bool v.Mangaplus_types.is_vertical_only encoder;
  ()

let rec encode_title_detail_view_rating (v:Mangaplus_types.title_detail_view_rating) encoder =
  match v with
  | Mangaplus_types.Allage -> Pbrt.Encoder.int_as_varint (0) encoder
  | Mangaplus_types.Teen -> Pbrt.Encoder.int_as_varint 1 encoder
  | Mangaplus_types.Teenplus -> Pbrt.Encoder.int_as_varint 2 encoder
  | Mangaplus_types.Mature -> Pbrt.Encoder.int_as_varint 3 encoder

let rec encode_title_detail_view (v:Mangaplus_types.title_detail_view) encoder = 
  begin match v.Mangaplus_types.title with
  | Some x -> 
    Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_title x) encoder;
  | None -> ();
  end;
  Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Mangaplus_types.title_image_url encoder;
  Pbrt.Encoder.key (3, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Mangaplus_types.overview encoder;
  Pbrt.Encoder.key (4, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Mangaplus_types.background_image_url encoder;
  Pbrt.Encoder.key (5, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int_as_varint v.Mangaplus_types.next_timestamp encoder;
  Pbrt.Encoder.key (6, Pbrt.Varint) encoder; 
  encode_title_detail_view_update_timing v.Mangaplus_types.update_timing encoder;
  Pbrt.Encoder.key (7, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Mangaplus_types.viewing_period_description encoder;
  Pbrt.Encoder.key (8, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Mangaplus_types.non_appearance_info encoder;
  List.iter (fun x -> 
    Pbrt.Encoder.key (9, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_chapter x) encoder;
  ) v.Mangaplus_types.first_chapter_list;
  List.iter (fun x -> 
    Pbrt.Encoder.key (10, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_chapter x) encoder;
  ) v.Mangaplus_types.last_chapter_list;
  List.iter (fun x -> 
    Pbrt.Encoder.key (12, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_title x) encoder;
  ) v.Mangaplus_types.recommended_title_list;
  Pbrt.Encoder.key (14, Pbrt.Varint) encoder; 
  Pbrt.Encoder.bool v.Mangaplus_types.is_simul_released encoder;
  Pbrt.Encoder.key (15, Pbrt.Varint) encoder; 
  Pbrt.Encoder.bool v.Mangaplus_types.is_subscribed encoder;
  Pbrt.Encoder.key (16, Pbrt.Varint) encoder; 
  encode_title_detail_view_rating v.Mangaplus_types.rating encoder;
  Pbrt.Encoder.key (17, Pbrt.Varint) encoder; 
  Pbrt.Encoder.bool v.Mangaplus_types.chapters_descending encoder;
  Pbrt.Encoder.key (18, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int_as_varint v.Mangaplus_types.number_of_views encoder;
  ()

let rec encode_title_updated (v:Mangaplus_types.title_updated) encoder = 
  begin match v.Mangaplus_types.title with
  | Some x -> 
    Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_title x) encoder;
  | None -> ();
  end;
  Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Mangaplus_types.updated_title_timestamp encoder;
  ()

let rec encode_title_updated_view (v:Mangaplus_types.title_updated_view) encoder = 
  List.iter (fun x -> 
    Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_title_updated x) encoder;
  ) v.Mangaplus_types.latest_title;
  ()

let rec encode_success_result_view (v:Mangaplus_types.success_result_view) encoder = 
  begin match v with
  | Mangaplus_types.All_titles_view x ->
    Pbrt.Encoder.key (5, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_all_titles_view x) encoder;
  | Mangaplus_types.Title_detail_view x ->
    Pbrt.Encoder.key (8, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_title_detail_view x) encoder;
  | Mangaplus_types.Title_updated_view x ->
    Pbrt.Encoder.key (20, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_title_updated_view x) encoder;
  end

and encode_success_result (v:Mangaplus_types.success_result) encoder = 
  Pbrt.Encoder.key (1, Pbrt.Varint) encoder; 
  Pbrt.Encoder.bool v.Mangaplus_types.is_featured_updated encoder;
  begin match v.Mangaplus_types.view with
  | Mangaplus_types.All_titles_view x ->
    Pbrt.Encoder.key (5, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_all_titles_view x) encoder;
  | Mangaplus_types.Title_detail_view x ->
    Pbrt.Encoder.key (8, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_title_detail_view x) encoder;
  | Mangaplus_types.Title_updated_view x ->
    Pbrt.Encoder.key (20, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_title_updated_view x) encoder;
  end;
  ()

let rec encode_error_result_action (v:Mangaplus_types.error_result_action) encoder =
  match v with
  | Mangaplus_types.Default -> Pbrt.Encoder.int_as_varint (0) encoder
  | Mangaplus_types.Unauthorized -> Pbrt.Encoder.int_as_varint 1 encoder
  | Mangaplus_types.Maintenance -> Pbrt.Encoder.int_as_varint 2 encoder
  | Mangaplus_types.Geoip_blocking -> Pbrt.Encoder.int_as_varint 3 encoder

let rec encode_error_result (v:Mangaplus_types.error_result) encoder = 
  Pbrt.Encoder.key (1, Pbrt.Varint) encoder; 
  encode_error_result_action v.Mangaplus_types.action encoder;
  Pbrt.Encoder.key (4, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Mangaplus_types.debug_info encoder;
  ()

let rec encode_response (v:Mangaplus_types.response) encoder = 
  begin match v with
  | Mangaplus_types.Success x ->
    Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_success_result x) encoder;
  | Mangaplus_types.Error x ->
    Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_error_result x) encoder;
  end

let rec encode_coming_soon_title (v:Mangaplus_types.coming_soon_title) encoder = 
  begin match v.Mangaplus_types.title with
  | Some x -> 
    Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_title x) encoder;
  | None -> ();
  end;
  Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Mangaplus_types.next_chapter_name encoder;
  Pbrt.Encoder.key (3, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int_as_varint v.Mangaplus_types.next_chapter_start_timestamp encoder;
  ()

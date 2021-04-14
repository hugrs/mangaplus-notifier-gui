[@@@ocaml.warning "-27-30-39"]

let rec pp_title_language fmt (v:Mangaplus_types.title_language) =
  match v with
  | Mangaplus_types.English -> Format.fprintf fmt "English"
  | Mangaplus_types.Spanish -> Format.fprintf fmt "Spanish"

let rec pp_title fmt (v:Mangaplus_types.title) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "title_id" Pbrt.Pp.pp_int fmt v.Mangaplus_types.title_id;
    Pbrt.Pp.pp_record_field "name" Pbrt.Pp.pp_string fmt v.Mangaplus_types.name;
    Pbrt.Pp.pp_record_field "author" Pbrt.Pp.pp_string fmt v.Mangaplus_types.author;
    Pbrt.Pp.pp_record_field "portrait_image_url" Pbrt.Pp.pp_string fmt v.Mangaplus_types.portrait_image_url;
    Pbrt.Pp.pp_record_field "landscape_image_url" Pbrt.Pp.pp_string fmt v.Mangaplus_types.landscape_image_url;
    Pbrt.Pp.pp_record_field "view_count" Pbrt.Pp.pp_int fmt v.Mangaplus_types.view_count;
    Pbrt.Pp.pp_record_field "language" pp_title_language fmt v.Mangaplus_types.language;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_all_titles_view fmt (v:Mangaplus_types.all_titles_view) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "titles" (Pbrt.Pp.pp_list pp_title) fmt v.Mangaplus_types.titles;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_title_detail_view_update_timing fmt (v:Mangaplus_types.title_detail_view_update_timing) =
  match v with
  | Mangaplus_types.Not_regularly -> Format.fprintf fmt "Not_regularly"
  | Mangaplus_types.Monday -> Format.fprintf fmt "Monday"
  | Mangaplus_types.Tuesday -> Format.fprintf fmt "Tuesday"
  | Mangaplus_types.Wednesday -> Format.fprintf fmt "Wednesday"
  | Mangaplus_types.Thursday -> Format.fprintf fmt "Thursday"
  | Mangaplus_types.Friday -> Format.fprintf fmt "Friday"
  | Mangaplus_types.Saturday -> Format.fprintf fmt "Saturday"
  | Mangaplus_types.Sunday -> Format.fprintf fmt "Sunday"
  | Mangaplus_types.Day -> Format.fprintf fmt "Day"

let rec pp_chapter fmt (v:Mangaplus_types.chapter) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "title_id" Pbrt.Pp.pp_int fmt v.Mangaplus_types.title_id;
    Pbrt.Pp.pp_record_field "chapter_id" Pbrt.Pp.pp_int fmt v.Mangaplus_types.chapter_id;
    Pbrt.Pp.pp_record_field "name" Pbrt.Pp.pp_string fmt v.Mangaplus_types.name;
    Pbrt.Pp.pp_record_field "sub_title" Pbrt.Pp.pp_string fmt v.Mangaplus_types.sub_title;
    Pbrt.Pp.pp_record_field "thumbnail_url" Pbrt.Pp.pp_string fmt v.Mangaplus_types.thumbnail_url;
    Pbrt.Pp.pp_record_field "start_time_stamp" Pbrt.Pp.pp_int fmt v.Mangaplus_types.start_time_stamp;
    Pbrt.Pp.pp_record_field "end_time_stamp" Pbrt.Pp.pp_int fmt v.Mangaplus_types.end_time_stamp;
    Pbrt.Pp.pp_record_field "already_viewed" Pbrt.Pp.pp_bool fmt v.Mangaplus_types.already_viewed;
    Pbrt.Pp.pp_record_field "is_vertical_only" Pbrt.Pp.pp_bool fmt v.Mangaplus_types.is_vertical_only;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_title_detail_view_rating fmt (v:Mangaplus_types.title_detail_view_rating) =
  match v with
  | Mangaplus_types.Allage -> Format.fprintf fmt "Allage"
  | Mangaplus_types.Teen -> Format.fprintf fmt "Teen"
  | Mangaplus_types.Teenplus -> Format.fprintf fmt "Teenplus"
  | Mangaplus_types.Mature -> Format.fprintf fmt "Mature"

let rec pp_title_detail_view fmt (v:Mangaplus_types.title_detail_view) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "title" (Pbrt.Pp.pp_option pp_title) fmt v.Mangaplus_types.title;
    Pbrt.Pp.pp_record_field "title_image_url" Pbrt.Pp.pp_string fmt v.Mangaplus_types.title_image_url;
    Pbrt.Pp.pp_record_field "overview" Pbrt.Pp.pp_string fmt v.Mangaplus_types.overview;
    Pbrt.Pp.pp_record_field "background_image_url" Pbrt.Pp.pp_string fmt v.Mangaplus_types.background_image_url;
    Pbrt.Pp.pp_record_field "next_timestamp" Pbrt.Pp.pp_int fmt v.Mangaplus_types.next_timestamp;
    Pbrt.Pp.pp_record_field "update_timing" pp_title_detail_view_update_timing fmt v.Mangaplus_types.update_timing;
    Pbrt.Pp.pp_record_field "viewing_period_description" Pbrt.Pp.pp_string fmt v.Mangaplus_types.viewing_period_description;
    Pbrt.Pp.pp_record_field "non_appearance_info" Pbrt.Pp.pp_string fmt v.Mangaplus_types.non_appearance_info;
    Pbrt.Pp.pp_record_field "first_chapter_list" (Pbrt.Pp.pp_list pp_chapter) fmt v.Mangaplus_types.first_chapter_list;
    Pbrt.Pp.pp_record_field "last_chapter_list" (Pbrt.Pp.pp_list pp_chapter) fmt v.Mangaplus_types.last_chapter_list;
    Pbrt.Pp.pp_record_field "recommended_title_list" (Pbrt.Pp.pp_list pp_title) fmt v.Mangaplus_types.recommended_title_list;
    Pbrt.Pp.pp_record_field "is_simul_released" Pbrt.Pp.pp_bool fmt v.Mangaplus_types.is_simul_released;
    Pbrt.Pp.pp_record_field "is_subscribed" Pbrt.Pp.pp_bool fmt v.Mangaplus_types.is_subscribed;
    Pbrt.Pp.pp_record_field "rating" pp_title_detail_view_rating fmt v.Mangaplus_types.rating;
    Pbrt.Pp.pp_record_field "chapters_descending" Pbrt.Pp.pp_bool fmt v.Mangaplus_types.chapters_descending;
    Pbrt.Pp.pp_record_field "number_of_views" Pbrt.Pp.pp_int fmt v.Mangaplus_types.number_of_views;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_title_updated fmt (v:Mangaplus_types.title_updated) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "title" (Pbrt.Pp.pp_option pp_title) fmt v.Mangaplus_types.title;
    Pbrt.Pp.pp_record_field "updated_title_timestamp" Pbrt.Pp.pp_string fmt v.Mangaplus_types.updated_title_timestamp;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_title_updated_view fmt (v:Mangaplus_types.title_updated_view) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "latest_title" (Pbrt.Pp.pp_list pp_title_updated) fmt v.Mangaplus_types.latest_title;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_success_result_view fmt (v:Mangaplus_types.success_result_view) =
  match v with
  | Mangaplus_types.All_titles_view x -> Format.fprintf fmt "@[All_titles_view(%a)@]" pp_all_titles_view x
  | Mangaplus_types.Title_detail_view x -> Format.fprintf fmt "@[Title_detail_view(%a)@]" pp_title_detail_view x
  | Mangaplus_types.Title_updated_view x -> Format.fprintf fmt "@[Title_updated_view(%a)@]" pp_title_updated_view x

and pp_success_result fmt (v:Mangaplus_types.success_result) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "is_featured_updated" Pbrt.Pp.pp_bool fmt v.Mangaplus_types.is_featured_updated;
    Pbrt.Pp.pp_record_field "view" pp_success_result_view fmt v.Mangaplus_types.view;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_error_result_action fmt (v:Mangaplus_types.error_result_action) =
  match v with
  | Mangaplus_types.Default -> Format.fprintf fmt "Default"
  | Mangaplus_types.Unauthorized -> Format.fprintf fmt "Unauthorized"
  | Mangaplus_types.Maintenance -> Format.fprintf fmt "Maintenance"
  | Mangaplus_types.Geoip_blocking -> Format.fprintf fmt "Geoip_blocking"

let rec pp_error_result fmt (v:Mangaplus_types.error_result) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "action" pp_error_result_action fmt v.Mangaplus_types.action;
    Pbrt.Pp.pp_record_field "debug_info" Pbrt.Pp.pp_string fmt v.Mangaplus_types.debug_info;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_response fmt (v:Mangaplus_types.response) =
  match v with
  | Mangaplus_types.Success x -> Format.fprintf fmt "@[Success(%a)@]" pp_success_result x
  | Mangaplus_types.Error x -> Format.fprintf fmt "@[Error(%a)@]" pp_error_result x

let rec pp_coming_soon_title fmt (v:Mangaplus_types.coming_soon_title) = 
  let pp_i fmt () =
    Format.pp_open_vbox fmt 1;
    Pbrt.Pp.pp_record_field "title" (Pbrt.Pp.pp_option pp_title) fmt v.Mangaplus_types.title;
    Pbrt.Pp.pp_record_field "next_chapter_name" Pbrt.Pp.pp_string fmt v.Mangaplus_types.next_chapter_name;
    Pbrt.Pp.pp_record_field "next_chapter_start_timestamp" Pbrt.Pp.pp_int fmt v.Mangaplus_types.next_chapter_start_timestamp;
    Format.pp_close_box fmt ()
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

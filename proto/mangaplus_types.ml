[@@@ocaml.warning "-27-30-39"]

open Core

type title_language =
  | English 
  | Spanish [@@ deriving sexp]

type title = {
  title_id : int;
  name : string;
  author : string;
  portrait_image_url : string;
  landscape_image_url : string;
  view_count : int;
  language : title_language;
} [@@ deriving sexp]

type all_titles_view = {
  titles : title list;
}

type title_detail_view_update_timing =
  | Not_regularly 
  | Monday 
  | Tuesday 
  | Wednesday 
  | Thursday 
  | Friday 
  | Saturday 
  | Sunday 
  | Day [@@ deriving sexp]

type chapter = {
  title_id : int;
  chapter_id : int;
  name : string;
  sub_title : string;
  thumbnail_url : string;
  start_time_stamp : int;
  end_time_stamp : int;
  already_viewed : bool;
  is_vertical_only : bool;
} [@@ deriving sexp]

type title_detail_view_rating =
  | Allage 
  | Teen 
  | Teenplus 
  | Mature [@@ deriving sexp]

type title_detail_view = {
  title : title option;
  title_image_url : string;
  overview : string;
  background_image_url : string;
  next_timestamp : int;
  update_timing : title_detail_view_update_timing;
  viewing_period_description : string;
  non_appearance_info : string;
  first_chapter_list : chapter list;
  last_chapter_list : chapter list;
  recommended_title_list : title list;
  is_simul_released : bool;
  is_subscribed : bool;
  rating : title_detail_view_rating;
  chapters_descending : bool;
  number_of_views : int;
} [@@ deriving sexp]

type title_updated = {
  title : title option;
  updated_title_timestamp : string;
}

type title_updated_view = {
  latest_title : title_updated list;
}

type success_result_view =
  | All_titles_view of all_titles_view
  | Title_detail_view of title_detail_view
  | Title_updated_view of title_updated_view

and success_result = {
  is_featured_updated : bool;
  view : success_result_view;
}

type error_result_action =
  | Default 
  | Unauthorized 
  | Maintenance 
  | Geoip_blocking 

type error_result = {
  action : error_result_action;
  debug_info : string;
}

type response =
  | Success of success_result
  | Error of error_result

type coming_soon_title = {
  title : title option;
  next_chapter_name : string;
  next_chapter_start_timestamp : int;
}

let rec default_title_language () = (English:title_language)

let rec default_title 
  ?title_id:((title_id:int) = 0)
  ?name:((name:string) = "")
  ?author:((author:string) = "")
  ?portrait_image_url:((portrait_image_url:string) = "")
  ?landscape_image_url:((landscape_image_url:string) = "")
  ?view_count:((view_count:int) = 0)
  ?language:((language:title_language) = default_title_language ())
  () : title  = {
  title_id;
  name;
  author;
  portrait_image_url;
  landscape_image_url;
  view_count;
  language;
}

let rec default_all_titles_view 
  ?titles:((titles:title list) = [])
  () : all_titles_view  = {
  titles;
}

let rec default_title_detail_view_update_timing () = (Not_regularly:title_detail_view_update_timing)

let rec default_chapter 
  ?title_id:((title_id:int) = 0)
  ?chapter_id:((chapter_id:int) = 0)
  ?name:((name:string) = "")
  ?sub_title:((sub_title:string) = "")
  ?thumbnail_url:((thumbnail_url:string) = "")
  ?start_time_stamp:((start_time_stamp:int) = 0)
  ?end_time_stamp:((end_time_stamp:int) = 0)
  ?already_viewed:((already_viewed:bool) = false)
  ?is_vertical_only:((is_vertical_only:bool) = false)
  () : chapter  = {
  title_id;
  chapter_id;
  name;
  sub_title;
  thumbnail_url;
  start_time_stamp;
  end_time_stamp;
  already_viewed;
  is_vertical_only;
}

let rec default_title_detail_view_rating () = (Allage:title_detail_view_rating)

let rec default_title_detail_view 
  ?title:((title:title option) = None)
  ?title_image_url:((title_image_url:string) = "")
  ?overview:((overview:string) = "")
  ?background_image_url:((background_image_url:string) = "")
  ?next_timestamp:((next_timestamp:int) = 0)
  ?update_timing:((update_timing:title_detail_view_update_timing) = default_title_detail_view_update_timing ())
  ?viewing_period_description:((viewing_period_description:string) = "")
  ?non_appearance_info:((non_appearance_info:string) = "")
  ?first_chapter_list:((first_chapter_list:chapter list) = [])
  ?last_chapter_list:((last_chapter_list:chapter list) = [])
  ?recommended_title_list:((recommended_title_list:title list) = [])
  ?is_simul_released:((is_simul_released:bool) = false)
  ?is_subscribed:((is_subscribed:bool) = false)
  ?rating:((rating:title_detail_view_rating) = default_title_detail_view_rating ())
  ?chapters_descending:((chapters_descending:bool) = false)
  ?number_of_views:((number_of_views:int) = 0)
  () : title_detail_view  = {
  title;
  title_image_url;
  overview;
  background_image_url;
  next_timestamp;
  update_timing;
  viewing_period_description;
  non_appearance_info;
  first_chapter_list;
  last_chapter_list;
  recommended_title_list;
  is_simul_released;
  is_subscribed;
  rating;
  chapters_descending;
  number_of_views;
}

let rec default_title_updated 
  ?title:((title:title option) = None)
  ?updated_title_timestamp:((updated_title_timestamp:string) = "")
  () : title_updated  = {
  title;
  updated_title_timestamp;
}

let rec default_title_updated_view 
  ?latest_title:((latest_title:title_updated list) = [])
  () : title_updated_view  = {
  latest_title;
}

let rec default_success_result_view () : success_result_view = All_titles_view (default_all_titles_view ())

and default_success_result 
  ?is_featured_updated:((is_featured_updated:bool) = false)
  ?view:((view:success_result_view) = All_titles_view (default_all_titles_view ()))
  () : success_result  = {
  is_featured_updated;
  view;
}

let rec default_error_result_action () = (Default:error_result_action)

let rec default_error_result 
  ?action:((action:error_result_action) = default_error_result_action ())
  ?debug_info:((debug_info:string) = "")
  () : error_result  = {
  action;
  debug_info;
}

let rec default_response () : response = Success (default_success_result ())

let rec default_coming_soon_title 
  ?title:((title:title option) = None)
  ?next_chapter_name:((next_chapter_name:string) = "")
  ?next_chapter_start_timestamp:((next_chapter_start_timestamp:int) = 0)
  () : coming_soon_title  = {
  title;
  next_chapter_name;
  next_chapter_start_timestamp;
}

(** mangaplus.proto Types *)



(** {2 Types} *)

type title_language =
  | English 
  | Spanish 
  | French 
  | Indonesian 
  | Portuguese_br 
  | Russian 
  | Thai 

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
  | Day 

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
}

type title_detail_view_rating =
  | Allage 
  | Teen 
  | Teenplus 
  | Mature 

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


(** {2 Default values} *)

val default_title_language : unit -> title_language
(** [default_title_language ()] is the default value for type [title_language] *)

val default_title : 
  ?title_id:int ->
  ?name:string ->
  ?author:string ->
  ?portrait_image_url:string ->
  ?landscape_image_url:string ->
  ?view_count:int ->
  ?language:title_language ->
  unit ->
  title
(** [default_title ()] is the default value for type [title] *)

val default_all_titles_view : 
  ?titles:title list ->
  unit ->
  all_titles_view
(** [default_all_titles_view ()] is the default value for type [all_titles_view] *)

val default_title_detail_view_update_timing : unit -> title_detail_view_update_timing
(** [default_title_detail_view_update_timing ()] is the default value for type [title_detail_view_update_timing] *)

val default_chapter : 
  ?title_id:int ->
  ?chapter_id:int ->
  ?name:string ->
  ?sub_title:string ->
  ?thumbnail_url:string ->
  ?start_time_stamp:int ->
  ?end_time_stamp:int ->
  ?already_viewed:bool ->
  ?is_vertical_only:bool ->
  unit ->
  chapter
(** [default_chapter ()] is the default value for type [chapter] *)

val default_title_detail_view_rating : unit -> title_detail_view_rating
(** [default_title_detail_view_rating ()] is the default value for type [title_detail_view_rating] *)

val default_title_detail_view : 
  ?title:title option ->
  ?title_image_url:string ->
  ?overview:string ->
  ?background_image_url:string ->
  ?next_timestamp:int ->
  ?update_timing:title_detail_view_update_timing ->
  ?viewing_period_description:string ->
  ?non_appearance_info:string ->
  ?first_chapter_list:chapter list ->
  ?last_chapter_list:chapter list ->
  ?recommended_title_list:title list ->
  ?is_simul_released:bool ->
  ?is_subscribed:bool ->
  ?rating:title_detail_view_rating ->
  ?chapters_descending:bool ->
  ?number_of_views:int ->
  unit ->
  title_detail_view
(** [default_title_detail_view ()] is the default value for type [title_detail_view] *)

val default_title_updated : 
  ?title:title option ->
  ?updated_title_timestamp:string ->
  unit ->
  title_updated
(** [default_title_updated ()] is the default value for type [title_updated] *)

val default_title_updated_view : 
  ?latest_title:title_updated list ->
  unit ->
  title_updated_view
(** [default_title_updated_view ()] is the default value for type [title_updated_view] *)

val default_success_result_view : unit -> success_result_view
(** [default_success_result_view ()] is the default value for type [success_result_view] *)

val default_success_result : 
  ?is_featured_updated:bool ->
  ?view:success_result_view ->
  unit ->
  success_result
(** [default_success_result ()] is the default value for type [success_result] *)

val default_error_result_action : unit -> error_result_action
(** [default_error_result_action ()] is the default value for type [error_result_action] *)

val default_error_result : 
  ?action:error_result_action ->
  ?debug_info:string ->
  unit ->
  error_result
(** [default_error_result ()] is the default value for type [error_result] *)

val default_response : unit -> response
(** [default_response ()] is the default value for type [response] *)

val default_coming_soon_title : 
  ?title:title option ->
  ?next_chapter_name:string ->
  ?next_chapter_start_timestamp:int ->
  unit ->
  coming_soon_title
(** [default_coming_soon_title ()] is the default value for type [coming_soon_title] *)

(** mangaplus.proto Pretty Printing *)


(** {2 Formatters} *)

val pp_title_language : Format.formatter -> Mangaplus_types.title_language -> unit 
(** [pp_title_language v] formats v *)

val pp_title : Format.formatter -> Mangaplus_types.title -> unit 
(** [pp_title v] formats v *)

val pp_all_titles_view : Format.formatter -> Mangaplus_types.all_titles_view -> unit 
(** [pp_all_titles_view v] formats v *)

val pp_title_detail_view_update_timing : Format.formatter -> Mangaplus_types.title_detail_view_update_timing -> unit 
(** [pp_title_detail_view_update_timing v] formats v *)

val pp_chapter : Format.formatter -> Mangaplus_types.chapter -> unit 
(** [pp_chapter v] formats v *)

val pp_title_detail_view_rating : Format.formatter -> Mangaplus_types.title_detail_view_rating -> unit 
(** [pp_title_detail_view_rating v] formats v *)

val pp_title_detail_view : Format.formatter -> Mangaplus_types.title_detail_view -> unit 
(** [pp_title_detail_view v] formats v *)

val pp_title_updated : Format.formatter -> Mangaplus_types.title_updated -> unit 
(** [pp_title_updated v] formats v *)

val pp_title_updated_view : Format.formatter -> Mangaplus_types.title_updated_view -> unit 
(** [pp_title_updated_view v] formats v *)

val pp_success_result_view : Format.formatter -> Mangaplus_types.success_result_view -> unit 
(** [pp_success_result_view v] formats v *)

val pp_success_result : Format.formatter -> Mangaplus_types.success_result -> unit 
(** [pp_success_result v] formats v *)

val pp_error_result_action : Format.formatter -> Mangaplus_types.error_result_action -> unit 
(** [pp_error_result_action v] formats v *)

val pp_error_result : Format.formatter -> Mangaplus_types.error_result -> unit 
(** [pp_error_result v] formats v *)

val pp_response : Format.formatter -> Mangaplus_types.response -> unit 
(** [pp_response v] formats v *)

val pp_coming_soon_title : Format.formatter -> Mangaplus_types.coming_soon_title -> unit 
(** [pp_coming_soon_title v] formats v *)

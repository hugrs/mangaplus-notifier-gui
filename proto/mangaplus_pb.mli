(** mangaplus.proto Binary Encoding *)


(** {2 Protobuf Encoding} *)

val encode_title_language : Mangaplus_types.title_language -> Pbrt.Encoder.t -> unit
(** [encode_title_language v encoder] encodes [v] with the given [encoder] *)

val encode_title : Mangaplus_types.title -> Pbrt.Encoder.t -> unit
(** [encode_title v encoder] encodes [v] with the given [encoder] *)

val encode_all_titles_view : Mangaplus_types.all_titles_view -> Pbrt.Encoder.t -> unit
(** [encode_all_titles_view v encoder] encodes [v] with the given [encoder] *)

val encode_title_detail_view_update_timing : Mangaplus_types.title_detail_view_update_timing -> Pbrt.Encoder.t -> unit
(** [encode_title_detail_view_update_timing v encoder] encodes [v] with the given [encoder] *)

val encode_chapter : Mangaplus_types.chapter -> Pbrt.Encoder.t -> unit
(** [encode_chapter v encoder] encodes [v] with the given [encoder] *)

val encode_title_detail_view_rating : Mangaplus_types.title_detail_view_rating -> Pbrt.Encoder.t -> unit
(** [encode_title_detail_view_rating v encoder] encodes [v] with the given [encoder] *)

val encode_title_detail_view : Mangaplus_types.title_detail_view -> Pbrt.Encoder.t -> unit
(** [encode_title_detail_view v encoder] encodes [v] with the given [encoder] *)

val encode_title_updated : Mangaplus_types.title_updated -> Pbrt.Encoder.t -> unit
(** [encode_title_updated v encoder] encodes [v] with the given [encoder] *)

val encode_title_updated_view : Mangaplus_types.title_updated_view -> Pbrt.Encoder.t -> unit
(** [encode_title_updated_view v encoder] encodes [v] with the given [encoder] *)

val encode_success_result_view : Mangaplus_types.success_result_view -> Pbrt.Encoder.t -> unit
(** [encode_success_result_view v encoder] encodes [v] with the given [encoder] *)

val encode_success_result : Mangaplus_types.success_result -> Pbrt.Encoder.t -> unit
(** [encode_success_result v encoder] encodes [v] with the given [encoder] *)

val encode_error_result_action : Mangaplus_types.error_result_action -> Pbrt.Encoder.t -> unit
(** [encode_error_result_action v encoder] encodes [v] with the given [encoder] *)

val encode_error_result : Mangaplus_types.error_result -> Pbrt.Encoder.t -> unit
(** [encode_error_result v encoder] encodes [v] with the given [encoder] *)

val encode_response : Mangaplus_types.response -> Pbrt.Encoder.t -> unit
(** [encode_response v encoder] encodes [v] with the given [encoder] *)

val encode_coming_soon_title : Mangaplus_types.coming_soon_title -> Pbrt.Encoder.t -> unit
(** [encode_coming_soon_title v encoder] encodes [v] with the given [encoder] *)


(** {2 Protobuf Decoding} *)

val decode_title_language : Pbrt.Decoder.t -> Mangaplus_types.title_language
(** [decode_title_language decoder] decodes a [title_language] value from [decoder] *)

val decode_title : Pbrt.Decoder.t -> Mangaplus_types.title
(** [decode_title decoder] decodes a [title] value from [decoder] *)

val decode_all_titles_view : Pbrt.Decoder.t -> Mangaplus_types.all_titles_view
(** [decode_all_titles_view decoder] decodes a [all_titles_view] value from [decoder] *)

val decode_title_detail_view_update_timing : Pbrt.Decoder.t -> Mangaplus_types.title_detail_view_update_timing
(** [decode_title_detail_view_update_timing decoder] decodes a [title_detail_view_update_timing] value from [decoder] *)

val decode_chapter : Pbrt.Decoder.t -> Mangaplus_types.chapter
(** [decode_chapter decoder] decodes a [chapter] value from [decoder] *)

val decode_title_detail_view_rating : Pbrt.Decoder.t -> Mangaplus_types.title_detail_view_rating
(** [decode_title_detail_view_rating decoder] decodes a [title_detail_view_rating] value from [decoder] *)

val decode_title_detail_view : Pbrt.Decoder.t -> Mangaplus_types.title_detail_view
(** [decode_title_detail_view decoder] decodes a [title_detail_view] value from [decoder] *)

val decode_title_updated : Pbrt.Decoder.t -> Mangaplus_types.title_updated
(** [decode_title_updated decoder] decodes a [title_updated] value from [decoder] *)

val decode_title_updated_view : Pbrt.Decoder.t -> Mangaplus_types.title_updated_view
(** [decode_title_updated_view decoder] decodes a [title_updated_view] value from [decoder] *)

val decode_success_result_view : Pbrt.Decoder.t -> Mangaplus_types.success_result_view
(** [decode_success_result_view decoder] decodes a [success_result_view] value from [decoder] *)

val decode_success_result : Pbrt.Decoder.t -> Mangaplus_types.success_result
(** [decode_success_result decoder] decodes a [success_result] value from [decoder] *)

val decode_error_result_action : Pbrt.Decoder.t -> Mangaplus_types.error_result_action
(** [decode_error_result_action decoder] decodes a [error_result_action] value from [decoder] *)

val decode_error_result : Pbrt.Decoder.t -> Mangaplus_types.error_result
(** [decode_error_result decoder] decodes a [error_result] value from [decoder] *)

val decode_response : Pbrt.Decoder.t -> Mangaplus_types.response
(** [decode_response decoder] decodes a [response] value from [decoder] *)

val decode_coming_soon_title : Pbrt.Decoder.t -> Mangaplus_types.coming_soon_title
(** [decode_coming_soon_title decoder] decodes a [coming_soon_title] value from [decoder] *)

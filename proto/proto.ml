module Mangaplus_pb = Mangaplus_pb
module Mangaplus_pp = Mangaplus_pp
module Mangaplus_types = Mangaplus_types

type title = Mangaplus_types.title [@@ deriving sexp]
type title_detail = Mangaplus_types.title_detail_view [@@ deriving sexp]
type title_full = {
  title: title;
  detail: title_detail
} [@@ deriving sexp]

let is_english (title : Mangaplus_types.title) =
  title.language = English

let is_spanish (title : Mangaplus_types.title) =
  title.language = Spanish

let is_completed (detail : Mangaplus_types.title_detail_view) =
  detail.next_timestamp = 0

module Mangaplus_pb = Mangaplus_pb
module Mangaplus_pp = Mangaplus_pp
module Mangaplus_types = Mangaplus_types

module Title = struct
  open Mangaplus_types

  let is_english t = t.language = English
  let is_spanish t = t.language = Spanish
  let id (t:title) = t.title_id

  let is_completed detail = detail.next_timestamp = 0
end

type title = Mangaplus_types.title
type title_detail = Mangaplus_types.title_detail_view
type title_full = {
  title: title;
  detail: title_detail
}

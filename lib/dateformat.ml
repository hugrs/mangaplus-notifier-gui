open Core

let time_of_epoch seconds =
  Time.Span.of_int_sec seconds
  |> Time.of_span_since_epoch

let date_of_epoch seconds =
  time_of_epoch seconds
  |> Time.to_date ~zone:(Lazy.force Time.Zone.local)

let datetime_of_epoch seconds =
  time_of_epoch seconds
  |> Time.to_date_ofday ~zone:(Lazy.force Time.Zone.local)

let epoch_to_human_string seconds =
  let (date,hour) = datetime_of_epoch seconds in
  Printf.sprintf "%s %s" (Date.format date "%A %d %B") (Time.Ofday.to_string_trimmed hour)

module Date_relative = struct
  [@@@ocaml.warning "-37"]
  module Dayspan = struct
    (* months - weeks - days *)
    type t = { m: int; w: int; d: int }
    let create m w d = { m; w; d }
    let empty = create 0 0 0
    let add_days t days = create t.m t.w (t.d + days)
    let add_weeks t weeks = create t.m (t.w + weeks) t.d
    let add_months t months = create (t.m + months) t.w t.d

    let decompose days =
      let rec helper span days =
        if days >= 30 then helper (add_months span 1) (days - 30)
        else if days >= 7 then helper (add_weeks span 1) (days - 7)
        else (add_days span days) in
      helper empty days

    type c =
      | Today
      | Days of int
      | Weeks of int
      | Months of int
    
    let categorize = function
      | { m=0; w=0; d=0 } -> Today
      | { m=0; w=0; d } -> Days d
      | { m=0; w; _ } -> Weeks w
      | { m; _ } -> Months m
  end

  type plural_type =
    | None
    | Suffix of string
    | Replace of string
  type with_plural = string * plural_type
  type time_direction = Past | Future

  type span_lang = {
    today: string;
    day: with_plural;
    week: with_plural;
    month: with_plural;
    template_past: int -> string -> string;
    template_future: int -> string -> string
  }

  let french = {
    today = "aujourd'hui";
    day = ("jour", Suffix "s");
    week = ("semaine", Suffix "s");
    month = ("mois", None);
    template_past = begin fun a s -> Printf.sprintf "il y a %i %s" a s end;
    template_future = begin fun a s -> Printf.sprintf "dans %i %s" a s end
  }
  let english = {
    today = "today";
    day = ("day", Suffix "s");
    week = ("week", Suffix "s");
    month = ("month", Suffix "s");
    template_past = begin fun a s -> Printf.sprintf "%i %s ago" a s end;
    template_future = begin fun a s -> Printf.sprintf "in %i %s" a s end
  }

  let pluralize (word, ptype) amount =
    if amount = 1 then word
    else match ptype with
    | None -> word
    | Suffix s -> word ^ s
    | Replace rep -> rep

  let localize dict direction span =
    let apply_template plural_info amount =
      match direction with
      | Past -> dict.template_past amount (pluralize plural_info amount)
      | Future -> dict.template_future amount (pluralize plural_info amount) in
    match Dayspan.categorize span with
    | Today -> dict.today
    | Days a -> apply_template dict.day a
    | Weeks a -> apply_template dict.week a
    | Months a -> apply_template dict.month a
  
  let of_dates d1 d2 ~lang:dict =
    let daydiff = Date.diff d2 d1 in
    let direction = if daydiff >= 0 then Future else Past in
    let daydiff = Int.abs daydiff in
    let spaninfo = Dayspan.decompose daydiff in
    localize dict direction spaninfo

  let of_date_from_today date ~lang:dict =
    let today = Date.today ~zone:(Lazy.force Time.Zone.local) in
    of_dates today date ~lang:dict

  let of_epochs t1 t2 ~lang =
    of_dates (date_of_epoch t1) (date_of_epoch t2) ~lang

  let of_epoch_from_today time ~lang =
    of_date_from_today (date_of_epoch time) ~lang
end

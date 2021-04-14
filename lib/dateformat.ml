open Core

let time_of_epoch seconds =
  let span = Time.Span.of_int_sec seconds in
  Time.of_span_since_epoch span

let date_of_epoch seconds =
  time_of_epoch seconds
  |> Time.to_date_ofday ~zone: (Lazy.force Time.Zone.local)

let epoch_to_human_string seconds =
  let (date,hour) = date_of_epoch seconds in
  Printf.sprintf "%s %s" (Date.format date "%A %d %B") (Time.Ofday.to_string_trimmed hour)

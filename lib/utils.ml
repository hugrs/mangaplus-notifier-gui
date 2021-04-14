(** Utility functions that are not specific to this project  *)

open Core

let _debug_print str =
  Out_channel.print_endline str;
  String.map ~f:(function ' ' -> 's' | '\n' -> 'n' | _->'?') str
  |> Out_channel.print_endline;
  str

let break_string ~limit str =
  let words = String.split ~on:' ' str in
  (* build a list of equal length, which consists of spaces and newlines *)
  let separators = List.folding_map words ~init:0 ~f:(fun acc elem ->
    let next_len = acc + (String.length elem) in
    if next_len > limit 
      then (0, "\n")
      else (next_len + 1, " ") (* account for the extra space *)
  ) in
  (* we want the separator before the word, otherwise it would pass the limit *)
  List.map2_exn separators words ~f:String.(^)
  |> String.concat ~sep:""
  |> String.lstrip (* remove dummy space *)

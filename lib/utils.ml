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

let copy_contents ~src ~dest =
  let buf = Bytes.create 4096 in
  let rec iter () =
    match Unix.read src ~len:4096 ~buf with
    | 4096 ->
      let _ = Unix.write ~len:4096 dest ~buf in
      iter ()
    | x when x < 4096 ->
      let _ = Unix.write ~len:x dest ~buf in
      ()
    | 0 -> ()
    | _ -> failwith "Unknown length returned from read" in
  iter ()

let copy ~src ~dest =
  let srcfd = Unix.openfile ~mode:[Unix.O_RDONLY] src in
  let destfd = Unix.openfile ~mode:[Unix.O_WRONLY ; Unix.O_CREAT ; Unix.O_TRUNC] dest in
  copy_contents ~src:srcfd ~dest:destfd;
  Unix.close destfd;
  Unix.close srcfd
  
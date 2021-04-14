open Core

let write_all_bytes file ~data =
  Out_channel.with_file ~binary:true file ~f:(fun outfile ->
    Out_channel.output_bytes outfile data
  )

let read_bytes ?(expected_size=4096) chan =
  let rec read_iter chan buf =
    match In_channel.input_buffer chan buf ~len:4096 with
    | Some () -> read_iter chan buf
    | None -> ()
  in
  let buf = Buffer.create expected_size in
  read_iter chan buf;
  Buffer.contents_bytes buf

let read_all_bytes file =
  In_channel.with_file ~binary:true file ~f:read_bytes

let if_exists file ~f =
  match Sys.file_exists file with
  | `No | `Unknown -> None
  | `Yes -> Some (f file)

let save_pb ~encode_f ~file data =
  let encoder = Pbrt.Encoder.create () in
  encode_f data encoder;
  let encoded_bytes = Pbrt.Encoder.to_bytes encoder in
  write_all_bytes file ~data:encoded_bytes

let load_pb ~decode_f file =
  let data_bytes = read_all_bytes file in
  let decoder = Pbrt.Decoder.of_bytes data_bytes in
  decode_f decoder

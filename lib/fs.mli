val write_all_bytes : string -> data:bytes -> unit
val read_all_bytes : string -> bytes
val if_exists : string -> f:(string -> 'a) -> 'a option
val save_pb : encode_f:('a -> Pbrt.Encoder.t -> unit) -> file:string -> 'a -> unit
val load_pb : decode_f:(Pbrt.Decoder.t -> 'a) -> string -> 'a
val path_from_root : ?create_dir:bool -> string -> string

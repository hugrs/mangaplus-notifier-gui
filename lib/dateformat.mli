val time_of_epoch : int -> Core.Time.t
val date_of_epoch : int -> Core.Date.t
val datetime_of_epoch : int -> Core.Date.t * Core.Time.Ofday.t
val epoch_to_human_string : int -> string

module Date_relative : sig
    type span_lang
    val french : span_lang
    val english : span_lang
    val of_dates : Core.Date.t -> Core.Date.t -> lang:span_lang -> string
    val of_date_from_today : Core.Date.t -> lang:span_lang -> string
    val of_epochs : int -> int -> lang:span_lang -> string
    val of_epoch_from_today : int -> lang:span_lang -> string
end

(** Receives a list of titles to check for new releases.
  Returns a list containing only titles who have a new chapter, with their info
  updated, or an empty list if no new chapter came out  *)
val update_outdated :
  Proto.title_full list -> Proto.title_full list Async.Deferred.t

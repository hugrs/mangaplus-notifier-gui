let test_copy () =
  Logs.set_level (Some Logs.Debug);
  Logs.set_reporter (Logs_fmt.reporter ());

  (* needed because files are copied to _build as readonly *)
  Unix.chmod "dummy2.txt" 0o660;
  
  let initial_sum = Sha1.file "dummy1.txt" in
  Logs.debug (fun m -> m "Copying %s to %s" "dummy1" "dummy2");
  Lib.Utils.copy ~src:"dummy1.txt" ~dest:"dummy2.txt";
  let new_sum = Sha1.file "dummy2.txt" in
  assert (String.equal (Sha1.to_bin initial_sum) (Sha1.to_bin new_sum));
  Logs.debug (fun m -> m "sha1 sums:\n%s\n%s" (Sha1.to_hex initial_sum) (Sha1.to_hex new_sum));
  ()

let () = test_copy ()

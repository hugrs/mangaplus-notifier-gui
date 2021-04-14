let connect (obj : (callback: 'a -> 'b)) (cb : 'a) =
  let id = obj ~callback:cb in
  ignore id

let (<~) = connect

#load "nums.cma"

let ( *~ ) = Big_int.mult_big_int
let ( +~ ) = Big_int.add_big_int
let ( /~ ) = Big_int.div_big_int
let ( -~ ) = Big_int.sub_big_int
let ( ^~ ) = Big_int.mod_big_int
let ( =~ ) = Big_int.eq_big_int
let ( <~ ) = Big_int.lt_big_int
let ( <=~ ) = Big_int.le_big_int
let ( >=~ ) = Big_int.ge_big_int
let ( >~ ) = Big_int.gt_big_int

let primes =
  [ Big_int.big_int_of_int 2;
    Big_int.big_int_of_int 3;
    Big_int.big_int_of_int 5;
    Big_int.big_int_of_int 7;
    Big_int.big_int_of_int 17;
    Big_int.big_int_of_int 19;
    Big_int.big_int_of_int 101;
    Big_int.big_int_of_int 103 ]

let unprimes =
  [ Big_int.big_int_of_int 1;
    Big_int.big_int_of_int 4;
    Big_int.big_int_of_int 6;
    Big_int.big_int_of_int 9;
    Big_int.big_int_of_int 14;
    Big_int.big_int_of_int 20;
    Big_int.big_int_of_int 108;
    Big_int.big_int_of_int 77;
    Big_int.big_int_of_int 21 ]

let is_prime n =
  match n with
  | n when n <~ Big_int.zero_big_int -> raise (Failure "Not nature")
  | n when n =~ Big_int.big_int_of_int 1 -> false
  | n when n =~ Big_int.big_int_of_int 2 -> true
  | n when n ^~ Big_int.big_int_of_int 2 =~ Big_int.zero_big_int -> false
  | n ->
      let s =
        Big_int.big_int_of_int
          (int_of_float (sqrt (float_of_int (Big_int.int_of_big_int n))))
      in
      let rec r i acc =
        if i <=~ s then
          if n ^~ i =~ Big_int.zero_big_int then false
          else r (i +~ Big_int.big_int_of_int 2) true
        else true
      in
      r (Big_int.big_int_of_int 3) true

let test_is_prime =
  let rec test_primes lst acc =
    match lst with
    | [] -> acc
    | a :: b ->
        test_primes
          b
          (if is_prime a then acc
          else (
            Printf.printf "test_primes: %s\n" (Big_int.string_of_big_int a) ;
            false))
  and test_unprimes lst acc =
    match lst with
    | [] -> acc
    | a :: b ->
        test_unprimes
          b
          (if is_prime a then (
           Printf.printf "test_unprimes: %s\n" (Big_int.string_of_big_int a) ;
           false)
          else acc)
  in
  test_primes primes true && test_unprimes unprimes true
;;

Printf.printf "%b\n" test_is_prime ;;

Printf.printf
  "%b\n"
  (is_prime
     (Big_int.big_int_of_string
        "82616570773948327592232845941706525094512325230608"))
;;

Printf.printf
  "%b\n"
  (is_prime
     (Big_int.big_int_of_string
        "59959406895756536782107074926966537676326235447210"))

let time f =
  let start = Sys.time () in
  let _ = f () in
  let end_ = Sys.time () in
  end_ -. start

let time_average f n =
  let rec loop i acc = if i < n then loop (succ i) (time f +. acc) else acc in
  loop 1 (float_of_int 0) /. float_of_int n
;;

Printf.printf
  "%f\n"
  (time_average
     (fun () -> is_prime (Big_int.big_int_of_int 111111234911111))
     10)

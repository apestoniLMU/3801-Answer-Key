exception Negative_Amount

let change amount =
  if amount < 0 then
    raise Negative_Amount
  else
    let denominations = [ 25; 10; 5; 1 ] in
    let rec aux remaining denominations =
      match denominations with
      | [] -> []
      | d :: ds -> (remaining / d) :: aux (remaining mod d) ds
    in
    aux amount denominations

(* Returns the application of a given function applied to the first item in the given list that satisfies the given
 * predicate. *)
let rec first_then_apply (item : 'a list) (pred : 'a -> bool) (func : 'a -> 'b option) : 'b option =
  match item with
  | [] -> None
  | x :: xs ->
  	if pred x then func x
    else first_then_apply xs pred func

(* Generates an infinite sequence of powers of a given base. *)
let powers_generator (base: int) : int Seq.t =
  let rec generate_power n () = Seq.Cons (n, generate_power (n * base)) in
  generate_power 1


(* Returns the number of lines in the given file that are (1) not empty, (2) not all whitespace, and (3) whose first
 * character is not '#'. *)
let meaningful_line_count (filename: string) : int =
  let is_meaningful_line (line: string) : bool =
    let trimmed_string = String.trim line in
    trimmed_string <> "" && not (String.starts_with ~prefix:"#" trimmed_string)
  in

  let file = open_in filename in
  let finally () = close_in file in

  let rec count_meaningful_lines (count: int) : int =
    match input_line file with
    | line -> count_meaningful_lines (if is_meaningful_line line then count + 1 else count)
    | exception End_of_file -> count
  in

  Fun.protect ~finally (fun () -> count_meaningful_lines 0)

(* Type representing a shape. Shapes implement methods for calculating their volume and surface area. *)
type shape = Sphere of float | Box of float * float * float

(* Calculates the volume of a given shape. *)
let volume (shape: shape) : float =
  match shape with
  | Sphere r -> Float.pi *. (r ** 3.) *. 4. /. 3.
  | Box (l, w, h) -> l *. w *. h

(* Calculates the surface area of a given shape. *)
let surface_area (shape: shape) : float =
  match shape with
  | Sphere r -> 4. *. Float.pi *. (r ** 2.)
  | Box (l, w, h) -> 2. *. ((l *. w) +. (l *. h) +. (w *. h))

(* Type representing an empty or non-empty node in a binary search tree. *)
type 'a binary_search_tree =
  | Empty
  | Node of 'a binary_search_tree * 'a * 'a binary_search_tree

(* Returns the size of a binary search tree. *)
let rec size (tree: 'a binary_search_tree) : int =
  match tree with
  | Empty -> 0
  | Node (left, _, right) -> 1 + size left + size right

(* Returns whether a value is contained in a binary search tree. *)
let rec contains (value: 'a) (tree: 'a binary_search_tree) : bool =
  match tree with
  | Empty -> false
  | Node (left, v, right) ->
      if value = v then true
      else if value < v then contains value left
      else contains value right

(* Returns an in-order traversal of a binary search tree as a list. *)
let rec inorder (tree: 'a binary_search_tree) : 'a list=
  match tree with
  | Empty -> []
  | Node (left, v, right) -> inorder left @ [ v ] @ inorder right

(* Inserts a value into a binary search tree. *)
let rec insert (value: 'a) (tree: 'a binary_search_tree) : 'a binary_search_tree =
  match tree with
  | Empty -> Node (Empty, value, Empty)
  | Node (left, v, right) ->
      if value < v then Node (insert value left, v, right)
      else if value > v then Node (left, v, insert value right)
      else tree
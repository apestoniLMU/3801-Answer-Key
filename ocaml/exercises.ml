exception Negative_Amount

(** 
    Calculates the number of coins needed to make change for a given amount.

    @param amount The amount of money to make change for.
    @raise Negative_Amount If the amount is negative.
    @return A list of integers representing the number of coins of each denomination.
*)
let change amount =
  if amount < 0 then raise Negative_Amount
  else
    let denominations = [ 25; 10; 5; 1 ] in
    let rec aux remaining denominations =
      match denominations with
      | [] -> []
      | d :: ds -> (remaining / d) :: aux (remaining mod d) ds
    in
    aux amount denominations

(** 
    Applies a transformation to the first element of a list that satisfies a given predicate.

    @param item The list of elements to search through.
    @param predicate A function that returns true for the element to transform.
    @param transform A function to apply to the first matching element.
    @return An option type that contains the transformed element or None if no match is found.
*)
let rec first_then_apply item predicate transform =
  match item with
  | [] -> None
  | x :: xs ->
      if predicate x then transform x
      else first_then_apply xs predicate transform

(** 
    Generates a sequence of powers of a given base.

    @param base The base to raise to increasing powers.
    @return A sequence of powers of the base.
*)
let powers_generator base =
  let rec generate_power n () = Seq.Cons (n, generate_power (n * base)) in
  generate_power 1

(** 
    Counts the number of meaningful (non-empty and non-comment) lines in a file.

    @param filename The name of the file to analyze.
    @return The count of meaningful lines in the file.
*)
let meaningful_line_count filename =
  let channel = open_in filename in
  let rec count_lines access =
    try
      let line = input_line channel |> String.trim in
      if line <> "" && not (String.starts_with ~prefix:"#" line) then
        count_lines (access + 1)
      else count_lines access
    with End_of_file ->
      close_in channel;
      access
  in
  count_lines 0

(** 
    Type representing different shapes. 
    Either a Sphere with a radius or a Box with length, width, and height. 
*)
type shape = Sphere of float | Box of float * float * float

(** 
    Calculates the volume of a given shape.

    @param s The shape for which to calculate the volume.
    @return The volume of the shape as a float.
*)
let volume s =
  match s with
  | Sphere r -> Float.pi *. (r ** 3.) *. 4. /. 3.
  | Box (l, w, h) -> l *. w *. h

(** 
    Calculates the surface area of a given shape.

    @param s The shape for which to calculate the surface area.
    @return The surface area of the shape as a float.
*)
let surface_area s =
  match s with
  | Sphere r -> 4. *. Float.pi *. (r ** 2.)
  | Box (l, w, h) -> 2. *. ((l *. w) +. (l *. h) +. (w *. h))

(** 
    Type representing a binary search tree. 
    Can be empty or contain a node with a value and two subtrees. 
*)
type 'a binary_search_tree =
  | Empty
  | Node of 'a binary_search_tree * 'a * 'a binary_search_tree

(** 
    Calculates the size (number of nodes) of a binary search tree.

    @param tree The binary search tree.
    @return The number of nodes in the tree.
*)
let rec size tree =
  match tree with
  | Empty -> 0
  | Node (left, _, right) -> 1 + size left + size right

(** 
    Checks if a value is contained in a binary search tree.

    @param value The value to search for.
    @param tree The binary search tree.
    @return True if the value is found, otherwise false.
*)
let rec contains value tree =
  match tree with
  | Empty -> false
  | Node (left, v, right) ->
      if value = v then true
      else if value < v then contains value left
      else contains value right

(** 
    Returns an inorder traversal of the binary search tree as a list.

    @param tree The binary search tree.
    @return A list of values in inorder.
*)
let rec inorder tree =
  match tree with
  | Empty -> []
  | Node (left, v, right) -> inorder left @ [ v ] @ inorder right

(** 
    Inserts a value into a binary search tree

    @param value The value to insert.
    @param tree The binary search tree.
    @return The new tree with the value inserted.
*)
let rec insert value tree =
  match tree with
  | Empty -> Node (Empty, value, Empty)
  | Node (left, v, right) ->
      if value < v then Node (insert value left, v, right)
      else if value > v then Node (left, v, insert value right)
      else tree
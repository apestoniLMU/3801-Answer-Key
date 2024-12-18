# CMSI 3801 Homework - Pesto & Co.

**Group Members:** 

* Axel Pestoni (@[apestoniLMU](https://github.com/apestoniLMU))
* Sam Reitich (@[sreitich](https://github.com/sreitich))
* Eren Unsal (@[Cyrendex](https://github.com/Cyrendex))
* Mehmet Colakoglu (@[mcolakoglu](https://github.com/Mehmet-Colak))



## Assignments



### **Homework 1:**

This assignment implements 5 exercises: 
* **First, then Lower-Case:** Function taking a sequence of strings and a predicate; returns the first string in the sequence that satisfies the predicate. Returns null if no strings satisfy the predicate.
* **Powers Generator:** Function that takes a base and an upper limit; creates a generator that yields the sequential powers of the given base, up to the given limit.
* **Say:** "Chainable" function with an optional string parameter. When given a string, returns a recursive function that can take a new string parameter. When no more strings (or an empty string) are given, returns a new string concatenating each string that was passed in the chained sequence of calls, joined by a space character.
* **Meaningful Line Count:** Function that takes a file path. Returns the number of lines in that file that are *not* (1) empty, (2) made entirely of whitespace, or (3) whose first non-whitespace character is '#'.
* **Quaternion:** Class representing the eponymous mathematical structure, which defines the rotation of an object in three-dimensional space. Implements overloaded operators for adding, multiplying, equality-checking, and "stringifying." Defines additional helpers for retrieving the quaternion's coefficients and computing its conjugate.

### Homework 2:

This assignment re-implements 4 of the previous exercises in new languages, and 1 new exercise:

* **First, then Lower-Case:** Identical in functionality to the previous function of the same name: returns the first string in a given sequence that satisfies a given predicate (converted to lowercase).
* **Say:** Similar in behavior to the previous `Say` function, but implemented as an object. Words are chained via an `and` method, and printed via accessing a `phrase` property.
* **Meaningful Line Count:** Identical in functionality to the previous function of the same name: returns the number of lines in a given file that are not (1) empty, (2) made entirely of whitespace, or (3) whose first non-whitespace character is '#'.
* **Quaternion:** A class, record, or struct (depending on the language in which it was implemented) representing a mathematical quaternion. Identical structure and behavior to the **Quaternion** class in the previous exercise. Adds a collection of useful constant static members: quaternions for `zero`, `I`, `J`, and `K`. 
* **Binary Search Tree:** A simple binary search tree with methods for inserting nodes, calculating the tree's size, checking if the tree contains a given value, and printing the tree's structure as a string. Implemented as a sealed interface (Java, Kotlin) or an enumeration (Swift), rather than a class or structure.

### Homework 3:

This assignment re-implements 4 previous exercises—using new paradigms—and 1 new exercise:

* **First, then Apply:** A more powerful variant of previously-implemented **First, then Lower-Case** functions. Rather than applying a to-lower-case function to the first satisfactory element in a list of strings, this function takes in a list of generics, and applies a function given as a parameter to the first satisfactory element.
* **Powers Generator:** Identical in functionality to the previous function of the same name. @See **Powers Generator** in homework 1.
* **Meaningful Line Count:** Identical in functionality to the previous functions of the same name. @See **Meaningful Line Count** in homeworks 1 and 2.
* **Shape:** A variant data type representing a three-dimensional geometric shape, which implements methods for calculating volume and surface area. Implemented variants are `Box` and `Sphere`. 
* **Binary Search Tree:** A simple binary search tree with similar functionality to the one implemented in homework 2. Implemented as an algebraic data type, rather than classes or structures.

### Homework 4:

This assignment follows a single exercise in C, C++, and Rust: the implementation of a stack as a dynamically sized array. This data structure is implemented generically in C++ and Rust, while the C implementation uses strings. In all languages, the stack structure supports `push` and `pop` operations, as well as functions for checking whether the stack is empty or full. The C and C++ implementations dynamically reallocate the size of the structure's internal array to grow and shrink to best fit the current number of elements; the Rust implementation wraps a vector that handles resizing automatically, while also implementing a `peek` function.

### Homework 5:

This assignment implements a single exercise in Go: a restaurant simulation. The program consists of 3 `Cook`s, 1 `waiter`, and 10 `Customer`s, each performing their tasks in an independent goroutine.

When the program begins, the `Customer`s enter the restaurant. Each `Customer` attempts to place a meal order with the `waiter`, who brings the order to an available `Cook`, who makes the meal. Once the meal is cooked, it is given to the `Customer` who ordered it. The `Customer` eats the meal, then places another order. After a `Customer` finishes 5 meals, they leave the restaurant. When all `Customers` have left, the restaurant closes and the program ends.

Each `Cook` can only prepare one meal at a time. If all `Cook`s are busy preparing meals, the `waiter` will wait, holding onto each outstanding order, until a `Cook` becomes available. The `waiter` can only hold 3 outstanding orders at a time. If the `waiter` cannot hold any additional orders when a `Customer` attempts to place an order, the `Customer` will wait for the `waiter` to become available again. After a certain duration, if the `waiter` has not become available, the `Customer` will abandon their order, leave the restaurant, and return later to try again.

All `Customer`s will *always* complete all 5 of their meals *eventually*, meaning the program will always end successfully.

## Testing Instructions
### Lua

```
lua exercises_test.lua
```

### Python

```
python3 exercises_test.py
```

### JavaScript

```
npm test
```

### Java

```
javac *.java && java ExercisesTest
```

### Kotlin

```
kotlinc *.kt -include-runtime -d test.jar && java -jar test.jar
```

### Swift

```
swiftc -o main exercises.swift main.swift && ./main
```

### TypeScript

```
npm test
```

### OCaml

```
ocamlc exercises.ml exercises_test.ml && ./a.out
```

### Haskell

```
ghc ExercisesTest.hs && ./ExercisesTest
```

### C

```
gcc string_stack.c string_stack_test.c && ./a.out
```

### C++

```
g++ -std=c++20 stack_test.cpp && ./a.out
```

### Rust

```
cargo test
```

### Go

```
go run restaurant.go
```

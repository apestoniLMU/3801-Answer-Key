# CMSI 3801 Homework - Pesto & Co.

**Group Members:** 

* Axel Pestoni (@[apestoniLMU](https://github.com/apestoniLMU))
* Sam Reitich (@[sreitich](https://github.com/sreitich))
* Eren Unsal (@[Cyrendex](https://github.com/Cyrendex))



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

------



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

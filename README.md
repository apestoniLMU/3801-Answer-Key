# CMSI 3801 Homework - Pesto & Co.

**Group Members:** 

* Axel Pestoni (@[apestoniLMU](https://github.com/apestoniLMU))
* Sam Reitich (@[sreitich](https://github.com/sreitich))
* Eren Unsal (@[Cyrendex](https://github.com/Cyrendex))

**Homework 1:**

This homework details the creation of 5 assigned problems:  
* firstThenLowerCase, a function that takes in a sequence of strings and a predicate, and returns the first string within that sequence that follows the predicate. 
* powersGenerator, a function that takes in two parameters: ofBase and upTo, and creates a generator that yields all values of a desired base up to a certain value.
* say, a function with a string parameter that chains within itself, calling itself until one of the parameters is an empty string, returning all previous strings joined and split by a space.
* meaningfulLineCount, a function that takes in a string that, if a file with the same name is found, prints the number of lines within that file that are neither (1) empty, nor (2) made up entirely of whitespace, nor (3) whose first non-whitespace character is #.
* Quaternion, a class that represents the directional rotation of an object. Quaternions can be added, multiplied, described as a string, can be compared to other quaternions, and can give a list representation of the coefficients.

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

import { open } from "node:fs/promises"

export function change(amount) {
  if (!Number.isInteger(amount)) {
    throw new TypeError("Amount must be an integer")
  }
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let [counts, remaining] = [{}, amount]
  for (const denomination of [25, 10, 5, 1]) {
    counts[denomination] = Math.floor(remaining / denomination)
    remaining %= denomination
  }
  return counts
}

/** Returns a lowercased version of the first string in the given list that satisfies the given predicate. */
export function firstThenLowerCase(sentence, predicate) {
  for (let i= 0; i < sentence.length; i++) {
    if (predicate(sentence[i]?.toLowerCase())) {
      return sentence[i]?.toLowerCase()
    }
  }
  return undefined
}

/**
 * Returns a generator producing the powers of the base specified by baseAndMax, up to but not exceeding the specified
 * maximum value.
 *
 * @param {number} ofBase         Base from which to generate sequential powers.
 * @param {number} upTo           Maximum value to which powers will be generated.
 * @returns {Generator<number>}   Generator producing sequential powers of baseAndMax.ofBase.
 */
export function* powersGenerator({ofBase, upTo}) {
  let index = 0
  while ((ofBase ** index) <= upTo) {
    yield ofBase ** index++
  }
}

/**
 * Chainable function returning each parameter passed in the chain, separated by a space.
 *
 * @param {string} word         String to add to the returned sequence.
 * @returns {string|function}   If a word was passed, returns a chainable function that can be called again to add to
 *                              the sequence of words. When called without a parameter, returns each word given to each
 *                              chained function call, separated by spaces.
 */
export function say(word) {
  // Stores the words we've collected in our chain.
  let words= [];

  // Helper that is returned whenever we call this function with a word, so the function can be called again.
  function chain(chainedWord) {
    // When no more words are being passed, return the words we've collected in this chain of calls.
    if (chainedWord === undefined) {
      if (words.length > 0) {
        return words.join(' ');
      }
      return ""
    // When a word is passed, append it to our collection and return this function to be called again, if desired.
    } else {
      words.push(chainedWord);
      return chain;
    }
  }

  // When given a word, start a chain by returning the chain function with our initial word.
  if (word !== undefined) {
    words.push(word);
    return chain
  // Special case for no parameter.
  } else {
    return ""
  }
}

/** Returns the number of lines in the specified file that are NOT (1) empty, (2) entirely whitespace, or (3) comprised
 * of '#'. */
export async function meaningfulLineCount(filePath) {
  let count = 0;
  const file = await open(filePath,'r')

  for await(const line of file.readLines()) {
    if ((line !== "") && (line.trim() !== "") && (line.trim()[0] !== "#")) {
      count++
    }
  }
  return count;
}

/**
 * Structure representing a quaternion: a four-value representation of three-dimensional rotation.
 *
 * Contains various utilities for manipulating quaternions.
 */
export class Quaternion {

  /** Default constructor. Constant members must be initialized. */
  constructor(a, i, j, k) {
    this.a = a;
    this.b = i;
    this.c = j;
    this.d = k;

    // Members of this class are constant.
    Object.freeze(this)
  }

  /** Returns a mathematical representation of this quaternion, ignoring any zero-coefficients. */
  toString() {
    let str = [];
    let ret = ""

    // Initialize return string to the first coefficient if it is nonzero.
    if (this.a !== 0) {
      str.push(String(this.a));
    }

    // Helper for formatting a single coefficient: appends a symbol to the coefficient's value if it is nonzero.
    function formatString(coValue, coSymbol) {
      // Do nothing if there is a zero value.
      if (Math.sign(coValue) === 0) {
        return null
      } else {
        // For positive coefficients, prepend a '+', unless they're the first nonzero element.
        if (Math.sign(coValue) === 1) {
          str.push((str.length > 0) ? "+" : "")
          // Special case for coefficients with the value of 1, which can omit their value entirely when printing.
          if (coValue === 1) {
            str.push(coSymbol)
          } else {
            str.push(String(coValue) + coSymbol)
          }

        // For negative coefficients, prepend a '-' if needed.
        } else {
          // Special case for coefficients with the value of -1, which can omit their value entirely when printing.
          if (coValue === -1) {
            str.push("-" + coSymbol)
            // No need to prepend '-' on negative values that will be printed.
          } else {
            str.push(String(coValue) + coSymbol)
          }
        }
      }
    }

    // We have to format each coefficient, besides the first one, since they need symbols with their values.
    formatString(this.b,"i")
    formatString(this.c,"j")
    formatString(this.d,"k")

    // All zero coefficients can be represented by "0."
    if (str.length === 0) {
      return "0"
    }

    // Build the return string from the list of coefficient string representations.
    for (const word of str) {
      ret += word
    }
    return ret
  }

  /** Adds two quaternions. */
  plus(other) {
    return new Quaternion(
        this.a + other.a,
        this.b + other.b,
        this.c + other.c,
        this.d + other.d)
  }

  /** Multiplies two quaternions. */
  times(other) {
    return new Quaternion(
      (this.a*other.a - this.b*other.b - this.c*other.c - this.d*other.d),
      (this.a*other.b + this.b*other.a + this.c*other.d - this.d*other.c),
      (this.a*other.c - this.b*other.d + this.c*other.a + this.d*other.b),
      (this.a*other.d + this.b*other.c - this.c*other.b + this.d*other.a)
    );
  }

  /** Returns a list of this quaternion's coefficients. */
  get coefficients() {
    return [this.a, this.b, this.c, this.d]
  }

  /** Computes the conjugate of this quaternion. */
  get conjugate() {
    return new Quaternion(
        this.a,
        -1 * this.b,
        -1 * this.c,
        -1 * this.d)
  }

  /** Two quaternions are equal if each of their coefficients are equivalent. */
  equals(other) {
    return (
        this.a === other.a &&
        this.b === other.b &&
        this.c === other.c &&
        this.d === other.d)
  }
}
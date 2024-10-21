import { open } from "node:fs/promises"

export function change(amount: bigint): Map<bigint, bigint> {
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let counts: Map<bigint, bigint> = new Map()
  let remaining = amount
  for (const denomination of [25n, 10n, 5n, 1n]) {
    counts.set(denomination, remaining / denomination)
    remaining %= denomination
  }
  return counts
}

/**
 * Returns the result of a function applied to the first item in the given
 * array that satisfies the given predicate.
 *
 * @param items - The array of items to search.
 * @param predicate - The predicate to satisfy.
 * @param consumer - The function to apply to the first item satisfying the predicate.
 * @returns The result of consumer applied to the first element in items that satisfies predicate. Undefined if no item
 * satisfies predicate.
 * */
export function firstThenApply<T, U>(
    items: T[],
    predicate: (item: T) => boolean,
    consumer: (item: T) => U
): U | undefined {
  for (const item of items) {
    if (predicate(item)) {
      return consumer(item);
    }
  }

  return undefined;
}

/**
 * Yields an infinite sequence of powers of a given base.
 *
 * @param base - The base of which to generator powers.
 * @yields Sequential powers of the base (b^0, b^1, etc.).
 */
export function* powersGenerator(base: bigint): Generator<bigint> {
  for (let power = 1n; ; power *= base) {
    yield power;
  }
}

/**
 * Returns the number of lines in the given file that are (1) not empty, (2) not all whitespace, and (3) whose first
 * character is not '#'.
 *
 * @param filePath - The path to the file whose lines will be counted. Throws an error if the path is not valid.
 */
export async function meaningfulLineCount(filePath: string): Promise<number> {
  let count = 0;
  const file = await open(filePath, 'r');

  for await(const line of file.readLines()) {
    if ((line !== "") && (line.trim() !== "") && (line.trim()[0] !== "#")) {
      count++;
    }
  }

  return count;
}

// Write your shape type and associated functions here

// Write your binary search tree implementation here

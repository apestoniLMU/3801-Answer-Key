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
 * @param items The array of items to search.
 * @param predicate The predicate to satisfy.
 * @param consumer The function to apply to the first item satisfying the predicate.
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
      return consumer(item)
    }
  }

  return undefined;
}

/**
 * Yields an infinite sequence of powers of a given base.
 *
 * @param base The base of which to generator powers.
 * @yields Sequential powers of the base (b^0, b^1, etc.).
 */
export function* powersGenerator(base: bigint): Generator<bigint> {
  for (let power = 1n; ; power *= base) {
    yield power
  }
}

/**
 * Returns the number of lines in the given file that are (1) not empty, (2) not all whitespace, and (3) whose first
 * character is not '#'.
 *
 * @param filePath The path to the file whose lines will be counted. Throws an error if the path is not valid.
 * @returns The number of lines in the given file that satisfy specified requirements.
 */
export async function meaningfulLineCount(filePath: string): Promise<number> {
  let count = 0
  const file = await open(filePath, 'r')

  for await(const line of file.readLines()) {
    if ((line !== "") && (line.trim() !== "") && (line.trim()[0] !== "#")) {
      count++
    }
  }

  return count
}

interface Box {
  kind: "Box",
  width: number,
  length: number,
  depth: number
}

interface Sphere {
  kind: "Sphere",
  radius: number
}

export type Shape = Box | Sphere;

/**
 * Computes the surface area of the given shape.
 *
 * @param shape The shape whose surface area will be calculated (a box or a sphere).
 * @returns The surface area of the given shape.
 */
export function surfaceArea(shape: Shape): number {
  switch (shape.kind) {
    case "Box":
      return 2 * ((shape.width * shape.length) + (shape.length * shape.depth) + (shape.depth * shape.width))
    case "Sphere":
      return 4 * Math.PI * (shape.radius ** 2)
  }
}

/**
 * Computers the volume of the given shape.
 *
 * @param shape The shape whose volume will be calculated (a box or a sphere).
 * @returns The volume of the given shape.
 */
export function volume(shape: Shape): number {
  switch (shape.kind) {
    case "Box":
      return shape.width * shape.length * shape.depth
    case "Sphere":
      return (4 / 3) * Math.PI * (shape.radius ** 3)
  }
}

/** Interface representing a type of entry in a BST (Node or Empty). */
export interface BinarySearchTree<T> {
  /** Returns the total size of this tree (the number of non-empty nodes). */
  size(): number

  /**
   * Inserts a unique item into this BST.
   *
   * @param data The item to add to this tree.
   * @returns The node at which the item was inserted.
   */
  insert(data: T): BinarySearchTree<T>

  /** Returns whether this tree contains a specified value. */
  contains(data: T): boolean

  /** Yields each item in this tree in-order. */
  inorder(): Iterable<T>
}

/** An entry in a binary search tree with data. */
class Node<T> {
  /**
   * @param left This node's left child.
   * @param data The value contained in this node.
   * @param right This node's right child.
   */
  constructor(
      private readonly left: BinarySearchTree<T>,
      private readonly data: T,
      private readonly right: BinarySearchTree<T>
  ) {}

  size(): number {
    return this.left.size() + 1 + this.right.size()
  }

  insert(data: T): BinarySearchTree<T> {
    if (data < this.data) {
      return new Node<T>(this.left.insert(data), this.data, this.right)
    } else if (data > this.data) {
      return new Node<T>(this.left, this.data, this.right.insert(data))
    } else {
      return this
    }
  }
  contains(data: T): boolean {
    if (data == this.data) {
      return true
    } else if (data > this.data) {
      return this.right.contains(data)
    } else {
      return this.left.contains(data)
    }
  }
  *inorder(): Iterable<T> {
    yield* this.left.inorder()
    yield* [this.data]
    yield* this.right.inorder()
  }

  public toString(): string {
    return `(${this.left}${this.data}${this.right})`.replaceAll("()", "")
  }
}

/** An empty node in a binary search tree. */
export class Empty<T> {
  size(): number {
    return 0
  }

  insert(data: T): BinarySearchTree<T> {
    return new Node<T>(new Empty<T>(), data, new Empty<T>)
  }

  contains(data: T): boolean {
    return false
  }

  inorder(): Iterable<T> {
    return []
  }

  public toString(): string {
    return "()"
  }
}
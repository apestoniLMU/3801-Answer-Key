import Foundation

struct NegativeAmountError: Error {}
struct NoSuchFileError: Error {}

func change(_ amount: Int) -> Result<[Int:Int], NegativeAmountError> {
    if amount < 0 {
        return .failure(NegativeAmountError())
    }
    var (counts, remaining) = ([Int:Int](), amount)
    for denomination in [25, 10, 5, 1] {
        (counts[denomination], remaining) =
            remaining.quotientAndRemainder(dividingBy: denomination)
    }
    return .success(counts)
}

/**
 Returns the first string in a given array that satisfies a given predicate.

 - returns:
 The first string in the given array satisfying the predicate, converted to lower-case.

 - parameters:
        - strings: The strings to search.
        - predicate: The predicate to satisfy.
 */
func firstThenLowerCase(of strings: [String], satisfying predicate: (String) -> Bool) -> String? {
    return strings.first(where: { predicate($0) })?.lowercased()
}

/**
 A structure that contains a "phrase" string. The "and" function can be used to generate a new
 instance that concatenates another string to the phrase.
 */
struct say {
    let phrase: String

    /** Constructor to optionally initialize phrase. */
    init(_ phrase: String = "") {
        self.phrase = phrase;
    }

    /**
     Returns a new say object with the given string appended to this instance's phrase.

     - returns:
     A new say instance with the the given string appended to this instance's phrase, joined
     by a space.

     - parameters:
            - nextWord: The word to concatenate to this instance's phrase.
     */
    func and(_ nextWord: String) -> say {
        return say(self.phrase + " " + nextWord)
    }
}

/**
 Returns the number of lines in the given file that are NOT (1) empty, (2) all whitespace or
 (3) whose first non-whitespace character is "#".

 - returns:
 The number of lines in the given file that meet the specified conditions. NoSuchFileError if
 the file could not be found.

 - parameters:
        - filepath: The path to the file to read.
*/
func meaningfulLineCount(_ filepath: String) async -> Result<Int, NoSuchFileError> {
	var count: Int = 0

	// NOTE: You might need to import FoundationNetworking depending on your version.
	let url: URL = URL(fileURLWithPath: filepath)
	do {
		for try await line in url.lines {
			let trimmed: String = line.trimmingCharacters(in: .whitespacesAndNewlines)
			if (trimmed.isEmpty || trimmed.hasPrefix("#")) {
				continue
			}

			count += 1
		}
	// File could not be found.
	} catch {
		return .failure(NoSuchFileError())
	}

	return .success(count)
}

/**
 A structure that represents a quaternion: a four-dimensional representation of three-dimensional rotation.
 */
struct Quaternion : CustomStringConvertible {
    let a: Double
    let b: Double
    let c: Double
    let d: Double

    static let ZERO = Quaternion(a: 0, b: 0, c: 0, d: 0)
    static let I = Quaternion(a: 0, b: 1, c: 0, d: 0)
    static let J = Quaternion(a: 0, b: 0, c: 1, d: 0)
    static let K = Quaternion(a: 0, b: 0, c: 0, d: 1)

    /** Constructor with optional property initialization. */
    init(a: Double = 0, b: Double = 0, c: Double = 0, d: Double = 0) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }

    /** The coefficients of this quaternion as an array. */
    var coefficients: [Double] {
        return [self.a, self.b, self.c, self.d]
    }

    /** The conjugate quaternion of this quaternion. */
    var conjugate: Quaternion {
        return Quaternion(
            a: self.a,
            b: -1 * self.b,
            c: -1 * self.c,
            d: -1 * self.d
        )
    }

    /** String representation of this quaternion, in the form "a + bi + cj + dk". */
    var description: String {
        // Special case for zero quaternion.
        if self == Quaternion.ZERO {
            return "0"
        }

        var retString: String = ""

        // Helper for formatting a single coefficient.
        func formatCo(value: Double, symbol: String) {
            switch value {
                case 0.0:
                    break
                case 1.0:
                    retString += (retString == "") ? "\(symbol)" : "+\(symbol)"
                case -1.0:
                    retString += "-\(symbol)"
                default:
                    retString += (value > 0.0)  ? "+\(value)\(symbol)" : "\(value)\(symbol)"
            }
        }

        // Custom formatting for first coefficient.
        if self.a != 0.0 {
            retString += "\(self.a)"
        }

        // Format remaining coefficients.
        formatCo(value: self.b, symbol: "i")
        formatCo(value: self.c, symbol: "j")
        formatCo(value: self.d, symbol: "k")

        return retString
    }
}

/**
 Adds two quaternions.
 */
func + (left: Quaternion, right: Quaternion) -> Quaternion {
    return Quaternion(
        a: left.a + right.a,
        b: left.b + right.b,
        c: left.c + right.c,
        d: left.d + right.d
    )
}

/**
 Multiplies two quaternions.
 */
func * (left: Quaternion, right: Quaternion) -> Quaternion {
    return Quaternion(
        a: (left.a * right.a) - (left.b * right.b) - (left.c * right.c) - (left.d * right.d),
        b: (left.a * right.b) + (left.b * right.a) + (left.c * right.d) - (left.d * right.c),
        c: (left.a * right.c) - (left.b * right.d) + (left.c * right.a) + (left.d * right.b),
        d: (left.a * right.d) + (left.b * right.c) - (left.c * right.b) + (left.d * right.a)
    )
}

/**
 Returns whether two quaternions are equal.
 */
func == (left: Quaternion, right: Quaternion) -> Bool {
    return
        (left.a == right.a &&
         left.b == right.b &&
         left.c == right.c &&
         left.d == right.d)
}

/**
 An enumeration representing a node in a binary search tree.
 */
indirect enum BinarySearchTree : CustomStringConvertible {
	// This is an empty child of a node.
	case empty
	// This is a node with a value and two (possibly empty) children.
	case node(BinarySearchTree, String, BinarySearchTree)

	/** Number of valid nodes in this tree. */
	var size: Int {
		switch self {
			case .empty: return 0
			case .node(let left, _, let right):
				return left.size + 1 + right.size
		}
	}

	/** String conversion. */
	var description: String {
		switch self {
			case .empty:
				return "()"
			case let .node(left, value, right):
				// Parentheses from any empty children have to be removed.
				return "(\(left)\(value)\(right))".replacingOccurrences(of: "()", with: "")
		}
	}

	/** Whether a node in this tree contains the given value. */
	func contains(_ str: String) -> Bool  {
		switch self {
			case .empty: return false
			case .node(let left, let value, let right):
				if value == str {
					return true
				}
				else if value > str {
					return left.contains(str)
				}
				else {
					return right.contains(str)
				}
		}
	}

	/** Inserts a new node into this tree. */
	func insert(_ value: String) -> BinarySearchTree {
		switch self {
			// Base case: insert value into the first empty child.
			case .empty:
				return .node(.empty, value, .empty)
			case let .node(left, v, right):
				if value < v {
					return .node(left.insert(value), v, right)
				} else if value > v {
					return .node(left, v, right.insert(value))
				// Special case: value is already present.
				} else {
					return self
				}
		}
	}
}
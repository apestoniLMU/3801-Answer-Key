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
 Returns the first string in the given array that satisfies the given predicate, converted to lower-case.
 */
func firstThenLowerCase(of strings: [String], satisfying predicate: (String) -> Bool) -> String? {
    return strings.first(where: { predicate($0) })?.lowercased()
}

/**
 A structure that contains a "phrase" string. The "and" function can be used to generate a new instance
 that concatenates another string to the phrase.
 */
struct say {
    /** This instance's phrase. */
    let phrase: String

    /** Constructor to optionally initialize phrase. */
    init(_ phrase: String = "") {
        self.phrase = phrase;
    }

    /** Returns a new say object with the given string appended to this instance's phrase, joined
     by a space. */
    func and(_ nextWord: String) -> say {
        return say(self.phrase + " " + nextWord)
    }
}

// Write your meaningfulLineCount function here

struct Quaternion : CustomStringConvertible {
    let a: Double
    let b: Double
    let c: Double
    let d: Double

    static let ZERO = Quaternion(a: 0, b: 0, c: 0, d: 0)
    static let I = Quaternion(a: 0, b: 1, c: 0, d: 0)
    static let J = Quaternion(a: 0, b: 0, c: 1, d: 0)
    static let K = Quaternion(a: 0, b: 0, c: 0, d: 1)

    /** Constructor with optional properties. */
    init(a: Double = 0, b: Double = 0, c: Double = 0, d: Double = 0) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }

    /** The coefficient values of this quaternion as an array. */
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

    /** String representation of this quaternion. */
    var description: String {
        // Special case for zero quaternion.
        if (self == Quaternion.ZERO)
        {
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
        if (self.a != 0.0) {
            retString += "\(self.a)"
        }

        // Format remaining coefficients.
        formatCo(value: self.b, symbol: "i")
        formatCo(value: self.c, symbol: "j")
        formatCo(value: self.d, symbol: "k")

        return retString
    }
}

/** Adds two quaternions. */
func + (left: Quaternion, right: Quaternion) -> Quaternion {
    return Quaternion(
        a: left.a + right.a,
        b: left.b + right.b,
        c: left.c + right.c,
        d: left.d + right.d
    )
}

/** Multiplies two quaternions. */
func * (left: Quaternion, right: Quaternion) -> Quaternion {
    return Quaternion(
        a: (left.a * right.a) - (left.b * right.b) - (left.c * right.c) - (left.d * right.d),
        b: (left.a * right.b) + (left.b * right.a) + (left.c * right.d) - (left.d * right.c),
        c: (left.a * right.c) - (left.b * right.d) + (left.c * right.a) + (left.d * right.b),
        d: (left.a * right.d) + (left.b * right.c) - (left.c * right.b) + (left.d * right.a)
    )
}

/** Returns whether two quaternions are equal. */
func == (left: Quaternion, right: Quaternion) -> Bool {
    return
        (left.a == right.a &&
         left.b == right.b &&
         left.c == right.c &&
         left.d == right.d)
}

// Write your Binary Search Tree enum here

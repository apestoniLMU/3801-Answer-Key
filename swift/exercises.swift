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
func firstThenLowerCase(of strings: [String], satisfying predicate: (String) -> Bool) -> String?
{
    return strings.first { predicate($0) }?.lowercased()
}

/**
 A structure that contains a "phrase" string. The "and" function can be used to generate a new instance
 that concatenates another string to its phrase.
 */
struct say
{
    /** This instance's read-only phrase. */
    private(set) var phrase: String

    /** Default constructor that initializes phrase to empty. */
    public init()
    {
        self.phrase = ""
    }

    /** Constructor initializing phrase. */
    public init(_ phrase: String)
    {
        self.phrase = phrase
    }

    /** Returns a new say object with the given string appended to this instance's phrase, separated
     by a space. */
    public func and(_ nextWord: String) -> say
    {
        return say(self.phrase + " " + nextWord)
    }
}

// Write your meaningfulLineCount function here

// Write your Quaternion struct here

// Write your Binary Search Tree enum here

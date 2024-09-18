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
func firstThenLowerCase(of strings: [String?], satisfying predicate: (String) -> Bool) -> String?
{
    for string in strings
    {
        if (string != nil ? predicate(string!) : false)
        {
            return string?.lowercased()
        }
    }

    return nil
}

// Write your say function here

// Write your meaningfulLineCount function here

// Write your Quaternion struct here

// Write your Binary Search Tree enum here

import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException

fun change(amount: Long): Map<Int, Long> {
    require(amount >= 0) { "Amount cannot be negative" }
    
    val counts = mutableMapOf<Int, Long>()
    var remaining = amount
    for (denomination in listOf(25, 10, 5, 1)) {
        counts[denomination] = remaining / denomination
        remaining %= denomination
    }
    return counts
}

// Write your first then lower case function here

/**
 *  A function when given a list of strings and a predicate, returns the lowercased
 *  version of the first string satisfying the given predicate. Otherwise, returns null.
 *
 * @param strList A list of strings.
 * @param predicate A predicate where given a string, returns a boolean value.
 * @return First string in strList that satisfies the predicate in lowercase, null otherwise.
 */
fun firstThenLowerCase(strList: List<String>, predicate: (String) -> Boolean): String? {
    return strList.firstOrNull(predicate)?.lowercase()
}

// Write your say function here

// Write your meaningfulLineCount function here

// Write your Quaternion data class here

// Write your Binary Search Tree interface and implementing classes here

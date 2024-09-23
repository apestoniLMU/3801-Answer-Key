import java.io.BufferedReader
import java.io.File
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
/**
 *  A class that can be optionally initialized with a string that possesses a
 *  read-only property 'phrase' which returns the concatenated string from
 *  current and previous helper method calls.
 *
 * @param sentence An optional string to start the sentence.
 * concatenates the passed argument onto the accumulated sentence.
 * @return The final accumulated sentence, empty string if no arguments
 * were passed.
 */
class say(private val sentence: String? = null) {
    /**
     *  The helper method of say class which concatenates passed string
     *  onto the accumulated sentence.
     *
     *   @param nextWord A string passed into the helper method and() which
     *   @return An instance of the say class with the nextWord added onto
     *   the accumulated sentence. If the sentence is null, initiate the class
     *   with nextWord.
     */
    fun and(nextWord: String): say {
        return say( if(sentence == null) nextWord else "$sentence $nextWord" )
    }

    val phrase: String
        get() = sentence ?: ""
}
// Write your meaningfulLineCount function here

/**
 *  A function when given a file name, returns the number of lines that fulfill a certain set of rules.
 *  If the file is not found, throws an IO exception.
 *
 *  Rules:
 *  1) Line is not empty
 *  2) Line is not entirely made of whitespaces
 *  3) The first non-whitespaces character of the line is not '#'
 *
 * @param fileName Name of the file.
 *
 * @return The amount of 'meaningful' lines.
 */
fun meaningfulLineCount(fileName: String): Long {
    var meaningfulCount: Long = 0L
    val fileReader: BufferedReader?
    try {
        fileReader = File(fileName).bufferedReader()
        print(fileReader.readLine())
    } catch (e: IOException) {
        throw IOException("No such file")
    }

    fileReader.useLines {
        lines -> lines.forEach  {
            val trimmedLine: String = it.trim()
            if (trimmedLine.isNotEmpty() && trimmedLine.substring(0, 1) != "#") {
                meaningfulCount++
            }
        }
    }
    return meaningfulCount
}
// Write your Quaternion data class here

// Write your Binary Search Tree interface and implementing classes here

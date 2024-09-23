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
data class Quaternion(
    val a: Double,
    val b: Double,
    val c: Double,
    val d: Double) {
    companion object {
            val ZERO = Quaternion(0.0, 0.0, 0.0, 0.0)
            val I = Quaternion(0.0, 1.0, 0.0, 0.0)
            val J = Quaternion(0.0, 0.0, 1.0, 0.0)
            val K = Quaternion(0.0, 0.0, 0.0, 1.0)
    }

    operator fun plus(other: Quaternion): Quaternion {
            return Quaternion(this.a + other.a, this.b + other.b, this.c + other.c, this.d + other.d)
    }

    operator fun times(other: Quaternion): Quaternion {
        return Quaternion(
            this.a * other.a - this.b * other.b - this.c * other.c - this.d * other.d,  // 1
            this.a * other.b + this.b * other.a + this.c * other.d - this.d * other.c,  // i
            this.a * other.c - this.b * other.d + this.c * other.a + this.d * other.b,  // j
            this.a * other.d + this.b * other.c - this.c * other.b + this.d * other.a  // k
        )
    }

    fun coefficients(): List<Double> {
        return listOf(this.a, this.b, this.c, this.d)
    }

    fun conjugate(): Quaternion {
        return Quaternion(this.a, -this.b, -this.c, -this.d)
    }

    override fun toString(): String {
        if (this == ZERO) return "0" // Special case

        val builder = StringBuilder()

        fun symbolFormat(value: Double, symbol: String) {
            when (value) {
                0.0 -> {} // Don't do anything when value is 0
                1.0 -> {if (builder.isNotEmpty()) builder.append("+$symbol") else builder.append(symbol) }
                -1.0 -> builder.append("-$symbol")
                else -> {
                    if (value > 0.0 && builder.isNotEmpty())  builder.append("+")
                    builder.append("$value$symbol")
                }
            }
        }

        if (this.a != 0.0) builder.append(this.a)

        symbolFormat(this.b, "i")
        symbolFormat(this.c, "j")
        symbolFormat(this.d, "k")

        return builder.toString()
    }
}
// Write your Binary Search Tree interface and implementing classes here

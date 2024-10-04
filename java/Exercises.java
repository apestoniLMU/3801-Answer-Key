import java.io.*;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Predicate;

public class Exercises {
    static Map<Integer, Long> change(long amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }
        var counts = new HashMap<Integer, Long>();
        for (var denomination : List.of(25, 10, 5, 1)) {
            counts.put(denomination, amount / denomination);
            amount %= denomination;
        }
        return counts;
    }

    /**
     * Returns the first string in the given list that satisfies the given predicate, converted to lower-case.
     *
     * @param strings       List of strings to search.
     * @param predicate     Predicate to try to satisfy.
     * @return              The first string satisfying the predicate.
     */
    static Optional<String> firstThenLowerCase(List<String> strings, Predicate<String> predicate) {
        return strings.stream().filter(predicate).map(String::toLowerCase).findFirst();
    }

    /**
     * A class containing a "phrase" string, which can be continuously concatenated inline via an "and" function.
     */
    static class Say {
        final private String phrase;

        /**
         * Constructor initializing "phrase."
         * @param phrase        This instance's phrase.
         */
        Say(String phrase) {
            this.phrase = phrase;
        }

        /**
         * Creates a new Say instance with a given string, appended to this instance's phrase, as its new phrase.
         * @param newWord       The string to append to this Say object's phrase, to use as the new object's phrase.
         * @return              A new Say object with the given string appended to this object's phrase as its phrase.
         */
        Say and(String newWord) {
            return new Say(this.phrase + " " + newWord);
        }

        /**
         * Accessor for phrase.
         * @return              This Say object's phrase.
         */
        String phrase() {
            return phrase;
        }
    }

    /**
     * Constructs a Say object with the given phrase.
     * @param phrase    The new object's phrase.
     * @return          A new Say object with the given phrase.
     */
    static Say say(String phrase) {
        return new Say(phrase);
    }

    /**
     * Constructs an empty Say object.
     * @return          A new Say object with an empty phrase.
     */
    static Say say() {
        return new Say("");
    }

    /**
     * Counts the number of lines in the given file that are not (1) empty, (2) all whitespace, or (3) whose first
     * non-whitespace character is "#".
     * @param path              The path of the file to read.
     * @return                  The number of lines in the file satisfying the conditions.
     * @throws IOException      Given file could not be found.
     */
    static long meaningfulLineCount(String path) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(path))) {
            return reader.lines()
            .filter(line -> !line.trim().isEmpty())
            .filter(line -> !line.trim().startsWith("#"))
            .count();
        } catch (Exception e) {
            throw new FileNotFoundException("No such file");
        }
    }
}

/**
 * Represents a mathematical quaternion: a four-dimensional representation of three-dimensional rotation.
 */
record Quaternion(double a, double b, double c, double d) {
    
    public static final Quaternion ZERO = new Quaternion(0, 0, 0, 0);
    public static final Quaternion I = new Quaternion(0, 1, 0, 0);
    public static final Quaternion J = new Quaternion(0, 0, 1, 0);
    public static final Quaternion K = new Quaternion(0, 0, 0, 1);

    public Quaternion {
        if (Double.isNaN(a) || Double.isNaN(b) || Double.isNaN(c) || Double.isNaN(d)) {
            throw new IllegalArgumentException("Coefficients cannot be NaN");
        }
    }

    /**
     * Multiplies this quaternion by another.
     * @param other     The quaternion to multiply by.
     * @return          The result of the multiplication.
     */
    public Quaternion times(Quaternion other) {
        return new Quaternion(
            (this.a*other.a() - this.b*other.b() - this.c*other.c() - this.d*other.d()),
            (this.a*other.b() + this.b*other.a() + this.c*other.d() - this.d*other.c()),
            (this.a*other.c() - this.b*other.d() + this.c*other.a() + this.d*other.b()),
            (this.a*other.d() + this.b*other.c() - this.c*other.b() + this.d*other.a())
        );
    }

    /**
     * Adds this quaternion to another.
     * @param other     The quaternion to add.
     * @return          The result of the addition.
     */
    public Quaternion plus(Quaternion other) {
        return new Quaternion(
            a + other.a(),
            b + other.b(),
            c + other.c(),
            d + other.d()
        );
    }

    /**
     * This quaternion's coefficients.
     * @return      This quaternion's coefficients as a list.
     */
    public List<Double> coefficients() {
        return List.copyOf(List.of(this.a, this.b, this.c, this.d));
    }

    /**
     * This quaternion's conjugate.
     * @return      The conjugate quaternion of this quaternion.
     */
    public Quaternion conjugate() {
        return new Quaternion(
            a, 
            -1*b, 
            -1*c, 
            -1*d
        );
    }

    /**
     * Converts this quaternion's coefficients into a readable format.
     * @return      This quaternion's coefficients in the form "a + bi + cj + dk."
     */
    public String toString() {
        String ret = "";
        if (a==0 && b==0 && c==0 && d==0) {
            return "0";
        } 

        if (a != 0) {
            ret += Double.toString(a);
        }

        if (b != 0) {
            if(ret.isEmpty()) {
                if(b == 1) {
                    ret += "i";
                } else if (b == -1) {
                    ret += "-i";
                } else {
                    ret += b + "i";
                }
            } else {
                if (b > 0) {
                    ret += "+";
                }

                if(Math.abs(b) != 1) {
                    ret += b + "i";
                } else {
                    ret += "i";
                }
            }
        }

        if (c != 0) {
            if(ret.isEmpty()) {
                if(c == 1) {
                    ret += "j";
                } else if (c == -1) {
                    ret += "-j";
                } else {
                    ret += c + "j";
                }
            } else {
                if (c > 0) {
                    ret += "+";
                }

                if(Math.abs(c) != 1) {
                    ret += c + "j";
                } else {
                    ret += "j";
                }
            }
        }

        if (d != 0) {
            if(ret.isEmpty()) {
                if(d == 1) {
                    ret += "k";
                } else if (d == -1) {
                    ret += "-k";
                } else {
                    ret += d + "k";
                }
            } else {
                if (d > 0) {
                    ret += "+";
                }

                if(Math.abs(d) != 1) {
                    ret += d + "k";
                } else {
                    ret += "k";
                }
            }
        }
        return ret;
    }
}

/**
 * A binary search tree that supports insertion, lookups, and element count.
 */
abstract sealed class BinarySearchTree permits Empty, Node {

    /**
     * The size of the tree from this node.
     */
    abstract int size();

    /**
     * Checks whether this tree contains the given value.
     * @param value     The value to search for.
     * @return          Whether this tree contains value.
     */
    abstract boolean contains(String value);

    /**
     * Inserts the given value into this tree.
     * @param value     The value to insert.
     * @return          The node into which the value was inserted.
     */
    abstract BinarySearchTree insert(String value);

    /**
     * Converts this tree into a readable string.
     * @return          The nodes of this tree in the format "(left_child)node(right_child)".
     */
    public abstract String toString();
}

/**
 * An empty binary search tree node.
 */
final class Empty extends BinarySearchTree {
    public Empty() {}
    public static final Empty EMPTY = new Empty();

    @Override
    int size() {
        return 0;
    }

    @Override
    boolean contains(String value) {
        return false;
    }

    @Override
    BinarySearchTree insert(String value) {
        return new Node(value, EMPTY, EMPTY);
    }

    @Override
    public String toString() {
        return "()";
    }
}

/**
 * A node in a binary search tree containing a value, an optional left child node, and an optional right child node.
 */
final class Node extends BinarySearchTree {
    private final String value;
    private final BinarySearchTree left;
    private final BinarySearchTree right;

    public Node(String value, BinarySearchTree left, BinarySearchTree right) {
        this.value = value;
        this.left = left;
        this.right = right;
    }

    @Override
    public int size() {
        return left.size() + 1 + right.size();
    }

    @Override
    public boolean contains(String value) {
        if (value.equals(this.value)) {
            return true;
        } else if (value.compareTo(this.value) < 0) { // value < this.value
            return left.contains(value);
        } else {
            return right.contains(value);
        }
    }

    @Override
    public BinarySearchTree insert(String value) {
        if (value.equals(this.value)) {
            return this; // No duplicates
        } else if (value.compareTo(this.value) < 0) {
            return new Node(this.value, left.insert(value), right);
        } else {
            return new Node(this.value, left, right.insert(value));
        }
    }

    @Override
    public String toString() {
        return ("(" + left + value + right + ")").replace("()", "");
    }
}
import java.io.*;
import java.util.List;
import java.util.ArrayList;
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

    // Write your first then lower case function here
    static Optional firstThenLowerCase(List<String> sentence, Predicate<String> p) {
        return sentence.stream().filter(p).map(String::toLowerCase).findFirst();
    }
    // Write your say function here
    static class Say {
        private List<String> words;

        Say(List<String> sList, String word) {
            this.words = new ArrayList<String>(sList);
            words.add(word);
        }
        
        Say and(String newWord) {
            return new Say(this.words, " " + newWord);
        }
        
        String phrase() {
            String ret = "";
            if(this.words.size()==0) {
                return "";
            }

            for(String each:this.words) {
                if(ret.equals("")) {
                    ret = each;
                } else {
                    ret += each;
                }
            }
            return ret;
        }
    }

    static Say say(String word) {
        return new Say(new ArrayList<String>(), word);
    }

    static Say say() {
        return new Say(new ArrayList<String>(), "");
    }

    // Write your line count function here
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

// Write your Quaternion record class here
record Quaternion(double a, double b, double c, double d) {
    
    public static final Quaternion ZERO = new Quaternion(0, 0, 0, 0);
    public static final Quaternion I = new Quaternion(0, 1, 0, 0);
    public static final Quaternion J = new Quaternion(0, 0, 1, 0);
    public static final Quaternion K = new Quaternion(0, 0, 0, 1);

    public Quaternion {
        if(Double.isNaN(a) || Double.isNaN(b) || Double.isNaN(c) || Double.isNaN(d)) {
            throw new IllegalArgumentException("Coefficients cannot be NaN");
        }
    }

    public Quaternion times(Quaternion other) {
        return new Quaternion(
            (this.a*other.a() - this.b*other.b() - this.c*other.c() - this.d*other.d()),
            (this.a*other.b() + this.b*other.a() + this.c*other.d() - this.d*other.c()),
            (this.a*other.c() - this.b*other.d() + this.c*other.a() + this.d*other.b()),
            (this.a*other.d() + this.b*other.c() - this.c*other.b() + this.d*other.a())
        );
    }

    public Quaternion plus(Quaternion other) {
        return new Quaternion(
            a + other.a(),
            b + other.b(),
            c + other.c(),
            d + other.d()
        );
    }


    public List<Double> coefficients() {
        return List.copyOf(List.of(this.a, this.b, this.c, this.d));
    }

    public Quaternion conjugate() {
        return new Quaternion(
            a, 
            -1*b, 
            -1*c, 
            -1*d
        );
    }

    public String toString() {
        String ret = "";
        if (a==0 && b==0 && c==0 && d==0) {
            return "0";
        } 

        if (a != 0) {
            ret += Double.toString(a);
        }

        if (b != 0) {
            if(ret.equals("")) {
                if(b == 1) {
                    ret += "i";
                } else if (b == -1) {
                    ret += "-i";
                } else {
                    ret += Double.toString(b) + "i";
                }
            } else {
                if (b > 0) {
                    ret += "+";
                }

                if(Math.abs(b) != 1) {
                    ret += Double.toString(b) + "i";
                } else {
                    ret += "i";
                }
            }
        }

        if (c != 0) {
            if(ret.equals("")) {
                if(c == 1) {
                    ret += "j";
                } else if (c == -1) {
                    ret += "-j";
                } else {
                    ret += Double.toString(c) + "j";
                }
            } else {
                if (c > 0) {
                    ret += "+";
                }

                if(Math.abs(c) != 1) {
                    ret += Double.toString(c) + "j";
                } else {
                    ret += "j";
                }
            }
        }

        if (d != 0) {
            if(ret.equals("")) {
                if(d == 1) {
                    ret += "k";
                } else if (d == -1) {
                    ret += "-k";
                } else {
                    ret += Double.toString(d) + "k";
                }
            } else {
                if (d > 0) {
                    ret += "+";
                }

                if(Math.abs(d) != 1) {
                    ret += Double.toString(d) + "k";
                } else {
                    ret += "k";
                }
            }
        }
        return ret;
    }
}
// Write your BinarySearchTree sealed interface and its implementations here

abstract sealed class BinarySearchTree permits Empty, Node {
    abstract int size();
    abstract boolean contains(String value);
    abstract BinarySearchTree insert(String value);
    public abstract String toString();
}

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
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Predicate;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

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
            return new Say(this.words, newWord);
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
                    ret += " " + each;
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


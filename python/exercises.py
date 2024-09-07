from dataclasses import dataclass, field
from collections.abc import Callable
from typing import Generator, Optional, TypeVar


def change(amount: int) -> dict[int, int]:
    if not isinstance(amount, int):
        raise TypeError('Amount must be an integer')
    if amount < 0:
        raise ValueError('Amount cannot be negative')
    counts, remaining = {}, amount
    for denomination in (25, 10, 5, 1):
        counts[denomination], remaining = divmod(remaining, denomination)
    return counts


def first_then_lower_case(str_list: list[str], predicate: Callable, /) -> Optional[str]:
    """
    Returns a lowercased version of the first string in the given list that satisfies the given predicate.
    """
    for string in str_list:
        if predicate(string):
            return string.lower()
    return None


def powers_generator(*, base: int, limit: int) -> Generator[int, None, type[StopIteration]]:
    """
    Returns a generator producing the powers of the given base, up to but not exceeding the given maximum.
    """
    power: int = 0
    while True:
        current_num = base ** power
        if current_num > limit:
            return StopIteration
        else:
            power += 1
            yield current_num


def say(word: Optional[str] = None, /) -> str | Callable:
    """
    Returns a chainable function that can be called again. When called without parameters, returns all parameters passed
    into the chain concatenated into a string, separated by spaces.
    """
    # Special case for no parameter on the first call.
    if word is None:
        return ""

    # Recursive chaining function. Returns itself (via say function) with the current list of concatenated words.
    def chain(next_word: Optional[str] = None, /):
        # When no more words are being passed into the chain, return the concatenated string of words.
        if next_word is None:
            return word
        # If this is called with another word, concatenate it and return a new chain function.
        return say(word + " " + next_word)

    return chain


def meaningful_line_count(file_name: str, /) -> int:
    """
    Returns the number of lines in the specified file that are NOT (1) empty, (2) entirely whitespace, or (3) comprised
    of '#'.
    """
    line_count: int = 0

    try:
        with (open(file_name, encoding="utf8") as file):
            for line in file:
                if len((stripped_line := line.strip())) > 0 and stripped_line[0] != '#':
                    line_count += 1
    except FileNotFoundError:
        raise FileNotFoundError("No such file")

    file.close()
    return line_count


@dataclass(frozen=True)
class Quaternion:
    """
    Represents a quaternion: a four-value representation of three-dimensional rotation.
    """
    a: float
    b: float
    c: float
    d: float

    def __eq__(self: "Quaternion", other: object, /) -> bool:
        """
        Two quaternions are equal if each of their coefficients are equivalent.
        """
        if not isinstance(other, Quaternion):
            return NotImplemented
        return self.a == other.a and self.b == other.b and self.c == other.c and self.d == other.d

    def __add__(self: "Quaternion", other: "Quaternion", /) -> "Quaternion":
        """
        Adds two quaternions.

        Returns:
            Quaternion:
                The resulting quaternion.
        """
        return Quaternion(
            self.a + other.a,
            self.b + other.b,
            self.c + other.c,
            self.d + other.d)

    def __mul__(self: "Quaternion", other: "Quaternion", /) -> "Quaternion":
        """
        Multiplies two quaternions.
        Formula courtesy of https://stackoverflow.com/questions/19956555/how-to-multiply-two-quaternions

        Returns:
            Quaternion:
                The resulting quaternion.
        """
        return Quaternion(
            self.a * other.a - self.b * other.b - self.c * other.c - self.d * other.d,  # 1
            self.a * other.b + self.b * other.a + self.c * other.d - self.d * other.c,  # i
            self.a * other.c - self.b * other.d + self.c * other.a + self.d * other.b,  # j
            self.a * other.d + self.b * other.c - self.c * other.b + self.d * other.a   # k
        )

    def __str__(self: "Quaternion") -> str:
        """
        Returns a mathematical representation of the quaternion, ignoring any zero-coefficients.
        """
        final_str = ""
        final_str += "" if self.a == 0 else str(self.a)
        final_str += "" if self.b == 0 else (("+" if (self.b > 0.0 and final_str != "") else "") + (str(self.b) if abs(self.b) - 1.0 != 0.0 else ("-" if self.b == -1.0 else ""))) + "i"
        final_str += "" if self.c == 0 else (("+" if (self.c > 0.0 and final_str != "") else "") + (str(self.c) if abs(self.c) - 1.0 != 0.0 else ("-" if self.c == -1.0 else ""))) + "j" 
        final_str += "" if self.d == 0 else (("+" if (self.d > 0.0 and final_str != "") else "") + (str(self.d) if abs(self.d) - 1.0 != 0.0 else ("-" if self.d == -1.0 else ""))) + "k"
        return final_str if final_str != "" else "0"

    @property
    def conjugate(self: "Quaternion") -> "Quaternion":
        """
        Returns the conjugation of this quaternion.
        """
        return Quaternion(
            self.a,
            -self.b,
            -self.c,
            -self.d)

    @property
    def coefficients(self: "Quaternion") -> tuple[float, float, float, float]:
        """
        Returns this quaternion's coefficients in the form of a tuple.
        """
        return self.a, self.b, self.c, self.d

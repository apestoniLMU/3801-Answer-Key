from dataclasses import dataclass, field
from collections.abc import Callable
from typing import Optional, TypeVar


def change(amount: int) -> dict[int, int]:
    if not isinstance(amount, int):
        raise TypeError('Amount must be an integer')
    if amount < 0:
        raise ValueError('Amount cannot be negative')
    counts, remaining = {}, amount
    for denomination in (25, 10, 5, 1):
        counts[denomination], remaining = divmod(remaining, denomination)
    return counts

# Write your first then lower case function here
def first_then_lower_case(str_list: list[str], predicate: Callable, /):
    for string in str_list:
        if predicate(string):
            return string.lower()      
    return None

# Write your powers generator here
def powers_generator(*, base: int, limit: int):
    power: int = 0
    while True: 
        current_num = base ** power
        if current_num > limit:
            return StopIteration
        else:
            power += 1
            yield current_num
        
# Write your say function here
def say(word: Optional[str] = None, /):
    if word is None:
        return ""
    def chain(next_word: Optional[str] = None, /):
        if next_word is None:
            return word
        return say(word + " " + next_word)
    return chain 
    
# Write your line count function here
def meaningful_line_count(file_name: str):
    line_count: int = 0
    try:
        with open(file_name, encoding="utf8") as file:
            for line in file:
                if stripped_line := line.strip(): # Had to nest the if statements for whatever reason.
                    if stripped_line[0] != '#':
                        line_count += 1
    except FileNotFoundError:
        raise FileNotFoundError("No such file")
    
    file.close() # Tried to nest this in a finally: block but that messes things up..?
    return line_count

TQuaternion = TypeVar("TQuaternion", bound="Quaternion") # Courtesy of https://peps.python.org/pep-0673/
# Write your Quaternion class here
@dataclass(frozen=True)
class Quaternion:
    a: float = field
    b: float = field
    c: float = field
    d: float = field

    def __eq__(self: TQuaternion, q2: TQuaternion):
        return self.a == q2.a and self.b == q2.b and self.c == q2.c and self.d == q2.d
    
    def __add__(self: TQuaternion, q2: TQuaternion): 
        temp_quaternion: TQuaternion = Quaternion(self.a + q2.a, self.b + q2.b, self.c + q2.c, self.d + q2.d)
        return temp_quaternion
    
    # Formula courtesy of https://stackoverflow.com/questions/19956555/how-to-multiply-two-quaternions
    def __mul__(self: TQuaternion, q2: TQuaternion):
        new_a, new_b, new_c, new_d = (
        self.a * q2.a - self.b * q2.b - self.c * q2.c - self.d * q2.d,  # 1
        self.a * q2.b + self.b * q2.a + self.c * q2.d - self.d * q2.c,  # i
        self.a * q2.c - self.b * q2.d + self.c * q2.a + self.d * q2.b,  # j
        self.a * q2.d + self.b * q2.c - self.c * q2.b + self.d * q2.a   # k
        )
        temp_quaternion: TQuaternion = Quaternion(new_a, new_b, new_c, new_d)
        return temp_quaternion
    
    def __str__(self: TQuaternion):
        final_str = ""
        final_str += "" if self.a == 0 else str(self.a)
        final_str += "" if self.b == 0 else (("+" if (self.b > 0.0 and final_str != "") else "") + (str(self.b) if abs(self.b) - 1.0 != 0.0 else ("-" if self.b == -1.0 else ""))) + "i"
        final_str += "" if self.c == 0 else (("+" if (self.c > 0.0 and final_str != "") else "") + (str(self.c) if abs(self.c) - 1.0 != 0.0 else ("-" if self.c == -1.0 else ""))) + "j" 
        final_str += "" if self.d == 0 else (("+" if (self.d > 0.0 and final_str != "") else "") + (str(self.d) if abs(self.d) - 1.0 != 0.0 else ("-" if self.d == -1.0 else ""))) + "k"
        return final_str if final_str != "" else "0"
    
    def __print__(self: TQuaternion):
        print(self.__str__())

    @property
    def conjugate(self: TQuaternion):
        temp_quaternion: TQuaternion = Quaternion(self.a, -self.b, -self.c, -self.d)
        return temp_quaternion

    @property
    def coefficients(self: TQuaternion):
        return (self.a, self.b, self.c, self.d)
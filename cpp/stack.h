// A class for an expandable stack. There is already a stack class in the
// Standard C++ Library; this class serves as an exercise for students to
// learn the mechanics of building generic, expandable, data structures
// from scratch with smart pointers.

#include <stdexcept>
#include <string>
#include <memory>
using namespace std;

// A stack object wraps a low-level array indexed from 0 to capacity-1 where
// the bottommost element (if it exists) will be in slot 0. The member top is
// the index of the slot above the top element, i.e. the next available slot
// that an element can go into. Therefore if top==0 the stack is empty and
// if top==capacity it needs to be expanded before pushing another element.
// However for security there is still a super maximum capacity that cannot
// be exceeded.

#define MAX_CAPACITY 32768
#define INITIAL_CAPACITY 16

template <typename T>
class Stack {

private:

    // Current elements in this stack.
    std::unique_ptr<T[]> elements;

    // 1 greater than the maximum number of items this stack can contain before requiring reallocation. When the value
    // of top reaches this, the stack will need to be expanded before another element can be pushed.
    size_t capacity = INITIAL_CAPACITY;

    // The next available index in the stack (i.e. 1 greater than the index of the current top-most element).
    size_t top = 0;

public:

    // Default constructor. Initializes stack size to INITIAL_CAPACITY.
    Stack() {
        elements = std::make_unique<T[]>(INITIAL_CAPACITY);
    }

    // Disable move and copy semantics.
    Stack(const Stack&) = delete;
    Stack(Stack&&) = delete;
    Stack& operator=(const Stack&) = delete;
    Stack& operator=(Stack&&) = delete;

    // The number of elements currently in this stack.
    size_t size() const {
        return top;
    }

    // True if this stack contains 0 elements.
    bool is_empty() const {
        return top == 0;
    }

    // True if this stack has reached its super maximum capacity and can no longer push new elements.
    // @See MAX_CAPACITY
    bool is_full() const {
        return top == MAX_CAPACITY;
    }

    // Push an element onto the stack.
    void push(T element) {
        reallocate(top + 1);
        elements[top] = element;
        top++;
    }

    // Pops the top element off the stack and returns it.
    T pop() {
        if (is_empty()) {
            throw underflow_error("cannot pop from empty stack");
        }

        T element = elements[top - 1];
        top--;
        reallocate(top);
        return element;
    }

private:

    // Expands or shrinks the stack's allocation when necessary to best fit the desired size.
    void reallocate(size_t desired_size) {
        if (desired_size > MAX_CAPACITY) {
            throw overflow_error("Stack has reached maximum capacity");
        }

        // Reallocate the array with twice the space if its current capacity is exceeded.
        if (desired_size > capacity) {
            std::unique_ptr<T[]> new_elements = std::make_unique<T[]>(capacity * 2);
            std::copy(elements.get(), elements.get() + capacity, new_elements.get());
            elements = std::move(new_elements);
            capacity *= 2;

            return;
        }

        // Reallocate the array with half the space if its current size falls below a quarter of its capacity.
        if (capacity > INITIAL_CAPACITY && desired_size < (capacity / 4)) {
            std::unique_ptr<T[]> new_elements = std::make_unique<T[]>(capacity / 2);
            std::copy(elements.get(), elements.get() + capacity / 2, new_elements.get());
            elements = std::move(new_elements);
            capacity /= 2;
        }
    }
};

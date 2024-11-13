#include "string_stack.h"
#include <stdlib.h>
#include <string.h>

#define INITIAL_CAPACITY 16

// A structure representing a stack of strings.
struct _Stack {
    // Array of strings in the stack.
    char** elements;
    // The stack's current capacity.
    int cap;
    // Index of the top-most element of the stack. -1 represents an empty stack.
    int top;
};

// Initializes a new stack, returning a response containing the new stack if successful.
stack_response create() {
    stack_response response = {success, NULL};

    // Allocate a new stack.
    const stack s = malloc(sizeof(struct _Stack));

    if (s == NULL) {
        response.code = out_of_memory;
        return response;
    }

    // Initialize stack size.
    s->cap = INITIAL_CAPACITY;
    s->elements = malloc(INITIAL_CAPACITY * sizeof(char*));

    // Ensure we have enough memory for the initial stack allocation.
    if (s->elements == NULL) {
        free(s);
        response.code = out_of_memory;
        return response;
    }

    s->top = -1;
    response.stack = s;
    return response;
}

// The number of elements currently in the given stack.
int size(const stack s) {
    return s->top + 1;
}

// True if the given stack contains 0 elements.
bool is_empty(const stack s) {
    return s->top == -1;
}

// True if the given stack has reached its super maximum and can no longer push new elements.
bool is_full(const stack s) {
    return (s->top + 1) == MAX_CAPACITY;
}

// Tries to push a new string onto the given stack.
response_code push(stack s, char* item) {
    if (strlen(item) >= MAX_ELEMENT_BYTE_SIZE) {
        return stack_element_too_large;
    }

    if (is_full(s)) {
        return stack_full;
    }

    // Expand the stack's array allocation if it's at its current capacity.
    if ((s->top + 1) == s->cap) {
        // Double the array's allocation.
        int new_cap = s->cap * 2;
        char** new_elements = realloc(s->elements, new_cap * sizeof(char*));

        if (new_elements == NULL) {
            return out_of_memory;
        }

        s->elements = new_elements;
        s->cap = new_cap;
    }

    // Add the string by copy, not reference.
    char* item_to_push = _strdup(item);
    if (item_to_push == NULL) {
        return out_of_memory;
    }

    s->top++;
    s->elements[s->top] = item_to_push;
    return success;
}

// Pops the top element from the given stack, returning the popped element if successful.
string_response pop(stack s) {
    string_response response = {stack_empty, NULL};

    if (is_empty(s)) {
        return response;
    }

    response.string = s->elements[s->top];
    s->elements[s->top] = NULL;
    s->top--;
    response.code = success;

    // Shrink the array's allocation if its size falls below a threshold (1/4 capacity).
    if (s->cap > INITIAL_CAPACITY && s->top + 1 < (s->cap / 4)) {
        int new_cap = s->cap / 2;
        char** new_elements = realloc(s->elements, new_cap * sizeof(char*));

        // Ensure we have enough space for the reallocation before updating moving the array.
        if (new_elements != NULL) {
            s->elements = new_elements;
            s->cap = new_cap;
        }
    }

    return response;
}

// Frees the stack and all of its elements.
void destroy(stack* s) {
    // NOTE: We should really be doing checks like this at the start of every operation, but an appropriate response
    // code wasn't given (e.g. "invalid_stack").
    if (s == NULL || *s == NULL) {
        return;
    }

    // Free every item in the stack.
    for (int i = 0; i <= (*s)->top; i++) {
        free((*s)->elements[i]);
    }

    // Free the stack array.
    free((*s)->elements);

    // Free the stack.
    free(*s);

    // We're now pointing to a null object.
    *s = NULL;
}
#include "string_stack.h"
#include <stdlib.h>
#include <string.h>

struct _Stack {
    char** elements;
    int cap;
    int top;
};

// Create() function to initialize a stack returning the appropriate response
stack_response create() {
    stack_response response = {success, NULL};

    // Allocating stack struct
    stack s = malloc(sizeof(struct _Stack));

    // Unable to create due to lack of memory
    if (s == NULL) {
        response.code = out_of_memory;
        return response;
    }

    /*
     * Following code uses the arrow operator. It's functionally the same as writing
     * (*s).cap aka. it gets the member called cap from the struct s.
     * https://stackoverflow.com/questions/2575048/arrow-operator-usage-in-c
     * We can delete this before the deadline I'm including it for you chumps.
     */ 
    s->cap = 8;
    s->elements = malloc(s->cap * sizeof(char*));

    if (s->elements == NULL) { // Unable to assign space due to memory
        free(s); // Free the memory assigned for struct
        response.code = out_of_memory;
        return response;
    }

    s->top = -1; // Empty stack
    response.stack = s;
    return response;
}

// Returns the size of the stack
int size(const stack s) {
    return s->top + 1;
}

// Easier to read way to check if the stack is empty
bool is_empty(const stack s) {
    return s->top == -1;
}

// Returns if the stack is full or not
bool is_full(const stack s) {
    return size(s) == MAX_CAPACITY;
}

response_code push(stack s, char* item) {
    if (strlen(item) >= MAX_ELEMENT_BYTE_SIZE) { // Pushing an item too big
        return stack_element_too_large;
    }

    if (is_full(s)) {
        return stack_full;
    }

    // Resizing array if trying to push beyond capacity
    if (s->top + 1 == s->cap) {
        int new_cap = s->cap * 2; // Doubling it for the reasons
        if (new_cap > MAX_CAPACITY) { // Exceeding the allocated capacity, limit it
            new_cap = MAX_CAPACITY;
        }

        char** new_elements = realloc(s->elements, new_cap * sizeof(char*));
        if (new_elements == NULL) { // Not enough memory, couldn't allocate
            return out_of_memory;
        }

        // Assign the new capacity and elements back to the stack
        s->elements = new_elements;
        s->cap = new_cap;
    }

    // This is what defensively copying is apparently
    char* defensive_copy = strdup(item);
    if (defensive_copy == NULL) {
        return out_of_memory;
    }

    s->top++;
    s->elements[s->top] = defensive_copy;
    return success;
}

string_response pop(stack s) {
    string_response response = {stack_empty, NULL};

    if (is_empty(s)) {
        return response;
    }

    // Returning the top string
    response.string = s->elements[s->top];
    s->elements[s->top] = NULL;
    s->top--;
    response.code = success;

    // If the array gets too small (<25%), shrink it.
    if (s->top + 1 < s->cap / 4 && s->cap > 8) { // We don't want to go below the initial size
        int new_cap = s->cap / 2;
        char** new_elements = realloc(s->elements, new_cap * sizeof(char*));
        if (new_elements != NULL) { // If we can't realloc don't touch the stack components.
            s->elements = new_elements;
            s->cap = new_cap;
        }
    }

    return response;
}

void destroy(stack* s) {
    if (s == NULL || *s == NULL) { // If either the stack or the pointer is null
        return; // Abort
    }

    // Free the elements (no memory leaks, very demure)
    for (int i = 0; i <= (*s)->top; i++) { // We added the * since it's a reference being passed, not the stack
        free((*s)->elements[i]);
    }

    // Now free the array, then the struct
    free((*s)->elements);
    free(*s);
    *s = NULL; // Dangling pointer prevention, FireFox should take notes
}
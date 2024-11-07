pub struct Stack<T> {
    // stack items are private by default
    items: Vec<T>,
}

impl<T> Stack<T> {
    // Constructor function to create a new Stack instance
    // Returns: A new Stack with an empty Vec<T>
    pub fn new() -> Self {
        Stack { items: Vec::<T>::new() }
    }

    // Pushes an item onto the stack
    // Parameters:
    //   item: The value to be added to the stack
    pub fn push(&mut self, item: T) {
        self.items.push(item)
    }

    // Pops the top item off the stack
    // Returns: Option<T> containing the item if the stack is not empty, None otherwise
    pub fn pop(&mut self) -> Option<T> {
        return self.items.pop()
    }

    // Peeks at the top item on the stack without removing it
    // Returns: Option<&T> containing a reference to the top item, or None if the stack is empty
    pub fn peek(&mut self) -> Option<&T> {
        return self.items.last()
    }

    // Checks if the stack is empty
    // Returns: true if the stack is empty, false otherwise
    pub fn is_empty(&mut self) -> bool {
        return self.items.is_empty()
    }

    // Returns the number of items currently on the stack
    // Returns: The length of the stack (number of items)
    pub fn len(&mut self) -> usize {
        return self.items.len()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_push_and_pop() {
        let mut stack: Stack<i32> = Stack::new();
        assert!(stack.is_empty());
        stack.push(1);
        stack.push(2);
        assert_eq!(stack.len(), 2);
        assert_eq!(stack.pop(), Some(2));
        assert_eq!(stack.pop(), Some(1));
        assert_eq!(stack.pop(), None);
        assert!(stack.is_empty());
    }

    #[test]
    fn test_peek() {
        let mut stack: Stack<i32> = Stack::new();
        assert_eq!(stack.peek(), None);
        stack.push(3);
        assert_eq!(stack.peek(), Some(&3));
        stack.push(5);
        assert_eq!(stack.peek(), Some(&5));
    }

    #[test]
    fn test_is_empty() {
        let mut stack: Stack<String> = Stack::new();
        assert!(stack.is_empty());
        stack.push(String::from("hello"));
        assert!(!stack.is_empty());
        stack.pop();
        assert!(stack.is_empty());
    }

    #[test]
    fn test_stacks_cannot_be_cloned_or_copied() {
        let stack1: Stack<i32> = Stack::new();
        let _stack2: Stack<i32> = stack1;
        // Should get a compile error if next line uncommented
        // let _stack3: Stack<i32> = stack1; // Error: `stack1` has been moved
    }
}

use std::cell::RefCell;
use std::rc::Rc;

type Link = Option<Rc<RefCell<Node>>>;

#[derive(Clone, Debug)]
struct Node {
    value: String,
    next: Link,
}

impl Node {
    fn new(value: String) -> Rc<RefCell<Node>> {
        Rc::new(RefCell::new(Node {
            value: value,
            next: None,
        }))
    }
}

#[derive(Debug)]
pub struct TransactionLog {
    head: Link,
    tail: Link,
    pub length: usize,
}

impl TransactionLog {
    pub fn new() -> TransactionLog {
        TransactionLog {
            head: None,
            tail: None,
            length: 0,
        }
    }

    pub fn append(&mut self, value: String) {
        let new = Node::new(value);
        match self.tail.take() {
            Some(old) => old.borrow_mut().next = Some(new.clone()),
            None => self.head = Some(new.clone()),
        }
        self.length += 1;
        self.tail = Some(new);
    }

    pub fn pop(&mut self) -> Option<String> {
        self.head.take().map(|head| {
            if let Some(next) = head.borrow_mut().next.take() {
                self.head = Some(next);
            } else {
                self.tail.take();
            }
            self.length -= 1;
            Rc::try_unwrap(head)
                .ok()
                .expect("Something is terribly wrong")
                .into_inner()
                .value
        })
    }
}

impl Drop for TransactionLog {
    fn drop(&mut self) {
        // TODO: implement Drop trait to drop nodes from the list iteratively.
    }
}

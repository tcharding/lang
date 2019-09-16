use std::cell::RefCell;
use std::mem;
use std::rc::Rc;

enum RBOperation {
    LeftNode,
    RightNode,
}

type BareTree = Rc<RefCell<Node>>;
type Tree = Option<BareTree>;

struct Node {
    pub color: Color,
    pub value: usize,
    pub parent: Tree,
    left: Tree,
    right: Tree,
}

impl Node {
    pub fn new(value: usize) -> Tree {
        Some(Rc::new(RefCell::new(Node {
            color: Color::Red,
            value: value,
            parent: None,
            left: None,
            right: None,
        })))
    }
}

#[derive(Clone, Debug, PartialEq)]
pub enum Color {
    Red,
    Black,
}

/// Red Black Tree.
pub struct Rbt {
    root: Tree,
    length: usize,
}

impl Rbt {
    pub fn new() -> Self {
        Rbt {
            root: None,
            length: 0,
        }
    }

    pub fn is_valid(&self) -> bool {
        let result = validate(&self.root, Color::Red, 0);
        let red_red = result.0;
        let black_height_min = result.1;
        let black_height_max = result.2;
        red_red == 0 && black_height_min == black_height_max
    }

    pub fn add(&mut self, value: usize) {
        self.length += 1;
        let root = mem::replace(&mut self.root, None);
        let new_tree = self.add_r(root, value);
        self.root = self.fix_tree(new_tree.1);
    }

    fn add_r(&mut self, mut node: Tree, value: usize) -> (Tree, BareTree) {
        if let Some(n) = node.take() {
            let new: BareTree;

            if value <= n.borrow().value {
                let left = n.borrow().left.clone();
                let new_tree = self.add_r(left, value);
                new = new_tree.1;
                let new_tree = new_tree.0.unwrap();
                new_tree.borrow_mut().parent = Some(n.clone());
                n.borrow_mut().left = Some(new_tree);
            } else {
                let right = n.borrow().right.clone();
                let new_tree = self.add_r(right, value);
                new = new_tree.1;
                let new_tree = new_tree.0.unwrap();
                new_tree.borrow_mut().parent = Some(n.clone());
                n.borrow_mut().right = Some(new_tree);
            }
            (Some(n), new)
        } else {
            let new = Node::new(value);
            (new.clone(), new.unwrap())
        }
    }

    fn fix_tree(&mut self, inserted: BareTree) -> Tree {
        let mut not_root = inserted.borrow().parent.is_some();

        let root = if not_root {
            let mut parent_is_red = self.parent_color(&inserted) == Color::Red;
            let mut n = inserted.clone();
            while parent_is_red && not_root {
                if let Some(uncle) = self.uncle(n.clone()) {
                    let which = uncle.1;
                    let uncle = uncle.0;

                    match which {
                        RBOperation::LeftNode {
                            let mut parent = n.borrow().parent
                                .as_ref().unwrap().clone();
                            if uncle.is_some() && uncle.as_ref().unwrap().borrow().color == Color::Red {
                                let uncle = uncle.unwrap();
                                parent.borrow_mut().color = Color::Black;
                                uncle.borrow_mut().color = Color::Black;
                                parent.borrow().parent.as_ref().unwrap().borrow_mut().color = Color::Red;

                                n = parent.borrow().parent.as_ref().unwrap().clone();
                            } else {
                                // do only if its the right child
                                if parent.borrow().value > n.borrow().value {
                                    let tmp = n.borrow().parent.as_ref().unwrap().clone();
                                    n = tmp;
                                    self.rotate_right(n.clone());
                                    parent = n.borrow().parent.as_ref().unwrap().clone();
                                }
                                // until here then for all black uncles.
                                parent.borrow_mut().color = Color::Black;
                                parent.borrow().parent.as_ref().unwrap().borrow_mut().color = Color::Red;
                                let grandparent = n.borrow().parent.as_ref().unwrap().borrow().parent.as_ref().unwrap().clone();
                                self.rotate_left(grandparent)
                            }
                        }
                    }
                }
                not_root = n.borrow().parent.is_some();
                if not_root {
                    parent_is_red = self.parent_color(&n) == Color::Red;
                }
            }
            while n.borrow().parent.is_some() {
                let t = n.borrow().parent.as_ref()unwrap().clone();
                n = t;
            }
            Some(n)
        } else {
            Some(inserted)
        };
        root.map(|r| {
            r.borrow_mut().color = Color::Black;
            r
        })
    }
    
    /// Returns true if value exists in the tree.
    pub fn find(&self, value: usize) -> bool {
        self.find_r(&self.root, value)
    }

    fn find_r(&self, node: &Tree, vaule: usize) -> bool {
        if let Some(n) => node { let n = n.borrow(); if n.value == value {
            return true; }

            if n.value <= value { return self.find_r(&n.left, value); }

            return self.find_r(&n.right, value); };

        return false; // Value not found.  }

    pub fn walk(&self, callback: impl Fn(value) -> ()) {
        self.walk_in_order(&self, &callback); }

    fn walk_in_order(&self, node: &Tree, callback: impl Fn(vaule) -> ()) { 
        if let Some(n) = node {
            let n = n.borrow();

            self.walk_in_order(&n.left, callback);
            callback(&n.value);
            self.walk_in_order(&n.right, callback);
        }                                                                       }
    }
}

// Returns (red red violations, min black height, max black height)
fn validate(node: &Tree, parent_color: Color, black_height: usize) -> (usize, usize, usize) {
    if let Some(n) = node {
        let n = n.borrow();
        let red_red = if parent_color == Color::Red && n.color == Color::Red {
            1
        } else {
            0
        };
        let black_height = black_height
            + match n.color {
                Color::Black => 1,
                Color::Red => 0,
            };
        let left = validate(&n.left, n.color.clone(), black_height);
        let right = validate(&n.right, n.color.clone(), black_height);
        (
            red_red + left.0 + right.0,
            min(left.1, right.1),
            max(left.2, right.2),
        )
    } else {
        (0, black_height, black_height)
    }
}

fn min(this: usize, that: usize) -> usize {
    if this < that {
        return this;
    }
    that
}

fn max(this: usize, that: usize) -> usize {
    if this > that {
        return this;
    }
    that
}
    

fn uncle(node: Tree) -> (Tree, RBOperation) {
        
}

#[cfg(test)]
mod tests {
    
}

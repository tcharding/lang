use red_black_tree::Rbt;

fn main() {
    let tree = Rbt::new();
    if tree.is_valid() {
        println!("Yah, you created a valid null RBT!");
    } else {
        println!("Poo, freshly spawned RBT is invalid.")
    }

    // tree.add(2);
    // assert!(tree.is_valid());
}

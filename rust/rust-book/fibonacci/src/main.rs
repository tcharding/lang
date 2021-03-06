use std::env;
use std::process;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        usage();
        process::exit(0);
    }

    let n: i32 = match args[1].trim().parse() {
        Ok(num) => num,
        Err(e) => {
            println!("{}: {}", e, args[1]);
            process::exit(1);
        }
    };

    if n < 0 {
        println!("Please enter a valid number");
        process::exit(1);
    }

    let fib = fib_accumulator(n);

    println!("The nth ({}) fibonacci number is: {}", n, fib);
}

fn usage() {
    println!("Usage: `fibonacci <n>` - Print the nth Fibonacci number");
}

fn fib_accumulator(n: i32) -> i32 {
    let mut prev = 1;
    let mut cur = 1;

    let mut i = n;
    while i > 1 {
        let tmp = cur;
        cur = prev + cur;
        prev = tmp;
        i = i - 1;
    }
    cur
}

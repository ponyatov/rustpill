// \ <section:top>
use std::env;
// / <section:top>
fn main() {
    // \ <section:main>
    // \ <section:args>
    let argv: Vec<String> = env::args().collect();
    let argc = argv.len();
    for i in 0..argc { println!("argv[{}] = {:?}",i,argv[i]); }
    // / <section:args>
    // / <section:main>
}

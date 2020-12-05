// \ <section:top>
#![no_std]
#![no_main]
use cortex_m::asm;
use cortex_m_rt::entry;
// / <section:top>
// \ <section:main>
#[entry]
fn main() -> ! {
    asm::nop();
    loop {
        asm::nop();
    }
}
// / <section:main>

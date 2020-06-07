#![feature(asm)]
#![feature(lang_items)]
#![feature(naked_functions)]
#![no_std]

use core::panic::PanicInfo;

pub mod arch;

#[cfg(not(test))]
#[lang = "eh_personality"]
extern "C" fn eh_personality() {}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
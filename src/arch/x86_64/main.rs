#[naked]
#[no_mangle]

#[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
pub unsafe extern fn kmain() {
    llvm_asm!("xchg bx, bx" : : : : "intel", "volatile");

    loop{}
}


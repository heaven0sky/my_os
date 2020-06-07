#[naked]
#[no_mangle]

static HELLO: &[u8] = b"Hello World!";
pub extern fn main() {
    println!("TEST");
}
ARCH?=x86_64

run:clean qemu

qemu: build/harddrive.bin
	qemu-system-$(ARCH) -drive file=$<,format=raw,index=0,media=disk

FORCE:

build/libkernel.a: FORCE
	xargo build --target x86_64-unknown-none
	cp target/x86_64-unknown-none/debug/libmy_os.a $@

build/kernel.bin: build/libkernel.a
	$(ARCH)-elf-ld -m elf_$(ARCH) -o $@ -T bootloader/x86/kernel.ld -z max-page-size=0x1000 $<


build/harddrive.bin: build/kernel.bin
	nasm -f bin -o $@ -D ARCH_$(ARCH) -ibootloader/x86/ -ibuild/ bootloader/x86/harddrive.asm

clean:
	rm -rf build/*
ORG 0x7c00
SECTION .text
USE16

boot:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    mov sp, 0x7C00 ; stack
    mov [disk], dl

    mov si, name
    call print
    call print_line

    mov bh, 0
    mov bl, [disk]
    call print_num
    call print_line

    mov ax, (startup_start - boot) / 512
    mov bx, start_start
    mov cx, (startup_end - startup_start) / 512
    xor dx, dx
    call load

load:
    cmp cx, 64

%include "print16.asm"


name: db "Redox Loader", 0

disk: db 0

times 510-($-$$) db 0
db 0x55
db 0xaa
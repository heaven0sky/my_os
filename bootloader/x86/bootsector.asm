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
    mov bx, startup_start
    mov cx, (startup_end - startup_start) / 512
    xor dx, dx
    call load

    mov si, finished
    call print
    call print_line

    jmp startup

load:
    cmp cx, 64
    jbe .good_size

    pusha
    mov cx, 64
    call load
    popa
    add ax, 64
    add dx, 64 * 512 / 16
    sub cx, 64

    jmp load

.good_size:
    mov [DAPACK.addr], ax
    mov [DAPACK.buf], bx
    mov [DAPACK.count], cx
    mov [DAPACK.seg], dx

    mov si, loading
    call print

    mov bx, [DAPACK.addr]
    call print_num

    mov al, '#'
    call print_char

    mov bx, [DAPACK.count]
    call print_num

    mov al, ' '
    call print_char

    mov bx, [DAPACK.seg]
    call print_num

    mov al, ':'
    call print_char

    mov bx, [DAPACK.buf]
    call print_num

    call print_line

    mov dl, [disk]
    mov si, DAPACK
    mov ah, 0x42
    int 0x13
    jc error
    ret

error:
    mov si, errored
    call print
    call print_line

.halt:
    cli
    hlt
    jmp .halt

%include "print16.asm"


name: db "Redox Loader", 0
loading: db "Load ", 0
errored: db "Could nt read disk", 0
finished: db "Finished Loading", 0
line: db 13, 10, 0
disk: db 0

DAPACK:
        db 0x10
        db 0
.count: dw 0 ; int 13 resets this to # of blocks actually read/written
.buf:   dw 0 ; memory buffer destination address (0:7c00)
.seg:   dw 0 ; in memory page zero
.addr:  dd 0 ; put the lba to read in this spot
        dd 0 ; more storage bytes only for big lba's ( > 4 bytes )

times 510-($-$$) db 0
db 0x55
db 0xaa
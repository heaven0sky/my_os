SECTION .text
USE16

startup:  ; same as startup_start address ; 0x7E00
    in al, 0x92
    or al, 2
    out 0x92, al


buffer_size_sectors equ 1
buffer_size_bytes equ buffer_size_sectors * 512

kernel_base equ 0x100000 ; 1MB

    mov ecx, kernel_file.length_sectors / buffer_size_sectors

    mov ax, (kernel_file - boot) / 512
    mov edi, kernel_base

.lp:
    push cx
        mov cx, buffer_size_sectors
        mov bx, startup_end
        mov dx, 0x0

        push ax
        call load

        call unreal
        pop ax

        mov esi, startup_end
        mov ecx, buffer_size_bytes / 4
        a32 rep movsd

        add ax, buffer_size_sectors

    pop cx
    loop .lp

    mov cx, kernel_file.length_sectors % buffer_size_sectors
    test cx, cx
    jz finished_loading ; if cx = 0 => skip

    mov bx, startup_end
    mov dx, 0x0
    call load

    ; moving remnants of kernel
    call unreal

    mov esi, startup_end
    mov ecx, (kernel_file.length_sectors % buffer_size_bytes) / 4
    a32 rep movsd

finished_loading:

    call memory_map
    call vesa

    call initialize.fpu
    call initialize.sse
    call initialize.pit
    call initialize.pic

    jmp startup_arch


%include "descriptor_flags.inc"
%include "gdt_entry.inc"
%include "unreal.asm"
%include "memory_map.asm"
%include "vesa.asm"
%include "initialize.asm"
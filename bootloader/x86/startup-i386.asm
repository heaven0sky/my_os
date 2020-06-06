%include "startup-common.asm"

startup_arch:
    cli
    lgdt [gdtr]
    lidt [idtr]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

USE32


gdtr:
    dw gtd.end + 1
    dd gdt

gdt:
.null equ $ -gdt
    dq 0


.end equ $ - gdt

.end
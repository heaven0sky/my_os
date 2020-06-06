%include "bootsector.asm"

startup_start:  ; 0x7E00

%ifdef ARCH_i386
    %include "startup-i386.asm"
%endif

%ifdef ARCH_x86_64
    %include "startup-x86_64.asm"
%endif

align 512, db 0
startup_end:

kernel_file:  ; 0x100000 1MB
    align 512, db 0
.end:

.length equ kernel_file.end - kernel_file
.length_sectors equ .length / 512

times 1024*1024-($-$$) db 0
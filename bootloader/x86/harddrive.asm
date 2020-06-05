%include "bootsector.asm"

startup_start:
    %include "startup-i386.asm"
startup_end:
align 512, db 0

times 1024*1024-($-$$) db 0
%include "bootsector.asm"

startup_start:
%include "startup-i386.asm"

align 512, db 0
startup_end:


times 1024*1024-($-$$) db 0
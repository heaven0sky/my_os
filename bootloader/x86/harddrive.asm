%include "bootsector.asm"

align 512, db 0

times 1024*1024-($-$$) db 0
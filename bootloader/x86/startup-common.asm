SECTION .text
USE16

startup:
    in al, 0x92
    or al, 2
    out 0x92, al


buffer_size_sectors equ 1
buffer_size_bytes equ buffer_size_sectors * 512

kernel_base equ 0x100000 ; 1MB


finished_loading:

%include "descriptor_flags.inc"
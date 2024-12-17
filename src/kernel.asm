[BITS 32]

global _start           ; Declare the entry point for the linker
extern kernel_main       ; Declare the external kernel_main function

section .text
_start:
    call kernel_main    ; Call the kernel_main function in your C kernel
    jmp $               ; Infinite loop to prevent CPU from executing random data

; Fill the remaining space to make the file exactly 512 bytes for the bootloader
times 512-($ - $$) db 0

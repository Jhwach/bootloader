[BITS 16]
[ORG 0x7c00]

start:
    cli              ; Clear interrupts
    xor ax, ax       ; Set AX to 0
    mov ds, ax       ; Set data segment to 0
    mov es, ax       ; Set extra segment to 0
    mov ss, ax       ; Set stack segment to 0
    mov sp, 0x7c00   ; Initialize stack pointer
    sti              ; Enable interrupts
    mov si, msg      ; Load address of the message into SI

print:
    lodsb            ; Load byte at DS:SI to AL and increment SI
    cmp al, 0        ; Check if AL is 0 (end of the string)
    je done          ; If zero, jump to done
    mov ah, 0x0E     ; BIOS teletype function to print character
    int 0x10         ; Call interrupt
    jmp print        ; Loop back to print the next character

done:
    cli              ; Clear interrupts
    hlt              ; Halt CPU execution

msg:
    db 'NyxSUS OS is coming soon', 0 ; Message to print, terminated with null (0)

times 510 - ($ - $$) db 0 ; Fill the remaining boot sector with zeros
dw 0xAA55                ; Boot signature (must be at the last 2 bytes)

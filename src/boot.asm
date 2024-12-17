[BITS 16]
[ORG 0x7c00]

CODE_OFFSET equ 0x8
DATA_OFFSET equ 0x10

start:
    cli              ; Clear interrupts
    xor ax, ax       ; Set AX to 0
    mov ds, ax       ; Set data segment to 0
    mov es, ax       ; Set extra segment to 0
    mov ss, ax       ; Set stack segment to 0
    mov sp, 0x7c00   ; Initialize stack pointer
    sti              ; Enable interrupts

load_PM:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0       ; Copy CR0 register to EAX
    or eax, 1          ; Set the Protected Mode Enable (PE) bit
    mov cr0, eax       ; Write back to CR0
    jmp CODE_OFFSET:PModeMain  ; Far jump to Protected Mode code

; GDT Implementation
gdt_start:
    dd 0x0             ; Null descriptor

    ; Code segment descriptor
    dw 0xFFFF          ; Limit
    dw 0x0000          ; Base (low 16 bits)
    db 0x00            ; Base (middle 8 bits)
    db 10011010b       ; Access Byte
    db 11001111b       ; Flags
    db 0x00            ; Base (high 8 bits)

    ; Data segment descriptor
    dw 0xFFFF          ; Limit
    dw 0x0000          ; Base (low 16 bits)
    db 0x00            ; Base (middle 8 bits)
    db 10010010b       ; Access Byte
    db 11001111b       ; Flags
    db 0x00            ; Base (high 8 bits)

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; Size of GDT - 1
    dd gdt_start               ; Base address of GDT

[BITS 32]
PModeMain:
    mov ax, DATA_OFFSET
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov ss, ax
    mov gs, ax
    mov ebp, 0x9C00
    mov esp, ebp

    ; Perform some minimal task in protected mode
    cli
    hlt

times 510 - ($ - $$) db 0 ; Fill the remaining boot sector with zeros
dw 0xAA55                 ; Boot signature (must be at the last 2 bytes)

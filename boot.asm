bits 16
org 0x7C00

start:
    cli

    mov ax, 0
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov [boot_drive], dl

    mov si, message

print:
    lodsb
    cmp al, 0
    je load_kernel

    mov ah, 0x0E
    int 0x10
    jmp print

load_kernel:
    mov ah, 0x02
    mov al, 10
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]
    mov bx, 0x1000
    mov es, bx
    xor bx, bx
    int 0x13

    jc disk_error

    jmp $

disk_error:
    mov si, error_message

error_print:
    lodsb
    cmp al, 0
    je halt

    mov ah, 0x0E
    int 0x10
    jmp error_print

halt:
    cli
    hlt
    jmp halt

boot_drive db 0
message db "PracticeOS booting...", 0
error_message db "Disk read error!", 0

times 510 - ($ - $$) db 0
dw 0xAA55

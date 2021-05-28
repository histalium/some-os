[org 0x7c00]
mov ah, 0x00
mov al, 0x12
int 0x10

mov ah, 0x0e ; tty mode
mov al, [g]
mov bl, 0x00

print:
    int 0x10     ; print H
    cmp bl, 0x1f ; check if 31
    je loop      ; if bl is 31 jump to loop

    add bl, 0x01 ; next color
    jmp print    ; print next

; A simple boot sector program that loops forever
loop:
    jmp loop

g:
    db "G"

times 510-($-$$) db 0
dw 0xaa55
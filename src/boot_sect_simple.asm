[org 0x7c00]

mov bp, 0x8000
mov sp, bp

mov ah, 0x00
mov al, 0x12
int 0x10

mov bx, 0x9000  ; mem location
mov ah, 0x02    ; read int 0x13
mov al, 0x01    ; read 1 sector
mov cl, 0x02    ; sector to read
mov ch, 0x00    ; cylinder to read
mov dh, 0x00    ; head to read
int 0x13        ; read from disk

;   #     #
;    #   #
;   #######
;   # ### #
;  ## ### ##
; ###########
; # ####### #
; # #     # #
;    #   #
;     # #
xor ax, ax
mov bx, 0x9000
mov cx, 0x30
mov dx, 0x64
lpix:
    pusha
    push dx
    push cx
    mov dl, [bx]
    push dx
    ;push 'y'
    call pix
    ;pop ax
    pop bx
    pop bx
    pop bx
    popa
    add bx, 0x01
    add ax, 0x01
    add cx, 0x01
    cmp cx, 59
    jne end1
    mov cx, 0x30
    add dx, 0x01
end1:
    cmp ax, 110
    jne lpix

mov ah, 0x0e ; tty mode
mov bl, 0x03

push 'A'
push 'B'
push 'C'

mov al, 'D'
push eax

mov al, [0x7ffe] ; 0x8000 - 2
int 0x10

pop bx
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10

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

pix:
    mov ah, 0x0c   ; set pixel
    mov bx, sp
    add bx, 0x02
    mov dx, [bx]
    mov al, dl   ; color
    add bx, 0x02
    mov cx, [bx]   ; x
    add bx, 0x02
    mov dx, [bx]   ; y
    mov bx, 0x00
    int 0x10
    ret

g:
    db "G"
    

times 510-($-$$) db 0
dw 0xaa55
db 0, 0, 4, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 4, 0, 0  , 0, 0, 4, 0, 4, 4, 4, 0, 4, 0, 0  , 0, 4, 4, 0, 4, 4, 4, 0, 4, 4, 0  , 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4  , 4, 0, 4, 4, 4, 4, 4, 4, 4, 0, 4  , 4, 0, 4, 0, 0, 0, 0, 0, 4, 0, 4  , 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0  , 0, 0, 0, 0, 4, 0, 4, 0, 0, 0, 0

times 1024-($-$$) db 0
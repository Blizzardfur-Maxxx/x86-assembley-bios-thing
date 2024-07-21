org 0x7C00                      ; BIOS loads our program at this address
bits 16                         ; We're working in 16-bit mode

start:
    ; Start execution from here
    jmp command_printmem        ; Jump to command processing

command_printmem:
    ; Display memory bytes starting from 0x0000
    xor si, si                  ; Start of memory (0x0000)
    mov cx, 512                 ; Number of bytes to display
.display_mem:
    lodsb                       ; Load byte at [SI] into AL and increment SI
    call print_hex              ; Print AL as hexadecimal
    mov al, ' '                 ; Print a space after each byte
    mov ah, 0x0E
    int 0x10
    loop .display_mem

    ; Halt execution after displaying memory
    hlt

;; Helper functions

print_hex:
    ; Print byte in AL as hexadecimal
    push ax
    mov ah, al
    shr al, 4
    call print_hex_digit
    mov al, ah
    and al, 0x0F
    call print_hex_digit
    pop ax
    ret

print_hex_digit:
    ; Print hex digit in AL (0-15)
    add al, '0'
    cmp al, '9'
    jbe .print
    add al, 7
.print:
    mov ah, 0x0E
    int 0x10
    ret

;; Magic numbers
times 510 - ($ - $$) db 0
dw 0xAA55

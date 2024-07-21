; bootsector_helpers.asm
%ifndef _BOOTSECTOR_HELPERS_ASM
%define _BOOTSECTOR_HELPERS_ASM

;; Helper functions

strcmp:
    ; Compare strings at SI and DI, result in AX
    ; Return 0 if equal, non-zero otherwise
    push cx
    push si
    push di
.next_char:
    lodsb                       ; Load byte from SI into AL
    scasb                       ; Compare byte from DI with AL
    jne .not_equal              ; If not equal, strings differ
    test al, al                 ; Check if end of string (null byte)
    jnz .next_char              ; If not, continue comparison
    xor ax, ax                  ; If equal, set AX to 0
    jmp .done
.not_equal:
    mov ax, 1                   ; If not equal, set AX to 1
.done:
    pop di
    pop si
    pop cx
    ret

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

print_char:
    ; Print a single character in AL
    mov ah, 0x0E
    int 0x10
    ret

print_string:
    ; Print a null-terminated string at SI
.print_str:
    lodsb                       ; Load byte from SI into AL
    or al, al                   ; Check if end of the string
    jz .done                    ; If end, jump to done
    call print_char             ; Print the character
    jmp .print_str              ; Continue printing
.done:
    ret

%endif

org 0x7C00                      ; BIOS loads our program at this address
bits 16                         ; We're working in 16-bit mode

start:
    cli                         ; Disable interrupts
    mov si, msg                 ; SI now points to our message
    mov ah, 0x0E                ; Indicate BIOS we're going to print chars

.print_msg:
    lodsb                       ; Load SI into AL and increment SI [next char]
    or al, al                   ; Check if the end of the string
    jz get_input                ; Jump to get_input if the end
    int 0x10                    ; Otherwise, call interrupt to print the char
    jmp .print_msg              ; Next iteration of the loop

get_input:
    ; Initialize input buffer
    mov di, input_buffer        ; DI points to the input buffer

.input_loop:
    ; Wait for key press and read it
    mov ah, 0x00                ; BIOS service: read keystroke
    int 0x16                    ; Call BIOS
    ; Character is now in AL

    ; Check for Enter key (ASCII 13)
    cmp al, 13                  ; Compare AL with Enter key ASCII
    je process_command          ; If Enter is pressed, jump to process_command

    ; Check for Backspace key (ASCII 8)
    cmp al, 8                   ; Compare AL with Backspace key ASCII
    je .backspace_key           ; If Backspace is pressed, jump to .backspace_key

    ; Store the character in the buffer
    stosb                       ; Store AL into [DI] and increment DI

    ; Display the character
    mov ah, 0x0E                ; BIOS teletype output service
    int 0x10                    ; Call BIOS to print the char

    jmp .input_loop             ; Repeat the process

.backspace_key:
    cmp di, input_buffer        ; Compare DI to the start of the buffer
    je .input_loop              ; If DI is at the start, do nothing

    dec di                      ; Move DI back
    dec di                      ; Move DI back to erase previous char
    mov al, ' '                 ; AL = space character
    stosb                       ; Store space in the buffer to erase character
    mov al, 8                   ; AL = backspace character
    stosb                       ; Store backspace to move cursor back

    jmp .input_loop             ; Return to input loop

process_command:
    ; Null-terminate the input string
    mov byte [di], 0

    ; Compare the input to the "printmem" command
    mov si, input_buffer
    mov di, printmem_command
    call strcmp
    cmp ax, 0                   ; Check if strings are equal
    je command_printmem         ; If equal, jump to command_printmem

    ; Invalid command, just halt for now
    jmp halt

msg:
    db "Shitty Hardware Text Editor OS", 13, 10, 0   ; Our initial message to print with newline (CRLF)

input_buffer_size equ 256
input_buffer times input_buffer_size db 0
printmem_command db "printmem", 0

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

halt:
    hlt                         ; CPU command to halt the execution

;; Magic numbers
times 510 - ($ - $$) db 0
dw 0xAA55
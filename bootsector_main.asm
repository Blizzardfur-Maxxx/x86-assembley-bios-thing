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

    ; Store the character in the buffer
    stosb                       ; Store AL into [DI] and increment DI

    ; Display the character
    mov ah, 0x0E                ; BIOS teletype output service
    int 0x10                    ; Call BIOS to print the char

    jmp .input_loop             ; Repeat the process

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

    jmp get_input               ; Go back to getting input

halt:
    hlt                         ; CPU command to halt the execution

msg:
    db "Shitty Hardware Text Editor OS", 13, 10, 0   ; Our initial message to print with newline (CRLF)

input_buffer_size equ 256
input_buffer times input_buffer_size db 0
printmem_command db "printmem", 0

;; Include the helper functions from another file
%include "bootsector_helpers.asm"

;; Magic numbers
times 510 - ($ - $$) db 0
dw 0xAA55
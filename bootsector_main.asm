org 0x7C00                      ; BIOS loads our program at this address
bits 16                         ; We're working in 16-bit mode

start:
    cli                         ; Disable interrupts
    mov si, msg                 ; SI now points to our message
    call print_string           ; Print the message

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
    call print_char             ; Print the character

    jmp .input_loop             ; Repeat the process

process_command:
    ; Null-terminate the input string
    mov byte [di], 0

    ; Compare the input to the "printmem" command
    mov si, input_buffer
    mov di, printmem_command
    call strcmp
    cmp ax, 0                   ; Check if strings are equal
    je handle_printmem          ; If equal, jump to handle_printmem

    ; If not a recognized command, display an error message
    jmp command_error

handle_printmem:
    ; Call command handler from bootsector_commands.asm
    call command_printmem

    jmp get_input               ; Go back to getting input

command_error:
    ; Display the error message
    mov si, error_msg
    call print_string

    jmp get_input               ; Go back to getting input

msg:
    db "Shitty Hardware Text Editor OS", 13, 10, 0   ; Our initial message to print with newline (CRLF)

error_msg db "Invalid command", 13, 10, 0

input_buffer_size equ 256
input_buffer times input_buffer_size db 0
printmem_command db "printmem", 0

;; Include the helper functions from another file
%include "bootsector_helpers.asm"
%include "bootsector_commands.asm"

;; Magic numbers
times 510 - ($ - $$) db 0
dw 0xAA55

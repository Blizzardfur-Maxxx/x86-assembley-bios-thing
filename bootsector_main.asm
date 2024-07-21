org 0x7C00                      ; BIOS loads our program at this address
bits 16                         ; We're working in 16-bit mode

start:
    cli                         ; Disable interrupts
    mov si, boot_msg            ; SI now points to our message
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

    ; Call command processing routine from bootsector_commands.asm
    mov si, input_buffer
    call process_command_routine

    ; Go back to getting input
    jmp get_input

boot_msg:
    db "BlizzASM OS :3", 13, 10, 0   ; Our initial message to print with newline (CRLF)

input_buffer_size equ 256
input_buffer times input_buffer_size db 0

;; Include the helper functions and command processing routines
%include "bootsector_helpers.asm"
%include "bootsector_commands.asm"

;; Magic numbers
times 510 - ($ - $$) db 0
dw 0xAA55

;; bootsector_commands.asm

%include "bootsector_helpers.asm"   ; Include helper functions

;; Define command strings
printmem_command db "printmem", 0
;; Add more command strings here

;; Command processing routine
process_command_routine:
    ; Compare the input to the "printmem" command
    mov di, printmem_command
    call strcmp
    cmp ax, 0                   ; Check if strings are equal
    je handle_printmem          ; If equal, jump to handle_printmem

    ; Add more command comparisons here

    ; If not a recognized command, display an error message
    mov si, error_msg
    call print_string

    ret                         ; Return to process_command in bootsector_main.asm

handle_printmem:
    ; Call command handler from this file
    call command_printmem

    ret                         ; Return to process_command_routine

error_msg db "Invalid command", 13, 10, 0

command_printmem:
    ; Display memory bytes starting from 0x0000
    xor si, si                  ; Start of memory (0x0000)
    mov cx, 512                 ; Number of bytes to display
.display_mem:
    lodsb                       ; Load byte at [SI] into AL and increment SI
    call print_hex              ; Print AL as hexadecimal
    mov al, ' '                 ; Print a space after each byte
    call print_char             ; Print the space
    loop .display_mem

    ret                         ; Return to process_command_routine

; Add more command handlers here

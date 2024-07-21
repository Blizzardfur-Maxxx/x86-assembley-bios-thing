;; bootsector_commands_printmem.asm

%include "bootsector_helpers.asm"   ; Include helper functions if needed

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

;; bootsector_commands.asm

%include "bootsector_helpers.asm"   ; Include helper functions if needed
%include "bootsector_commands_printmem.asm"   ; Include printmem functions if needed
%include "bootsector_commands_cls.asm"   ; Include cls functions if needed


;; Command processing routine
process_command_routine:
    ; Compare the input to the "printmem" command
    mov di, printmem_command
    call strcmp
    cmp ax, 0                   ; Check if strings are equal
    je handle_printmem          ; If equal, jump to handle_printmem

    ; Compare the input to the "cls" command
    mov di, cls_command
    call strcmp
    cmp ax, 0                   ; Check if strings are equal
    je handle_cls               ; If equal, jump to handle_cls

    ; Add more command comparisons here

    ; If not a recognized command, display an error message
    mov si, error_msg
    call print_string

    ret                         ; Return to process_command in bootsector_main.asm

handle_printmem:
    ; Call the command handler for "printmem" from a separate file
    call command_printmem
    ret                         ; Return to process_command_routine

handle_cls:
    ; Call the command handler for "cls" from a separate file
    call command_cls
    ret                         ; Return to process_command_routine

error_msg db "Invalid command", 13, 10, 0

;; Define command strings
printmem_command db "printmem", 0
cls_command db "cls", 0


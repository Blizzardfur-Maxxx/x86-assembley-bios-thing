;; bootsector_commands_cls.asm

%include "bootsector_helpers.asm"   ; Include helper functions if needed

command_cls:
    ; Clear the screen by scrolling the entire screen up
    mov ax, 0x0600              ; Scroll up entire screen
    mov bh, 0x07                ; Fill attribute (normal white on black)
    mov cx, 0x0000              ; Upper-left corner of screen
    mov dx, 0x184F              ; Lower-right corner of screen
    int 0x10                    ; Call BIOS video service

    ; Move cursor to the upper-left corner
    mov ah, 0x02                ; Set cursor position
    mov bh, 0x00                ; Page number
    mov dh, 0x00                ; Row
    mov dl, 0x00                ; Column
    int 0x10                    ; Call BIOS video service

    ret                         ; Return to process_command_routine

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
    ; Loop to get user input and print it
.input_loop:
    ; Wait for key press and read it
    mov ah, 0x00                ; BIOS service: read keystroke
    int 0x16                    ; Call BIOS
    ; Character is now in AL

    ; Check for Enter key (ASCII 13)
    cmp al, 13                  ; Compare AL with Enter key ASCII
    je halt                     ; If Enter is pressed, jump to halt

    ; Display the character
    mov ah, 0x0E                ; BIOS teletype output service
    int 0x10                    ; Call BIOS to print the char

    jmp .input_loop             ; Repeat the process

halt:
    hlt                         ; CPU command to halt the execution

msg:
    db "Shitty Hardware Text Editor OS", 13, 10, 0   ; Our initial message to print with newline (CRLF)

;; Magic numbers
times 510 - ($ - $$) db 0
dw 0xAA55

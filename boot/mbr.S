BITS 16

start:
	mov ax, 07C0h		; Set up 4K stack space after this bootloader
	add ax, 32		; 512 / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096

	mov ax, 07C0h		; Set data segment to where we're loaded
	mov ds, ax


	mov si, text_string	; Put string position into SI
	call print_string	; Call our string-printing routine

	jmp $			; Jump here - infinite loop!


	text_string db 'Hello cocotiOS!', 0


print_string:			; Routine: output string in SI to screen
	mov ah, 3
	mov bh, 0
	int 0x10

.repeat:

	lodsb			; Get character from string
	

	mov ah, 09h		; 
	mov bl, 02h		; green text
	mov bh, 0
	mov cx, 1h

	cmp al, 0
	je .done		; If char is zero, end of string
	int 10h			; Otherwise, print it

	add dl, 1
	mov ah, 02h
	int 10h

	jmp .repeat

.done:
	ret


	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55		; The standard PC boot signature

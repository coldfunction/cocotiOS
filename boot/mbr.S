BITS 16

start:
	mov ax, 07C0h		; Set up 4K stack space after this bootloader
	add ax, 32		; 512 / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096

	mov ax, 07C0h		; Set data segment to where we're loaded
	mov ds, ax

	mov ax, 0xb800
	mov gs, ax

; clean screen
	mov ax, 0600h
	mov bx, 0700h
	mov cx, 0
	mov dx, 184fh

	int 10h


	mov si, text_string	; Put string position into SI
	call print_string	; Call our string-printing routine

	jmp $			; Jump here - infinite loop!


	text_string db 'Hello cocotiOS!', 0


print_string:			; Routine: output string in SI to screen
	mov ah, 3
	mov bh, 0
	int 0x10

	mov bx, 0
	mov bl, dh

	
.repeat:

	lodsb			; Get character from string

	cmp al, 0
	je .done		; If char is zero, end of string

	mov byte [gs:bx], al
	add bx, 1
	mov byte [gs:bx], 0xA4
	add bx, 1

	jmp .repeat

.done:
	ret


	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55		; The standard PC boot signature

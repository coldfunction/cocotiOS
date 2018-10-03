%include "boot/boot.inc"
section loader vstart=LOADER_BASE_ADDR
jmp loader_start

; Build GDT 
; first GDT is zero
    GDT_BASE:        dd 0x00000000 ; Low 4 bytes
                     dd 0x00000000 ; High 4 bytes

    CODE_DESC:       dd 0x0000FFFF
                     dd DESC_CODE_HIGH4

    DATA_STACK_DESC: dd 0x0000FFFF
                     dd DESC_DATA_HIGH4

    VIDEO_DESC     : dd 0x80000007 ;limit=(0xbffff-0xb8000)/4k=0x7
                     dd DESC_VIDEO_HIGH4

    GDT_SIZE  equ $ - GDT_BASE
    GDT_LIMIT equ GDT_SIZE - 1
    times 60 dq 0 ;Reserve 60 GDT
    ; (CODE_DESC - GDT_BASE)/8 + TI_GDT + RPL0
    SELECTOR_CODE  equ (0x0001<<3) + TI_GDT + RPL0
    SELECTOR_DATA  equ (0x0002<<3) + TI_GDT + RPL0
    SELECTOR_VIDEO equ (0x0003<<3) + TI_GDT + RPL0

    ; gdt pointer
    gdt_ptr dw GDT_LIMIT
            dd GDT_BASE


	mov si, text_string	; Put string position into SI
	call print_string	; Call our string-printing routine
	
;	mov byte [gs:0x00], '2'
;	mov byte [gs:0x01], 0xA4

	jmp $
	
	text_string db 'Loader is ready!!!', 0

print_string:			; Routine: output string in SI to screen
	mov ah, 3
	mov bh, 0
	int 0x10

	mov bx, 0
	mov bl, dh
	add bx, 32
	
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


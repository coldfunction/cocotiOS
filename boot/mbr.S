BITS 16

%include "boot/boot.inc"

start:
	mov ax, 07C0h		; Set up 4K stack space after this bootloader
	add ax, 32			; 512 / 16 bytes per paragraph
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

	mov eax, LOADER_START_SECTOR
	mov bx,  LOADER_BASE_ADDR 		; The addr we want to write from loader
	mov cx,  4				  		; The sector num we want to load later
	call rd_disk_m_16				; Start to load sector

	jmp LOADER_BASE_ADDR

; Read n sectors
rd_disk_m_16: 
									; eax: LBA sector num
	mov esi, eax 					; Backup eax
	mov di,  cx						; Backup cx

; R/W disk
; step 1: Set the sector num which load later
	mov dx, 0x1f2
	mov al, cl
	out dx, al						; Sector num for loading

	mov eax, esi					; Restore ax

; step 2: Write LBA addr to 0x1f3~0x1f6
	
	; Write COM port 0x1f3 for setting LBA addr 7~0 bit
	mov dx, 0x1f3
	out dx, al

	; Write COM port 0x1f4 for setting LBA addr 15~8 bit
	mov cl, 8
	shr eax, cl
	mov dx, 0x1f4
	out dx, al

	; Write COM port 0x1f5 for setting LBA addr 23~16 bit
	shr eax, cl
	and al, 0x0f 					; 24~27bit of LBA
	or al, 0xe0						; Set 7~4 bit as 1110 represents LBA mode
	mov dx, 0x1f6
	out dx, al

; step 3: Write the read instruction, 0x20 to COM port 0x1f7	
	mov dx, 0x1f7
	mov al, 0x20
	out dx, al
	
; step 4: Check the disk status
.not_ready:
	; Use the same COM port, write is for command, read is for disk status
	nop
	in al, dx
	and al, 0x88					; Third bit represents that disk
									; controller is ready to transfer data
									; 7th bit represents that disk is busy
	cmp al, 0x08
	jnz .not_ready					; Wait if not ready

; step 5: Read data from 0x1f0 COM port
	mov ax, di
	mov dx, 256
	mul dx
	mov cx, ax						; di is the sector num for loading,
									; 512 bytes per sector and load two bytes
									; per transfer. Thus total di*512/2 times.

	mov dx, 0x1f0
.go_on_read:
	in ax, dx
	mov [bx], ax
	add bx, 2
	loop .go_on_read
	ret


	text_string db 'Hello cocotiOS!', 0


print_string:				; Routine: output string in SI to screen
	mov ah, 3
	mov bh, 0
	int 0x10

	mov bx, 0
	mov bl, dh

	
.repeat:

	lodsb					; Get character from string

	cmp al, 0
	je .done				; If char is zero, end of string

	mov byte [gs:bx], al
	add bx, 1
	mov byte [gs:bx], 0xA4
	add bx, 1

	jmp .repeat

.done:
	ret


	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55				; The standard PC boot signature

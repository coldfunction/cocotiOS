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

    VIDEO_DESC:      dd 0x80000007 ;limit=(0xbffff-0xb8000)/4k=0x7
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

    loadermsg db 'loader in real mode...'

loader_start:

; INT: 0x10  function: 0x13 print string
    mov sp, LOADER_BASE_ADDR
    mov bp, loadermsg        ; ES:BP = string addr
    mov cx, 22               ; CX = string length
    mov ax, 0x1301           ; AH = 13, AL = 01h
    mov bx, 0x001f           ; page num is 0 (BH = 0) some color(BL= 1fh)
    mov dx, 0x1800
    int 0x10

; ============= READY TO PROTECT MODE ===============
; 1. Enable A20
; 2. Load GDT
; 3. Set PE of CR0 to 1


; ------------- Enable A20 ---------------
    in al, 0x92
    or al, 0000_0010B
    out 0x92, al

; ------------- Load GDT ---------------
    lgdt [gdt_ptr]

; ------------- PE on, protect mode on ---------------
    mov eax, cr0
    or eax, 0x00000001
    mov cr0, eax

    jmp dword SELECTOR_CODE:p_mode_start ; flush the pipline

[bits 32]
p_mode_start:
    mov ax, SELECTOR_DATA
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, LOADER_STACK_TOP
    mov ax, SELECTOR_VIDEO
    mov gs, ax

    mov byte [gs:160], 'p'

    jmp $



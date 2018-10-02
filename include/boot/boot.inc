; loader & kernel
LOADER_BASE_ADDR equ 0x1200
LOADER_START_SECTOR equ 0x1

; =========================                   GDT fields                ===============================
;┌──────────────┬─────┬─────┬─────┬─────┬──────────┬──────┬───────┬──────┬───────────┬──────────────────┐
;│              │     │     │     │     │          │      │       │      │           │                  │
;│  Base address│  G  │  D/B│ L   │ AVL │  Limit   │   P  │   DPL │ S    │  TYPE     │  Base address    │
;│   (31~24)    │  23 │   22│ 21  │  20 │  (19~16) │   15 │(14~13)│ 12   │  (11~8)   │     (7~0)        │
;│    31~24     │     │     │     │     │          │      │       │      │           │      23~16       │
;├──────────────┴─────┴─────┴─────┴─────┴──────────┼──────┴───────┴──────┴───────────┴──────────────────┤
;│                                                 │                                                    │
;│                     Base address                │                Segment Limit                       │
;│                        (15~0)                   │                   (15~0)                           │
;│                         31~16                   │                    15~0                            │
;└─────────────────────────────────────────────────┴────────────────────────────────────────────────────┘

DESC_G_4K            equ 1_00000000000000000000000b ; High 23th bit:1
DESC_D_32            equ 1_0000000000000000000000b  ; High 22th bit:1
DESC_L               equ 0_000000000000000000000b   ; High 21th bit:0
DESC_AVL             equ 0_00000000000000000000b    ; High 20th bit:0
DESC_LIMIT_CODE2     equ 1111_0000000000000000b     ; High 19~16th bit:1111
DESC_LIMIT_DATA2     equ DESC_LIMIT_CODE2
DESC_LIMIT_VIDEO2    equ 0000_0000000000000000b
DESC_P               equ 1_000000000000000b
DESC_DPL_0           equ 00_0000000000000b
DESC_DPL_1           equ 01_0000000000000b
DESC_DPL_2           equ 10_0000000000000b
DESC_DPL_3           equ 11_0000000000000b
DESC_S_CODE          equ 1_000000000000b
DESC_S_DATA          equ DESC_S_CODE
DESC_S_SYS           equ 0_000000000000b
DESC_TYPE_CODE       equ 1000_00000000b             ; x=1, c=0, r=0, a=0
DESC_TYPE_DATA       equ 0010_00000000b             ; x=0, e=0, w=1, a=0
DESC_BASE_ADDR_16_23 equ 0x00
DESC_CODE_HIGH4   equ (0x00 << 24) + DESC_G_4K + DESC_D_32 + \
                                    DESC_L + DESC_AVL + DESC_LIMIT_CODE2 \
                                    + DESC_P + DESC_DPL_0 + DESC_S_CODE \
                                    + DESC_TYPE_CODE + DESC_BASE_ADDR_16_23

DESC_DATA_HIGH4   equ (0x00 << 24) + DESC_G_4K + DESC_D_32 + \
                                    DESC_L + DESC_AVL + DESC_LIMIT_DATA2 \
                                    + DESC_P + DESC_DPL_0 + DESC_S_DATA \
                                    + DESC_TYPE_DATA + DESC_BASE_ADDR_16_23

DESC_VIDEO_HIGH4   equ (0x00 << 24) + DESC_G_4K + DESC_D_32 + \
                                    DESC_L + DESC_AVL + DESC_LIMIT_VIDEO2 \
                                    + DESC_P + DESC_DPL_0 + DESC_S_DATA \
                                    + DESC_TYPE_DATA + DESC_BASE_ADDR_16_23

; =============     Selector fields     =============
;   15                                 3     2        0
;   +-------------------------------------------------+
;   |                                  |     |        |
;   |              INDEX               | TI  |   RPL  |
;   |                                  |     |        |
;   +-------------------------------------------------+

RPL0   equ 00b
RPL1   equ 01b
RPL2   equ 10b
RPL3   equ 11b
TI_GDT equ 000b
TI_LDT equ 100b


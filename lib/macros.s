; macros.s — Common 65816 macros for SNES development
; Verified against Gargoyles Quest (GG_MAIN.658) and Harvest Moon (bank_80.asm)

; ============================================================================
; CPU Mode Switching
; ca65 needs .a8/.a16/.i8/.i16 directives to track register width
; ============================================================================

.p816                       ; Enable 65816 instruction set

.macro SET_A8
    sep #$20            ; Set M flag — accumulator 8-bit
    .a8
.endmacro

.macro SET_A16
    rep #$20            ; Clear M flag — accumulator 16-bit
    .a16
.endmacro

.macro SET_XY8
    sep #$10            ; Set X flag — index registers 8-bit
    .i8
.endmacro

.macro SET_XY16
    rep #$10            ; Clear X flag — index registers 16-bit
    .i16
.endmacro

.macro SET_AXY16
    rep #$30            ; Clear M+X flags — all registers 16-bit
    .a16
    .i16
.endmacro

.macro SET_AXY8
    sep #$30            ; Set M+X flags — all registers 8-bit
    .a8
    .i8
.endmacro

; ============================================================================
; PPU Registers ($2100-$213F)
; ============================================================================

INIDISP     = $2100     ; Display control (force blank + brightness)
OBSEL       = $2101     ; Sprite size + base address
OAMADDL     = $2102     ; OAM address low
OAMADDH     = $2103     ; OAM address high
OAMDATA     = $2104     ; OAM data write
BGMODE      = $2105     ; BG mode + tile size
MOSAIC      = $2106     ; Mosaic filter
BG1SC       = $2107     ; BG1 tilemap address + size
BG2SC       = $2108     ; BG2 tilemap address + size
BG3SC       = $2109     ; BG3 tilemap address + size
BG4SC       = $210A     ; BG4 tilemap address + size
BG12NBA     = $210B     ; BG1+BG2 character base address
BG34NBA     = $210C     ; BG3+BG4 character base address
BG1HOFS     = $210D     ; BG1 horizontal scroll (write twice)
BG1VOFS     = $210E     ; BG1 vertical scroll (write twice)
BG2HOFS     = $210F     ; BG2 horizontal scroll
BG2VOFS     = $2110     ; BG2 vertical scroll
BG3HOFS     = $2111     ; BG3 horizontal scroll
BG3VOFS     = $2112     ; BG3 vertical scroll
BG4HOFS     = $2113     ; BG4 horizontal scroll
BG4VOFS     = $2114     ; BG4 vertical scroll
VMAIN       = $2115     ; VRAM address increment mode
VMADDL      = $2116     ; VRAM address low
VMADDH      = $2117     ; VRAM address high
VMDATAL     = $2118     ; VRAM data write low
VMDATAH     = $2119     ; VRAM data write high
M7SEL       = $211A     ; Mode 7 settings
M7A         = $211B     ; Mode 7 matrix A
M7B         = $211C     ; Mode 7 matrix B
M7C         = $211D     ; Mode 7 matrix C
M7D         = $211E     ; Mode 7 matrix D
M7X         = $211F     ; Mode 7 center X
M7Y         = $2120     ; Mode 7 center Y
CGADD       = $2121     ; CGRAM (palette) address
CGDATA      = $2122     ; CGRAM data write
W12SEL      = $2123     ; Window 1/2 mask for BG1/BG2
W34SEL      = $2124     ; Window 1/2 mask for BG3/BG4
WOBJSEL     = $2125     ; Window 1/2 mask for OBJ/color
WH0         = $2126     ; Window 1 left position
WH1         = $2127     ; Window 1 right position
WH2         = $2128     ; Window 2 left position
WH3         = $2129     ; Window 2 right position
WBGLOG      = $212A     ; Window logic for BGs
WOBJLOG     = $212B     ; Window logic for OBJ/color
TM          = $212C     ; Main screen layer enable
TS          = $212D     ; Sub screen layer enable
TMW         = $212E     ; Main screen window mask
TSW         = $212F     ; Sub screen window mask
CGWSEL      = $2130     ; Color math control A
CGADSUB     = $2131     ; Color math control B
COLDATA     = $2132     ; Fixed color data
SETINI      = $2133     ; Screen mode/video select

; ============================================================================
; CPU/DMA Registers ($4200-$437F)
; ============================================================================

NMITIMEN    = $4200     ; NMI/IRQ/joypad enable
WRIO        = $4201     ; Programmable I/O port (output)
WRMPYA      = $4202     ; Multiplicand A
WRMPYB      = $4203     ; Multiplicand B
WRDIVL      = $4204     ; Dividend low
WRDIVH      = $4205     ; Dividend high
WRDIVB      = $4206     ; Divisor
HTIMEL      = $4207     ; H-count timer low
HTIMEH      = $4208     ; H-count timer high
VTIMEL      = $4209     ; V-count timer low
VTIMEH      = $420A     ; V-count timer high
MDMAEN      = $420B     ; General DMA enable
HDMAEN      = $420C     ; HDMA enable
MEMSEL      = $420D     ; FastROM enable

; Read-only status registers
RDNMI       = $4210     ; NMI flag + CPU version
TIMEUP      = $4211     ; IRQ flag
HVBJOY      = $4212     ; H/V blank + joypad status

; Joypad registers
JOY1L       = $4218     ; Joypad 1 low byte
JOY1H       = $4219     ; Joypad 1 high byte
JOY2L       = $421A     ; Joypad 2 low byte
JOY2H       = $421B     ; Joypad 2 high byte

; DMA channel 0 registers
DMAP0       = $4300     ; DMA control
BBAD0       = $4301     ; DMA destination (B-bus address)
A1T0L       = $4302     ; DMA source address low
A1T0H       = $4303     ; DMA source address high
A1B0        = $4304     ; DMA source bank
DAS0L       = $4305     ; DMA size low
DAS0H       = $4306     ; DMA size high

 #define userMem $D1A881
.assume ADL = 1
.org userMem - 2
.db $EF, $7B
#include "icon.asm"

_START:
	di
	im	1
	;clear VRAM
	ld	hl, VRAM
	ld	de, VRAM+1
	ld	bc, VRAMEnd-VRAM
	ld	(hl), $00
	ldir

	;clear emulated memory map location
	ld	hl, romStart
	ld	de, romStart+1
	ld	bc, $FFFF
	ld	(hl), $00
	ldir

	;set up 8bpp mode with Vcomp interrupts
	ld	hl, mpLcdCtrl
	ld	(hl), $27
	inc	hl
	ld	(hl), %00011001
	;set up front porch interrupt
	ld	hl, mpLcdImsc
	set	3, (hl)
	ld	hl, mpLcdIcr
	set	3, (hl)
	ld	hl, $F00004
	ld	(hl), $00
	inc	hl
	ld	(hl), $08

	;load palettes into RAM
	ld	hl, Palettes
	ld	de, $D2E100
	ld	bc, Palette_End-Palettes
	ldir
	;load engine into RAM
	ld	hl, Sonic2_Engine
	call	Mov9ToOP1
	call	ChkFindSym
	ex	de, hl
	ld	bc, 16
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	inc	hl
	ld	de, romStart
	ldir
	ld	a, $D2
	ld	mb, a
	;set the SMS stack
	ld.s	sp, $DFF0
	jp.s	romStart	;start of program

#include "includes/ti_equates.asm"

Sonic2_Engine:
	.db AppVarObj, "Sonic2", 0

Palettes:
#include "includes\palettes.asm"
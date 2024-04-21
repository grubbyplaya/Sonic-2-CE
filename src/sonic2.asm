 #define userMem $D1A881
.assume ADL = 1
.org userMem - 2
.db $EF, $7B
#include "icon.asm"

_START:
	di
	im	1

	;clear palette
	ld	hl, mpLcdPalette
	ld	de, mpLcdPalette+1
	ld	bc, $0100
	ld	(hl), $00
	ldir

	;set up 4bpp mode with Vcomp interrupts
	ld	hl, mpLcdCtrl
	ld	(hl), $23
	inc	hl
	ld	(hl), %00011101

	;set up front porch interrupt
	ld	hl, mpLcdImsc
	set	3, (hl)
	ld	hl, mpLcdIcr
	set	3, (hl)

	ld	hl, $F50000
	ld	(hl), 3

	call	SegaLogo

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

	;set up LCD interrupts
	ld	hl, $F00004
	ld	(hl), $00
	inc	hl
	ld	(hl), $08

	;clear some space for the tile cache
	ld	hl, SegaTileCache
	ld	de, SegaTileCache+1
	ld	bc, $7E00
	ld	(hl), $00
	ldir

	;load collision into RAM
	ld	hl, Coliision
	ld	de, $D2E000
	ld	bc, CollisionSize
	ldir

	;load palettes into RAM
	ld	hl, Palettes
	ld	de, $D2E000+CollisionSize
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

	;load ROM banks 28, 30, and 31
	ld	hl, Bank28
	ld	de, pixelShadow+$4000
	call	LoadBank

	ld	hl, Bank30
	ld	de, pixelShadow+$8000
	call	LoadBank

	ld	hl, Bank31
	ld	de, pixelShadow+$C000
	call	LoadBank

	ld	a, $D2
	ld	mb, a
	ld	($D2DE02), sp
	ld.lil	sp, $D1A745
	ld.sis	sp, $DFF0
	jp.sis	$0000	;start of program

LoadBank:
	push	de
	call	Mov9ToOP1
 	call	ChkFindSym
	ex	de, hl			;point HL to appvar
	pop	de
	ld	bc, 16
	add	hl, bc			;offset HL into actual data
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	inc	hl
	ldir				;copy appvar to bank slot
	ret

#include "sega_logo.asm"

#include "includes/ti_equates.asm"

Palettes:
#include "includes\palettes.asm"

Sonic2_Engine:
	.db AppVarObj, "Sonic2", 0

Bank28:
	.db	AppVarObj, "Bank28", 0

Bank30:
	.db	AppVarObj, "Bank30", 0

Bank31:
	.db	AppVarObj, "Bank31", 0

#define CollisionSize	Collision_End-Cllsn_Data_CollisionHeaders

Coliision:
.ORG $E000
#include "collision_data.asm"
Collision_End:

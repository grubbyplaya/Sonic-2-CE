
 #define userMem $D1A881
.assume ADL = 1
.org userMem - 2
.db $EF, $7B

	di
	ld	hl, $D40000
	ld	de, $D40001
	ld	bc, $025000
	ld	(hl), $00
	ldir
	ld	a, $27
	ld	($E30018), a
	ld	a, %00011001
	ld	($E30019), a
	ld	bc, $1020
	ld	de, Sonic_Palette
	exx
	ld	de, $E30200
	exx
_:	push	bc
	push	de
	ld	a, (de)
	ld	l, a
	ld	h, $02
	mlt	hl
	ld	bc, SMS_Palette
	add	hl, bc
	push	hl
	exx
	pop	hl
	ldi
	ldi
	exx
	pop	de
	inc	de
	pop	bc
	djnz	-_
	ld	hl, Sonic_Tile_1
	ld	de, $D40000
	call	DrawTile
	ld	hl, Sonic_Tile_2
	ld	de, $D40008
	call	DrawTile
_:	ld	hl, $F50012
	bit	5, (hl)
	jr	z, -_
	ei
	ld	a, $2D
	ld	($E30018), a
	ld	a, $01
	ld	($E30019), a
	ret	

DrawTile:
	ld	c, $20
	ld	($D0D4F0), de

_:	ld	a, (hl)		;BC points to the palette
	ld	mb, a		;save byte
	and	%00001111	;remove bits 4-7
	jr	z, +_
	ld	(de), a		;draw pixel
_:	inc	de
	
	ld	a, mb		;get back the byte
	and	%11110000	;remove bits 0-3
	jr	z, +_
	rlca			;offset result into bits 0-3
	rlca
	rlca
	rlca
	ld	(de), a		;load it onto the screen
_:	inc	hl
	inc	de

	dec	c
	push	af
	ld	a, c
	and	%00100011
	call	z, SwitchLine
	pop	af
	jr	nz, ---_
	ret

SwitchLine:
	exx
	ld	hl, ($D0D4F0)
	ld	de, 320
	add	hl, de
	ld	($D0D4F0), hl
	push	hl
	exx
	pop	de
	ret

Sonic_Palette:
	#import "palettes/palette_alz2_sonic_gg.bin"
Sonic_Tile_1:
	.db $22, $22, $22, $75
	.db $11, $22, $22, $75
	.db $11, $22, $22, $75
	.db $11, $21, $41, $74
	.db $22, $11, $34, $43
	.db $11, $11, $34, $33
	.db $11, $11, $41, $43
	.db $11, $11, $11, $54
Sonic_Tile_2:
	.db $67, $01, $00, $00
	.db $67, $01, $00, $00
	.db $67, $67, $06, $00
	.db $67, $64, $06, $00
	.db $44, $63, $00, $00
	.db $43, $04, $00, $00
	.db $55, $00, $00, $00
	.db $77, $05, $00, $00
SMS_Palette:
	#include "sms_palette.asm"
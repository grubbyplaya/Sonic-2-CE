
 #define userMem $D1A881
.assume ADL = 1
.org userMem - 2
.db $EF, $7B
	di
	ld	a, $27
	ld	($E30018), a
	ld	a, %00011001
	ld	($E30019), a
	ld	hl, $D40000
	ld	de, $D40001
	ld	bc, $025000
	xor	a
	ld	(hl), a
	ldir
	ld	hl, Palette
	ld	de, $E30200
	ld	bc, $80
	ldir
	ld	b, $80
	ld	a, $00
	ld	hl, $D40000
	ld	de, $D40001
_:	push	bc
	ld	bc, 640
	ld	(hl), a
	ldir
	inc	a
	pop	bc
	djnz	-_
_:	ld	hl, $F50012
	bit	5, (hl)
	jr	z, -_
	ei
	ld	a, $2D
	ld	($E30018), a
	ld	a, $09
	ld	($E30019), a
	ret	

Palette:
#include "sms_palette.asm"
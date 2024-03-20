;SEGA logo routines
SegaLogo:
	;clear screen
	ld	hl, VRAM
	ld	de, VRAM+1
	ld	bc, VRAMEnd-VRAM
	ld	(hl), $FF
	ldir

	;load SEGA logo
	ld	a, 58
	ld	hl, LogoArt
	ld	de, $D41C81
_:	ld	bc, 46
	ldir
	ex	de, hl
	ld	bc, 34
	add	hl, bc
	ex	de, hl
	dec	a
	jr	nz, -_

	ld	b, 0
	ld	a, b
_:	inc	b
	cpl
	and	$03
	call	FadePalette
	ld	a, b
	cp	4
	jr	nz, -_

	ld	b, 127
_:	call	WaitAFrame
	djnz	-_
	ld	b, 0
	ld	a, b
_:	call	FadePalette
	inc	b
	ld	a, b
	cp	4
	jr	nz, -_
	ld	hl, mpLcdPalette
	ld	de, mpLcdPalette+1
	ld	bc, 8
	ld	(hl), $00
	ldir

	;set up 8bpp mode with Vcomp interrupts
	ld	hl, mpLcdCtrl
	ld	(hl), $27
	inc	hl
	ld	(hl), %00011001
	ret

FadePalette:		;fades the palette in and out
	push	af
	ld	c, 4
_:	call	WaitAFrame
	dec	c
	jr	nz, -_
	pop	af
	exx
	ld	l, a
	ld	h, 8
	mlt	hl
	ld	de, LogoPalette
	add	hl, de
	ld	de, mpLcdPalette
	ld	bc, 8
	ldir
	exx
	ret

WaitAFrame:
	ld	hl, mpLcdRis
	ld	a, (hl)
	bit	3, a
	jr	z, WaitAFrame
	ld	hl, mpLcdIcr
	set	3, (hl)
	ret

LogoArt:
#import "misc/sega_logo.bin"

LogoPalette:
.dw $81BF, $36DF, $CB5F, $FFFF	;brightness level 4
.dw $80CF, $1D6F, $A5AF, $BDEF	;brightness level 3
.dw $8068, $8CA8, $90C8, $2108	;brightness level 2
.dw $8024, $8844, $8864, $1084	;brightness level 1
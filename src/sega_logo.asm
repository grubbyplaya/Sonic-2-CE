;SEGA logo routines
SegaLogo:
	call	StatusScroll

	;set up 4bpp mode with Vcomp interrupts
	ld	hl, mpLcdCtrl
	ld	(hl), $23
	inc	hl
	ld	(hl), %00011101

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
	call	WaitSomeFrames
	ld	b, 4
	ld	a, b
_:	call	FadePalette
	inc	b
	ld	a, b
	cp	8
	jr	nz, -_
	ld	hl, mpLcdPalette
	ld	de, mpLcdPalette+1
	ld	bc, 8
	ld	(hl), $00
	ldir
	ret

FadePalette:		;fades the palette in and out
	exx
	ld	b, 4
	call	WaitSomeFrames
	ld	l, a
	ld	h, 8
	mlt	hl
	ld	de, LightPalette
	add	hl, de
	ld	de, mpLcdPalette
	ld	bc, 8
	ldir
	exx
	ret

WaitSomeFrames:
	call	WaitAFrame
	djnz	WaitSomeFrames
	ret

WaitAFrame:
	ld	hl, mpLcdRis
	bit	3, (hl)
	jr	z, WaitAFrame
	ld	hl, mpLcdIcr
	set	3, (hl)
	ret

StatusScroll:
	call	ClrLCDFull
	ld	hl, mpLcdPalette
	ld	de, mpLcdPalette+1
	ld	bc, 8
	ld	(hl), $FF
	ldir

	ld	b, 15
_:	push	bc
	ld	de, VRAM
	ld	hl, VRAM + (LcdWidth*4)
	ld	bc, lcdWidth*98
	ldir
	pop	bc
	call	WaitAFrame
	djnz	-_
	ret

LogoArt:
#import "misc/sega_logo.bin"

LightPalette:
.dw $81BF, $36DF, $CB5F, $FFFF	;brightness level 4
.dw $C2DF, $5B7F, $63BF, $FFFF	;brightness level 3
.dw $5F7F, $EFBF, $F3DF, $FFFF	;brightness level 2
.dw $EFBF, $F7DF, $77FF, $FFFF	;brightness level 1

DarkPalette:
.dw $81BF, $36DF, $CB5F, $FFFF	;darkness level 4
.dw $80CF, $1D6F, $A5AF, $BDEF	;darkness level 3
.dw $8068, $8CA8, $90C8, $2108	;darkness level 2
.dw $8024, $8844, $8864, $1084	;darkness level 1
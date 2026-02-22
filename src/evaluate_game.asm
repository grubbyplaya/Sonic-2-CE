EvaluateGame:
	di
	call	SetDefaultSPI

	ld	hl, EndBG
	ld	de, VRAM
	call	DecompressZX0

	ld	hl, EndPal
	ld	de, mpLcdPalette
	ld	bc, 46
	ldir

	call	DrawLevelTime
	call	DrawTotalTime
	call	DrawEmeralds
	ld	hl, kbdG1
_:	bit	kbit2nd, (hl)
	jr	z, -_

	ld	sp, ($D2DE02)		;reset SP
	pop	iy
	pop	iy
	jp	SetupGame		;reset game


DrawLevelTime:
	ld	hl, WhiteNumbers
	ld	(TextColor+1), hl

	ld	b, 7
	ld	c, 0
	ld	ix, LevelTimerTable+romStart

_:	push	bc
	ld	l, c
	ld	h, 3
	mlt	hl
	ld	de, TextCoords
	add	hl, de
	ld	de, 0

	ld	hl, (hl)
	ld	b, 3
_:	push	bc
	push	hl
	ld	a, (ix+1)
	call	PTRToDoubleDigits
	pop	hl

	push	hl
	ld	de, 24
	add	hl, de
	ld	a, (ix)
	call	PTRToDoubleDigits
	pop	hl

	ld	de, 320*8
	add	hl, de
	lea	ix, ix+2
	pop	bc
	djnz	-_

	pop	bc
	inc	c
	djnz	--_
	ret

PTRToDoubleDigits:
	ld	(DoubleDigitCoords), hl
	push	hl
	call	DrawDoubleDigits
	pop	hl
	ld	de, 8
	add	hl, de
	ret

DrawTotalTime:
	ld	hl, YellowNumbers
	ld	(TextColor+1), hl

	ld	ix, LevelTimerTable + romStart
	xor	a
	ld	b, 21	;number of levels
	;tally minutes
_:	add	a, (ix+1)
	lea	ix, ix+2
	djnz	-_

	;tally hours
_:	inc	b
	sub	a, 60
	jr	nc, -_
	dec	b
	add	a, 60	;A = total minutes

	ex	af, af'
	ld	l, b
	ld	a, b
	or	a
	jr	z, +_
	call	CalcTextPTR

	ld	de, $D45374 - 20
	ld	bc, $0808
	call	DrawArt

_:	ld	ix, LevelTimerTable + romStart
	push	ix
	ld	hl, ReverseBCD
	ld	de, 0
	ld	b, 21
_:	push	hl
	ld	a, (ix)
	cp	$10
	jr	c, +_
	sub	$10
	ld	e, a
	add	hl, de
	ld	a, (hl)
_:	ld	(ix), a
	lea	ix, ix+2
	pop	hl
	djnz	--_

	pop	ix
	ld	e, 0
	ld	hl, 0
	ld	b, 21
_:	ld	e, (ix)
	add	hl, de
	lea	ix, ix+2
	djnz	-_

	ex	af, af'
_:	inc	a
	ld	de, 60
	or	a
	sbc	hl, de
	jr	nc, -_
	dec	a
	add	hl, de

	;draw minutes onto screen
	push	hl
	call	HexToBCD
	ld	hl, $D4536C
	ld	(DoubleDigitCoords), hl
	call	DrawDoubleDigits
	pop	hl
	ld	a, l
	call	HexToBCD
	ld	hl, $D45385
	ld	(DoubleDigitCoords), hl
	call	DrawDoubleDigits
	ret

HexToBCD:
	ld	hl, ProperBCD
	cp	$10
	jr	c, +_
	sub	a, $10
	ld	de, 0
	ld	e, a
	add	hl, de
	ld	a, (hl)
	ret

_:	or	a
	daa
	ret

CalcTextPTR:
	ld	h, 64
	mlt	hl
TextColor:
	ld	de, YellowNumbers
	add	hl, de
	ret

DrawDoubleDigits:
	push	af
	and	$F0
	rrca
	rrca
	rrca
	rrca
	ld	l, a
	call	CalcTextPTR

	ld	de, (DoubleDigitCoords)
	ld	bc, $0808
	call	DrawArt

	pop	af
	and	$0F
	ld	l, a
	call	CalcTextPTR

	ld	de, (DoubleDigitCoords)
	ex	de, hl
	ld	bc, 8
	add	hl, bc
	ex	de, hl

	ld	bc, $0808
	call	DrawArt
	ret

DoubleDigitCoords:
	.dl 0

DrawEmeralds:
	ld	a, ($D2D2C5)
	ld	b, 6

_:	push	bc
	ld	hl, BlankEmerald
	or	a
	rra
	push	af
	jr	nc, +_

	ld	l, b
	ld	h, 3
	mlt	hl
	ld	de, EmeraldTable
	add	hl, de
	ld	hl, (hl)

_:	ld	e, b
	ld	d, 3
	mlt	de
	ex	de, hl
	ld	bc, EmeraldCoords
	add	hl, bc
	ld	hl, (hl)
	ex	de, hl

	mlt	bc
	ld	c, 22
	ld	b, 16
	call	DrawArt
	pop	af
	pop	bc
	djnz	--_
	ret

DrawArt:
	ld	a, b
DrawArtLoop:
	push	bc
	push	af
	ld	a, c

	push	hl
	ld	hl, lcdWidth
	ld	b, 0
	or	a
	sbc	hl, bc
	push	hl
	pop	bc
	pop	hl

DrawArtRow:
	push	af
	ld	a, (hl)
	cp	4
	jr	z, +_
	ld	(de), a
_:	inc	hl
	inc	de
	pop	af
	dec	a
	jr	nz, DrawArtRow
	ex	de, hl
	add	hl, bc
	ex	de, hl
	pop	af
	pop	bc
	dec	a
	jr	nz, DrawArtLoop
	ret

#include "src/includes/dzx0_fast.asm"

EndBG:
#import "src/misc/EndBG.bin"

EndPal:
#import "src/misc/EndPal.bin"

EmeraldTable:
.dl	BlankEmerald
.dl	EmeraldGreen
.dl	EmeraldRed
.dl	EmeraldGrey
.dl	EmeraldPink
.dl	EmeraldYellow
.dl	EmeraldBlue

TextCoords:
.dl	$D42AD4
.dl	$D452D4
.dl	$D47AD4
.dl	$D4A2D4
.dl	$D4CAD4
.dl	$D4F2D4
.dl	$D42B6C

EmeraldCoords:
.dl	$D40000
.dl	$D50C5A
.dl	$D50C3F
.dl	$D50C24
.dl	$D4F35A
.dl	$D4F33F
.dl	$D4F324

EmeraldBlue:
#import "src/misc/Emeralds/EmeraldBlue.bin"
EmeraldYellow:
#import "src/misc/Emeralds/EmeraldYellow.bin"
EmeraldPink:
#import "src/misc/Emeralds/EmeraldPink.bin"
EmeraldGrey:
#import "src/misc/Emeralds/EmeraldGrey.bin"
EmeraldRed:
#import "src/misc/Emeralds/EmeraldRed.bin"
EmeraldGreen:
#import "src/misc/Emeralds/EmeraldGreen.bin"
BlankEmerald:
#import "src/misc/Emeralds/EmeraldBlank.bin"

ProperBCD:
.db $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29
.db $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $40, $41, $42, $43
.db $44, $45, $46, $47, $48, $49, $50, $51, $52, $53, $54, $55, $56, $57
.db $58, $59

ReverseBCD:
.db 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 0, 0, 0, 0, 0, 0
.db 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 0, 0, 0, 0, 0, 0
.db 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 0, 0, 0, 0, 0, 0
.db 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 0, 0, 0, 0, 0, 0
.db 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 0, 0, 0, 0, 0, 0
.db 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 0, 0, 0, 0, 0, 0
.db 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 0, 0, 0, 0, 0, 0
.db 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 0, 0, 0, 0, 0, 0
.db 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 0, 0, 0, 0, 0, 0


#include "src/misc/font.asm"

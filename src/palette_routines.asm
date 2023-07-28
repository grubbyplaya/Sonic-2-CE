#define gameMem cmdPixelShadow-$C000

;Variables used by palette control/update routines

#define PaletteFadeTime		gameMem+$D2C8	;TODO: Check this one
#define BgPaletteControl	gameMem+$D4E6	;Triggers background palette fades (bit 6 = to black, bit 7 = to colour).
#define BgPaletteIndex		gameMem+$D4E7	;Current background palette (index into array of palettes)
#define FgPaletteControl	gameMem+$D4E8	;Triggers foreground palette fades (bit 6 = to black, bit 7 = to colour).
#define FgPaletteIndex		gameMem+$D4E9	;Current foreground palette (index into array of palettes)
#define WorkingCRAM		$E30220		;copy of Colour RAM maintained in work RAM.
#define Palette_UpdateTrig	gameMem+$D4EA	; causes a CRAM update with the next vblank

Palette_Update:
	ld	hl, gameMem+$D2C9		;counter for smooth fade
	inc	(hl)
	ld	a, (gameMem+$D2C8)	;palette fade timeout value (will fade when counter = timeout value)
	cp	(hl)
	ret	nc
	ld	(hl), $00
	ld	ix, BgPaletteControl
	ld	iy, WorkingCRAM
	ld	b, $02
_:	push	bc
	push	iy
	ld	a, (ix+$00)
	or	a
	jr	z, +_
	call	Palette_UpdateColours
	ld	a, $FF
	ld	(Palette_UpdateTrig), a
_:	ld	de, $0002	;check FgPaletteControl
	add	ix, de
	pop	iy
	ld	de, $0010
	add	iy, de
	pop	bc
	djnz	--_
	ret

Palette_UpdateColours:	
	bit	7, a	;check for fade to colour
	jr	nz, Palette_FadeToColour
	bit	6, a	;check for fade to black
	jp	nz, Palette_FadeToBlack
	bit	5, a	;reset to indexed palette
	jr	nz, Palette_Reset
	ret

Palette_Reset:		;$8044
_:	call	Palette_CalculateOffset
	push	iy
	pop	de
	ld	bc, $0010
	ldir	
	ld	(ix+$00), $00	;reset the palette control byte
	ret

Palette_FadeToColour:	;$8054
	call	Palette_CalculateOffset
	ld	b, $10
_:	push	bc
	ld	a, (ix+$00)
	and	$03
	ld	c, a
	ld	a, (hl)
	and	$03
	xor	$03
	ld	b, a
	ld	a, c
	sub	b
	jr	nc, +_
	xor	a
_:	and	$03
	ld	(iy+$00), a
	ld	a, (hl)
	and	$0C
	xor	$0C
	rrca	
	rrca	
	ld	b, a
	ld	a, c
	sub	b
	jr	nc, +_
	xor	a
_:	rlca	
	rlca	
	and	$0c
	or	(iy+$00)
	ld	(iy+$00), a
	ld	a, (hl)
	and	$30
	xor	$30
	rrca	
	rrca	
	rrca	
	rrca	
	ld	b, a
	ld	a, c
	sub	b
	jr	nc, +_
	xor	a
_:	rlca	
	rlca	
	rlca	
	rlca	
	and	$30
	or	(iy+$00)
	ld	(iy+$00), a
	inc	iy
	inc	hl
	pop	bc
	djnz	----_
	inc	(ix+$00)
	ld	a, (ix+$00)
	and	$07
	cp	$04
	ret	nz
	ld	(ix+$00), $00
	ret

Palette_FadeToBlack:	;80B8
	call	Palette_CalculateOffset	;get a pointer to the palette into HL
	ld	b, $10		;loop over all 16 colours
	ld	a, (iy+$00)	
	and	$3C		;keep hold of R and G components
	ld	c, a
	ld	a, (iy+$00)
	and	$03		;get the B component
	jr	z, +_
	sub	$01		;fade the B component
	and	$03
	or	c		;recombine with the R and G components
_:	ld	(iy+$00), a	;store updated colour
	ld	a, (iy+$00)
	and	$33		;keep hold of the R and B components
	ld	c, a
	ld	a, (iy+$00)
	and	$0C
	jr	z, +_
	sub	$04		;fade the G component
	and	$0C
	or	c		;recombine with the R and B components
	ld	(iy+$00), a	;store updated colour
_:	ld	a, (iy+$00)
	and	$0F		;keep hold of the G and B 
	ld	c, a
	ld	a, (iy+$00)
	and	$30
	jr	z, +_
	sub	$10		;fade the R component
	and	$30
	or	c		;recombine with the G and B components
	ld	(iy+$00), a	;store updated colour
_:	inc	iy
	djnz	----_		;move to next colour
	inc	(ix+$00)
	ld	a, (ix+$00)
	and	$03
	cp	$03
	ret	nz
	ld	(ix+$00), $00
	ret 

Palette_CalculateOffset:	;$8110
	ld	a, (ix+$01)	;get the palette index number
	ld	l, a		;calculate the offset into the array
	ld	h, $00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, Palettes
	add	hl, de
	ret
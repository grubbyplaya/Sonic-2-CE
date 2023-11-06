.ASSUME ADL=1
;These routines take data from VDP RAM
;and translates them into a usable frame.

;19 KB of VRAM is unused.
;256x224 buffering takes up 56 KB
;The screen itself is 75 KB
;Y Scroll is normal. No need to calculate


DrawScreen:
	di
	call	StoreRegisters
	ld	a, (VDPRegister1)
	bit	6, a
	ret.sis	z
	
	;start drawing the SAT
	ld.sis	a, (DrawSATTrig)
	or	a
	call	z, DrawSAT			;right now, let's only draw the sprites,
	ld	hl, RenderedScreenMap	;since tilemap drawing has a lot more math.
	ld	de, VRAM+$1E20
	ld	bc, $0100
_:	push	bc
	ld	bc, $0100
	ldir

	ld	ix, $0040
	add	ix, de
	push	ix
	pop	de
	pop	bc
	dec	bc
	ld	a, b
	or	c
	jr	nz, -_

	ld.sis	(DrawSATTrig), a
	ld.sis	(DrawTilemapTrig), a
	ei
	jp.sis	RestoreRegisters

RenderScreenMap:
	ld.s	a, (DrawTilemapTrig)
	or	a
	call	z, DrawScreenMap	;set up double buffering
	ld	iyl, 192		;length of SMS screen

	ld	hl, RenderedScreenMap
	ld	de, VRAM+$1E20		;first pixel within letterbox
	ld	bc, 0
	ld	a, (VDP_VScroll)
	cp	$D4			;Y scroll < !$2C?
	jr	c, +_
	
_:	add	a, h			;the higher the Y scroll register is,
	ld	h, a			;the lower the screen goes
_:	ld	a, (VDP_HScroll)
	neg				;the higher the X scroll register is,
	ld	l, a			;the farther left the screen goes
	ld	c, a
	ldir				;copy left half of the scanline
	dec	hl

	neg				;calculate remainder
	ld	c, a
	ld	l, 0
	ldir				;copy right half of scanline
	
	inc	h
	ld	l, 0
	push	de
	ld	de, SegaVRAM		;overflow into VDP RAM?
	call	CpHLDE			;loop to the start of screen map if true
	jr	nc, +_
	ld	hl, RenderedScreenMap
_:	pop	de
	
	ld	ix, $0040		;go to next scanline
	add	hl, de
	push	ix
	pop	de
	
	dec	iyl
	jr	nz, --_
	ret

ClearScreen:
	ld	hl, VRAM
	ld	de, VRAM+1
	ld	bc, 320*240
	ld	(hl), $00	;palette index #32 is always black
	ldir
	ret

DrawScreenMap:
	ld	hl, RenderedScreenMap	;fills the framebuffer with background color 0
	ld	de, RenderedScreenMap+1
	ld	bc, SegaVRAM-RenderedScreenMap
	ld	(hl), $00
	ldir

	ld	hl, SegaVRAM+ScreenMap
	ld	bc, 32*28
	xor	a
	ld	ixh, a	;x position of tile (in tiles)
	ld	ixl, a	;y position (in tiles)

_:	xor	a
	inc	hl
	bit	3, (hl)		;check for palette flag
	jr	z, +_		;copy to A
	ld	a, $10
_:	exx
	ld	d, a
	exx
	call	GetTilePointer
	call	GetTileCoordinates
	call	ConvertTileTo8bpp

	;reset self-modifying code
	ld	a, $13			;INC DE
	ld.sis	(DrawPixel), a
	ld	de, $0019		;ADD HL, DE \ NOP
	ld.sis	(MoveToNextLine), de
	ld	de, 312
	ld.sis	(SetScanlineSkip+1), de

	inc	hl
	ld	a, 31
	cp	ixh
	jr	z, +_
	inc	ixh

	dec	bc
	ld	a, b
	or	c
	jr	nz, --_
	ret

_:	ld	ixh, $00
	ld	a, 27
	cp	ixl
	ret	z	;return if IXL is at the last row
	inc	ixl
	jr	---_

GetTilePointer:		;makes DE a pointer to the selected tile
	dec	hl
	ld	a, (hl)
	push	hl
	ld	h, $20
	ld	l, a
	mlt	hl

	ld	de, SegaVRAM+$2000
	add	hl, de
	ex	de, hl
	pop	hl
	inc	hl
	ret
	
GetTileCoordinates:
	exx
	ld	l, $08
	ld	a, ixl
	ld	h, a
	mlt	hl	;HL has the Y coordinate

	ld	e, $08
	ld	a, ixh
	ld	d, a
	mlt	de	;DE has the X coordinate
	
	ld	h, l
	ld	l, e
	ld	de, RenderedScreenMap
	add	hl, de
	push	hl	;DE has the tile's coordinate
	exx
	pop	de
	ld	a, (hl)
	and	$06	;do we have to flip the tile?
	ret	z	;return if we don't

	exx
	bit	1, a	;do we flip it horizontally?
	jr	z, +_	;jump if we don't
	ld	bc, $0008
	add	hl, bc
	push	af

	;since we're drawing the tile backwards, we
	;switch out the INC DE in the tile drawing
	;routines for a DEC DE.
	ld	a, $1B
	ld.sis	(DrawPixel), a
	ld	bc, 264
	ld.sis	(SetScanlineSkip+1), bc
	pop	af
_:	bit	2, a	;do we flip it vertically?
	jr	z, +_	;return if we don't
	ld	bc, $0700
	or	a
	sbc	hl, bc

	;switch out ADD HL, DE with SBC HL, DE
	ld	bc, $52ED
	ld.sis	(MoveToNextLine), bc
	cp	$06
	jr	z, +_
	ld	bc, 312
	ld.sis	(SetScanlineSkip+1), bc
_:	push	hl
	exx
	pop	de
	ret

DrawSAT:
	ld	iy, SAT		;y position
	ld	ix, SAT+$80	;x position
	ld	b, $40		;number of SAT entries
	exx
	ld	d, $10
	exx
_:	ld	h, (iy)
	ld	a, 208
	cp	h		;is the sprite's Y position 208?
	ret	z		;stop rendering SAT if so
	ld	l, 160
	mlt	hl
	add	hl, hl		;HL now has the scanline to start on
	ld	de, $0020
	add	hl, de		;move into the letterbox
	ld	e, (ix)
	add	hl, de
	inc	ix		;IX now has the tile to draw
	inc	iy		;IY has the next loop's Y position	
	ld	de, VRAM+$1E00	;first scanline to be updated
	add	hl, de
	push	hl		;HL now points to the tile's top-left corner

	ld	h, $20		;size of tile
	ld	l, (ix)
	mlt	hl
	inc	ix
	ld	de, SegaVRAM
	add	hl, de		;HL now points to the specified tile
	nop
	pop	de		;DE has the tile's coordinates
	call	ConvertTileTo8bpp
	djnz	-_
	ret

; =============================================================================
;	In:
;	HL	- Pointer to pattern.
;	DE	- Position of tile.
;	D'	- Palette type flag. (0 = BG, !0 = FG)
;	ld:
;	None.
;	Destroys:
;	A, C, DE, HL
; -----------------------------------------------------------------------------

ConvertTileTo8bpp:
	ld	c, $08
_:	call	ConvertPixelRow
	inc	hl
	inc	hl
	push	hl
	ex	de, hl
SetScanlineSkip:
	ld	de, 248
	ld	a, iyh		;are we drawing the SAT?
	or	a		;jump if we aren't
	jr	z, SetScanlineSkip
	ld	de, lcdWidth-8
MoveToNextLine:
	add	hl, de
	ex	de, hl
	pop	hl
	dec	c
	jr	nz, -_
	ret
	

ConvertPixelRow:		;converts pixels from Sega's stupid format to a nybble
	push	hl
	exx
	pop	hl
	ld	e, $08
	ld	b, (hl)
	inc	hl
	ld	c, (hl)
	inc	hl
	push	hl
	ld	hl, (hl)
_:	xor	a
	rl	h
	rla
	rl	l
	rla
	rl	c
	rla
	rl	b
	rla
	or	d
	exx
	cp	$00
	jr	z, DrawPixel
	ld	(de), a
DrawPixel:
	inc	de
	exx
	dec	e
	jr	nz, -_
	exx
	pop	hl
	ret

SetFGPaletteFlag:
	ex	af, af'	;the Master System has 2 4bpp palettes.
	set	4, a	;the selected palette depends on flags
	ex	af, af'	;independent from the tile data.
	ret
.ASSUME ADL=0
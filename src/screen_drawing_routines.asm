;These routines take data from VDP RAM
;and translates them into a usable frame.

;3 KB of VRAM is unused.
;256x224 buffering takes up 56 KB
;The screen itself is 75 KB
;VDP RAM is 16 kB in size


;Y Scroll is normal. No need to calculate


DrawScreen:
	call	StoreRegisters
	ld	a, (VDPRegister1)
	bit	6, a
	jp	z, ClearScreen
	
	;start drawing the SAT
	call	DrawSAT			;right now, let's only draw the sprites,
	ld	hl, RenderedScreenMap	;since tilemap drawing has a lot more math.
	ld	de, VRAM+$1E20
	ld	bc, $0100
_:	push	bc
	ld	bc, $0100
	ldir

	ld	ix, $0040
	add	hl, de
	push	ix
	pop	de
	pop	bc
	dec	bc
	ld	a, b
	or	c
	jr	nz, -_
		
	ld	a, $D0
	ld	mb, a
	jp	RestoreRegisters

RenderScreenMap:
	call	DrawScreenMap	;set up double buffering
	ld	iyl, 192	;length of SMS screen

	ld	hl, RenderedScreenMap+$010000
	ld	de, VRAM+$1E20	;first pixel within letterbox
	ld	bc, 0
	ld	a, (VDP_VScroll)
	cp	$D4		;Y scroll < ~$2C?
	call	c, SwitchTilemapHalf
	
	add	a, h		;the higher the Y scroll register is,
	ld	h, a		;the lower the screen goes
_:	ld	a, (VDP_HScroll)
	neg			;the higher the X scroll register is,
	ld	l, a		;the farther left the screen goes
	ld	c, a
	ldir			;copy left half of the scanline
	dec	hl

	neg			;calculate remainder
	ld	c, a
	xor	a
	ld	l, a
	ldir			;copy right half of scanline
	
	inc	h
	ld	l, 0
	push	de
	ld	de, SegaVRAM	;overflow into VDP RAM?
	call	_CpHLDE		;loop to the start of screen map if true
	call	z, SwitchTileMapHalf
	pop	de
	
	ld	ix, $0040	;go to next line
	add	hl, de
	push	ix
	pop	de
	
	dec	iyl
	jr	nz, -_
	
	ld	hl, RenderedScreenMap
	ld	de, RenderedScreenMap+1
	ld	bc, SegaVRAM-RenderedScreenMap
	xor	a
	ld	(hl), a
	ldir

SwitchTilemapHalf:
	ld	hl, RenderedScreenMap
	ret

ClearScreen:
	ld	hl, VRAM
	ld	de, VRAM+1
	ld	bc, 320*240
	ld	(hl), $21	;palette index #32 is always black
	ldir
	ret

DrawScreenMap:
	ld	hl, RenderedScreenMap	;fills the framebuffer with background color 0
	ld	de, RenderedScreenMap+1
	ld	bc, SegaVRAM-RenderedScreenMap
	ld	(hl), $00
	ldir

	ld	hl, ScreenMap
	ld	bc, 32*28
	xor	a
	ld	ixh, a	;x position of tile (in tiles)
	ld	ixl, a	;y position (in tiles)

_:	push	bc
	inc	hl
	bit	3, (hl)		;check for palette flag
	jr	z, +_		;jump if it's the BG palette

	call	GetTilePointer
	call	GetTileCoordinates
	ld	a, $FF
	call	ConvertTileTo8bpp
	pop	bc
	jr	++_

_:	call	GetTilePointer
	call	GetTileCoordinates
	xor	a
	call	ConvertTileTo8bpp
	pop	bc

_:	inc	hl
	ld	a, 31
	cp	ixh
	jr	z, +_
	inc	ixh

	dec	bc
	ld	a, b
	or	c
	jr	nz, ---_
	ret

_:	ld	ixh, $00
	ld	a, 27
	cp	ixl
	ret	z	;return if IXL is at the last row
	inc	ixl
	jr	----_

GetTileCoordinates:
	push	hl
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
	ex	de, hl	;DE has the tile's coordinate
	pop	hl	;bring back the tile pointer
	ret

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
	ret
	
DrawSAT:
	ld	iy, SAT		;y position
	ld	ix, SAT+$80	;x position
	ld	b, $40		;number of SAT entries

_:	mlt	hl 		;clear HLU
	ld	h, (iy)
	ld	l, (ix)		;HL now has the sprite's coordinate
	ld	a, 208
	cp	l
	ret	z
	inc	ix		;IX now has the tile to draw
	inc	iy		;IY has the next loop's Y position	
	ld	de, RenderedScreenMap
	add	hl, de
	push	hl

	ld	h, $20		;size of tile
	ld	l, (ix)
	mlt	hl
	inc	ix
	ld	de, SegaVRAM
	add	hl, de		;HL now points to the specified tile
	pop	de		;DE has the tile's coordinates
	xor	a
	cpl
	call	ConvertTileTo8bpp
	djnz	-_
	ret

; =============================================================================
;	In:
;	HL	- Pointer to pattern.
;	DE	- Position of tile.
;	Z	- Palette type flag. (0 = BG, !0 = FG)
;	ld:
;	None.
;	Destroys:
;	A, C, DE, HL
; -----------------------------------------------------------------------------

ConvertTileTo8bpp:
	ld	c, $20
	ex	af, af'
	push	de

_:	ld	a, (hl)		;BC points to the palette
	ld	mb, a		;save byte
	and	%00001111	;remove bits 4-7
	jr	z, ++_
	ex	af, af'
	jr	z, +_		;if 0, use the BG palette
	ex	af, af'
	set	5, a
	ex	af, af'
_:	ex	af, af'
	ld	(de), a		;draw pixel
_:	inc	hl
	inc	de
	
	ld	a, mb		;get back the byte
	and	%11110000	;remove bits 0-3
	jr	z, ++_
	rlca			;offset result into bits 0-3
	rlca
	rlca
	rlca
	ex	af, af'
	jr	z, +_		;if 0, use the BG palette
	ex	af, af'
	set	5, a
	ex	af, af'
_:	ex	af, af'
	ld	(de), a		;load it onto the screen
_:	inc	hl
	inc	de

	ld	a, c
	and	%00100011
	jr	nz, +_		;jump if C isn't a multiple of 4 or if it's 32
	pop	de
	inc	d		;DE points to the tile's next line
	push	de
_:	dec	c
	jr	nz, ----_
	pop	de
	ret

;These routines take data from VDP RAM and translates them into a usable frame.

.ASSUME ADL=0
DrawScreen:
.ORG	DrawScreen+romStart
	;start drawing the tilemap
	ld	a, (DrawTilemapTrig)
	bit	0, a
	call.lil nz, DrawScreenMap
	ld	a, (DrawTilemapTrig)
	bit	1, a
	call.lil nz, RenderScreenMap

	;start drawing the SAT
	ld	a, (DrawSATTrig)
	or	a
	call.lil nz, DrawSAT

	ld	a, (DrawTilemapTrig)
	ld	(LastTilemapTrig), a
	xor	a
	ld	(DrawSATTrig), a
	ld	(DrawTilemapTrig), a
	ret
.ASSUME ADL=1

RenderScreenMap:
	ld	hl, RenderedScreenMap
	ld	de, VRAM+$1E20		;first letter in letterbox
	ld	bc, 0
	ld	iyl, 192		;length of SMS screen
	ld.sis	a, (VDP_VScroll)
	add	a, h			;should HLU increment?
	jr	nc, +_			;jump if not
	ld	hl, SegaVRAM
_:	ld	h, a

	;draw scanline
	ld.sis	a, (VDP_HScroll)
	or	a
	jp	z, RenderScreenMap_NullScroll

_:	ld	c, a
	neg
	ld	l, a
	ldir
	dec	h
	ld	l, 0
	ld	c, a
	ldir
	neg

	;go to next scanline
	ex	de, hl
	ld	c, $40
	add	hl, bc
	ex	de, hl
	inc	h
	ld	l, b

	push	de
	ld	de, SegaVRAM
	call	CpHLDE
	pop	de
	jr	c, +_
	ld	hl, RenderedScreenMap
_:	dec	iyl
	jr	nz, --_
	ret.sis
	
RenderScreenMap_NullScroll:
	ld	bc, $0100
	ldir
	ex	de, hl
	ld	c, $40
	add	hl, bc
	ex	de, hl

	push	de
	ld	de, SegaVRAM
	call	CpHLDE
	pop	de
	jr	c, +_
	ld	hl, RenderedScreenMap
_:	dec	iyl

	jr	nz, RenderScreenMap_NullScroll
	ret.sis

DrawScreenMap:
	xor	a
	ld	ixh, a				;x position of tile (in tiles)
	ld	ixl, a				;y position (in tiles)
	ld	hl, ScreenMap
	ld	bc, 32*28
_:	push	bc
	ld	a, (hl)
	inc	hl
	or	(hl)
	jr	z, +_				;jump if null indice
	ld	a, (hl)
	and	%10000000			;should we draw the tile right now?
	call	z, DrawScreenMap_Tiles

_:	inc	ixh				;update counters
	ld	a, 32
	cp	ixh
	jr	nz, +_
	ld	ixh, $00
	inc	ixl

_:	inc	hl
	pop	bc
	dec	bc
	ld	a, b
	or	c
	jr	nz, ---_
	ret.sis

DrawScreenMap_Tiles:
	set	7, (hl)				;set that flag for future interrupts
	xor	a
	ld	($D2DE06), a			;reset the SAT drawing flag
	ld	c, (hl)
	bit	0, (hl)				;which half of VRAM is the tile on?
	dec	hl
	jr	z, ++_				;don't use cached tiles if said tile is on the first half

	ld	a, (hl)
	ld	de, SegaTileFlags
	ld	e, a				;use tile index as an offset into flags
	ld	a, (de)
	bit	0, a				;is the tile cached?
	jr	nz, DrawCachedTile		;do alternate routine if so

	bit	3, c
	jr	nz, +_				;if we're using the FG palette, don't flag the cached tile
	inc	a
_:	ld	(de), a
	jr	++_

_:	ld	de, 0
	ld	(DrawCachedPixel), de
_:	call	GetTilePointer
	call	GetTileFlags
	call	ConvertTileTo8bpp
	;reset self-modifying code
	ld	a, $13				;INC DE
	ld	(DrawPixel), a
	ld	hl, 248
	ld	(SetScanlineSkip+1), hl
	ld	hl, $0077FD
	ld	(DrawCachedPixel), hl
	ld	hl, ($D2DD00)
	ret

DrawCachedTile:
	push	hl
	call	GetTileCoordinates
	inc	hl
	ld	a, (hl)
	dec	hl
	ld	l, (hl)
	ld	h, $40			;size of converted tile
	mlt	hl
	push	de
	ld	de, SegaTileCache
	add	hl, de			;HL = cached tile ptr
	pop	de

	bit	1, a				;do we flip the tile horizontally?
	jp	nz, DrawCachedTile_FlippedX	;jump if we shouldn't

_:	bit	2, a			;do we flip the tile vertically?
	jr	z, +_			;jump if we shouldn't
	;shift HL and DE to the bottom side of the tile
	ld	bc, $0700
	ex	de, hl
	add	hl, bc
	ex	de, hl
	ld	bc, -264
	ld	(SetCachedTile_DrawingGapY+1), bc

_:	ld	a, $08
_:	ld	bc, $0008		;BC = tile width
	ldir
	ex	de, hl
SetCachedTile_DrawingGapY:
	ld	bc, 248
	add	hl, bc
	ex	de, hl
	dec	a
	jr	nz, -_
	pop	hl
	inc	hl
	set	7, (hl)
	;reset self-modifying code
	ld	bc, 248
	ld	(SetCachedTile_DrawingGapY+1), bc
	ret

DrawCachedTile_FlippedX:
	;shift DE to the right side of the tile
	ld	bc, $0007
	ex	de, hl
	add	hl, bc
	ex	de, hl

	bit	2, a	;is the tile flipped in both directions?
	ld	a, 8
	jr	z, +_	;skip this if it isn't

	ld	bc, $0700
	ex	de, hl
	add	hl, bc
	ex	de, hl
	ld	bc, -248
	ld	(SetCachedTile_DrawingGap+1), bc

_:	ld	c, 8
	ex	af, af'
_:	ld	a, (hl)
	ld	(de), a
	inc	hl
	dec	de
	dec	c
	jr	nz, -_
SetCachedTile_DrawingGap:
	ld	bc, 264
	ex	de, hl
	add	hl, bc
	ex	de, hl
	ex	af, af'
	dec	a
	jr	nz, --_

	pop	hl
	inc	hl
	set	7, (hl)
	;reset self-modifying code
	ld	bc, 264
	ld	(SetCachedTile_DrawingGap+1), bc
	ret	

GetTilePointer:		;makes HL a pointer to the selected tile
	ld	a, (hl)
	inc	hl
	ld	b, (hl)
	push	hl
	ld	h, $20
	ld	l, a
	mlt	hl
	ld	de, SegaVRAM+$2000
	ld	a, b
	bit	0, a	;which half of VRAM are the tiles on?
	jr	nz, +_
	ld	de, SegaVRAM
_:	ex	de, hl
	add	hl, de
	ex	de, hl
	add	hl, hl
	ld	bc, SegaTileCache
	add	hl, bc
	push	hl
	pop	iy		;IY = BG tile cache
	ex	de, hl
	pop	bc
	ld	($D2DD00), bc
	ret
	
GetTileCoordinates:
	exx
	ld	l, $08
	ld	a, ixl
	ld	h, a
	mlt	hl		;HL has the Y coordinate

	ld	e, $08
	ld	a, ixh
	ld	d, a
	mlt	de		;DE has the X coordinate
	
	ld	h, l
	ld	l, e
	ld	de, RenderedScreenMap
	add	hl, de
	push	hl		;DE has the tile's coordinate
	exx
	pop	de
	ret

GetTileFlags:		;calculates a tile's palette & mirroring direction
	call	GetTileCoordinates
	exx
	ld	d, $00
	exx
	ld	a, (bc)
	and	$0E		;is the tile normal?
	ret	z		;return if so

	exx
	ld	e, a
	bit	3, e		;should we use the FG palette?
	jr	z, +_		;jump if we shouldn't
	ld	d, $10
_:	bit	1, e		;do we flip the tile horizontally?
	jr	z, +_		;jump if we don't

	ld	bc, $0007
	add	hl, bc
	ld	a, $1B		;since we're drawing the tile backwards, we
	ld	(DrawPixel), a	;switch out the INC DE in the tile drawing
	ld	bc, 264		;routines for a DEC DE.
	ld	(SetScanlineSkip+1), bc

_:	bit	2, e		;do we flip the tile vertically?
	jr	z, +_		;jump if we shouldn't

	ld	bc, $0700
	add	hl, bc
	ld	bc, -264
	ld	(SetScanlineSkip+1), bc

	ld	a, e
	and	$06
	cp	$06		;do we flip the tile both ways?
	jr	nz, +_
	ld	bc, -248
	ld	(SetScanlineSkip+1), bc
_:	push	hl
	exx
	pop	de
	ret

DrawSAT:	;draws all the sprites, from most to least significant
	ld	a, 1
	ld	($D2DE06), a
	ld	iy, SAT		;y position
	ld	ix, SAT+$80	;x position/tile index
	ld	b, $40		;number of SAT entries
	exx
	ld	d, $10
	exx

_:	ld	h, (iy)
	ld	a, 208
	cp	h		;is the sprite's Y position 208?
	ret.sis	z		;stop rendering SAT if so

	;is the sprite off-screen?
	ld	a, 175
	cp	h
	jr	c, +_		;skip this sprite
	ld	a, (ix)
	or	a
	jr	z, +_		;check if the same applies to Y coords
	cp	$F8
	jr	nc, +_

	;draw the top half of the sprite
	call	SetSpriteCoords	;set sprite coordinates
	ex	de, hl		;HL now points to the tile's top-left corner
	ld	l, (ix+1)
	call	SetSpritePTR

	;draw the bottom half of the sprite
	ld	a, (iy)
	add	a, 8
	ld	h, a
	call	SetSpriteCoords
	ex	de, hl
	ld	l, (ix+1)
	inc	l
	call	SetSpritePTR

_:	lea	ix, ix+2	;point IX and IY to the next entry
	inc	iy
	djnz	--_
	ret.sis

SetSpriteCoords:
	ld	l, 160
	mlt	hl
	add	hl, hl		;HL now has the scanline to start on
	ld	de, $0020
	add	hl, de		;move into the letterbox
	ld	e, (ix)
	add	hl, de		;DE has the tile's coordinates
	ld	de, VRAM+$1F40	;first scanline to be updated
	add	hl, de
	ret

SetSpritePTR:
	ld	h, $20		;size of tile
	mlt	hl
	push	de
	ld	de, SegaVRAM
	add	hl, de		;HL now points to the specified tile
	pop	de		;DE has the tile's coordinates
	push	iy
	ld	iy, SegaTileCache+$10000	;point IY to tile cache
	call	ConvertTileTo8bpp
	pop	iy
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
	push	hl
	ex	de, hl
SetScanlineSkip:
	ld	de, 248
	ld	a, ($D2DE06)		;are we drawing the SAT?
	or	a
	jr	z, +_			;jump if we aren't
	ld	de, lcdWidth-8
_:	add	hl, de
	ex	de, hl
	pop	hl
	dec	c
	jr	nz, --_
	ret
	

ConvertPixelRow:		;converts pixels from a planar format to a nybble
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
	cp	$10
	jr	z, DrawPixel
	ld	(de), a
DrawPixel:
	inc	de
DrawCachedPixel:
	ld	(iy), a
	inc	iy
	exx
	dec	e
	jr	nz, -_
	exx
	pop	hl
	inc	hl
	inc	hl
	ret

Draw8bppTileEnd:
.ORG	Draw8bppTileEnd-romStart
.ASSUME ADL=0
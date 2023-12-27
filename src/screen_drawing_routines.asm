
;These routines take data from VDP RAM and translates them into a usable frame.

.ASSUME ADL=0
DrawScreen:
.ORG	DrawScreen+romStart

	;call.lil RenderScreenMap
	;start drawing the SAT
	ld	a, (DrawSATTrig)
	or	a
	call.lil nz, DrawSAT
	;right now, let's only draw the sprites,
	;since tilemap drawing would take a lot more cycles.
	xor	a
	ld	(DrawSATTrig), a
	ld	(DrawTilemapTrig), a
	ret
.ASSUME ADL=1

RenderScreenMap:
	ld.sis	a, (DrawTilemapTrig)
	push	af
	or	a
	call	nz, DrawScreenMap	;set up double buffering
	pop	af
	ld	hl, ScrollingTrig
	or.sis	(hl)			;should anything be drawn at all?
	ret.sis	z
	;TODO: Write working routine

ClearScreen:
	ld	hl, VRAM
	ld	de, VRAM+1
	ld	bc, 320*240
	ld	(hl), $00
	ldir
	ret

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
	and	%10010000			;should we draw the tile right now?
	call	z, DrawScreenMap_Tiles

_:	inc	ixh				;update counters
	ld	a, 31
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
	ret

DrawScreenMap_Tiles:
	set	7, (hl)				;set that flag for future interrupts
	dec	hl
	xor	a
	ld	($D2DE06), a			;reset the SAT drawing flag
	ld	a, (hl)
	ld	de, SegaTileFlags
	ld	e, a				;use tile index as an offset into flags
	ld	a, (de)
	bit	0, a				;is the tile cached?
	jr	nz, DrawCachedTile		;do alternate routine if so
	inc	a
	ld	(de), a
	call	GetTilePointer
	call	GetTileFlags
	call	ConvertTileTo8bpp
	;reset self-modifying code
	ld	a, $13				;INC DE
	ld	(DrawPixel), a
	ld	de, $0019			;ADD HL, DE \ NOP
	ld	(MoveToNextLine), de
	ld	de, 248
	ld	(SetScanlineSkip+1), de
	ld	hl, ($D2DD00)
	ret

DrawScreenMap_PriorityTiles:
	ld	ix, $0000
	ld	hl, ScreenMap
	inc	hl
_:	bit	4, (hl)
	call	nz, DrawScreenMap_Tiles
	dec	bc
	ld	a, b
	or	c
	jr	nz, -_
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

	bit	1, a			;do we flip the tile horizontally?
	jr	z, +_			;jump if we shouldn't
	;shift HL and DE to the right side of the tile
	ld	bc, $0007
	add	hl, bc
	ex	de, hl
	add	hl, bc
	ex	de, hl
	ld	bc, $B8ED		;LD BC', LDDR
	ld	(SetCachedTile_DrawingX), bc
	ld	bc, 264
	ld	(SetCachedTile_DrawingGap+1), bc

_:	bit	2, a			;do we flip the tile vertically?
	jr	z, +_			;jump if we shouldn't
	;shift HL and DE to the bottom side of the tile
	ld	bc, $0018
	add	hl, bc
	ld	bc, $0700
	ex	de, hl
	add	hl, bc
	ex	de, hl
	ld	bc, $42ED
	ld	(SetCachedTile_DrawingY), bc

_:	and	$06			;do we flip the tile both ways?
	cp	$06
	ld	a, $08
	jr	z, +_
	ld	bc, 248
	ld	(SetCachedTile_DrawingGap+1), bc
_:	ld	bc, $0008		;BC = tile width
SetCachedTile_DrawingX:
	ldir
	nop
	ex	de, hl
SetCachedTile_DrawingGap:
	ld	bc, 248
SetCachedTile_DrawingY:
	add	hl, bc
	nop
	nop
	ex	de, hl
	dec	a
	jr	nz, -_
	pop	hl
	inc	hl
	set	7, (hl)
	ret
	

GetTilePointer:		;makes HL a pointer to the selected tile
	ld	a, (hl)
	inc	hl
	push	hl
	ld	h, $20
	ld	l, a
	mlt	hl
	ld	de, SegaVRAM+$2000
	ex	de, hl
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
	ld	bc, $080111	;routines for a DEC DE.
	ld	(SetScanlineSkip), bc

_:	bit	2, e		;do we flip the tile vertically?
	jr	z, +_		;jump if we shouldn't
	ld	bc, $0700
	add	hl, bc
	ld	a, $ED		;switch out ADD HL, DE with SBC HL, DE
	ld	(MoveToNextLine), a
	ld	a, $52
	ld	(MoveToNextLine+1), a

	ld	a, e
	and	$06
	cp	$06		;do we flip the tile both ways?
	jr	z, +_
	ld	a, $11
	ld	(SetScanlineSkip), a
	ld	bc, 248
	ld	(SetScanlineSkip+1), bc
_:	push	hl
	exx
	pop	de
	ret

DrawSAT:
	ld	hl, SegaTileFlags+$E0	;cached tile index
	ld	($D2DE06), hl
	ld	iy, SAT		;y position
	ld	ix, SAT+$80	;x position/tile index
	ld	b, $40		;number of SAT entries
	exx
	ld	d, $10
	exx

_:	ld	h, (iy)
	ld	a, 208
	cp	h		;is the sprite's Y position 208?
	ret	z		;stop rendering SAT if so
	ld	a, 192
	cp	h		;is the sprite off-screen?
	jr	c, +_		;skip this sprite
	ld	a, h
	cp	(ix)		;is the indice a null ptr?
	jr	z, +_
	ld	($D2DE06), a	;set SAT drawing flag

	call	SetSpriteCoords	;set sprite coordinates
	ex	de, hl		;HL now points to the tile's top-left corner
	ld	l, (ix+1)
	call	SetCachedSpritePtr

	ld	hl, ($D2DE06)	;set cached tile flag
	set	0, (hl)
	inc	hl
	ld	($D2DE06), hl

	ld	l, (iy)
	ld	e, 8
	add	hl, de
	ld	h, l
	call	SetSpriteCoords
	ex	de, hl
	ld	l, (ix+1)	;calc bottom half of 8x16 sprite
	inc	l
	call	SetCachedSpritePtr

_:	inc	ix		;point IX and IY to the next entry
	inc	ix
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
	ld	de, VRAM+$1E00	;first scanline to be updated
	add	hl, de
	ret

SetCachedSpritePtr:
	ld	h, $20		;size of tile
	mlt	hl
	push	de
	ld	de, SegaVRAM
	add	hl, de		;HL now points to the specified tile
	pop	de		;DE has the tile's coordinates
	push	iy
	ld	iy, SegaTileCache+$4000	;point IY to tile cache
	exx
	ld	b, $40
	ld	c, (ix)
	mlt	bc
	add	iy, bc
	exx
	call	ConvertTileTo8bpp
	ld	iy, SegaTileFlags
	ld	a, (ix+1)	;set cached tile flag
	ld	iyl, a
	ld	a, $01
	ld	(iy), a
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
	jr	z, MoveToNextLine	;jump if we aren't
	ld	de, lcdWidth-8
MoveToNextLine:
	add	hl, de
	nop
	nop
	ex	de, hl
	pop	hl
	dec	c
	jr	nz, -_
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
	ld	(iy), a
DrawPixel:
	inc	de
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
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
	call.lil DrawSAT

	xor	a
	ld	(DrawTilemapTrig), a
	ret
.ASSUME ADL=1

#define ScreenPTR VRAM

RenderScreenMap:
	; setup values
	ld	de, ScreenPTR
	ld.sis bc, (VDP_HScroll)
	ld	a, c
	or	a
	jp	z, RenderScreenMap_NullScroll
	
	ld	a, 192
RenderScreenMap_Loop:
	push af
	push bc

	; offset HL to the starting pixel
	ld	hl, RenderedScreenMap
	add hl, bc
	ld	a, c
	neg
	ld	l, a
	; intiial pixels drawn = C
	ld b, 0
	ldir

	; go back to the scanline
	dec	hl
	ld	l, 0
	; pixels drawn = 256 - HScroll
	ld	c, a
	ldir

	;go to the next scanline
	pop bc
	inc b
	ld a, b
	cp 224
	jr nz, +_
	ld b, 0

_:	pop af
	dec a
	jr	nz, RenderScreenMap_Loop
	ret.sis
	
RenderScreenMap_NullScroll:
	; draw the top half of the screen
	ld	hl, RenderedScreenMap

	ld a, b
	cp 32 + 1
	jr c, RenderScreenMap_WholeScreen

	ld	a, 224
	add hl, bc
	sub a, b
	ld b, a
	ldir
	
	ld b, a
	ld a, 192
	sub b
	ld b, a
	
	; draw the bottom half of the screen
	ld	hl, RenderedScreenMap
	ldir
	ret.sis

RenderScreenMap_WholeScreen:
	add hl, bc
	ld bc, smsHeight * smsWidth
	ldir
	ret.sis


DrawScreenMap:
	ld	hl, ScreenMap
	ld	bc, 32*28

_:	push	bc
	push	hl

	ld a, (hl)
	inc	hl
	or (hl)
	jr z, +_

	bit	7, (hl)
	call	z, DrawScreenMap_Tiles
_:	call	IncTileCoords

	pop	hl
	pop	bc

	inc hl
	inc	hl
	dec	bc
	ld	a, b
	or	c
	jr	nz, --_

	; clear tile coords
	ld	hl, 0
	ld	(TileCoords), hl

	ret.sis

IncTileCoords:
	; inc the tile column
	ld	hl, TileCoords
	inc	(hl)

	; if we're haven't finished the row, bail out
	ld	a, 32
	cp	(hl)
	ret	nz

	; go to next tile row
	ld	(hl), 0
	inc	hl
	inc	(hl)
	ret

TileCoords:
	;   X, Y
	.db 0, 0, 0

DrawScreenMap_Tiles:
	set	7, (hl)				;set that flag for future interrupts
	ld	c, (hl)
	dec hl

	bit 4, c
	jr	nz, +_
	bit	0, c				;which half of VRAM is the tile on?
	jr	z, +_				;don't use cached tiles if said tile is on the first half of VRAM

	ld	a, (hl)
	ld	de, SegaTileFlags
	ld	e, a				;use tile index as an offset into flags
	ld	a, (de)
	bit	0, a				;is the tile cached?
	jr	nz, DrawCachedTile		;do alternate routine if so

	bit	3, c
	jr	nz, +_				;if we're using the FG palette, don't flag the cached tile
	inc	a
	ld	(de), a

_:	call	GetTilePointer
	call	GetTileFlags
	call	ConvertTileTo8bpp
	;reset self-modifying code
	ld	a, $13				;INC DE
	ld	(IncPixel), a
	ld 	hl, smsWidth - 8
	ld 	(SetScanlineSkip), hl
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
	ld	bc, -(smsWidth + 8)
	ld	(SetCachedTile_DrawingGapY+1), bc

_:	ld	a, $08
_:	ld	bc, $0008		;BC = tile width
	ldir
	ex	de, hl
SetCachedTile_DrawingGapY:
	ld	bc, smsWidth - 8
	add	hl, bc
	ex	de, hl
	dec	a
	jr	nz, -_
	pop	hl
	inc	hl
	set	7, (hl)
	;reset self-modifying code
	ld	bc, smsWidth - 8
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
	ld	bc, -(smsWidth - 8)
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
	ld	bc, smsWidth + 8
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
	ld	bc, smsWidth + 8
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
	pop	ix
	ret
	
GetTileCoordinates:
	exx
	ld	l, $08
	ld	a, (TileCoords + 1)
	ld	h, a
	mlt	hl		;HL has the Y coordinate

	ld	e, $08
	ld	a, (TileCoords)
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

	; return if the tile is normal
	ld	a, (ix)
	and	%11110
	ret	z
	exx

	;should we use the FG palette?
	ld e, a
	bit	3, e
	jr	z, +_
	; if so, set bit 4 of D
	set	4, d

	; is this a priority tile?
_:	bit	4, e
	jr	z, +_
	; if so, set bit 5 of D
	set	5, d

	; should we flip the tile horizontally?
_:	bit	1, e
	jr	z, +_

	; if so, modify the coords and the drawing code
	ld	bc, $0007
	add	hl, bc

	; since we're drawing the tile backwards, we
	; switch out the INC DE in the tile drawing
	; routines for a DEC DE.
	ld	a, $1B
	ld	(IncPixel), a
	ld	bc, smsWidth + 8
	ld	(SetScanlineSkip), bc

	; should we flip the tile vertically?
_:	bit	2, e
	jr	z, +_

	ld	bc, $0700
	add	hl, bc
	ld	bc, -(smsWidth + 8)
	ld	(SetScanlineSkip), bc

	; should we flip the tile both ways?
	ld	a, e
	and	$06
	cp	$06	
	jr	nz, +_

	ld	bc, -(smsWidth - 8)
	ld	(SetScanlineSkip), bc

_:	push	hl
	exx
	pop	de
	ret

DrawSAT:	;draws all the sprites, from most to least significant
	ld	a, 16
	ld	(SpriteLength), a
	
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

	;draw the top half of the sprite
	ld	a, (ix)
	call	SetSpriteCoords	;set sprite coordinates
	jr	nc, +_
	ex	de, hl		;HL now points to the tile's top-left corner
	ld	l, (ix+1)
	call	SetSpritePTR

_:	lea	ix, ix+2	;point IX and IY to the next entry
	inc	iy
	djnz	--_

	ld	a, 8
	ld	(SpriteLength), a
	ret.sis

SetSpriteCoords:
	ld	e, a
	call	CheckSpriteOffscreen
	ret	nc
SetSpriteCoords_NoClip:
	or	a
	sbc	hl, hl
	ld	l, (ix)
	ld	h, (iy)
	inc h
	ld	de, ScreenPTR
	add	hl, de
	scf
	ret

CheckSpriteOffscreen:
	;is the sprite off-screen?
	or	a
	ret	z
	cp	$F8
	ret	nc
	ld	a, h
	cp	177
	ret	nc		;skip this sprite
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
SpriteLength = $+1
	ld	c, $08
_:	call	ConvertPixelRow
	push	hl
	ex	de, hl
SetScanlineSkip = $+1
	ld	de, smsWidth - 8
	add	hl, de
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
DrawPixel_Loop:
	xor	a
	rl	h
	rla
	rl	l
	rla
	rl	c
	rla
	rl	b
	rla
	bit	4, d
	jr	nz, DrawSpritePixel

	or	d
	exx
	ld	(de), a
	and $0F
	ld	(iy), a
	inc	iy

DrawPixel_LoopBack:
IncPixel:
	inc	de
	exx
	dec	e
	jr	nz, DrawPixel_Loop
	exx
	pop	hl
	inc	hl
	inc	hl
	ret

DrawSpritePixel:
	exx
	set	4, a
	cp	$10
	jr	z, DrawPixel_LoopBack
	ex	de, hl
	bit	5, (hl)
	ex de, hl
	jr	nz, DrawPixel_Priority
	ld	(de), a
	jr	DrawPixel_LoopBack

DrawPixel_Priority:
	ex af, af'
	ld a, (de)
	cp	$20
	jr	nz, DrawPixel_LoopBack
	ex af, af'
	ld	(de), a
	jr	DrawPixel_LoopBack

Draw8bppTileEnd:
.ORG	Draw8bppTileEnd-romStart
.ASSUME ADL=0
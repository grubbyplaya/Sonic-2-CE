;These routines take data from VDP RAM
;and interprets them into a usable frame.

;3 KB of VRAM is unused.
;Double buffering takes up 48 KB
;The screen itself is 75 KB
;VDP RAM is 16 kB in size


;Screen Map starts at X Scroll - $FF
;Y Scroll is normal. No need to interpret


DrawScreen:
	call	StoreRegisters
	ld	a, (VDPRegister1)
	bit	6, a
	jr	nz, +_
	call	ClearScreen	
	ret
	
_:	call	DrawScreenMap	;set up double buffering
	call	DrawSAT
	ld	a, 192		;length of SMS screen
	ld	ix, $40		;size of letterbox

	ld	hl, RenderedScreenMap
	ld	de, VRAM+$1E20	;first pixel within letterbox
_:	ld	bc, $0100
	ldir

	add	ix, de
	push	ix
	pop	de
	dec	a	
	jr	nz, -_
	call	Engine_HandleVBlank

	call	RestoreRegisters
	ret

ClearScreen:
	ld	hl, VRAM
	ld	de, VRAM+1
	ld	bc, 320*240
	ld	a, $00
	ld	(hl), a
	ldir
	ret

DrawScreenMap:
	ld	hl, RenderedScreenMap ;fills screen with background color 0
	ld	de, RenderedScreenMap+1
	ld	bc, SegaVRAM-RenderedScreenMap
	ld	a, (CRAM)
	ld	(hl), a
	ldir

	ld	hl, ScreenMap
	ld	bc, 32*28
	ld	ixh, $00	;x position of tile (in tiles)
	ld	ixl, $00	;y position (in tiles)

_:	push	bc
	inc	hl
	bit	3, (hl)	
	jr	z, +_

	call	GetTilePointer
	call	GetTileCoordinates
	call	ConvertFGTileTo8bpp
	pop	bc
	jr	++_

_:	call	GetTilePointer
	call	GetTileCoordinates
	call	ConvertBGTileTo8bpp
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
	mlt	hl
	ld	h, l ;H has the Y coordinate

	ld	e, $08
	ld	a, ixh
	ld	d, a
	mlt	de	;DE has the X coordinate
	
	ld	l, e
	ld	de, RenderedScreenMap
	add	hl, de
	ex	de, hl	;DE has the tile's coordinate
	pop	hl	;bring back the tile pointer
	ret

GetScrollingOffsets:	;gets the screen map offsets
	ld	a, (BackgroundYScroll)
	ld	h, a
	ld	a, (BackgroundXScroll)
	ld	l, a
	ld	de, RenderedScreenMap
	add	hl, de
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
	add	hl, de		;HL now points to the selected tile
	pop	de		;DE has the tile's coordinates
	call	ConvertFGTileTo8bpp
	djnz	-_
	ret

; =============================================================================
;	In:
;	HL	- Pointer to pattern.
;	DE	- Position of tile.
;	B	- Row count.
;	C	- Column count.
;	ld:
;	None.
;	Destroys:
;	A, C, DE
; -----------------------------------------------------------------------------

ConvertBGTileTo8bpp:
	ld	(SaveSP), sp
	ex	de, hl
	ld	sp, hl
	ex	de, hl

	ld	c, $20
	ld	(cursorImage), hl

_:	ld	a, (hl)
	ld	mb, a		;save byte
	and	%00001111	;remove bits 4-7
	jr	z, +_

	ld	h, 0
	ld	l, a
	ld	de, CRAM	;load DE into palette
	add	hl, de		;use HL as offset into palette
	ld	a, (hl)		;load result into A
	push	af ;draw pixel
	inc	sp
	pop	af
	
_:	ld	a, mb		;get back the byte
	and	%11110000	;remove bits 0-3
	jr	z, +_
	rlca			;offset result into bits 0-3
	rlca
	rlca
	rlca
	ld	h, 0
	ld	l, a
	ld	de, CRAM	;load DE into palette
	add	hl, de		;use HL as offset into palette
	ld	a, (hl)		;load result into A

	push	af ;draw pixel
	inc	sp
	pop	af
	
_:	ld	a, c
	and	%00010011
	jr	nz, +_		;jump if C isn't a multiple of 4 or $20

	ld	hl, $00F8
	add	hl, sp
	ld	sp, hl

_:	ld	hl, (cursorImage)
	inc	hl
	dec	c
	ld	a, c
	cp	$00
	jr	nz, ----_
	ld	sp, (SaveSP)
	ret
	
ConvertFGTileTo8bpp:
	ld	(SaveSP), sp
	ex	de, hl
	ld	sp, hl
	ex	de, hl

	ld	c, $20
	ld	(cursorImage), hl

_:	ld	a, (hl)
	ld	mb, a	;save byte
	and	%11110000		;remove bits 4-7
	jr	z, +_

	ld	h, 0
	ld	l, a
	ld	de, CRAM+$10	;load DE into palette
	add	hl, de		;use HL as offset into palette
	ld	a, (hl)		;load result into A

	push	af ;draw pixel
	inc	sp
	pop	af
	
_:	ld	a, mb		;get back the byte
	and	%00001111	;remove bits 0-3
	jr	z, +_
	rlca			;offset result into bits 0-3
	rlca
	rlca
	rlca

	ld	h, 0
	ld	l, a
	ld	de, CRAM+$10	;load DE into palette
	add	hl, de		;use HL as offset into palette
	ld	a, (hl)		;load result into A

	push	af ;draw pixel
	inc	sp
	pop	af

_:	ld	a, c
	and	%00010011
	jr	nz, +_		;jump if C is a multiple of 4 or $20

	ld	hl, $00F8
	add	hl, sp
	ld	sp, hl

_:	ld	hl, (cursorImage)
	inc	hl
	dec	c
	ld	a, c
	cp	$00
	jr	nz, ----_
	ld	sp, (SaveSP)
	ret
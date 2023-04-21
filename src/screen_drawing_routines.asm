;3 KB of VRAM is unused. 
;Double buffering takes up 48 KB
;The screen itself is 75 KB
;VDP RAM is 16 kB in size

;These routines take data from VDP RAM
;and interprets them into a usable image.

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
	ld	de, VRAM+$1E20
_:	ld	bc, $0100
	ldir

	add	ix, de
	push	ix
	pop	de
	dec	a
	ld	b, a		
	djnz	-_
	call	Engine_HandleVBlank

	call	RestoreRegisters
	ret

ClearScreen:
	push	af
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
	ld	bc, 32*32
	ld	ixh, $00	;x position of tile (in tiles)
	ld	ixl, $00	;y position of tile (in tiles)

_:	push	bc
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

	dec   bc
	ld	a, b
	or	c
	jr	nz, ---_
	ret

_:	ld	ixh, $00
	ld	a, 27
	cp	ixl
	ret	z	;exit if IXL is at the last row
	inc	ixl
	jr	----_

GetTileCoordinates:
	push	hl
	ld	a, ixl
	ld	h, a
	ld	l, $00
	ld	e, $FF

	push	bc
	call	Engine_Multiply_8_by_8u
	pop	bc
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl	;HL stores the Y coordinate

	push	hl
	ld	d, $00
	ld	e, ixh
	ld	hl, $0008	;width of tile

	push	bc
	call	Engine_Multiply_8_by_8u
	pop	bc

	ex	de, hl	;DE has the X coordinate
	pop	hl		;HL has the Y coordinate
	add	hl, de
	ex	de, hl
	pop	hl		;bring back the tile pointer
	ret
	
DrawSAT:
	ld	iy, SAT	;y position
	ld	ix, SAT+$80	;x position
	ld	b, $40	;number of SAT entries
_:	ld	h, $FF
	ld	e, (iy)
	push	bc
	call	Engine_Multiply_8_by_8u
	add	hl, de
	pop	bc
	ld	d, $00
	ld	e, (ix)
	add	hl, de	;HL now has the sprite's coordinate
	inc	ix		;IX now has the tile to draw
	inc	iy
	
	ld	de, RenderedScreenMap
	add	hl, de
	push	hl

	ld	a, (ix)
	ld	e, a
	ld	h, $20
	push	bc
	call	Engine_Multiply_8_by_8u
	pop	bc
	
	ld	de, SegaVRAM
	add	hl, de	;HL now points to the selected tile
	pop	de
	call	ConvertFGTileTo8bpp
	djnz	-_
	ret

GetScrollOffsets:	;gets the screen map offsets
	ld	h, 	$FF
	ld	a, (BackgroundYScroll)
	ld	e, a
	call	Engine_Multiply_8_by_8u
	ld	d, $00
	ld	a, (BackgroundXScroll)
	ld	e, a
	add	hl, de
	ret

GetTilePointer:	;makes DE a pointer to the selected tile
	ld	e, $20
	inc	hl
	ld	a, (hl)
	dec	hl
	push	hl
	ld	l, a
	ld	h, $00
	push	bc
	call	Engine_Multiply_8_by_8u
	pop	bc
	ld	de, SegaVRAM+$2000
	add	hl, de
	ex	de, hl
	pop	hl
	ret

; =============================================================================
;	In:
;	HL	- Pointer to pattern.
;	SP	- Position of tile.
;	B	- Row count.
;	C	- Column count.
;	ld:
;	None.
;	Destroys:
;	A, C, DE
; -----------------------------------------------------------------------------

ConvertBGTileTo8bpp:
	ld	(SaveSP), sp
	ex de, hl
	ld sp, hl
	ex de, hl
	ld	c, $20
	ld	(cursorImage), hl
_:	ld	a, (hl)
	ld	(CursorImage-1), a	;save byte
	res	4, a		;remove bits 4-7
	res	5, a
	res	6, a
	res	7, a
	cp	$00
	jr z, +_
	ld	h, 0
	ld	l, a
	ld	de, CRAM		;load DE into palette
	add	hl, de		;use HL as offset into palette
	ld	a, (hl)		;load result into A
	push	af ;draw pixel
	inc	sp
	pop	af
	
_:	ld	a, (CursorImage-1)	;get back the byte
	res	0, a		;remove bits 0-3
	res	1, a
	res	2, a
	res	3, a
	cp	$00
	jr	z, +_
	rlca			;offset result into bits 0-3
	rlca
	rlca
	rlca
	ld	h, 0
	ld	l, a
	ld	de, CRAM		;load DE into palette
	add	hl, de		;use HL as offset into palette
	ld	a, (hl)		;load result into A
	push	af ;draw pixel
	inc	sp
	pop	af

_:	bit	0, c	;is C a multiple of 2?
	jr	nz, +_	;jump if not
	bit	1, c	;is C a multiple of 4?
	jr	nz, +_

	ld	hl, $00F8
	add	hl, sp
	ld	sp, hl

_:	ld	hl, (cursorImage)
	inc	hl
	dec	c
	ld	a, c
	cp	$00
	jr	nz,	 ----_
	ld	sp, (SaveSP)
	ret
	
ConvertFGTileTo8bpp:
	ld	(SaveSP), sp
	ex de, hl
	ld sp, hl
	ex de, hl
	ld	c, $20
	ld	(cursorImage), hl
_:	ld	a, (hl)
	ld	(CursorImage-1), a	;save byte
	res	4, a			;remove bits 4-7
	res	5, a
	res	6, a
	res	7, a
	cp	$00
	jr z, +_
	ld	h, 0
	ld	l, a
	ld	de, CRAM+$10	;load DE into palette
	add	hl, de		;use HL as offset into palette
	ld	a, (hl)		;load result into A
	push	af ;draw pixel
	inc	sp
	pop	af
	
_:	ld	a, (CursorImage-1)	;get back the byte
	res	0, a		;remove bits 0-3
	res	1, a
	res	2, a
	res	3, a
	cp	$00
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

_:	bit	0, c	;is C a multiple of 2?
	jr	nz, +_	;jump if not
	bit	1, c	;is C a multiple of 4?
	jr	nz, +_

	ld	hl, $00F8
	add	hl, sp
	ld	sp, hl

_:	ld	hl, (cursorImage)
	inc	hl
	dec	c
	ld	a, c
	cp	$00
	jr	nz,	----_
	ld	sp, (SaveSP)
	ret

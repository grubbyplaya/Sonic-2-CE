;3 KB of VRAM is unused. 
;Double buffering takes up 48 KB
;The screen itself is 75 KB
;VDP RAM is 16 kB in size

;These routines take data from VDP RAM
;and interprets them into a usable image.

;Screen Map starts at X Scroll - $FF
;Y Scroll is normal. No need to interpret


DrawScreen:
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
	;code this when SAT parsing is done
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
	push hl

	ld	a, (ix)
	ld	e, a
	ld	h, $20
	push	bc
	call	Engine_Multiply_8_by_8u
	pop	bc
	
	ex	de, hl
	ld	hl, SegaVRAM
	add	hl, de
	pop de
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



GetBGTilePointer:	;makes HL a pointer to the selected tile
	ld	e, $20
	call	Engine_Multiply_8_by_8u
	ld	de, SegaVRAM+$2000
	add	hl, de
	ret

GetFGTilePointer:	;makes HL a pointer to the selected tile
	ld	e, $20
	call	Engine_Multiply_8_by_8u
	ld	de, SegaVRAM
	add	hl, de
	ret

; =============================================================================
;	In:
;	HL	- Pointer to pixel.
;	SP	- Position of tile.
;	B	- Row count.
;	C	- Column count.
;	ld:
;	None.
;	Destroys:
;	A, SP, C, DE, HL
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
	ld	c, $20
	ld	(cursorImage), hl
	
_:	ld	a, (hl)
	ld	(cursorImage-1), a	;save byte
	res	4, a		;remove bits 4-7
	res	5, a
	res	6, a
	res	7, a
	cp	$00 
	jr	z, +_
	ld	h, 0
	ld	l, a
	ld	de, CRAM+$10		;load DE into palette
	add	hl, de		;use HL as offset into palette
	ld	a, (hl)		;load result into A
	push	af ;draw pixel
	inc	sp
	pop	af
	
_:	ld	a, (cursorImage-1)	;get back the byte
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
	ld	de, CRAM+$10		;load DE into palette
	add	hl, de		;use HL as offset into palette
	ld	a, (hl)		;load result into A
	push	af	;draw pixel
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
	cp	$1C
	cp	$00
	jr	nz, ----_
	ld	sp, (SaveSP)
	ret

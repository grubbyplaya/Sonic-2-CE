.ASSUME ADL=0
;**************************************************
;*			Variables
;**************************************************
#define	BitFieldCount	$D340
#define	TileCount	$D342
#define	FlagPointer	$D345
#define	SourcePointer	$D348

;**************************************************
;* LoadTiles - 
;* Load (un)compressed tile data into VRAM.
;* Expects VDP memory pointer to have been set.
;*	
;*	A  - Indexed tiles flag
;*	HL - Source Address
;**************************************************
LoadTiles:
_LABEL_1AA6_22:
	;if $D34C is set, each byte of decompressed data 
	;at $D300 is treated as an index into the mirroring
	;table stored at $0100.
	ld	($D34C), a
	push	hl				;push the base address onto the stack
	inc	hl				;read the tile data header
	inc	hl
	ld	a, (hl)
	ld	(TileCount), a			;tilecount lo-byte
	inc	hl
	ld	a, (hl)
	ld	(TileCount+1), a		;tilecount hi-byte 
	inc	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)				;compression definition pointer (http://forums.sonicretro.org/index.php?showtopic=11509)
	inc	hl
	ld	(SourcePointer), hl		;tile data pointer
	pop	hl
	add	hl, de				;add the relative compression definition pointer to the base address
	ld	(FlagPointer), hl		;store the compression definition pointer
	ld	hl, $D320		;clear RAM $D320->$D340
	ld	de, $D321
	ld	bc, $001F
	ld	(hl), $00
	ldir
	xor	a				;reset counter
	ld	(BitFieldCount), a

_:	call	_GetCompressionType		;select the correct decompression method
								
	cp	$00				;$00 - blank tile
	jr	nz, +_
	call	WriteBlankTile			;write a blank tile to VRAM
	jr	++++_
	
_:	cp	$02				;$02 - compressed tile
	jr	nz, +_
	call	LoadCompressedTile
	call	WriteTileToVRAM
	jr	+++_
	
_:	cp	$03				;$03 - xor compressed tile
	jr	nz, +_
	call	LoadCompressedTile
	call	XORDecode
	call	WriteTileToVRAM
	jr	++_
	
_:	call	LoadUncompressedTile		;$01 - uncompressed tile
	call	WriteTileToVRAM
	
_: 	ld	hl, (TileCount)			;decrement tile count
	dec	hl
	ld	(TileCount), hl
	ld	a, l
	or	h
	jr	nz, -----_
	ret

;*************************************************************
;*	Load uncompressed tile (direct copy from $D346 to $D300).
;*************************************************************
LoadUncompressedTile:
	ld	hl, (SourcePointer)	;copy 32 bytes from source to $D300	
	ld	de, $D300
	ld	bc, $0020
	ldir
	ld	(SourcePointer), hl	;store new source pointer
	ret

;*************************************************************
;*	Load compressed tile data and store decompressed at $D300.
;*************************************************************
LoadCompressedTile:		;$1B1E
	ld	ix, $D300				;destination address for decompressed tile data
	ld	hl, (SourcePointer)	;read the bitmask

	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	inc	hl
	ld	a, $20
_:	push	af
	rr	b
	rr	c
	rr	d
	rr	e
	jr	c, +_		;if previous lsb was 0, read a byte from (hl)
	ld	(ix+0), $00	;previous lsb was 0 - write $00 to (ix)
	jr	++_
_:	ld	a, (hl)		;read byte from (hl) and write to (ix)
	ld	(ix+0), a
	inc	hl				;increment source pointer
_: 	inc	ix				;increment destination pointer
	pop	af
	dec	a
	jr	nz, ---_
	ld	(SourcePointer), hl	;store next source pointer
	ret

;*************************************************************
;*	Decode XOR'ed tile data.
;*************************************************************
XORDecode:
	ld	ix, $D300	;decode data at $D300
	ld	b, $07
_:	ld	a, (ix+0)		;xor byte at (ix+0) with byte at (ix+2)...
	xor	(ix+2)
	ld	(ix+2), a		;...and store the result at (ix+2)
	
	ld	a, (ix+1)		;xor byte at (ix+1) with byte at (ix+3)...
	xor	(ix+3)
	ld	(ix+3), a		;...and store the result at (ix+3)
	
	ld	a, (ix+16)		;xor byte at (ix+16) with byte at (ix+18)...
	xor	(ix+18)
	ld	(ix+18), a		;...and store result at (ix+18)
	
	ld	a, (ix+17)		;xor byte at (ix+17) with byte at (ix+19)...
	xor	(ix+19)
	ld	(ix+19), a		;...and store result at (ix+19)
	
	lea	ix, ix+2		;ix += 2
	djnz	-_
	ret

;**********************************************************************
;* Read the compression type bitfield for the next data block.
;* Compression type bitfield is a series of 2-bit flags that define
;* the type of compression used on the following data.
;*
;*	See: http://forums.sonicretro.org/index.php?showtopic=10063
;*
;**********************************************************************
_GetCompressionType:
	ld	a, (BitFieldCount)		;get counter value (4 flags per byte)
	cp	$04			;do we need to increment flag-byte pointer?
	jr	nz, +_
	
	ld	hl, (FlagPointer)	;increment the flag-byte pointer
	inc	hl
	ld	(FlagPointer), hl
	xor	a				;reset counter
	ld	(BitFieldCount), a
	
_:	ld	b, a
	ld	hl, (FlagPointer)	;read flag pointer
	ld	a, (hl)
_:	dec	b
	jp	m, +_	;jump if sign (<0)
	rrca				;rotate previous compression type out
	rrca
	jr	-_
_:	and	$03
	push	af
	ld	a, (BitFieldCount)
	inc	a
	ld	(BitFieldCount), a
	pop	af
	ret					;compression type stored in A

	
;*************************************************************
;*	Write a blank tile is encountered (compression type = 0) 
;*	data is copied from $D320 to VRAM.
;*************************************************************
WriteBlankTile:
	ld	hl, $D320		;copy 32 bytes from $D320 to $D300
	ld	de, $D300
	ld	bc, $0020
	ldir
	
;*************************************************************
;*	Write the decompressed tile data (at $D300) to VRAM
;*************************************************************
WriteTileToVRAM:
	ld.lil	hl, $D2D300		;copy 32 bytes from $D300 to VRAM
	ld	ix, (VRAMPointer)
	call	SetTileCacheFlags
	ld	a, ($D34C)
	or	a
	jr	nz, WriteMirroredTileToVRAM

	ld	bc, $0020
	push	ix
	ld.lil	de, SegaVRAM
	add.lil	ix, de
	push.lil ix
	pop.lil	de
	pop	ix
	add	ix, bc
	ldir.lil

	ld	(VRAMPointer), ix
	ret

;************************************************************
;*	Write tile data to VRAM. Data at $D300 is treated as an	*
;*	index into the mirroring data at $0100.					*
;************************************************************
WriteMirroredTileToVRAM:
	ld	b, $20
_:	ld	e, (hl)		;read a byte of tile data from RAM
	ld	d, $01
	push	ix
	exx
	ld.lil	de, SegaVRAM
	add.lil	ix, de
	exx
	ld	a, (de)		;"flip" the byte by using it as an		
	ld.lil	(ix), a		;index into the array at $100 and
	pop	ix		;retrieving the value
	inc	ix
	inc	hl
	ld	(VRAMPointer), ix
	djnz	-_
	ret

SetTileCacheFlags:
	exx
	lea	hl, ix

	;divide the address pointer by the tile size
	srl	h
	rr	l		;hl /= 2
	srl	h
	rr	l		;hl /= 2
	srl	h
	rr	l		;hl /= 2
	srl	h
	rr	l		;hl /= 2
	srl	h
	rr	l		;hl /= 2

	ld	bc, $E0			;amount of tiles not used in the tilemap
	sbc	hl, bc			;save some space by excluding them
	ld.lil	bc, SegaTileFlags
	add.lil	hl, bc
	res.lil	0, (hl)			;flag this tile for redrawing
	exx
	ret
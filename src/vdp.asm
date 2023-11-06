.assume ADL=0
#define	VDP_ScreenMap			SegaVRAM+$3800
#define	VDP_SATAddress			SegaVRAM+$3F00
#define DrawTilemapTrig			$D4C0
#define DrawSATTrig			$D4C1

; =============================================================================
;	VDP_InitRegisters()
; -----------------------------------------------------------------------------
;	Sets the VDP registers to known values.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	Out:
;	None.
; -----------------------------------------------------------------------------
VDP_InitRegisters:
	; loop 11 times to copy to each register
	ld	bc, $0B
	; load DE with a pointer to the RAM cached copies 
	; of the VDP registers
	ld	de, VDPRegister0
	
	ld	hl, _VDP_InitRegisters_RegValues
	ei
	; loop over each register
	ldir	
	ret

_VDP_InitRegisters_RegValues:
.db $26, $82, $FF, $FF, $FF, $FF, $FB, $00, $00, $00, $FF


; =============================================================================
;	VDP_SetRegister(uint8 register, uint8 data)			UNUSED
; -----------------------------------------------------------------------------
;	Sets a VDP register.
; -----------------------------------------------------------------------------
;	In:
;	B	- The value.
;	C	- The register number.
;	Out:
;	None.
;	Destroys:
;	A
; -----------------------------------------------------------------------------
VDP_SetRegister:	; $1310
	push	bc
	push	hl
	
	;update the VDP Register
	ld	a, b
	ld	(Ports_VDP_Control), a
	ld	a, c
	or	$80
	ld	(Ports_VDP_Control), a
	
	;update the RAM copy
	ld	a, b
	ld	b, $00
	ld	hl, VDPRegister0
	add	hl, bc
	ld	(hl), a
	pop	hl
	pop	bc

	ret


; =============================================================================
;	VDP_ReadStatus()						UNUSED
; -----------------------------------------------------------------------------
;	Reads the VDP status flags.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	Out:
;	A	- The status byte.
; -----------------------------------------------------------------------------
VDP_ReadStatus:	 ; $1325
	ld	a, (Ports_VDP_Control)
	ret


; =============================================================================
;	VDP_SetAddress(uint16 address)
; -----------------------------------------------------------------------------
;	Sets the VRAM address pointer.
; -----------------------------------------------------------------------------
;	In:
;	HL	- The new address.
;	Out:
;	None.
;	Destroys:
;	None.
; -----------------------------------------------------------------------------
VDP_SetAddress:	 ; Ported
	push	af	
	ld	a, h
	and	$3F
	ld	(VRAMPointer+1), a
	ld	a, l
	ld	(VRAMPointer), a	
	pop	af	
	ret


; =============================================================================
;	VDP_SendRead(uint16 address)					 UNUSED IN PORT
; -----------------------------------------------------------------------------
;	Sends a read command to the VDP.
; -----------------------------------------------------------------------------
;	In:
;	HL	- The address to read from.
;	Out:
;	None.
;	Destroys:
;	A
; -----------------------------------------------------------------------------
VDP_SendRead:
	ld	a, l
	ld	(Ports_VDP_Control), a
	ld	a, h
	and	$3F
	ld	(Ports_VDP_Control), a
	ret


; =============================================================================
;	VDP_WriteByte(uint16 address, uint8 data)			 UNUSED
; -----------------------------------------------------------------------------
;	Sets the VDP address pointer and writes a value.
; -----------------------------------------------------------------------------
;	In:
;	A	- The data to write.
;	HL	- The address to read from.
;	Out:
;	None.
;	Destroys:
;	None.
; -----------------------------------------------------------------------------
VDP_WriteByte:		; Ported
	; set the VDP address pointer
	push	de
	call	VDP_SetAddress
	; write the data
	ld.lil	de, SegaVRAM
	add	hl, de
	ld	(hl), a
	pop	de
	ret


; =============================================================================
;	VDP_ReadByte(uint16 address)					UNUSED
; -----------------------------------------------------------------------------
;	Sets the VDP address pointer and reads a value.
; -----------------------------------------------------------------------------
;	In:
;	HL	- The address to read from.
;	Out:
;	A	- Data read from the address.
;	Destroys:
;	None.
; -----------------------------------------------------------------------------
VDP_ReadByte:		; Ported
	push	de
	ld	a, h
	and	$3F
	ld	h, a
	ld.lil	de, SegaVRAM
	add	hl, de
	ld	a, (hl)
	pop	de
	ret


; =============================================================================
;	VDP_WriteAndSkip(uint8 data, uint16 address, uint16 count)	UNUSED
; -----------------------------------------------------------------------------
;	Writes a value to every other byte, starting from <address> (i.e. writes
;	one byte, skips the next address, writes a byte, skips...)
; -----------------------------------------------------------------------------
;	In:
;	A	- The data.
;	BC	- Number of bytes to write. When the function returns, the VRAM
;		address pointer will be HL + 2*BC.
;	HL	- The address to start writing from.
;	Out:
;	None.
;	Destroys:
;	A, BC
; -----------------------------------------------------------------------------
VDP_WriteAndSkip:		; Ported
	call	VDP_SetAddress
	push	de
	ld.lil	de, SegaVRAM
	add	hl, de	
	pop	de

_:	; write the data to VRAM
	ld	(hl), a	
	; skip the next VRAM address
	inc	hl
	inc	hl
	
	; decrement BC and loop back if != 0
	ld	a, b
	or	c
	jr	nz, -_
	ret


; =============================================================================
;	VDP_Write(uint16 data, uint16 address, uint16 count)
; -----------------------------------------------------------------------------
;	Writes a 16 bit value to a section of VRAM.
; -----------------------------------------------------------------------------
;	In:
;	DE	- The value.
;	BC	- Number of words to write.
;	HL	- The address to start writing from.
;	Out:
;	None.
;	Destroys:
;	A, BC
; -----------------------------------------------------------------------------
VDP_Write:	; Ported
	call	VDP_SetAddress
	push	de
	ld.lil	de, SegaVRAM
	add	hl, de
	pop	de	

_:	; write the low-order byte
	ld	(hl), e
	push	af 
	pop	af
	inc	hl
	
	; write the hi-order byte
	ld	(hl), d
	
	; decrement BC and loop back if != 0
	dec	bc
	ld	a, b
	or	c
	jr	nz, -_
	cpl
	ld.s	(DrawTilemapTrig), a
	ret


; =============================================================================
;	VDP_Copy(uint16 src, uint16 dest, uint16 count)
; -----------------------------------------------------------------------------
;	Copies a block of data to VRAM.
; -----------------------------------------------------------------------------
;	In:
;	Hl	- Source address.
;	DE	- VRAM destination address.
;	BC	- Number of bytes to copy.
;	Out:
;	None.
;	Destroys:
;	A, BC, DE
; -----------------------------------------------------------------------------
VDP_Copy:	 ; Ported and optimized
	push	de
	ld.lil	de, SegaVRAM
	add	hl, de
	pop	de
	;copy the source to VDP RAM
	ldir
	ret

; =============================================================================
;	VDP_SetMode2Reg_DisplayOn()
; -----------------------------------------------------------------------------
;	Sets the VDP's Mode Control 2 register and turns the display on.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	Out:
;	None.
; -----------------------------------------------------------------------------
VDP_SetMode2Reg_DisplayOn:		; $1381
	;set register VDP(1) - mode control register 2
	ld	hl, VDPRegister1
	ld	a, (hl)
	;change all flags - make sure display is visible
	or	VDP_DisplayVisibleBit
	ld	(hl), a
	ret


; =============================================================================
;	VDP_SetMode2Reg_DisplayOff()
; -----------------------------------------------------------------------------
;	Sets the VDP's Mode Control 2 register but leaves the display turned off.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	Out:
;	None.
; -----------------------------------------------------------------------------
VDP_SetMode2Reg_DisplayOff:
	;set register VDP(1) - mode control register 2
	ld	hl, VDPRegister1
	ld	a, (hl)
	; set each of the flags except for the "Display Visible" bit
	; i.e. leave the display turned off
	and	$BF	;VDP_DisplayVisibleBit ~ $FF
	ld	(hl), a
	ret


; =============================================================================
;	VDP_EnableFrameInterrupt()
; -----------------------------------------------------------------------------
;	Sets the VDP's Mode Control 2 register, ensuring frame interrupts are 
;	enabled.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	Out:
;	None.
; -----------------------------------------------------------------------------
VDP_EnableFrameInterrupt:
	ld	hl, VDPRegister1
	ld	a, (hl)
	or	VDP_FrameInterruptsBit
	ld	(hl), a
	ret


; =============================================================================
;	VDP_DisableFrameInterrupt()						UNUSED
; -----------------------------------------------------------------------------
;	Sets the VDP's Mode Control 2 register, ensuring frame interrupts are 
;	disabled.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	Out:
;	None.
; -----------------------------------------------------------------------------
VDP_DisableFrameInterrupt:		; $13AA
	ld	hl, VDPRegister1
	ld	a, (hl)
	and	$DF	;VDP_FrameInterruptsBit ~ $FF
	ld	(hl), a
	ret


; =============================================================================
;	VDP_DrawText()
; -----------------------------------------------------------------------------
;	Copies char strings to the VDP. Disables interrupts. Calling functions
;	will need to re-enable interrupts afterwards.
; -----------------------------------------------------------------------------
;	In:
;	HL	- VRAM address.
;	DE	- Pointer to char data.
;	BC	- Char count.
;	Out:
;	None.
;	Destroys:
;	A, HL
; -----------------------------------------------------------------------------
VDP_DrawText:		; Ported and optimized
	di
	push	de
	ld.lil	de, SegaVRAM
	add	hl, de
	pop	de

	ex	de, hl
_:	ldi	;write a char to the VDP memory
	inc	de
	
	; copy the tile attribute byte to the VDP
	ld.s	a, (VDP_DefaultTileAttribs)
	ld	(de), a
	
	; increment the source pointer
	inc	hl
	
	;loop back if BC != 0
	ld	a, c
	or	b
	jr	nz, -_
	ret

; =============================================================================
;	VDP_UNKNOWN(uint16 vdp_address, uint16 char_ptr, uint16 count)	UNUSED
; -----------------------------------------------------------------------------
;	Unknown use. Copies chars to VDP. Seems to wait for a button press
;	before copying each char.
; -----------------------------------------------------------------------------
;	In:
;	HL	- VRAM address.
;	DE	- Pointer to char data.
;	BC	- Char count.
;	Out:
;	None.
;	Destroys:
;	A
; -----------------------------------------------------------------------------
LABEL_13D2:
	push	de
	push	bc
	
_:	ld	a, ($D292)
	bit	7, a
	jr	nz, +++_

	di
	
	call	VDP_SetAddress
 
	; copy a byte from RAM to VRAM
	push	de
	ld.lil	de, SegaVRAM
	add	hl, de
	ld	(hl), a
	inc	hl
	pop	de
	
	; copy the default tile attribs to VRAM
	ld	a, (VDP_DefaultTileAttribs)
	nop
	nop
	nop
	ld	(hl), a

	ei

	push	bc
	push	de
	push	hl

	; wait 6 frames for a button press?
	ld	b, $06
_:	ei
	halt
	ld.lil	a, (kbdG1)
	and	kbit2nd
	jr	nz, +_

	djnz	-_

_:	pop	hl
	pop	de
	pop	bc

	inc	hl
	inc	hl
	inc	de

	; decrement the counter and loop back if != 0
	dec	bc
	ld	a, c
	or	b
	jr	nz, ---_

_:	pop	bc
	pop	de
	ret


; =============================================================================
;	VDP_UpdateSAT()
; -----------------------------------------------------------------------------
;	Copies the working copy of the SAT, stored in RAM, to the VDP.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	Out:
;	None.
; -----------------------------------------------------------------------------
VDP_UpdateSAT:		; Ported
	; check the SAT update trigger. don't bother updating
	; if it is 0
	ld	hl, DrawSATTrig
	xor	a
	or.s	(hl)
	ret	z
	
	; reset the trigger
	ld.s	(hl), $00
	
	; check the frame counter. if it's odd do a descending update
	ld.s	a, (FrameCounter)
	rrca
	jp	c, VDP_UpdateSAT_Descending
	
	; copy 64 v-pos attributes to the VDP
	ld.lil	hl, VDP_WorkingSAT_VPOS + ramStart	;copy 64 VPOS bytes.
	ld.lil	de, SegaVRAM+$3F00
	ld	bc, $40
	ldir
	
	; copy 64 h-pos and char code attributes to the VDP
	ld.lil	hl, VDP_WorkingSAT_HPOS + ramStart
	ld.lil	de, SegaVRAM+$3F80
	ld	bc, $40
	ldir
	ld.s	(DrawSATTrig), a
	ret


VDP_UpdateSAT_Descending:	; Ported
	ld	(SaveSP), sp	
	; copy the 8 player sprites first (so that they always
	; appear on top).
	ld.lil	hl, VDP_WorkingSAT_VPOS + ramStart
	ld.lil	de, VDP_SATAddress
	ld	bc, $08
	ldir.l

	; copy the remaining 56 sprites in descending order
	ld.lil	hl, VDP_WorkingSAT_VPOS + $3F + ramStart
	ld.lil	de, VDP_SATAddress + $3F
	ld	bc, $38
	lddr.l

	; copy hpos and char codes for the 8 player sprites
	ld.lil	hl, VDP_WorkingSAT_HPOS + ramStart
	ld.lil	de, VDP_SATAddress + $80
	ld	bc, $10
	ldir.l

	; copy the remaining 56 hpos and char codes in descending order
	ld.lil	hl, VDP_WorkingSAT_HPOS + $7E + ramStart
	ld.lil	de, VDP_SATAddress + $87
	ld	b, 56
	ld	sp, -4

_:	ldi.l
	ldi.l
	add	hl, sp
	djnz	-_

	ld	sp, (SaveSP)
	ld	a, b
	ld.s	(DrawSATTrig), a
	ret


; =============================================================================
;	VDP_ClearScreenMap()							UNUSED
; -----------------------------------------------------------------------------
;	Clears the VDP's screen map memory
; -----------------------------------------------------------------------------
;	In:
;	None.
;	Out:
;	None.
; -----------------------------------------------------------------------------
VDP_ClearScreenMap:	 ; $179B
	; wait for one frame
	ei
	halt
	di

	; clear the VDP's screen map memory
	ld.lil	hl, VDP_ScreenMap	;address
	ld	bc, $0380		;count
	ld	de, $0000		;value
	call	VDP_Write
	jr	VDP_ClearSAT


; =============================================================================
;	VDP_ClearScreen
; -----------------------------------------------------------------------------
;	Clears the screen by resetting the first level tile ($2000) and setting the
;	screen map to the tile index.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	Out:
;	None.
;	Destroys:
;	A, BC, DE, HL
; -----------------------------------------------------------------------------
VDP_ClearScreen:	 ;$17AC
	ld.lil	hl, SegaVRAM+$2000		;clear the first level tile from VRAM (32-bytes starting at $2000)
	ld	bc, $0020
	ld	de, $0000
	call	VDP_Write
	ld.lil	hl, VDP_ScreenMap		;set up all background tiles to point to the first "level tile"
	ld	bc, $0380
	ld	de, $0100
	call	VDP_Write
	neg
	ld	(DrawTilemapTrig), a
	;FALL THROUGH

; =============================================================================
;	VDP_ClearSAT()
; -----------------------------------------------------------------------------
;	Clears the RAM copy of the SAT by setting each sprite's vpos attribute
;	to 240 then sets the SAT update trigger.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	Out:
;	None.
;	Destroys:
;	A, B, DE, HL
; -----------------------------------------------------------------------------
VDP_ClearSAT:	; Ported
	ld	hl, VDP_WorkingSAT_VPOS
	ld	de, VDP_WorkingSAT_HPOS
	xor	a
	
	; loop over the 64 sprites
	ld	b, $40
	
_:	; set the vpos and clear the hpos and char code
	ld	(hl), $F0
	inc	hl
	ld	(de), a
	inc	de
	ld	(de), a
	inc	de
	
	djnz	-_
	
	; flag the SAT update trigger
	ld	a, $FF
	ld	(DrawSATTrig), a
	
	ret

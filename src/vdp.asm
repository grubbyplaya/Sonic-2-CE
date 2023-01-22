#define	VDP_ScreenMap           $D43800
#define	VDP_SATAddress          $D43F00

; =============================================================================
;  VDP_InitRegisters()
; -----------------------------------------------------------------------------
;  Sets the VDP registers to known values.
; -----------------------------------------------------------------------------
;  In:
;	None.
;  Out:
;	None.
; -----------------------------------------------------------------------------
VDP_InitRegisters:
	;read/clear VDP status flags
	in	a, ($BF)
	; loop 11 times to copy to each register
	ld	b, $0B		; FIXME: more efficient to load BC with one opcode
	; load C with the first latch byte
	ld	c, $80
	; load DE with a pointer to the RAM cached copies 
	; of the VDP registers
	ld	de, VDPRegister0
	
	ld	hl, _VDP_InitRegisters_RegValues
	
	; loop over each register
_:	ld	a, (hl)
	ld   (Ports_VDP_Control), a
	ld	(de), a
	ld	a, c
	ld   (Ports_VDP_Control), a
	inc   c
	inc   de
	inc   hl
	djnz  -_
	
	ret

_VDP_InitRegisters_RegValues:
.db $26, $82, $FF, $FF, $FF, $FF, $FB, $00, $00, $00, $FF


; =============================================================================
;  VDP_SetRegister(uint8 register, uint8 data)			   UNUSED
; -----------------------------------------------------------------------------
;  Sets a VDP register.
; -----------------------------------------------------------------------------
;  In:
;	B   - The value.
;	C   - The register number.
;  Out:
;	None.
;  Destroys:
;	A
; -----------------------------------------------------------------------------
VDP_SetRegister:	; $1310
	push  bc
	push  hl
	
	;update the VDP Register
	ld	a, b
	ld   (Ports_VDP_Control), a
	ld	a, c
	or	$80
	ld   (Ports_VDP_Control), a
	
	;update the RAM copy
	ld	a, b
	ld	b, $00
	ld	hl, VDPRegister0
	add   hl, bc
	ld	(hl), a
	pop   hl
	pop   bc

	ret


; =============================================================================
;  VDP_ReadStatus()						  UNUSED
; -----------------------------------------------------------------------------
;  Reads the VDP status flags.
; -----------------------------------------------------------------------------
;  In:
;	None.
;  Out:
;	A   - The status byte.
; -----------------------------------------------------------------------------
VDP_ReadStatus:	 ; $1325
	in	a, (Ports_VDP_Control)
	ret


; =============================================================================
;  VDP_SetAddress(uint16 address)
; -----------------------------------------------------------------------------
;  Sets the VRAM address pointer.
; -----------------------------------------------------------------------------
;  In:
;	HL  - The new address.
;  Out:
;	None.
;  Destroys:
;	None.
; -----------------------------------------------------------------------------
VDP_SetAddress:	 ; $1328
	push  af
	
	ld	a, l
	ld   (Ports_VDP_Control), a
	ld	a, h
	or	$40
	ld   (Ports_VDP_Control), a
	
	pop   af
	
	ret


; =============================================================================
;  VDP_SendRead(uint16 address)
; -----------------------------------------------------------------------------
;  Sends a read command to the VDP.
; -----------------------------------------------------------------------------
;  In:
;	HL  - The address to read from.
;  Out:
;	None.
;  Destroys:
;	A
; -----------------------------------------------------------------------------
VDP_SendRead:	   ;$1333
	ld	a, l
	ld   (Ports_VDP_Control), a
	ld	a, h
	and   $3F
	ld   (Ports_VDP_Control), a
	
	push  af		; FIXME: pointless stack activity/timing related?
	pop   af
	
	ret


; =============================================================================
;  VDP_WriteByte(uint16 address, uint8 data)			 UNUSED
; -----------------------------------------------------------------------------
;  Sets the VDP address pointer and writes a value.
; -----------------------------------------------------------------------------
;  In:
;	A   - The data to write.
;	HL  - The address to read from.
;  Out:
;	None.
;  Destroys:
;	None.
; -----------------------------------------------------------------------------
VDP_WriteByte:	  ; $133E
	; set the VDP adderess pointer
	push  af		  ;FIXME: this push/pop is unnecessary as
	call  VDP_SetAddress	  ; VDP_SetAddress does the same thing.
	pop   af
	; write the data
	ld	(Ports_VDP_Data), a
	ret


; =============================================================================
;  VDP_ReadByte(uint16 address)					  UNUSED
; -----------------------------------------------------------------------------
;  Sets the VDP address pointer and reads a value.
; -----------------------------------------------------------------------------
;  In:
;	HL  - The address to read from.
;  Out:
;	A   - Data read from the address.
;  Destroys:
;	None.
; -----------------------------------------------------------------------------
VDP_ReadByte:	   ; $1346
	call  VDP_SendRead
	ld	a, (Ports_VDP_Data)
	ret


; =============================================================================
;  VDP_WriteAndSkip(uint8 data, uint16 address, uint16 count)	UNUSED
; -----------------------------------------------------------------------------
;  Writes a value to every other byte, starting from <address> (i.e. writes
;  one byte, skips the next address, writes a byte, skips...)
; -----------------------------------------------------------------------------
;  In:
;	A   - The data.
;	BC  - Number of bytes to write. When the function returns, the VRAM
;	  addess pointer will be HL + 2*BC.
;	HL  - The address to start writing from.
;  Out:
;	None.
;  Destroys:
;	A, BC
; -----------------------------------------------------------------------------
VDP_WriteAndSkip:	   ; $134C
	push  de
	
	push  af		;FIXME: this push/pop is unnecessary
	call  VDP_SetAddress
	pop   af
	
	ld	d, a
	
_:	ld	a, d
	; write the data to VRAM
	ld	(Ports_VDP_Data), a
	push  af
	pop   af
	
	; skip the next VRAM address
	ld	a, (Ports_VDP_Data)
	
	; decrement BC and loop back if != 0
	dec   bc
	ld	a, b
	or	c
	jr	nz, -_
	
	pop   de
	ret


; =============================================================================
;  VDP_Write(uint16 data, uint16 address, uint16 count)
; -----------------------------------------------------------------------------
;  Writes a 16 bit value to a section of VRAM.
; -----------------------------------------------------------------------------
;  In:
;	DE  - The value.
;	BC  - Number of words to write.
;	HL  - The address to start writing from.
;  Out:
;	None.
;  Destroys:
;	A, BC
; -----------------------------------------------------------------------------
VDP_Write:	;$1361
	call  VDP_SetAddress
	
_:	; write the low-order byte
	ld	a, e
	ld	(Ports_VDP_Data), a
	push  af 
	pop   af
	
	; write the hi-order byte
	ld	a, d
	ld	(Ports_VDP_Data+1), a
	
	; decrement BC and loop back if != 0
	dec   bc
	ld	a, b
	or	c
	jr	nz, -_

	ret


; =============================================================================
;  VDP_Copy(uint16 src, uint16 dest, uint16 count)
; -----------------------------------------------------------------------------
;  Copies a block of data to VRAM.
; -----------------------------------------------------------------------------
;  In:
;	Hl  - Source address.
;	DE  - VRAM destination address.
;	BC  - Number of bytes to copy.
;  Out:
;	None.
;  Destroys:
;	A, BC, DE
; -----------------------------------------------------------------------------
VDP_Copy:	 ;$1372
	ex	de, hl	 ;set the VRAM pointer
	call  VDP_SetAddress
	
_:	; read a byte from the source
	ld	a, (de)
	; ...and copy to the VDP
	ld	(Ports_VDP_Data), a
	
	; move the source pointer
	inc   de
	
	; decrement BC and loop back if != 0
	dec   bc
	ld	a, b
	or	c
	jr	nz, -_
	
	ret


; =============================================================================
;  VDP_SetMode2Reg_DisplayOn()
; -----------------------------------------------------------------------------
;  Sets the VDP's Mode Control 2 register and turns the display on.
; -----------------------------------------------------------------------------
;  In:
;	None.
;  Out:
;	None.
; -----------------------------------------------------------------------------
VDP_SetMode2Reg_DisplayOn:	  ; $1381
	;set register VDP(1) - mode control register 2
	ld	hl, VDPRegister1
	ld	a, (hl)
	;change all flags - make sure display is visible
	or	VDP_DisplayVisibleBit
	ld	(hl), a
	ld	(Ports_VDP_Control), a
	ld	a, $81
	ld	(Ports_VDP_Control+1), a
	ret


; =============================================================================
;  VDP_SetMode2Reg_DisplayOff()
; -----------------------------------------------------------------------------
;  Sets the VDP's Mode Control 2 register but leaves the display turned off.
; -----------------------------------------------------------------------------
;  In:
;	None.
;  Out:
;	None.
; -----------------------------------------------------------------------------
VDP_SetMode2Reg_DisplayOff:
	;set register VDP(1) - mode control register 2
	ld	hl, VDPRegister1
	ld	a, (hl)
	; set each of the flags except for the "Display Visible" bit
	; i.e. leave the display turned off
	and	VDP_DisplayVisibleBit = $FF
	ld	(hl), a
	
	ld	(Ports_VDP_Control), a
	ld	a, $81
	ld	(Ports_VDP_Control+1), a
	ret


; =============================================================================
;  VDP_EnableFrameInterrupt()
; -----------------------------------------------------------------------------
;  Sets the VDP's Mode Control 2 register, ensuring frame interrupts are 
;  enabled.
; -----------------------------------------------------------------------------
;  In:
;	None.
;  Out:
;	None.
; -----------------------------------------------------------------------------
VDP_EnableFrameInterrupt:
	ld	hl, VDPRegister1
	ld	a, (hl)
	or	VDP_FrameInterruptsBit
	ld	(hl), a
	ld	(Ports_VDP_Control), a
	ld	a, $81
	ld	(Ports_VDP_Control+1), a

	ret


; =============================================================================
;  VDP_DisableFrameInterrupt()					   UNUSED
; -----------------------------------------------------------------------------
;  Sets the VDP's Mode Control 2 register, ensuring frame interrupts are 
;  disabled.
; -----------------------------------------------------------------------------
;  In:
;	None.
;  Out:
;	None.
; -----------------------------------------------------------------------------
VDP_DisableFrameInterrupt:	  ; $13AA
	ld	hl, VDPRegister1
	ld	a, (hl)
	and	VDP_FrameInterruptsBit = $FF
	ld	(hl), a
	ld	(Ports_VDP_Control), a
	ld	a, $81
	ld	(Ports_VDP_Control+1), a
	ret


; =============================================================================
;  VDP_DrawText()
; -----------------------------------------------------------------------------
;  Copies char strings to the VDP. Disables interrupts. Calling functions
;  will need to re-enable interrupts afterwards.
; -----------------------------------------------------------------------------
;  In:
;	HL  - VRAM address.
;	DE  - Pointer to char data.
;	BC  - Char count.
;  Out:
;	None.
;  Destroys:
;	A
; -----------------------------------------------------------------------------
VDP_DrawText:	   ; $13B8
	di
	
	call	VDP_SetAddress
	
	push	de
	push	bc
	
_:	; copy a byte from RAM to the VDP
	ld	a, (de)
	ld	(Ports_VDP_Data), a	;write a char to the VDP memory
	
	; copy the tile attribute byte to the VDP
	ld	a, (VDP_DefaultTileAttribs)
	nop
	nop
	nop
	ld	(Ports_VDP_Data+1), a
	
	; increment the source pointer
	inc	de
	
	; decrement the counter and loop back if != 0
	dec	bc
	ld	a, c
	or	b
	jr	nz, -_

	pop	bc
	pop	de
	ret


; =============================================================================
;  VDP_UNKNOWN(uint16 vdp_address, uint16 char_ptr, uint16 count)	UNUSED
; -----------------------------------------------------------------------------
;  Unknown use. Copies chars to VDP. Seems to wait for a button press
;  before copying each char.
; -----------------------------------------------------------------------------
;  In:
;	HL  - VRAM address.
;	DE  - Pointer to char data.
;	BC  - Char count.
;  Out:
;	None.
;  Destroys:
;	A
; -----------------------------------------------------------------------------
LABEL_13D2:
	push	de
	push	bc
	
_:	ld	a, (gameMem+$D292)
	bit	7, a
	jr	nz, +++_

	di
	
	call	VDP_SetAddress
 
	; copy a byte from RAM to VRAM
	ld	a, (de)
	ld	(Ports_VDP_Data), a
	
	; copy the default tile attribs to VRAM
	ld	a, (VDP_DefaultTileAttribs)
	nop
	nop
	nop
	ld	(Ports_VDP_Data+1), a

	ei

	push	bc
	push	de
	push	hl

	; wait 6 frames for a button press?
	ld	b, $06
_:	ei
	halt
	ld	a, (gameMem+$D137)
	and	$80
	jr	nz, +_

	djnz  -_

_:	pop   hl
	pop   de
	pop   bc

	inc   hl
	inc   hl
	inc   de

	; decrement the counter and loop back if != 0
	dec   bc
	ld	a, c
	or	b
	jr	nz, ---_

_:	pop   bc
	pop   de
	ret


; =============================================================================
;  VDP_UpdateSAT()
; -----------------------------------------------------------------------------
;  Copies the working copy of the SAT, stored in RAM, to the VDP.
; -----------------------------------------------------------------------------
;  In:
;	None.
;  Out:
;	None.
; -----------------------------------------------------------------------------
VDP_UpdateSAT:	  ; PORTED
	; check the SAT update trigger. don't bother updating
	; if it is 0
	ld	hl, VDP_SATUpdateTrig
	xor	a
	or	(hl)
	ret	z
	
	; reset the trigger
	ld	(hl), $00
	
	; check the frame counter. if it's odd do a descending update
	ld	a, (FrameCounter)
	rrca
	jp	c, VDP_UpdateSAT_Descending
	
	; set the address pointer to the SAT
	ld	a, VDP_SATAddress & $FF
	ld	(VDP_SATAddress), a
	
	; copy 64 v-pos attributes to the VDP
	ld	hl, VDP_WorkingSAT_VPOS	   ;copy 64 VPOS bytes.
	ld	de, $D43F00
	ld	bc, $3F
	ldir

	;set VRAM pointer to SAT + $80
	ld	a, $80
	ld	(VDP_WorkingSAT + $80), a
	
	; copy 64 h-pos and char code attributes to the VDP
	ld	hl, VDP_WorkingSAT_HPOS
	ld	de, $D43F40
	ld	bc, $3F
	ldir
	ret


VDP_UpdateSAT_Descending:	; PORTED
	; set the address pointer to the SAT
	ld	a, VDP_SATAddress & $FF
	ld	(VDP_SATAddress), a
	
	; copy the 8 player sprites first (so that they always
	; appear on top).
	ld	hl, VDP_WorkingSAT_VPOS
	ld	de, $D43F00
	ld	bc, $07
	ldir

	; copy the remaining 56 sprites in descending order
	ld	hl, VDP_WorkingSAT_VPOS + $3F
	ld	de, $D43F3F	   ; FIXME - opcode not required
	ld	bc, $38
	lddr

	; set address pointer to SAT + $80
	ld	a, $80
	ld	(VDP_SATAddress + $80), a
	
	; copy hpos and char codes for the 8 player sprites
	ld	hl, VDP_WorkingSAT_HPOS
	ld	de, $D43F40
	ld	bc, $0F
	ldir

	; copy the remaining 56 hpos and char codes in descending order
	ld	hl, VDP_WorkingSAT_HPOS + $7E
	ld	de, $D43FBE
	ld	bc, -4

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc

	ldi
	ldi
	add	hl, bc
	ret


; =============================================================================
;  VDP_ClearScreenMap()						  UNUSED
; -----------------------------------------------------------------------------
;  Clears the VDP's screen map memory
; -----------------------------------------------------------------------------
;  In:
;	None.
;  Out:
;	None.
; -----------------------------------------------------------------------------
VDP_ClearScreenMap:	 ; $179B
	; wait for one frame
	ei
	halt
	di

	; clear the VDP's screen map memory
	ld	hl, VDP_ScreenMap  ;address
	ld	bc, $0380	  ;count
	ld	de, $0000	  ;value
	call	VDP_Write
	jr	VDP_ClearSAT


; =============================================================================
;  VDP_ClearScreen
; -----------------------------------------------------------------------------
;  Clears the screen by resetting the first level tile (gameMem+$2000) and setting the
;  screen map to the tile index.
; -----------------------------------------------------------------------------
;  In:
;	None.
;  Out:
;	None.
;  Destroys:
;	A, BC, DE, HL
; -----------------------------------------------------------------------------
VDP_ClearScreen:	 ;$17AC
	ei
	halt
	di
	ld	hl, $D42000	  ;clear the first level tile from VRAM (32-bytes starting at $2000)
	ld	bc, $0020
	ld	de, $0000
	call	VDP_Write
	ld	hl, ScreenMap	  ;set up all background tiles to point to the first "level tile"
	ld	bc, $0380
	ld	de, $0100
	call	VDP_Write


; =============================================================================
;  VDP_ClearSAT()
; -----------------------------------------------------------------------------
;  Clears the RAM copy of the SAT by setting each sprite's vpos attribute
;  to 240 then sets the SAT update trigger.
; -----------------------------------------------------------------------------
;  In:
;	None.
;  Out:
;	None.
;  Destroys:
;	A, B, DE, HL
; -----------------------------------------------------------------------------
VDP_ClearSAT:	; $17C7
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
	ld	(VDP_SATUpdateTrig), a

	ret

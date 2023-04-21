; =============================================================================
;  MACRO: wait_1s()
; -----------------------------------------------------------------------------
;  Halts the CPU for 60 frames (1 second on NTSC machines).
; -----------------------------------------------------------------------------
;  In:
;	None.
;  Out:
;	None.
; -----------------------------------------------------------------------------

#macro wait_1s
	ld	a, ($F30000)
	ld	b, a
_:	ld	a, ($F30000)
	cp	b
	jr	z, -_
#endmacro

#macro wait_1s_og	;replaced for timing reasons
	ld	b, Time_1Second
_:	ei
	halt
	djnz	-_
#endmacro
; =============================================================================
;  MACRO: Engine_FillMemory(uint8 value)
; -----------------------------------------------------------------------------
;  Fills work RAM ($C001 to $DFF0) with the specified value.
; -----------------------------------------------------------------------------
;  In:
;	value - The value to copy to memory.
;  Out:
;	None.
; -----------------------------------------------------------------------------
#macro Engine_FillMemory args value
	ld	hl, gameMem+$C001
	ld	de, gameMem+$C002
	ld	bc, $1FEE
	ld	(hl), value
	ldir
#endmacro


; =============================================================================
;  MACRO: PaletteIx(uint16 palette_addr)
; -----------------------------------------------------------------------------
;  Calculates a palette index given its address. The palette address must be
;  greater than the "Palettes" label.
; -----------------------------------------------------------------------------
;  In:
;	palette_addr - Palette address.
;  Out:
;	None.
; -----------------------------------------------------------------------------
#macro PaletteIx args palette_addr
	#ifdef palette_addr <= Palettes
		.echo "Specified palette address ($"
		.echo palette_addr
		.echo "is not within range.\n"
	#endif
	.db ((palette_addr - Palettes) / 16)
#endmacro

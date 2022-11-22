; =============================================================================
;  MACRO: wait_1s()
; -----------------------------------------------------------------------------
;  Halts the CPU for 60 frames (1 second on NTSC machines).
; -----------------------------------------------------------------------------
;  In:
;    None.
;  Out:
;    None.
; -----------------------------------------------------------------------------

#macro wait_1s
    ld    b, Time_1Second
    ei
    halt
    djnz  - wait_1s
#endmacro

; =============================================================================
;  MACRO: Engine_FillMemory(uint8 value)
; -----------------------------------------------------------------------------
;  Fills work RAM ($C001 to $DFF0) with the specified value.
; -----------------------------------------------------------------------------
;  In:
;    value - The value to copy to memory.
;  Out:
;    None.
; -----------------------------------------------------------------------------
#macro Engine_FillMemory args value
    ld    hl, $C001
    ld    de, $C002
    ld    bc, $1FEE
    ld    (hl), value
    ldir
#endmacro


; =============================================================================
;  MACRO: PaletteIx(uint16 palette_addr)
; -----------------------------------------------------------------------------
;  Calculates a palette index given its address. The palette address must be
;  greater than the "Palettes" label.
; -----------------------------------------------------------------------------
;  In:
;    palette_addr - Palette address.
;  Out:
;    None.
; -----------------------------------------------------------------------------
#macro PaletteIx args palette_addr
    #ifdef palette_addr <= Palettes
        .echo "Specified palette address ($"
        .printv palette_addr
        .echo "is not within range.\n"
        ret
    #endif
    .db ((palette_addr - Palettes) / 16)
#endmacro

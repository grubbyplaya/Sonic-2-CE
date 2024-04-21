.ASSUME ADL=0
;**********************************
;*	Variables
;**********************************
#define	CursorPos	$D2C2
#define	HoldTime	$D46A	;keep a track of how long up/down buttons are held

LevelSelectMenu:
LABEL_A2C:
	di
	call	Engine_ClearVRAM
	call	LevelSelect_LoadFont
	call	Engine_ClearLevelAttributes
	call	Engine_ClearWorkingVRAM
	ld	a, $01			;tile attributes
	ld	(VDP_DefaultTileAttribs), a
	ld.lil	hl, SegaVRAM+$3808	;VRAM destination
	ld	de, LevelSelect_Title	;source data
	ld	bc, 24	;char count
	call	VDP_DrawText
	jr	LevelSelect_DrawEntries

LevelSelect_TextEntries:
.dw LevelSelect_Entry1
.dw LevelSelect_Entry4
.dw LevelSelect_Entry7
.dw LevelSelect_Entry10
.dw LevelSelect_Entry13
.dw LevelSelect_Entry16
.dw LevelSelect_Entry19

LevelSelect_VRAMEntries:
 .dw $3888
 .dw $3948
 .dw $3A08
 .dw $3AC8
 .dw $3B88
 .dw $3C48
 .dw $3D08

LevelSelect_DrawEntries:
	ld	ix, LevelSelect_TextEntries
	ld	iy, LevelSelect_VRAMEntries
	ld	b, 7
	;draw Act 1 text
_:	push	bc
	ld	hl, (iy)
	push	hl
	ld.lil	de, SegaVRAM
	add.lil	hl, de
	ld	de, (ix)
	ld	bc, 24
	call	VDP_DrawText

	;draw Act 2 text
	pop	hl
	push	hl
	ld.lil	de, SegaVRAM+$0066
	add.lil	hl, de
	ld	de, Act2Text
	ld	c, 5
	call	VDP_DrawText

	;draw Act 3 text
	pop	hl
	ld.lil	de, SegaVRAM+$00A6
	add.lil	hl, de
	ld	de, Act3Text
	ld	c, 5
	call	VDP_DrawText
	lea	ix, ix+2	;LEA IX, IX+2 is more efficient than INC IX \ INC IX
	lea	iy, iy+2	;same with IY
	pop	bc
	djnz	-_
LevelSelect_FinishSetup:
	ld	hl, $D4E6
	ld	(hl), $00
	set	7, (hl)
	inc	hl
	ld	(hl), $02
	ld	hl, $D4E8
	ld	(hl), $00
	set	7, (hl)
	inc	hl
	ld	(hl), $02
	ei
	xor	a
	ld	(CursorPos), a
	call	LevelSelect_MainLoop
	ld	a, (CursorPos)
	add	a, a
	ld	e, a
	ld	d, $00
	ld	hl, LevelSelect_Values
	add	hl, de
	ld	a, (hl)
	ld	(CurrentLevel), a
	inc	hl
	ld	a, (hl)
	ld	(CurrentAct), a
	ret

LevelSelect_Values:
.db $00, $00	;Under Ground Zone - Act 1
.db $00, $01	;Under Ground Zone - Act 2
.db $00, $02	;Under Ground Zone - Act 3
.db $01, $00	;Sky High Zone - Act 1
.db $01, $01	;Sky High Zone - Act 2
.db $01, $02	;Sky High Zone - Act 3
.db $02, $00	;Aqua Lake Zone - Act 1
.db $02, $01	;Aqua Lake Zone - Act 2
.db $02, $02	;Aqua Lake Zone - Act 3
.db $03, $00	;Green Hills Zone - Act 1
.db $03, $01	;Green Hills Zone - Act 2
.db $03, $02	;Green Hills Zone - Act 3
.db $04, $00	;Gimmick Mt. Zone - Act 1
.db $04, $01	;Gimmick Mt. Zone - Act 2
.db $04, $02	;Gimmick Mt. Zone - Act 3
.db $05, $00	;Scrambled Egg Zone - Act 1
.db $05, $01	;Scrambled Egg Zone - Act 2
.db $05, $02	;Scrambled Egg Zone - Act 3
.db $06, $00	;Crystal Egg Zone - Act 1
.db $06, $01	;Crystal Egg Zone - Act 2
.db $06, $02	;Crystal Egg Zone - Act 3

LevelSelect_MainLoop:	;0E46
	ei
	halt
	di
	call	_CheckInput
	call	_DrawCursor
	ld	a, (Engine_InputFlags)
	bit	BTN_2_BIT, a
	jr	z, +_
	ld	a, $3F
	ld	(EmeraldFlags), a
_:	bit	BTN_1_BIT, a
	jr	z, LevelSelect_MainLoop
	ld	a, $FF
	ld	($D294), a
	ret

_CheckInput:	;$0E5C
	ld	a, (Engine_InputFlagsLast)
	bit	BTN_UP_BIT, a
	jr	nz, _MoveCursorUp
	bit	BTN_DOWN_BIT, a
	jr	nz, _MoveCursorDown
	ld	a, (Engine_InputFlags)
	and	BTN_UP | BTN_DOWN	;check to see if up/down buttons are held
	jr	z, _ResetCursorVelocity	;nothing held - reset cursor velocity
	ld	a, (HoldTime)
	inc 	a
	ld	(HoldTime), a
	cp	$28
	ret 	c							;cap cursor velocity at $27
	ld	a, $26
	ld	(HoldTime), a
	ld	a, (Engine_InputFlags)
	bit	BTN_UP_BIT, a
	jr	nz, _MoveCursorUp
	bit	BTN_DOWN_BIT, a
	jr	nz, _MoveCursorDown
	ret

_ResetCursorVelocity:	;$0E89
	xor	a
	ld	(HoldTime), a
	ret

_MoveCursorUp:
	ld	a, (CursorPos)
	or	a
	ret	z
	dec	a
	ld	(CursorPos), a
	ld	a, $03
	ld	(DrawTilemapTrig), a
	ret

_MoveCursorDown:
	ld	a, (CursorPos)
	cp	$14
	ret	nc
	inc	a
	ld	(CursorPos), a
	ld	a, $03
	ld	(DrawTilemapTrig), a
	ret

_DrawCursor:
	ld	a, (CursorPos)
	ld	l, a				;calculate VRAM address
	ld	h, $40
	mlt	hl
	ld	de, $3878
	add	hl, de
	ld	de, _TileMappings	;source
	ld	bc, $0301			;rows/cols
	jp	Engine_LoadCardMappings	;copy to VRAM

_TileMappings:
.dw $0100	;tile used above the cursor
.dw $013C	;tile used for the cursor
.dw $0100	;tile used below the cursor

LevelSelect_Title:
.db " - SONIC THE HEDGEHOG - "

#if Language = 1

LevelSelect_Entry1:
.db "UNDER GROUND ZONE  ACT-1"

LevelSelect_Entry4:
.db "SKY HIGH ZONE      ACT-1"
	
LevelSelect_Entry7:
.db "AQUA LAKE ZONE     ACT-1"

LevelSelect_Entry10:
.db "GREEN HILLS ZONE   ACT-1"

LevelSelect_Entry13;
.db "GIMMICK MT. ZONE   ACT-1"

LevelSelect_Entry16:
.db "SCRAMBLED EGG ZONE ACT-1"

LevelSelect_Entry19:
.db "CRYSTAL EGG ZONE  	ACT-1"

#else Language = 2

LevelSelect_Entry1:
.db "ZONE SOUTERRAINE   ACT-1"

LevelSelect_Entry4:
.db "ZONE TRES HAUTE    ACT-1"
	
LevelSelect_Entry7:
.db "ZONE DU LAC AQUA   ACT-1"

LevelSelect_Entry10:
.db "ZONE COLLINE VERTE ACT-1"

LevelSelect_Entry13;
.db "ZONE MONT BIDULE   ACT-1"

LevelSelect_Entry16:
.db "ZONE OUEF BROUILLE ACT-1"

LevelSelect_Entry19:
.db "ZONE OUEF CRISTAL  ACT-1"

#endif

Act2Text:
.db "ACT-2"

Act3Text:
.db "ACT-3"

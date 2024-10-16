.assume ADL=0

#include	"includes/defines.asm"
#include	"includes/macros.asm"
#include	"includes/sms.asm"
#include	"includes/structures.asm"
#include	"includes/objects.asm"		;values for objects
#include	"includes/player_states.asm"	;values for player object state
#include	"includes/level_values.asm"
#include	"includes/memory_layout.asm"

;=====================================================================
;Changing the "Version" variable will determine which version
;of the ROM is built. Values are:
;	1 - for version 1.0
;	2 - for version 2.2
;
; NOTE: all addresses listed in this dissassembly refer to ver. 1.0
;

;some basic sense-checking on the version variable
#ifndef Version = 2
	#ifndef Version = 1
		.echo "FAIL: Invalid build version!"
	#endif
#endif
;=====================================================================
#define LevelDataStart		LevelLayout

#define BackgroundXScroll	$D172
#define BackgroundYScroll	$D173

#define CameraOffsetX		$D288
#define CameraOffsetY		$D289		;used for moving the camera when looking up or down

#define Score			$D29C		;score stored in 3-byte BCD

#define LevelTimerTrigger	$D2B8		;level timer update trigger
#define LevelTimer		$D2B9

#define IdleTimer		$D3B4

;Variables used by the continue screen
#define ContinueScreen_Count	$D2C4
#define ContinueScreen_Timer	$D2C3		;when this fires the countdown is decreased

;Variables used by demo levels
#define ControlByte		$D2D2		;holds a pointer to the controller byte to be copied into Engine_InputFlags
#define DemoNumber		$D2D7
#define DemoBank		$D2D8		;holds the bank number that $D2D2 points into. This should be paged in before dereferencing the pointer.
#define NextControlByte		$D2D9		;holds a pointer to the next controller byte to be copied into $D2D2


;Variables used by palette control/update routines
#define PaletteFadeTime		$D2C8	;TODO: Check this one
#define BgPaletteControl	$D4E6	;Triggers background palette fades (bit 6 = to black, bit 7 = to colour).
#define BgPaletteIndex		$D4E7	;Current background palette (index into array of palettes)
#define FgPaletteControl	$D4E8	;Triggers foreground palette fades (bit 6 = to black, bit 7 = to colour).
#define FgPaletteIndex		$D4E9	;Current foreground palette (index into array of palettes)

;VDP Values
#define ScreenMap		SegaVRAM+$3800		;location of the screen map (name table)
#define SAT			SegaVRAM+$3F00		;location of the Sprite Attribute Table
#define VDPRegister0		$D11E			;copies of the VDP registers stored in RAM
#define VDPRegister1		$D11F
#define VDPRegister2		$D120
#define VDPRegister3		$D121
#define VDPRegister4		$D122
#define VDPRegister5		$D123
#define VDPRegister6		$D124
#define VRAMPointer		$DE00			;emulated VDP address register
#define SaveSP			$DE02			;saves SPL value
#define SegaSP			$DE05			;saves SPS value

#define RenderedScreenMap	VRAM + (320*240)		;256*224 screen framebuffer
#define SegaVRAM		RenderedScreenMap + (256*224)	;Master System VDP RAM
#define SegaTileFlags		SegaVRAM + $4000		;flags for drawing tilemap
#define CRAM			mpLcdPalette
#define WorkingCRAM		$D4C6				;copy of Colour RAM maintained in work RAM.
#define ColorDepth		$DC41


#define DATA_B30_9841		$E000
#define DATA_B30_9A41		$E200

#define BankSlot2		$8000				;ROM bank slot 2.
#define LastLevel		$07
#define LastBankNumber		1 << 5 - 1			; must be 2^n-1 since it is used in AND ops

_START:
	call.lil StoreBankPointers + romStart
	jp	Engine_Initialise

.FILL 47, $00

; =============================================================================
; Engine_Interrupt()
; -----------------------------------------------------------------------------
;	Maskable interrupt handler. Determines the interrupt type and despatches to 
;	the correct handler.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_Interrupt:
	di
	jp	Engine_HandleVBlank

.FILL $29, $00

; =============================================================================
; Engine_NMI()
; -----------------------------------------------------------------------------
;	Non-Maskable interrupt handler. Stub function that immediately calls the 
;	pause handler.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------

Engine_NMI:
	ret

; =============================================================================
; Engine_ErrorTrap()
; -----------------------------------------------------------------------------
;	Error handler function that quickly scribbles some text to VRAM before 
;	jumping to 0.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------

_error_msg:
	.db "ERROR"

Engine_ErrorTrap:		;$0073
	call	VDP_ClearScreen
	ld	a, $01
	ld	(VDP_DefaultTileAttribs), a
	ld	hl, $3A4C		;scribble to this vram address
	ld	de, _error_msg
	ld	bc, $05
	call	VDP_DrawText

	; hang for 180 frames
	ld	b, Time_3Seconds
_:	call	Engine_WaitForInterrupt
	djnz	-_
	jp	_START

.db "MS SONIC", $A5, "THE", $A5, "HEDGEHOG.2 "
#if Version = 2
	.db "Ver2.20 1992/12/09"
#else
	.db "Ver1.00 1992/09/05"
#endif

.db " SEGA /Aspect Co.,Ltd "

.FILL $2E, $00
; =============================================================================
;	Tile Mirroring Lookup Table
; -----------------------------------------------------------------------------
#include "byte_flip_lut.asm"


; =============================================================================
;	Object Logic Jump Table
; -----------------------------------------------------------------------------
#include "logic_jump_table.asm"

DATA_330:
.db $00, $03, $06, $09, $0C, $0F, $12, $15
.db $19, $1C, $1F, $22, $25, $28, $2B, $2E
.db $31, $34, $36, $39, $3C, $3F, $42, $44
.db $47, $49, $4C, $4F, $51, $53, $56, $58
.db $5A, $5C, $5F, $61, $63, $65, $67, $68
.db $6A, $6C, $6E, $6F, $71, $72, $73, $75
.db $76, $77, $78, $79, $7A, $7B, $7C, $7D
.db $7D, $7E, $7E, $7F, $7F, $7F, $7F, $7F
.db $7F, $7F, $7F, $7F, $7F, $7E, $7E, $7D
.db $7D, $7C, $7B, $7B, $7A, $79, $78, $77
.db $75, $74, $73, $71, $70, $6E, $6D, $6B
.db $69, $68, $66, $64, $62, $60, $5E, $5B
.db $59, $57, $55, $52, $50, $4D, $4B, $48
.db $46, $43, $40, $3D, $3B, $38, $35, $32
.db $2F, $2C, $29, $26, $23, $20, $1D, $1A
.db $17, $14, $11, $0E, $0B, $07, $04, $01
.db $00, $FF, $FC, $F9, $F5, $F2, $EF, $EC
.db $E9, $E6, $E3, $E0, $DD, $DA, $D7, $D4
.db $D1, $CE, $CB, $C8, $C5, $C3, $C0, $BD
.db $BA, $B8, $B5, $B3, $B0, $AE, $AB, $A9
.db $A7, $A5, $A2, $A0, $9E, $9C, $9A, $98
.db $97, $95, $93, $92, $90, $8F, $8D, $8C
.db $8B, $89, $88, $87, $86, $85, $85, $84
.db $83, $83, $82, $82, $81, $81, $81, $81
.db $81, $81, $81, $81, $81, $81, $82, $82
.db $83, $83, $84, $85, $86, $87, $88, $89
.db $8A, $8B, $8D, $8E, $8F, $91, $92, $94
.db $96, $98, $99, $9B, $9D, $9F, $A1, $A4
.db $A6, $A8, $AA, $AD, $AF, $B1, $B4, $B7
.db $B9, $BC, $BE, $C1, $C4, $C7, $CA, $CC
.db $CF, $D2, $D5, $D8, $DB, $DE, $E1, $E4
.db $E7, $EB, $EE, $F1, $F4, $F7, $FA, $FD

; =============================================================================
;	Engine_Reset()
; -----------------------------------------------------------------------------
;	Soft reset. Executed if the reset button is pressed.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_Reset:		; $0431
	di
	; reset the stack pointer
	ld	sp, $DFF0
	
	; init the VDP
	call	VDP_SetMode2Reg_DisplayOff
	
	ld	a, (EmeraldFlags)

	; initialise work RAM
	ld	hl, $C000
	ld	de, $C001
	ld	bc, $1B00
	ldir

	ld	(EmeraldFlags), a

	call	Engine_ClearVRAM
	call	Engine_ClearPaletteRAM
	
	; reset the paging registers
	xor	a
	ld	(Frame2Page), a
	; FALL THROUGH


; =============================================================================
;	Engine_Initialise()
; -----------------------------------------------------------------------------
;	Initialises the hardware.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------

Engine_Initialise:
	;clear screen?
	call	Engine_ClearPaletteRAM

	call	LoadSHCScreen

	;call	LoadSave
	call	Engine_LoadLevelTiles  
	call	LevelSelectCheck
	call	VDP_SetMode2Reg_DisplayOn

LABEL_472:
	ld	hl, $D292
	set	6, (hl)
	ld	a, $04			;set the palette fade timeout value (will fade every 4th VBLANK)
	ld	($D2C8), a
	call	ChangeGameMode
	di
	call	Engine_ClearVRAM
	call	Engine_ClearWorkingVRAM
	xor	a
	ld	($D292), a
	call	Engine_InitCounters
	call	Engine_WaitForInterrupt	
	ld	hl, GlobalTriggers
	ld	(hl), GT_GAMEOVER | GT_TITLECARD
	jp	Engine_CheckGlobalTriggers

LevelSelectCheck:
	ld.lil	a, (kbdG7)
	and	kbdLeft
	ret	z
	ld	(LevelSelectTrg), a
	ret

; =============================================================================
;	Engine_HandleVBlank()
; -----------------------------------------------------------------------------
;	V-Blank interrupt handler.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_HandleVBlank:		; $04A5
; -------------------------------------
;	V-blank Prologue
	push	af
	ex	af, af'
	push	af
	push	bc
	push	de
	push	hl
	exx
	push	bc
	push	de
	push	hl
	push	ix
	push	iy
; -------------------------------------
	; if this trigger is set we should update VDP colour RAM
	; and nothing else
	ld	a, (UpdatePalettesOnly)
	or	a
	jp	nz, Engine_HandleVBlank_PalettesOnly
	
	ld	a, ($D136)
	or	a
	jp	nz, Engine_HandleVBlank_Epilogue

	ld	a, (Frame2Page)
	ld	($FFFF), a
	call	VDP_SetMode2Reg_DisplayOff	;update VDP mode control register 2
	
	ld	bc, $0000
	ld	a, ($D290)			;do we need to adjust the background scroll values?
	or	a
	jr	z, +_
	
	dec	a
	ld	($D290), a
	
	and	$06
	ld	e, a
	ld	d, $00
	ld	hl, ScrollAdjustValues
	add	hl, de
	ld	c, (hl)
	inc	hl
	ld	b, (hl)

	; Set the background X-scroll value (write to register VDP(8))
_:	ld	hl, (VDP_HScroll)
	ld	ix, DrawTilemapTrig
	ld	a, (BackgroundXScroll)
	add	a, b			;apply adjustment value
	cp	l
	jr	z, +_
	set	1, (ix)
_:	ld	(VDP_HScroll), a
	
	; Set the background Y-scroll value (write to register VDP(9))
	ld	a, (BackgroundYScroll)
	add	a, c			;apply adjustment value
	cp	h
	jr	z, +_
	set	1, (ix)
_:	ld	(VDP_VScroll), a

	; fetch the level viewport flags
	ld	a, (LevelAttributes.ViewportFlags)
	
	
	; check to see if camera viewport update is required
	bit	LVP_CAMERA_UPDATE_RQD, a
	jr	z, +_
	
	; clear the "Update" bit
	res	LVP_CAMERA_UPDATE_RQD, a
	ld	(LevelAttributes.ViewportFlags), a
	
	ld	ix, LevelAttributes
	
	; is VRAM row update required?
	bit	LVP_ROW_UPDATE_PENDING, (ix + LevelDescriptor.ViewportFlags)		
	call	nz, Engine_CopyMappingsToVRAM_Row
	
	; is VRAM col update required?
	bit	LVP_COL_UPDATE_PENDING, (ix + LevelDescriptor.ViewportFlags)		
	call	nz, Engine_CopyMappingsToVRAM_Column
	
	ld	hl, ($D284)		;update viewport position
	ld	(Camera_X), hl
	ld	hl, ($D286)
	ld	(Camera_Y), hl

_:	call	VDP_UpdateSAT
	call	Engine_AnimateRingArt
	call	Engine_CopyPalettes
	call	VDP_SetMode2Reg_DisplayOn
	call	ReadInput
	call	Engine_LoadPlayerTiles

	ld	a, (GlobalTriggers)
	bit	1, a			;check whether game is paused
	jr	nz, Engine_HandleVBlank_Epilogue
	
	;call the palette update code
	call	Palette_Update

	ld	a, (GlobalTriggers)
	bit	GT_GAMEOVER_BIT, a
	jr	z, Engine_HandleVBlank_Epilogue
	bit	GT_TITLECARD_BIT, a
	jr	nz, Engine_HandleVBlank_Epilogue

	ld	a, 31
 	call	Engine_SwapFrame2
	call	Engine_UpdateSpriteAttribs
	call	Engine_UpdateSpriteAttribsArt
	call	Engine_UpdateCyclingPalettes

Engine_HandleVBlank_Epilogue:
	ld	a, ($D292)
	or	a
	call	nz, LABEL_59E_218

	call	Engine_Timer_Increment	;increment the act timer

	;increment the frame counter
	ld	hl, FrameCounter
	inc	(hl)

	ld	hl, Engine_InterruptServiced
	inc	(hl)

	ld	hl, (CurrentLevel)
	ld	de, $0109
	or	a
	sbc	hl, de
	jr	z, +_
	ld	a, ($FFFF)
	call	Engine_SwapFrame2

_:	ld.lil	hl, $E30028
	ld.lil	(hl), $08
	ld.lil	sp, $D1A745		;reset SPL

	; -------------------------------------
	; VBlank Epilogue
	pop	iy
	pop	ix
	pop	hl
	pop	de
	pop	bc
	exx
	pop	hl
	pop	de
	pop	bc
	pop	af
	ex	af, af'
	pop	af
	ei
	ret

Engine_HandleVBlank_PalettesOnly:		; $058D
	call	Palette_Update
	call	Engine_CopyPalettes
	jp	Engine_HandleVBlank_Epilogue


; =============================================================================
;	Engine_WaitForInterrupt()
; -----------------------------------------------------------------------------
;	Blocks until the next interrupt has been serviced.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_WaitForInterrupt:		; $0593
	di

	call	StoreRegisters
	ld	a, (FrameCounter)
	rra
	call	c, DrawScreen		;draw the last interrupt's frame
	call	RestoreRegisters

	ei
	; loop until the next interrupt has been serviced
	push	hl
	push	af
	ld	hl, Engine_InterruptServiced
_:	ld	a, (hl)
	or	a
	jr	z, -_
	xor	a
	ld	(hl), a
	pop	af
	pop	hl
	ret

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

wait_1s:	;wait a second
	ld	b, Time_1Second
_:	call	Engine_WaitForInterrupt
	djnz	-_
	ret

LABEL_59E_218:
	ld	a, ($D157)
	and	$30
	ret	z
	ld	hl, $D292
	set	7, (hl)
	ret

; Data from 5AA to 5B1 (8 bytes)
ScrollAdjustValues:
_DATA_05AA:
.db $FE, $00, $FE, $FE, $02, $02, $00, $02

Engine_PauseHandler:
	;the SMS pause button triggers an NMI for one frame.
	;since it's the only SMS button to do that, we'll
	;try to mimic that behavior first.
	bit	6, (hl)
	ret	nz
	set	6, (hl)
	ld	a, 3
	ld	(DrawTilemapTrig), a

	ld	a, (BgPaletteControl)
	or	a
	jr	nz, +_
	
	ld	a, ($D292)
	or	a
	jr	nz, +_
	
	ld	a, (GlobalTriggers)
	and	$FD
	cp	GT_GAMEOVER
	jr	nz, +_
	
	ld	a, $FF
	ld	($D12E), a
_:	ret

PauseHandler_Trig:
.db $00


Engine_CheckGlobalTriggers:	; $0690
	call	Engine_WaitForInterrupt
	ld	a, (GlobalTriggers)
	
	; check GT_END_SEQUENCE : ending sequence trigger
	rlca
	jr	c, GameState_EndSequence
	
	; check GT_GAMEOVER : game over/continue trigger
	rlca
	jp	nc, GameState_Gameover
	
	; check GT_NEXT_ACT_BIT : load next act trigger
	rlca
	jp	c, GameState_NextAct
	
	; check GT_NEXT_LEVEL : load next level trigger
	rlca
	jp	c, GameState_NextZone
	
	; check GT_KILL_PLAYER : kill player trigger
	rlca
	jp	c, GameState_KillPlayer
	
	; check GT_TITLECARD : load level titlecard
	rlca
	jp	c, GameState_Titlecard
	
	rlca
	jp	c, LABEL_9C4
	
	call	Engine_UpdateLevelState
	call	LABEL_A13
	jp	Engine_CheckGlobalTriggers

;run the ending sequence
GameState_EndSequence:
	call	Engine_LoadLevel		;load the level
	call	Engine_LoadLevelPalette
	call	Engine_ReleaseCamera
	
	call	LABEL_6F3
	xor	a
	ld	(Engine_DynPalette_0), a
	ld	(Engine_DynPalette_1), a
	
	; fade out over 1 second
	call	PaletteFadeOut
	call	wait_1s
	jp	EvaluateGame	


LABEL_6F3:						;ending credits sequence
	ld	a, $5D
	ld	($D700), a
	ld	a, Object_Sonic
	ld	(Player.ObjID), a
	ld	a, PlayerState_EndSeq_Init
	ld	(Player.StateNext), a

	xor	a			;reset the level timer update trigger
	ld	(LevelTimerTrigger), a
	ld	a, $0D	;set up the cycling palette
	ld	(Engine_DynPalette_0), a

	ld	a, 29
	call	Engine_SwapFrame2
	call	LABEL_B29_B400			; move the last 16 sprites in the SAT off of the screen.
	ld	hl, $012C
	ld	($D46F), hl

_:	call	Engine_WaitForInterrupt
	call	Engine_UpdateLevelState
	ld	a, 29
	call	Engine_SwapFrame2
	call	LABEL_B29_B40C
	ld	a, ($D701)
	cp	$06
	jr	nz, -_
	ret

EvaluateGame:		;display game results
	ld.lil	hl, (EvalGamePTR)
	jp.lil	(hl)

GameState_Gameover:	; $072F
	xor	a
	call	Engine_WaitForInterrupt
	call	Engine_ClearVRAM
	call	Engine_ClearWorkingVRAM
	call	Engine_ClearLevelAttributes
	call	GameState_CheckContinue		;load the continue screen if required
	ld	a, ($D2BD)		;load the "Game Over" screen if bit 7 of $D2BD is reset.
	bit	7, a
	jr	nz, GameState_DoContinue
	call	GameOverScreen_DrawScreen

	; wait for 2 seconds
	ld	b, Time_2Seconds
_:	call	Engine_WaitForInterrupt
	djnz	-_
	
	ld	bc, $0D98
	call	Engine_WaitForInterrupt
	ld	a, (Engine_Inputflags)		;check to see if 2nd/alpha button is pressed
	and	$30
	jr	nz, +_
	dec	bc
	ld	a, b
	or	c
	jr	nz, -_
	
_:	; fade out over 1 second
	call	PaletteFadeOut
 	call	wait_1s
	
	jp	LABEL_472


GameState_DoContinue:		; $0777
	ld	a, 3
	ld	(LifeCounter), a
	xor	a
	ld	($D29C), a
	ld	($D29D), a
	ld	($D29E), a
	
	ld	hl, GlobalTriggers
	res	GT_KILL_PLAYER_BIT, (hl)
	set	GT_TITLECARD_BIT, (hl)
	set	GT_GAMEOVER_BIT, (hl)
	jp	Engine_CheckGlobalTriggers


GameState_CheckContinue:		; $0792
	ld	hl, $D2BD
	res	7, (hl)
	ld	a, (hl)
	or	a
	ret	z
	xor	a					;reset the timer
	ld	(ContinueScreen_Timer), a
	ld	a, 9				;set the countdown to 9
	ld	(ContinueScreen_Count), a
	call	ContinueScreen_DrawScreen
	call	ContinueScreen_LoadNumberMappings
	
	; create the sonic object
	ld	ix, PlayerObj
	ld	(ix + Object.ObjID), Object_Sonic
	ld	(ix + Object.State), PlayerState_ContinueScreen
	ld	(ix + Object.StateNext), PlayerState_ContinueScreen
	call	Engine_UpdatePlayerObjectState	
	
	ld	hl, GlobalTriggers
	set	GT_GAMEOVER_BIT, (hl)
	call	ContinueScreen_MainLoop
	ld	hl, GlobalTriggers
	res	GT_GAMEOVER_BIT, (hl)
	
	; fade out over 1 second
	call	PaletteFadeOut
 	call	wait_1s
	ret


ContinueScreen_MainLoop:		;7DB
	call	Engine_WaitForInterrupt
	call	Engine_UpdatePlayerObjectState
	
	; check to see if button 1/2 is pressed
	ld	a, (Engine_InputFlagsLast)
	and	BTN_1 | BTN_2
	jr	nz, +_

	ld	hl, ContinueScreen_Timer	;increase the timer
	inc	(hl)
	ld	a, (hl)
	cp	$5A			;if the timer = $5A, decrement the countdown
	jr	c, ContinueScreen_MainLoop

	ld	(hl), $00
	inc	hl
	dec	(hl)
	ld	a, (hl)
	cp	$FF			;countown expired
	ret	z

	call	ContinueScreen_LoadNumberMappings
	jr	ContinueScreen_MainLoop
	
_:	ld	hl, ContinueCounter
	res	7, (hl)
	dec	(hl)
	set	7, (hl)

	; execute for 3 seconds
	ld	b, Time_3Seconds
_:	push	bc
	call	Engine_WaitForInterrupt
	call	Engine_UpdatePlayerObjectState
	pop	bc
	djnz	-_
	ret

LABEL_81D:
	jp	Engine_CheckGlobalTriggers


GameState_NextAct:		; $0820

	call	LABEL_A27			;reset LevelTimerTrigger
	call	Engine_CheckHasEmerald
	
	; wait for 3 seconds
	ld	b, Time_3Seconds
_:	call	Engine_WaitForInterrupt
	djnz	-_
	
	; store number of lives when starting the act. this is used
	; by the signpost object to calculate whether to display the
	; tails sign.
	ld	a, (LifeCounter)
	ld	(LivesOnEntry), a
	
	; reset dynamic palette numbers
	call	Engine_ClearAuxLevelHeader
	
	call	PaletteFadeOut	;trigger FG & BG palette fade to black
	ld	b, $1E
_:	call	Engine_WaitForInterrupt
	djnz	-_

	call	Engine_ClearWorkingVRAM		;clear various blocks of RAM & prepare the SAT
	call	Engine_ClearLevelAttributes
	call	Engine_ClearVRAM
	call	Score_CalculateActTimeScore
	call	TitleCard_LoadAndDraw	;also deals with loading score card tiles

	ld	hl, GlobalTriggers
	set	GT_TITLECARD_BIT, (hl)
	call	ScoreCard_UpdateScore
	
	; wait for 1 second
 	call	wait_1s
	
	;fade out for 1 second
	call	PaletteFadeOut
	call	wait_1s
	
	ld	hl, GlobalTriggers
	res	GT_NEXT_ACT_BIT, (hl)
	;increment the act counter
	ld	a, (CurrentAct)
	inc	a
	ld	(CurrentAct), a
	
	jp	Engine_CheckGlobalTriggers



; =============================================================================
;	Engine_CheckHasEmerald()
; -----------------------------------------------------------------------------
;	Checks to see if the "has emerald" trigger has been set and, if so, sets
;	the relevant bit in the emeralds bitfield.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_CheckHasEmerald:	; $0878
	ld	a, (HasEmeraldTrg)
	or	a
	ret	z
	
	; add a continue?
	ld	a, ($D2BD)
	inc	a
	ld	($D2BD), a
	
	; set the EmeraldFlags bit corresponding to
	; the current level.
	ld	a, (CurrentLevel)
	inc	a
	ld	b, a
	xor	a
	scf
_:	rla
	djnz	-_
	ld	b, a
	ld	a, (EmeraldFlags)
	or	b
	ld	(EmeraldFlags), a
	
	xor	a
	ld	(HasEmeraldTrg), a
	ret


GameState_NextZone:	; $089B
	call	LABEL_A27
	call	Engine_CheckHasEmerald
	ld	bc, $012C

LABEL_8A4:
	push	bc
	call	Engine_WaitForInterrupt
	call	Engine_UpdateLevelState
	pop	bc
	dec	bc
	ld	a, b
	or	c
	jr	nz, LABEL_8A4
	xor	a				;stop music
	ld	($DD03), a
	
	; reset dynamic palette numbers
	call	Engine_ClearAuxLevelHeader
	
	call	PaletteFadeOut
	ld	b, Time_1Second/2
_:	call	Engine_WaitForInterrupt
	djnz	-_
	call	Engine_ClearWorkingVRAM
	call	Engine_ClearLevelAttributes
	call	Engine_ClearVRAM
	call	Score_CalculateActTimeScore
	call	TitleCard_LoadAndDraw

	ld	hl, GlobalTriggers
	res	GT_NEXT_LEVEL_BIT, (hl)
	set	GT_TITLECARD_BIT, (hl)
	call	ScoreCard_UpdateScore
	
	; wait for 1 second
 	call	wait_1s
	
	; fade out for 1 second
	call	PaletteFadeOut
	call	wait_1s
	
	;reset the act counter & increment level counter
	xor	a
	ld	(CurrentAct), a
	ld	(HasEmeraldTrg), a
	ld	a, (CurrentLevel)
	inc	a
	ld	(CurrentLevel), a
	cp	$06
	jr	c, ++_
	jr	z, +_
	ld	a, ($D2C5)
	and	$3F
	cp	$3F
	jr	nz, LABEL_91B
	ld	a, $01
	ld	(CurrentAct), a
	jr	LABEL_91B

_:	ld	a, ($D2C5)
	and	$1F
	cp	$1F
	jr	nz, LABEL_91B
	
_:	jp	Engine_CheckGlobalTriggers
	
LABEL_91B:	;play ending sequence
	ld	a, Level_End
	ld	(CurrentLevel), a
	ld	hl, GlobalTriggers
	res	GT_NEXT_LEVEL_BIT, (hl)
	res	GT_TITLECARD_BIT, (hl)
	set	GT_END_SEQUENCE_BIT, (hl)
	jp	Engine_CheckGlobalTriggers


GameState_KillPlayer:		; $092A
	call	LABEL_A27
	ld	hl, LifeCounter
	dec	(hl)
	call	Engine_CapLifeCounterValue

_:	call	Engine_WaitForInterrupt
	call	Engine_UpdatePlayerObjectState
	
	; make sure that the player object is in the correct state
	ld	a, (Player.StateNext)
	cp	PlayerState_LostLife
	jr	z, +_
	ld	a, PlayerState_LostLife
	ld	(Player.StateNext), a
	
_:	; check player's onscreen position
	ld	a, (Player.ScreenY + 1)
	cp	2
	jr	nz, --_	

	; wait for 2 seconds
	ld	b, Time_2Seconds
_:	call	Engine_WaitForInterrupt
	djnz	-_
	;FALL THROUGH

Engine_ResetLevel:
	; reset dynamic palette numbers
	call	Engine_ClearAuxLevelHeader
	
	; fade out for 1 second
	call	PaletteFadeOut
	call	wait_1s
	
	ld	a, (LifeCounter)
	or	a
	jr	z, +_

	ld	hl, GlobalTriggers
	res	GT_KILL_PLAYER_BIT, (hl)
	set	GT_TITLECARD_BIT, (hl)
	call	Engine_ClearVRAM
	jp	Engine_CheckGlobalTriggers


_:	ld	hl, GlobalTriggers
	res	GT_GAMEOVER_BIT, (hl)
	jp	Engine_CheckGlobalTriggers



GameState_Titlecard:		; $097F
	call	Engine_ClearVRAM
	call	Engine_ClearWorkingVRAM
	call	TitleCard_LoadAndDraw
	call	ScrollingText_UpdateSprites
	
	; fade out over 42 frames
	call	PaletteFadeOut
	ld	b, 42
_:	call	Engine_WaitForInterrupt
	djnz	-_
	
	call	Engine_LoadLevel
	call	Engine_CapLifeCounterValue
	call	Engine_UpdateRingCounterSprites
	call	Engine_Timer_SetSprites
	call	Engine_LoadLevelPalette
	call	Engine_ReleaseCamera

	ld	a, (CurrentLevel)	;check to see if we're on ALZ-2 and set the water level
	cp	Level_ALZ
	jr	nz, +_

	ld	a, (CurrentAct)
	dec	a
	jr	nz, +_
	ld	hl, $0100			;set water level
	ld	($D4A4), hl

_:	; reset the titlecard trigger bit
	ld	hl, GlobalTriggers
	res	GT_TITLECARD_BIT, (hl)
	jp	Engine_CheckGlobalTriggers


LABEL_9C4:
	xor	a
	ld	(LevelTimerTrigger), a
_:	ld	a, ($D12E)
	or	a
	jr	z, -_
	xor	a
	ld	($D12E), a

	cpl	;set level timer update trigger
	ld	(LevelTimerTrigger), a

	ld	hl, GlobalTriggers
	res	GT_BIT_1, (hl)
	call	Engine_WaitForInterrupt
	jp	Engine_CheckGlobalTriggers



;************************************************************************
;*	This subroutine deals with updating the state of the level.	*
;*	This includes camera, objects, any level specific features	*
;*	(such as the SHZ2 wind) and any PLCs.				*
;************************************************************************
Engine_UpdateLevelState:			;$9E4
	ld	ix, $D15E		;load the pointer to the level descriptor
	bit	6, (ix+0)
	ret	nz
	call	Engine_UpdateCameraPos
	di
	call	Engine_UpdatePlayerObjectState
	ei
	call	Engine_UpdateAllObjects
	call	Engine_HandlePLC
	call	Engine_UpdateSHZ2Wind
	
	ld	a, ($D2D6)
	and	$0B
	jr	nz, +_			;update object layout every 11th frame

	ld	a, 30			;load the level's sprite layout
	call	Engine_SwapFrame2
	call	Engine_UpdateObjectLayout
	
_:	ld	hl, $D2D6
	inc	(hl)
	ret

LABEL_A13:
	ld	a, ($D12E)
	or	a
	ret	z
	xor	a
	ld	($D12E), a
	
	ld	hl, GlobalTriggers
	set	GT_BIT_1, (hl)
	ret

LABEL_A27:
	ld	de, (LevelTimer)
	ld	ix, CurrentLevel
	ld	l, (ix)
	ld	h, 6
	mlt	hl
	ld	a, (ix+1)
	add	a, a
	ld	c, a
	ld	b, 0
	add	hl, bc
	ld	bc, LevelTimerTable
	add	hl, bc
	ld	(hl), e
	inc	hl
	ld	(hl), d
	xor	a		;reset timer update trigger
	ld	(LevelTimerTrigger), a
	ret


#include "level_select.asm"


_Load_Intro_Level:
	di
	call	Engine_ClearLevelAttributes
	ld	a, Level_Intro
	ld	(CurrentLevel), a
	xor	a
	ld	(CurrentAct), a
	di
	call	Engine_LoadLevel			;load the level

	ld	a, $7C
	ld	($D288), a
	ld	a, $74
	ld	($D289), a
	call	Engine_CalculateCameraBounds		;setup screen offsets

	di
	ld	a, $08
	call	Engine_SwapFrame2			;load background scenery
	ld	hl, $0200
	call	VDP_SetAddress
	ld	hl, Art_Intro_Scenery
	xor	a
	call	LoadTiles

	ld	a, 19			;load tails tiles
	call	Engine_SwapFrame2

	ld	hl, $0800
	call	VDP_SetAddress
	ld	hl, Art_Intro_Tails
	xor	a
	call	LoadTiles

	ld	hl, $0B40	;load robotnik tiles
	call	VDP_SetAddress
	ld	hl, Art_Intro_Tails_Eggman
	xor	a
	call	LoadTiles

	di
	; set horizontal scroll value
	ld	a, $2C
	ld	(VDP_HScroll), a
	ld	a, $5F
	ld	($D740), a
	ld	a, $1C
	ld	($D7C0), a
	ld	a, $1D
	ld	($D800), a
	ld	($D840), a 
	call	Engine_LoadLevelPalette
	
	ld	a, GT_GAMEOVER
	ld	(GlobalTriggers), a
	
	call	Engine_ReleaseCamera

LABEL_F41:
	call	Engine_WaitForInterrupt
	call	LABEL_107C
	call	Engine_UpdateLevelState
	
	ld	hl, (Player.X)
	inc	hl
	ld	(Player.X), hl
	
	ld	bc, $0170
	xor	a
	sbc	hl, bc
	jr	c, LABEL_F41

	ld	a, $1E
	ld	($D780), a

	ld	bc, $030C
_:	call	LABEL_107C
	push	bc
	call	Engine_WaitForInterrupt
	call	Engine_UpdateLevelState
	pop	bc
	dec	bc
	ld	a, b
	or	c
	jr	nz, -_

	ld	a, PlayerState_16
	ld	(Player.StateNext), a
	call	Engine_LockCamera

	ld	bc, $0078
_:	call	LABEL_107C
	push	bc
	call	Engine_WaitForInterrupt
	call	Engine_UpdateLevelState
	pop	bc
	dec	bc
	ld	a, b
	or	c
	jr	nz, -_

	ld	bc, $003C
_:	call	LABEL_107C
	push	bc
	call	Engine_WaitForInterrupt
	call	Engine_UpdateLevelState
	pop	bc
	dec	bc
	ld	a, b
	or	c
	jr	nz, -_

	xor	a
	ld	($D700), a
	ret


_Load_Title_Level:
	di
	call	Engine_ClearLevelAttributes
	call	Engine_ClearWorkingVRAM
	ld	a, Level_Intro
	ld	(CurrentLevel), a
	ld	a, 1
	ld	(CurrentAct), a
	call	Engine_LoadLevel
	
LABEL_FB9:
	di
	call	Engine_ClearVRAM
	ld	a, 24
	call	Engine_SwapFrame2	;page in bank 24
	ld	hl, $2000
	call	VDP_SetAddress
	ld	hl, Art_Title_Screen	;title screen compressed art
	call	LoadTiles		;load the tiles into VRAM
	
	ld	a, $08
	call	Engine_SwapFrame2	;page in bank 08.

	ld	hl, $38CC		;destination
	ld	de, Mappings_Title	;source
	ld	bc, $1214		;row/col count
	call	Engine_LoadCardMappings	;load the mappings into VRAM

	ld	a, $2C			;set the background scroll values
	ld	(BackgroundYScroll), a	
	ld	a, $F8
	ld	(BackgroundXScroll), a
	di

	ld	hl, $DB00	;clear the working SAT
	ld	de, $DB01
	ld	bc, $00BF
	ld	(hl), $00
	ldir

	; clear the first object
	xor	a
	ld	(Player.ObjID), a

	ld	a, $08
	call	Engine_SwapFrame2		;page in bank 08.

	ld	hl, $0200
	call	VDP_SetAddress
	ld	hl, Art_Title_Sonic_Hand	;load sonic's animated hand
	call	LoadTiles
	
	ld	hl, $05C0
	call	VDP_SetAddress
	ld	hl, Art_Title_Tails_Face	;load tails' animated eye
	call	LoadTiles
	
	ld	c, $50				;object number
	ld	h, $00
	call	Engine_AllocateObjectHighPriority		;set up the hand object
	
	ld	c, $51				;object number
	ld	h, $00
	call	Engine_AllocateObjectHighPriority	;set up the eye object
	
	call	Engine_LoadLevelPalette
	ld	a, GT_GAMEOVER
	ld	(GlobalTriggers), a
	
	xor	a
	ld	(FrameCounter), a		;reset the frame counter

	; wait for .5 sec
	ld	bc, Time_1Second/2
_:	push	bc
	call	Engine_WaitForInterrupt
	call	Engine_UpdateLevelState
	call	TitleScreen_ChangePressStartText
	pop	bc
	dec	bc
	ld	a, b
	or	c
	jr	nz, -_
	
	ld	bc, $04B0
_:	call	LABEL_107C
	push	bc
	ei
	halt
	di
	ld	a, (FrameCounter)
	rra
	call	c, DrawScreen

	call	Engine_UpdateLevelState
	call	TitleScreen_ChangePressStartText
	pop	bc
	dec	bc	
	ld	a, b
	or	c
	jr	nz, -_
	ret	


TitleScreen_ChangePressStartText:		; $1060
	;page in the bank containing the mappings	
	ld	a, 08	 
	call	Engine_SwapFrame2

	ld	a, ($D12F)			;get the frame counter value
	
	ld	de, Mappings_Title + $258	;"Press Start Button" text mappings
	
	and	$20				;alternate between "Press Start Button" and blank
	jr	z, +_				;row every 32nd frame

	ld	de, Mappings_Title		;title screen mappings
_:	ld	hl, $3C8C			;vram destination
	ld	bc, $0114			;rows/cols
	;load the mappings into VRAM
	jp	Engine_LoadCardMappings

LABEL_107C:
	ld	hl, $D292
	bit	7, (hl)
	ret	z
	pop	af
	ret	

LABEL_1084:
;loads the player sprite tiles into VRAM
Engine_LoadPlayerTiles:	;$10BF
	ld	a, ($D34E)
	and	$A0
	cp	$A0			;check for bits 5 & 7
	ret	nz
	ld	a, ($D34F)		;which sprite?
	or	a
	jr	z, Engine_ClearPlayerTiles
	ld	l, a			;calculate offset (aligned to 4-byte)
	ld	h, $04
	mlt	hl
	ld	de, Data_PlayerSprites - $04
	ld	a, ($D34E)
	bit	6, a			;if bit 6 is set the sprite is facing left
	jr	z, +_
	ld	de, Data_PlayerSprites_Mirrored - $04
_:	add	hl, de

	ld	a, 31
	call.lil GetDataPTR + romStart
	ld.lil	a, (hl)			;bank number
	inc.lil	hl
	ld.lil	e, (hl)			;art pointer
	inc.lil	hl
	ld.lil	d, (hl)
	inc.lil	hl
	ld.lil	b, (hl)			;tile count / 2 (each sprite is 8x16)
	ld	c, $40
	mlt	bc
	ex	de, hl
 	call.lil GetDataPTR + romStart		;calculate new pointer for HL

	ld.lil	de, SegaVRAM
Engine_LoadPlayerTiles_CopyTiles:	;copy 2 tiles (64 bytes) to vram
	ldir.lil
	ld	hl, $D34E
	res	7, (hl)
	ret

;************************************************
;* Resets the tile patterns in VRAM.		*
;************************************************
Engine_ClearPlayerTiles:
	ld.lil	hl, SegaVRAM
	ld.lil	de, SegaVRAM+1
	ld	bc, $01FF
	ld.lil	(hl), $00
	ldir.lil
	ret

	
;updates sprite art flags + frame index
Engine_UpdateSpriteAttribsArt:			;$1274
	ld	hl, $D34E
	ld	a, ($D504)
	rlca
	rlca
	and	$40
	or	$20
	ld	(hl), a
	ld	a, ($D350)
	cp	(hl)
	jr	z, +_
	ld	a, (hl)
	ld	($D350), a
	set	7, (hl)
_:	ld	a, ($D34F)
	ld	b, a
	ld	a, ($D506)
	cp	b
	ret	z
	ld	($D34F), a	;animation frame art to load
	set	7, (hl)		;set the "sprite art update required" flag
	ret


Engine_SwapFrame2:
LABEL_129C:
	cp	4		;return if bank <= 4
	ret	c

	push	bc
	ld	b, a		;store bank page
	ld	a, r		;are interrupts enabled?
	jp	pe, +_	
	ld	a, $FF
	ld	($DF20), a
_:	ld	a, (Frame2Page)
	cp	b		;are we changing the ROM bank?
	ld	a, b
	pop	bc
	ret	z		;return if we aren't
	ld	(Frame2Page), a
	di
	jp.lil	CheckForBank+romStart
Engine_ResetInterruptFlag:
	xor	a
	ld	($DF20), a
	ret

PaletteFadeOut:
LABEL_12C8:
	ld	hl, BgPaletteControl
	ld	(hl), $00
	set	6, (hl)	;flag - background palette fade to black.
	inc	hl
	inc	hl
	ld	(hl), $00
	set	6, (hl)	;flag - foreground palette fade to black.
	ret

; =============================================================================
;	Engine_CopyPalettes()
; -----------------------------------------------------------------------------
;	Copies the colour data stored in RAM to the VDP.
;	CE - Converts CRAM data to 16bpp and copies it to the LCD controller.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
;	Destroys:
;
; -----------------------------------------------------------------------------
Engine_CopyPalettes:		; $12D6
	;check the Palette_UpdateTrig flag
	ld	a, (Palette_UpdateTrig)
	or	a
	ret	z			;don't update if the flag is 0
	ld.lil	de, CRAM
	exx
	ld	b, $20
	ld.lil	de, WorkingCRAM+romStart

_:	push	bc
	ld	a, (de)	
	ld	l, a
	ld	h, $00
	add	hl, hl
	ld.lil	bc, SMS_Palette+romStart
	add.lil	hl, bc
	push.lil hl
	exx
	pop.lil	hl
	ld	bc, $0002
	ldir.lil
	exx
	inc.lil	de
	pop	bc
	djnz	-_

	;reset the Palette_UpdateTrig flag
	xor	a
	ld	(Palette_UpdateTrig), a
	ret

SMS_Palette:	;SMS palette converted to 16bpp
	#include "sms_palette.asm"

; =============================================================================
;	VDP Routines
; -----------------------------------------------------------------------------
#include "vdp.asm"


; =============================================================================
;	Engine_UpdateSpriteAttribs()
; -----------------------------------------------------------------------------
;	Updates the sprites for each active object. Checks their onscreen positions
;	and updates the (working copy) SAT. Any unused/inactive sprites are pushed
;	offscreen.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_UpdateSpriteAttribs:	;$17DF
	; if on the ending sequence we need to preserve sprite attributes
	; for invalid/destroyed objects.
	ld	a, (GlobalTriggers)
	bit	GT_END_SEQUENCE_BIT, a
	jp	nz, Engine_UpdateSpriteAttribs_NoClear

	ld	ix, PlayerObj
	
	; initialise a pointer to the SAT v-pos attributes
	ld	hl, VDP_WorkingSAT_VPOS
	ld	(Engine_UpdateSpriteAttribs_vpos_ptr), hl
	
	; initialise a pointer to the SAT h-pos attributes
	ld	hl, VDP_WorkingSAT_HPOS
	ld	(Engine_UpdateSpriteAttribs_hpos_ptr), hl
	
	; number of objects to update
	ld	b, $14
	
_:	; check that the object is active (i.e. state != 0)
	xor	a
	or	(ix + Object.State)
	jr	z, ++_

	ld	a, (ix + Object.ObjID)		;get object type
	dec	a
	cp	$EF
	jr	nc, ++_
	
	push	bc

	ld	c, (ix + Object.Flags04)
	
	; is the object flashing?
	bit	OBJ_F4_FLASHING, c
	call	nz, Engine_ToggleSpriteVisible
	
	bit	OBJ_F4_VISIBLE, c		;set = object not drawn
	jr	nz, +_
	
	bit	OBJ_F4_BIT6, c			;set = object not drawn
	jr	nz, +_
	
	call	Engine_GetObjectScreenPos
	call	Engine_UpdateObjectVPOS
	call	Engine_UpdateObjectHPOS

_:	pop	bc

_:	;move to next object
	lea	ix, ix+$40
	djnz	---_
	
	
	; check to see if we have sprites that weren't updated
	ld	hl, (Engine_UpdateSpriteAttribs_vpos_ptr)
	ld	a, $32
	sub	l
	jr	c, +_

	; we have inactive sprites that werent updated.
	; move them offscreen
	inc	a
	
	; copy the count into BC
	ld	c, a
	ld	b, $00
	
	; copy the pointer into DE
	ld	e, l
	ld	d, h
	inc	de
	
	; any remaining sprites will be pushed offscreen
	; by setting their vpos attribute to 224
	ld	(hl), 224
	ldir

_:	; flag for a SAT update
	ld	a, $FF
	ld	(VDP_SATUpdateTrig), a
	ret


; =============================================================================
;	Engine_UpdateObjectVPOS(uint16 object_ptr)
; -----------------------------------------------------------------------------
;	Updates the v-pos attributes for each of the object's sprites.
; -----------------------------------------------------------------------------
;	In:
;	IX		- Pointer to object.
;	($D369) - Pointer to v-pos attribute in working SAT.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_UpdateObjectVPOS:		;$1842
	; fetch the v-pos pointer into IY
	ld	iy, (Engine_UpdateSpriteAttribs_vpos_ptr)		;SAT VPOS
	
	; read the vertical offset value from the anim mapping data
	ld	h, (ix + Object.SprOffsets + 1) 
	ld	l, (ix + Object.SprOffsets)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	
	; fetch the object's vertical position
	ld	l, (ix + Object.ScreenY)
	ld	h, (ix + Object.ScreenY + 1)
	
	; adjust the position with the offset value
	add	hl, de
	
	; store the adjusted value
	ld	(Engine_UpdateSpriteAttribs_adj_pos), hl
	
	
	exx
	; fetch the sprite mapping pointer & adjusted
	; position into the shadow DE and BC registers.
	ld	d, (ix + Object.SprMappgPtr + 1)
	ld	e, (ix + Object.SprMappgPtr)
	ld	bc, (Engine_UpdateSpriteAttribs_adj_pos)
	exx
	
	
	ld	a, (ix + Object.SpriteCount)		;sprite count
	; check that the object has at least one sprite
	or	a
	ret	z
	
	; iterate over each of the object's sprites
	ld	b, a 
			
_:	exx
	; get the mapping data for this sprite
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	inc	de
		
	; add the adjustment value to the mapping value
	add	hl, bc
		
	; store the result in the SAT
	ld	(iy + 0), l
		
	ld	a, 64
	add	a, l
	ld	l, a
	jr	nc, +_
		
	inc	h
		
_:	ld	a, h
	or	a
	jr	nz, +_
		
	ld	a, l
	cp	48
	jr	nc, ++_
		
_:	; push the sprite offscreen
	ld	(iy + 0), 224
	
	; move to the next sprite mapping entry
_:	inc	de
	inc	de
	; move to the next SAT vpos entry
	inc	iy
	exx
	
	; update the next sprite
	djnz	----_
	
	; store the current v-pos pointer
	ld	(Engine_UpdateSpriteAttribs_vpos_ptr), iy
	ret


; =============================================================================
;	Engine_UpdateObjectHPOS(uint16 object_ptr)
; -----------------------------------------------------------------------------
;	Updates the h-pos attributes for each of the object's sprites.
; -----------------------------------------------------------------------------
;	In:
;	IX		- Pointer to object.
;	($D369) - Pointer to h-pos attribute in working SAT.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_UpdateObjectHPOS:		;$1896
	; fetch the h-pos attribute pointer into IY
	ld	iy, (Engine_UpdateSpriteAttribs_hpos_ptr)		;SAT HPOS pointer
	
	; fetch the sprite offset pointer from the object structure
	ld	h, (ix + Object.SprOffsets + 1)
	ld	l, (ix + Object.SprOffsets)
	; adjust the pointer past the vertical offset word
	inc	hl
	inc	hl
	
	; read the horizontal offset value into DE
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	
	; check which direction the object is facing
	; if it's facing left we need to negate the offset value
	bit	OBJ_F4_FACING_LEFT, (ix + Object.Flags04)
	jr	z, +_
	
	; facing left - 2's comp the offset
	dec	de
	ld	a, d
	cpl	
	ld	d, a
	ld	a, e
	cpl	
	ld	e, a
	
_:	; get a pointer to the object's char codes...
	inc	hl
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	; ...and store it here
	ld	(Engine_ObjCharCodePtr), bc
	; fetch the object's onscreen x-coordinate
	ld	l, (ix + Object.ScreenX)
	ld	h, (ix + Object.ScreenX + 1)
	
	; add the horizontal adjustment value
	add	hl, de

	; store the adjusted value here
	ld	(Engine_UpdateSpriteAttribs_adj_pos), hl
	exx
	; fetch a pointer to the object's sprite mapping data
	ld	d, (ix + Object.SprMappgPtr + 1)
	ld	e, (ix + Object.SprMappgPtr)
	; skip past the v-pos value
	inc	de
	inc	de
	; check the object number. jump if we're dealing with the
	; player object
	ld	a, (ix + Object.ObjID)
	dec	a
	jr	z, +_
		
		; check which direction the object is facing
	bit	OBJ_F4_FACING_LEFT, (ix + Object.Flags04)
	jr	z, +_
		
	; object is facing left. update the pointer
	ld	hl, $046C
	add	hl, de
	ex	de, hl
		
_:	ld	bc, (Engine_UpdateSpriteAttribs_adj_pos)		;fetch the horizontal position value
	exx
	
	; check that the object has at least one sprite
	ld	a, (ix + Object.SpriteCount)
	or	a
	ret	z
	
	; iterate over each sprite
	ld	b, a
	
_:	exx
	; fetch the mapping data for this sprite
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	inc	de	
	; add the adjustment value
	add	hl, bc	
	; store the hpos attribute in the SAT
	ld	(iy+0), l	
	ld	a, h
	or	a
	jr	z, +_	
	; move the sprite offscreen
	ld	(iy+0), $00
		
_:	; move to the next entry in the mapping data
	inc	de
	inc	de	
	; move to the SAT char code for this sprite
	inc	iy
	; fetch the char code 
	ld	hl, (Engine_ObjCharCodePtr)
	ld	a, (hl)	
	; check which direction the object is facing
	bit	OBJ_F4_FACING_LEFT, (ix + Object.Flags04)
	jr	z, +_
	; object is facing left - add the VRAM index value
	add	a, (ix + Object.LeftFacingIdx)
	jr	++_
		
_:	; object is facing right - add the VRAM index value
	add	a, (ix + Object.RightFacingIdx)	
_:	; store the resulting char code in the SAT
	ld	(iy + $00), a
	; increment the char code pointer and store it
	inc	hl
	ld	(Engine_ObjCharCodePtr), hl	
	; move to the next SAT entry
	inc	iy
	exx
	; update the next sprite
	djnz	----_
	; store the h-pos entry pointer
	ld	(Engine_UpdateSpriteAttribs_hpos_ptr), iy
	ret


; =============================================================================
;	Engine_ToggleSpriteVisible(uint16 object_ptr)
; -----------------------------------------------------------------------------
;	Toggles object visibility depending on the value of the FlashCounter
;	variable.
; -----------------------------------------------------------------------------
;	In:
;	IX		- Pointer to object.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_ToggleSpriteVisible:	;$1923
	inc	(ix + Object.FlashCounter)
	ld	a, (ix + Object.FlashCounter)
	rrca
	rrca
	
	; hide sprite when bit 1 != 0
	jr	c, +_
	
	res	OBJ_F4_VISIBLE, (ix + Object.Flags04)
	ret
	
_:	set	OBJ_F4_VISIBLE, (ix + Object.Flags04)
	ret


; =============================================================================
;	Engine_UpdateSpriteAttribs_NoClear()
; -----------------------------------------------------------------------------
;	Updates the sprites for each active object. Checks their onscreen positions
;	and updates the (working copy) SAT. Does not affect unused/inactive sprites.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_UpdateSpriteAttribs_NoClear:		;$1937
	; fetch a pointer to the first object
	ld	ix, Engine_ObjectSlots
	
	; initialise the v-pos attribute pointer
	ld	hl, VDP_WorkingSAT_VPOS
	ld	(Engine_UpdateSpriteAttribs_vpos_ptr), hl
	
	; initialise the h-pos attribute pointer
	ld	hl, VDP_WorkingSAT_HPOS
	ld	(Engine_UpdateSpriteAttribs_hpos_ptr), hl

	; iterate over 16 objects
	ld	b, 16

_:	; check the object's state.
	xor	a
	or	(ix + Object.State)
	; dont update if the object is inactive
	jr	z, ++_

	ld	a, (ix + Object.ObjID)		;check object ID
	dec	a
	cp	$EF
	;dont update if object ID >= $F0
	jr	nc, ++_

	push	bc

	ld	c, (ix + Object.Flags04)
	bit	OBJ_F4_FLASHING, c
	call	nz, Engine_ToggleSpriteVisible
	
	bit	OBJ_F4_VISIBLE, c
	jr	nz, +_
	
	bit	OBJ_F4_BIT6, c
	jr	nz, +_
	
	call	Engine_GetObjectScreenPos
	call	Engine_UpdateObjectVPOS
	call	Engine_UpdateObjectHPOS

_:	pop	bc

_:	; move to the next object
	lea	ix, ix+$40
	djnz	---_

	ld	a, $FF
	ld	(VDP_SATUpdateTrig), a
	ret


; =============================================================================
;	Engine_LoadCardMappings(uint16 src, uint16 dest, uint8 rows, uint8 cols)
; -----------------------------------------------------------------------------
;	Copies title/score card mappings into VRAM.
; -----------------------------------------------------------------------------
;	In:
;	HL	- Destination VRAM address.
;	DE	- Source address.
;	B	- Row count.
;	C	- Column count.
;	ld:
;	None.
;	Destroys:
;	A, BC, DE, HL
; -----------------------------------------------------------------------------
Engine_LoadCardMappings:				;$197F
	;calculate vram address
	call	LABEL_19D7
	ld	a, 3
	ld	(DrawTilemapTrig), a
	; FALL THROUGH

Engine_LoadMappings:		;$1982
	push	bc
	push	hl
	ld	b, c

	push	de
	ld.lil	de, SegaVRAM
	add.lil	hl, de
	pop	de
	
.ASSUME ADL=1
	ex.il	de, hl
	push.il	de
	ld.il	de, romStart
	add.il	hl, de
	pop.il	de
.ASSUME ADL=0


_:	; write tile index
	ldi.lil
	; write attribute byte
	ldi.lil
	inc	bc
	inc	bc
	; if we've reached the last column in the row
	; loop back to the first
	ld	a, e
	and	$3F
	jr	nz, +_
	
.ASSUME ADL=1
	push.il	hl
	ex.il	de, hl
	ld.il	de, $0040
	or	a
	sbc.il	hl, de
	ex.il	de, hl
	pop.il	hl
.ASSUME ADL=0
	
_:	djnz	--_
	; move to the next row
	ex	de, hl
	pop	hl
	ld	bc, $0040
	add	hl, bc
	
	; make sure we dont overwrite the SAT
	ld	a, h
	cp	$3F
	jr	nz, +_
	ld	h, $38
	
_:	pop	bc				;move to the next row
	djnz	Engine_LoadMappings
	ei
	ret

LABEL_19D7:
	push	bc
	
	; take low-byte of VRAM address
	ld	a, l
	; AND with $C0 to remove the column address from the word
	and	$C0
	ld	b, a
	
	; get low-byte of camera X coordinate
	ld	a, (Camera_X)
	rrca
	rrca
	add	a, l
	and	$3E
	or	b
	ld	l, a
	push	hl
	
	; get low-byte of camera Y coordinate
	ld	a, (Camera_Y)	;vert. offset in level
	; rotate the subtile offset out of the byte
	rrca
	rrca
	rrca
	and	$1F
	; the accumulator now contains the tile row address
	rlca
	ld	c, a
	ld	b, 0
	ld	hl, Data_OffscreenBufferOffsets
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	pop	hl
	add	hl, bc
	ld	a, h
	cp	$3F
	jr	c, +_
	or	a
	ld	bc, $0700
	sbc	hl, bc
_:	pop	bc
	ret


;****************************************************************
;*	Updates a single mapping block to the screen after	*
;*	a change to the level layout (e.g. player collected	*
;*	a ring or destroyed a breakable block.)			*
;*	Copies each of the tiles in the block to VRAM.		*
;****************************************************************
Engine_UpdateMappingBlock:
	di
	call	LABEL_1A13	;calculate VRAM address
	ld	bc, $0404		;load a mapping block
	jp	Engine_LoadMappings

LABEL_1A13:
	ld	hl, (Cllsn_AdjustedY)	;collision vert. pos
	ld	a, l
	and	$E0			;cap at line 224
	ld	l, a			
	srl	h
	rr	l		;hl /= 2
	srl	h
	rr	l		;hl /= 2
	ld	bc, Data_OffscreenBufferOffsets
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	a, (Cllsn_AdjustedX)	;collision horiz. pos
	rrca
	rrca
	and	$38
	ld	l, a
	ld	h, $38		;offset into screen map
	add	hl, bc
	ret



ReadInput:	;$1A35
	ld	hl, $D145
	ld	de, $D146
	ld	bc, $000F
	lddr
	ld	hl, $D155
	ld	de, $D156
	ld	bc, $000F
	lddr
	ld	hl, Engine_InputFlags
	call	_Port1_Input
	ld	(hl), a				;store joypad bitfield
	ld	($D157), a

	ld	hl, Engine_InputFlagsLast
	ld	c, a
	ld	a, ($D138)
	cpl
	ld	b, a
	ld	a, c
	cpl
	xor	b
	and	c
	ld	(hl), a

	ld	a, ($D292)		;should cpu control sonic?
	bit	3, a
	call	nz, Engine_Demo_MovePlayer	;should the cpu control the player?

	ld.lil	a, (kbdG6)
	bit	kbitClear, a		;is the clear key pressed?
	jp.lil	nz, ExitGame		;exit the program if it is

	ld	hl, PauseHandler_Trig
	ld.lil	a, (kbdG1)
	bit	kbitMode, a		;is the X key pressed?
	jp	nz, Engine_PauseHandler	;emulate SMS start button if it is
	res	6, (hl)

	bit	kbitDel, a		;is the delete key pressed?
	ret	z
	jp	Engine_Reset		;reset the game if it is

_Port1_Input:	;$1A7A
	ld	de, 0
	ld.lil	a, (kbdG7)		;check arrow keys
	rla				;adjust bitmask
	bit	4, a			;is the up key pressed?
	jr	z, +_			;jump if it isn't
	xor	$11			;move the flag to bit 0			
_:	ld	d, a

	ld	e, $80
	ld.lil	a, (kbdG1)
	and	kbd2nd		;check button 1
	rra
	or	d
	ld	d, a

	ld.lil	a, (kbdG2)
	and	kbdAlpha	;check button 2
	rra
	rra
	or	d
	ret


; =============================================================================
;	Engine_Demo_MovePlayer()
; -----------------------------------------------------------------------------
;	Loads demo control sequence data into the controller flag variables.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_Demo_MovePlayer:	; $1A8C
	; page in the bank with the control sequences
	ld	a, (Engine_DemoSeq_Bank)
	call	Engine_SwapFrame2

	ld	hl, (ControlByte)	;fetch the offset (offset for the current control sequence within the bank)
	ld	a, h			;bail out if offset = 0
	or	l
	ret	z

	ld	a, (hl)			;load the control byte
	ld	(Engine_InputFlags), a	;and store it for later
	inc	hl
	ld	a, (hl)
	ld	(Engine_InputFlagsLast), a
	inc	hl

	ld	(ControlByte), hl	;fetch the next offset 
	ret


#include "tile_loading_routines.asm"

; =============================================================================
;	Engine_Multiply_8_by_8u(uint8 multiplier, uint8 multiplicand)	UNUSED
; -----------------------------------------------------------------------------
;	Multiplies two unsigned 8bit integers and returns the unsigned 16 bit
;	resut.
; -----------------------------------------------------------------------------
;	In:
;	H	- Multiplier
;	E	- Multiplicand.
;	ld:
;	HL	- Product.
;	Destroys:
;	A, B, D, HL
; -----------------------------------------------------------------------------
Engine_Multiply_8_by_8u:	;$1BDD
	ld	d, $00		;D = L = 0
	ld	l, d
	
	ld	b, $08		;loop 8 times	
_:	add	hl, hl
	jr	nc, +_
	
	add	hl, de
_:	djnz	--_

	ret


; =============================================================================
;	Engine_Divide_16_by_u8(uint8 Divisor, uint8 Dividend)	UNUSED
; -----------------------------------------------------------------------------
;	Divides a 16bit integer by an 8-bit unsigned integer.
; -----------------------------------------------------------------------------
;	In:
;	HL	- Dividend
;	E	- Divisor
;	ld:
;	HL	- Quotient.
;	Destroys:
;	A, B, HL
; -----------------------------------------------------------------------------
Engine_Divide_16_by_u8:		;$1BE9
	; loop 16 times
	ld	b, $10
	; clear carry
	xor	a
	
_:	add	hl, hl
	; rotate carry bit into A
	rla
	
	cp	e
	jr	c, +_
	
	sub	e
	set	0, l
	
_:	djnz	--_
	ret


;unused
LABEL_1BF7:
	ld	a, $10
_:	sla	e
	rl	d
	adc	hl, hl
	jr	c, +_
	
	sbc	hl, bc
	jr	nc, ++_
	
	add	hl, bc
	dec	a
	jr	nz, -_
	ret

_:	or	a
	sbc	hl, bc
_:	inc	e
	dec	a
	jr	nz, ---_
	ret


ScoreCard_UpdateScore:		;$1C12
_:	ld	a, (Engine_InputFlags)	;check for button press
	and	BTN_1 | BTN_2
	jr	nz, +_		;if not pressing a button, wait for 1 frame
	ei
	halt
	di
_:	call	Engine_WaitForInterrupt	
	ld	a, (RingCounter)
	or	a
	jr	z, +_

	dec	a		;decrement ring counter
	daa
	ld	(RingCounter), a
	
	ld	hl, Score_BadnikValue
	call	LABEL_1CD0		;update score value
	call	LABEL_1D4F		;update score graphics?
	call	LABEL_1D6F
	jr	--_
_:	; wait a second
 	call	wait_1s
	
_:	ld	a, (Engine_InputFlags)		;check for button press
	and	BTN_1 | BTN_2
	jr	nz, +_
	ei
	halt
	di
_:	call	Engine_WaitForInterrupt
	xor	a
	ld	de, $D2A2		;score time value
	ld	hl, Score_BadnikValue
	ld	a, (de)
	sbc	a, (hl)
	daa	
	ld	(de), a
	inc	de
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	daa
	ld	(de), a
	ld	hl, Score_BadnikValue
	call	LABEL_1CD0		;update score value
	call	LABEL_1D60
	call	LABEL_1D6F

	ld	hl, $D2A2
	ld	a, (hl)
	inc	hl
	or	(hl)
	jr	nz, --_
	ld	hl, FrameCounter
	set	1, (hl)
	call	Engine_WaitForInterrupt

	ld	hl, $3C2A		;vram address
	ld	de, ScoreCard_Mappings_Blank	;mapping source
	ld	bc, $0202		;rows,cols
	jp	Engine_LoadCardMappings

Score_AddBadnikValue:		;$1CB8
	ld	hl, Score_BadnikValue
	jp	LABEL_1CD0

Score_AddBossValue:		;$1CBE
	ld	hl, Score_BossValue
	jp	LABEL_1CD0

LABEL_1CC4:
	ld	hl, DATA_1E76
	jp	LABEL_1CD0

LABEL_1CCA:
	ld	hl, DATA_1E94
	jp	LABEL_1CD0


;Add the value pointed to by HL to the score
LABEL_1CD0:
	ld	a, ($D292)
	or	a
	ret	nz
	xor	a
	ld	de, Score
	ld	a, (de)
	adc	a, (hl)
	daa
	ld	(de), a	;update first BCD byte
	inc	de
	inc	hl
	ld	a, (de)
	adc	a, (hl)
	daa
	ld	(de), a	;update second BCD byte
	inc	de
	inc	hl
	ld	a, (de)
	adc	a, (hl)
	daa
	ld	(de), a	;update third BCD byte
	
	jr	nc, +_		;score overflow. cap at 999,990
	ld	hl, $D29F
	ld	(hl), $90
	inc	hl
	ld	(hl), $99
	inc	hl
	ld	(hl), $99
	ld	a, $02
	jr	++_
_:	ld	a, $01
_: 	ld	($D2B5), a
	call	LABEL_1D05
	jp	LABEL_1D34
		
LABEL_1D05: ;BCD subtraction subroutine
	xor	a
	ld	de, $D29E
	ld	hl, $D2A1
	ld	a, (de)
	sub	(hl)
	ret	c
	jr	z, +_
	jr	+++_
_:	dec	hl
	dec	de
	ld	a, (de)
	sub	(hl)
	ret	c
	jr	z, +_
	jr	++_
_:	dec	hl
	dec	de
	ld	a, (de)
	sub	(hl)
	ret	c
	jr	nc, +_
_:	ld	hl, Score
	ld	de, $D29F
	ld	bc, $0003
	ldir
	ld	a, $02
	ld	($D2B5), a
	ret

LABEL_1D34:
	ld	hl, $D2B6
	ld	a, (hl)
	or	a
	ret	nz
	ld	a, ($D29E)
	cp	$03
	ret	c
	ld	(hl), $01
	ld	hl, LifeCounter
	inc	(hl)
	ld	a, (GlobalTriggers)
	bit	GT_NEXT_LEVEL_BIT, a
	ret	nz
	jp	Engine_CapLifeCounterValue

LABEL_1D4F:
	di
	ld	a, $01
	ld	($D2B4), a
	ld	hl, RingCounter
	ld	de, $3BA4
	call	LABEL_1D7F
	ei
	ret

LABEL_1D60:
	di
	ld	a, $02
	ld	($D2B4), a
	ld	hl, $D2A2
	ld	de, $3C24
	call	LABEL_1D7F
LABEL_1D6F:
	ld	a, $03
	ld	($D2B4), a
	ld	hl, Score
	ld	de, $3CA0
	call	LABEL_1D7F
	ei
	ret

LABEL_1D7F:
	push	de
	push	hl
	ld	de, $D2A8
	ld	bc, $0007
	ldir	
	pop	hl
	call	Score_ConvertBCDtoASCI
	pop	hl
	ld	a, ($D2B4)
	cp	$02
	jr	c, ++_
	jr	z, +_
	ld	de, $D2B3
	ld	bc, $0605
	jr	LABEL_1DAF

_:	ld	de, $D2B1
	ld	bc, $0403
	jr	LABEL_1DAF

_:	ld	de, $D2AF
	ld	bc, $0201
	;FALL THROUGH

LABEL_1DAF:
	ld	($D11C), hl
_:	ld	a, c
	or	a
	jr	z, +_
	dec	c
	ld	a, (de)
	cp	$30
	jr	nz, +_
	ld	a, $3A
	jr	++_
_:	ld	c, $00
	ld	a, (de)
_:	push	bc
	sub	$30
	add	a, a
	add	a, a
	push	de

	di
	ld	hl, ($D11C)
	ld.lil	de, SegaVRAM
	add.lil	hl, de
	ex.lil	de, hl
	ld	hl, ScoreCard_Mappings_Numbers
	ld	c, a
	ld	b, $00
	add	hl, bc
	ld.lil	bc, romStart
	add.lil	hl, bc
	ldi.lil
	ldi.lil

	push.lil hl
	ld	hl, ($D11C)
	inc	hl
	inc	hl
	ld	($D11C), hl
	ld	de, $3E
	add	hl, de
	ld.lil	de, SegaVRAM
	add.lil	hl, de
	ex.lil	de, hl
	pop.lil	hl
	ldi.lil
	ldi.lil

	ei
	pop	de
	dec	de
	pop	bc
	djnz	---_
	ld	hl, DrawTilemapTrig
	ld	(hl), $03
	ret

;mappings for scorecard digits 0-9
ScoreCard_Mappings_Numbers:	;$1E07
.dw $114E, $1158
.dw $114F, $1159
.dw $1150, $115A
.dw $1151, $115B
.dw $1152, $115C
.dw $1153, $115B
.dw $1154, $1148
.dw $1155, $115D
.dw $1156, $1148
.dw $1157, $115B

;mappings for blank character
ScoreCard_Mappings_Blank:		;$1E2F
.dw $1170, $1170, $1170, $1170


;****************************************************************
;*	Convert the BCD value stored at $D2A8 to ASCII and	*
;*	store at $D2AE.						*
;*								*
;*	ld	($D2B4)		Number of bytes.		*
;*	ld	HALF		Half-carry set if BCD overflow. *
;*	destroys		A, BC, DE, HL			*
;****************************************************************
Score_ConvertBCDtoASCI:		;$1E37
	xor	a				;clear flags
	ld	hl, $D2A8		;BCD representation
	ld	de, $D2AE		;destination for ASCII representation
	ld	a, ($D2B4)		;number of BCD bytes
	ld	c, a
	ld	b, a
	cp	$04
	ccf	;complement carry & half flags
	ret	c

_:	ld	a, (hl)
	and	$0F
	cp	$0A
	ccf	;complement carry & half flags
	ret	c

	ld	a, (hl)
	and	$F0
	cp	$A0
	ccf	;complement carry & half flags
	ret	c

	inc	hl
	djnz	-_

	ld	hl, $D2A8
	xor	a			;clear flags

	ld	b, c

_:	rrd				;rotate lo-nibble at (HL) into A
	or	$30			;convert to ASCII
	ld	(de), a			;store here

	inc	de
	rrd	;rotate lo-nibble at (HL) into A
	or	$30			;convert to ASCII
	ld	(de), a			;store here

	inc	de			;move to next BCD byte
	inc	hl
	djnz	-_

	ret


DATA_1E6D:
.db $00, $00, $00

Score_BadnikValue:
.db $01, $00, $00
Score_BossValue:
.db $50, $00, $00
DATA_1E76:
.db $00, $01, $00
DATA_1E79:
.db $10, $01, $00
DATA_1E7C:
.db $20, $01, $00
DATA_1E7F:
.db $30, $01, $00
DATA_1E82:
.db $40, $01, $00
DATA_1E85:
.db $50, $01, $00
DATA_1E88:
.db $60, $01, $00
DATA_1E8B:
.db $70, $01, $00
DATA_1E8E:
.db $80, $01, $00
DATA_1E91:
.db $90, $01, $00
DATA_1E94:
.db $00, $02, $00
DATA_1E97:
.db $10, $02, $00
DATA_1E9A:
.db $20, $02, $00
DATA_1E9D:
.db $30, $02, $00
DATA_1EA0:
.db $40, $02, $00
DATA_1EA3:
.db $50, $02, $00
DATA_1EA6:
.db $60, $02, $00
DATA_1EA9:
.db $70, $02, $00
DATA_1EAC:
.db $80, $02, $00
DATA_1EAF:
.db $90, $02, $00
DATA_1EB2:
.db $00, $03, $00
DATA_1EB5:
.db $10, $03, $00
DATA_1EB8:
.db $20, $03, $00
DATA_1EBB:
.db $30, $03, $00
DATA_1EBE:
.db $40, $03, $00
DATA_1EC1:
.db $50, $03, $00
DATA_1EC4:
.db $60, $03, $00
DATA_1EC7:
.db $70, $03, $00
DATA_1ECA:
.db $80, $03, $00
DATA_1ECD:
.db $90, $03, $00
DATA_1ED0:
.db $00, $05, $00
DATA_1ED3:
.db $00, $06, $00
DATA_1ED6:
.db $00, $07, $00
DATA_1ED9:
.db $00, $08, $00
DATA_1EDC:
.db $00, $09, $00
DATA_1EDF:
.db $00, $10, $00
DATA_1EE2:
.db $00, $15, $00
DATA_1EE5:
.db $00, $20, $00
DATA_1EE8:
.db $00, $25, $00
DATA_1EEB:
.db $00, $30, $00


;****************************************************************
;*	Calculate a score value based on the time taken to	*
;*	complete the act and add it to the player's score.	*
;****************************************************************
Score_CalculateActTimeScore:		;$1EEE
	ld	a, (LevelTimer + 1)	;check minutes
	or	a					;jump if level completed >= 1min
	jr	nz, Score_CalculateActTimeScore_Sec

	ld	a, (LevelTimer)				;get seconds
	cp	$20					;if(seconds < 20) seconds = 20
	jr	nc, +_
	ld	a, $20

_:	sub	$20					;subtract 20 seconds and use as
	ld	l, a					;an index into array at $1F70
	ld	h, $00
	add	hl, hl
	ld	de, DATA_1F70
	add	hl, de

	ld	e, (hl)					;add the value to the score
	inc	hl
	ld	d, (hl)
	ex	de, hl
	jp	Score_AddValue


;****************************************************************
;*	Calculate a score value based on the number of		*
;*	seconds taken to complete an act and add it to the	*
;*	player's score.						*
;****************************************************************
Score_CalculateActTimeScore_Sec:		;$1F0E
	xor	a
	ld	($D2A5), a			;clear the memory that will be used
	ld	($D2A6), a			;to hold the score value
	ld	($D2A7), a

	ld	hl, (LevelTimer)	;get the current zone time
	ld	de, $0959			;subtract 9mins 59sec
	xor	a
	sbc	hl, de
	jr	z, +++_		;jump if timer == 09'59"

	ld	hl, (LevelTimer)
	srl	h		;hl /= 2
	rr	l
	srl	h		;hl /= 2
	rr	l
	srl	h		;hl /= 2
	rr	l
	srl	h		;hl /= 2
	rr	l
	ld	a, l
	sub	$10
	jr	nc, +_

	xor	a

_:	ld	l, a
	ld	h, $00
	ld	de, DATA_1FE4
	add	hl, de
	ld	a, (hl)
	ld	($D2A5), a
	ld	a, (LevelTimer)
	and	$0F
	cp	$05
	jr	c, +_

	ld	a, ($D2A5)
	cp	$01
	jr	z, +_

	sub	$01
	daa	
	ld	($D2A5), a

_:	xor	a
	ld	($D2A6), a
	ld	($D2A7), a
	ld	hl, $D2A5
	jp	Score_AddValue
	
_:	ld	hl, DATA_1ED0
	jp	Score_AddValue
		
		
DATA_1F70:
.dw DATA_1EEB
.dw DATA_1EE8
.dw DATA_1EE5
.dw DATA_1EE2
.dw DATA_1EDF
.dw DATA_1EDC
.dw DATA_1ED9
.dw DATA_1ED6
.dw DATA_1ED3
.dw DATA_1ED0
.dw DATA_1E6D
.dw DATA_1E6D
.dw DATA_1E6D
.dw DATA_1E6D
.dw DATA_1E6D
.dw DATA_1E6D
.dw DATA_1ECD
.dw DATA_1ECA
.dw DATA_1EC7
.dw DATA_1EC4
.dw DATA_1EC1
.dw DATA_1EBE
.dw DATA_1EBB
.dw DATA_1EB8
.dw DATA_1EB5
.dw DATA_1EB2
.dw DATA_1E6D
.dw DATA_1E6D
.dw DATA_1E6D
.dw DATA_1E6D
.dw DATA_1E6D
.dw DATA_1E6D
.dw DATA_1EAF
.dw DATA_1EAC
.dw DATA_1EA9
.dw DATA_1EA6
.dw DATA_1EA3
.dw DATA_1EA0
.dw DATA_1E9D
.dw DATA_1E9A
.dw DATA_1E97
.dw DATA_1E94
.dw DATA_1E6D
.dw DATA_1E6D
.dw DATA_1E6D
.dw DATA_1E6D
.dw DATA_1E6D
.dw DATA_1E6D
.dw DATA_1E91
.dw DATA_1E8E
.dw DATA_1E8B
.dw DATA_1E88
.dw DATA_1E85
.dw DATA_1E82
.dw DATA_1E7F
.dw DATA_1E7C
.dw DATA_1E79
.dw DATA_1E76


DATA_1FE4:
#import "unknown\s2_1FE4.bin"

;Used by the score card
;add the value pointed to by HL to the score at $D2A2
Score_AddValue:			;$2079
	ld	a, ($D292)
	or	a
	ret	nz

	xor	a			;clear flags

	ld	de, $D2A2	;load pointer to score
	ld	a, (de)			;add first BCD byte
	adc	a, (hl)
	daa	
	ld	(de), a
	
	inc	de
	inc	hl
	ld	a, (de)			;add second BCD byte 
	adc	a, (hl)
	daa	
	ld	(de), a
	
	inc	de
	inc	hl
	ld	a, (de)			;add third BCD byte
	adc	a, (hl)
	daa	
	ld	(de), a
	ret	nc			;return if no BCD overflow

	ld	hl, $D2A2	;overflow - cap score at 999,990
	ld	(hl), $90
	inc	hl
	ld	(hl), $99
	inc	hl
	ld	(hl), $99
	ld	a, $02
	ret

;increment the zone timer clock
Engine_Timer_Increment:		;$20A1
	ld	a, (LevelTimerTrigger)	;is timer update required?
	or	a
	ret	z

	ld	hl, $D2BC			;increment the frame counter
	inc	(hl)

	ld	a, $3C	;return if the frame counter < 60
	sub	(hl)
	ret	nz

	ld	(hl), a	;frame counter == 60. reset the counter
	ld	hl, LevelTimer		;increment the zone timer
	ld	a, $01				;increment seconds
	add	a, (hl)
	daa
	ld	(hl), a

	sub	$60		;increment minutes if required
	jr	nz, Engine_Timer_SetSprites

	ld	(hl), a	;reset seconds
	inc	hl
	ld	a, $01	;increment minutes
	add	a, (hl)
	daa
	ld	(hl), a	;is the timer at 10 minutes?
	sub	$10
	jr	nz, Engine_Timer_SetSprites

	ld	a, $FF		;timer at 10 minutes. set the 
	ld	($D49F), a	;"Kill player" flag

	xor	a
	ld	(LevelTimerTrigger), a	;reset "timer update required" flag.
	ret

;calculate the sprites to display for the zone timer
Engine_Timer_SetSprites:		;$20D2
	ld	a, ($D292)
	or	a
	ret	nz

	ld	a, (LevelTimer+1)	;get the minutes
	rlca
	and	$1E		;calculate the sprite to display for the current value
	add	a, $10
	ld	($DBB9), a			;set the char code in the SAT

	ld	a, (LevelTimer)		;get the seconds
	rrca	;calculate the sprite to display for the most significant digit
	rrca
	rrca
	and	$1E
	add	a, $10
	ld	($DBBD), a			;set the char code in the SAT

	ld	a, (LevelTimer)		;calculate the sprite to display for the lest significant digit
	rlca
	and	$1E
	add	a, $10
	ld	($DBBF), a			;set the char code in the SAT
	ret

LABEL_20FB:
	ld	a, (ix + $0B)
	or	a
	ret	z
	ld	d, $00
	ld	e, (ix+$0A)
	ld	hl, DATA_330
	add	hl, de
	ld	a, (hl)
	and	a
	jp	p, +_

	ld	($D100), a
	ld	a, $FF
	ld	($D101), a
	ld	($D106), a
	jr	++_

_:	ld	($D100), a
	xor	a
	ld	($D101), a
	ld	($D106), a
_:	ld	hl, $0000
	ld	($D104), hl
	ld	b, (ix+$0B)
_:	ld	hl, ($D104)
	ld	de, ($D100)
	add	hl, de
	ld	($D104), hl
	djnz	-_
	lea	hl, ix
	ld	de, $0010
	add	hl, de
	ld	de, $D104
	xor	a
	ld	a, (de)
	adc	a, (hl)
	ld	(hl), a
	inc	de
	inc	hl
	ld	a, (de)
	adc	a, (hl)
	ld	(hl), a
	inc	de
	inc	hl
	ld	a, (de)
	adc	a, (hl)
	ld	(hl), a
	ld	a, (ix+$0A)
	add	a, $C0
	ld	e, a
	ld	d, $00
	ld	hl, DATA_330
	add	hl, de
	ld	a, (hl)
	and	a
	jp	p, +_

	ld	($D100), a
	ld	a, $FF
	ld	($D101), a
	ld	($D106), a
	jr	++_

_:	ld	($D100), a
	xor	a
	ld	($D101), a
	ld	($D106), a

_:	ld	hl, $0000
	ld	($D104), hl
	ld	b, (ix+$0B)

_:	ld	hl, ($D104)
	ld	de, ($D100)
	add	hl, de
	ld	($D104), hl
	djnz	-_

	lea	hl, ix
	ld	de, $0013
	add	hl, de
	ld	de, $D104
	xor	a
	ld	a, (de)
	adc	a, (hl)
	ld	(hl), a
	inc	de
	inc	hl
	ld	a, (de)
	adc	a, (hl)
	ld	(hl), a
	inc	de
	inc	hl
	ld	a, (de)
	adc	a, (hl)
	ld	(hl), a
	ret

Engine_LoadLevel:		;$21AA
	di
	call	Engine_ClearWorkingVRAM
	call	Engine_LoadLevelTiles
	call	Engine_InitStatusIcons
	ld	ix, LevelAttributes
	call	Engine_ClearLevelAttributes		;clear level header
	call	Engine_LoadLevelHeader
	call	Engine_LoadLevelLayout
	call	Engine_LoadAuxLevelHeader
	ld	a, Object_Sonic					;set up the sonic object
	ld	($D500), a
	ld	a, ($D2B7)
	or	a
	jr	nz, +_
	ld	(LevelTimer), a
	ld	(LevelTimer+1), a
	dec	a			;set timer update trigger
	ld	(LevelTimerTrigger), a
_:	call	Engine_WaitForInterrupt
	ret
	

Engine_ClearWorkingVRAM:		 ;21E0
	 ld	 hl, $D300	;clear RAM from $D300 -> $DBBF
	 ld	 de, $D301
	 ld	 bc, $08BF
	 ld	 (hl), $00
	 ldir
	 ret


; =============================================================================
;	Engine_InitStatusIcons()
; -----------------------------------------------------------------------------
;	Initialises the HUD sprites (h-pos, v-pos & char code). HUD sprites
;	occupy the last 12 entries in the SAT.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_InitStatusIcons:	;$21EE
	ld	a, ($D292)
	or	a
	ret	nz
	
	di
	call	VDP_ClearSAT
	
	ld	hl, Engine_Data_StatusIconDefaults
	ld	ix, VDP_WorkingSAT_VPOS + $34	;VPOS for last 12 sprites in SAT
	ld	iy, VDP_WorkingSAT_HPOS + $68	;HPOS/char for last 12 sprites
	ld	b, 12
	call	Engine_SetStatusIconPositions
	
	
	; if we're on Act 3 and the current level is not crystal egg
	; then push 2 sprites offscreen (vpos = 224).
	ld	a, (CurrentLevel)
	cp	Level_CEZ
	jr	nz, +_
	
	ld	a, (CurrentAct)
	cp	Act3
	jr	nz, +_
	
	ld	a, 224
	ld	(VDP_WorkingSAT_VPOS + $38), a
	ld	(VDP_WorkingSAT_VPOS + $39), a
	
_:	ei
	ret

;Initial positions of the status icons (lives/timer/rings)
Engine_Data_StatusIconDefaults:	;$221F
;		hpos
;	vpos	|	char
;	|----|----|----|
.db $AF, $28, $16		;life icon position
.db $AF, $10, $28
.db $AF, $18, $2A
.db $AF, $20, $24
.db $00, $20, $10		;ring icon position
.db $00, $28, $10
.db $00, $10, $3E
.db $00, $18, $40
.db $10, $10, $10		;timer position
.db $10, $18, $26
.db $10, $20, $10
.db $10, $28, $10


Engine_SetStatusIconPositions:		;$2243
	ld	a, (hl)		;load vpos
	ld	(ix + $00), a
	inc	hl
	ld	a, (hl)		;load hpos
	ld	(iy + $00), a
	inc	hl
	ld	a, (hl)		;load char
	ld	(iy + $01), a
	inc	hl
	inc	ix
	lea	iy, iy+2
	djnz	Engine_SetStatusIconPositions
	ret	


; =============================================================================
;	Engine_InitCounters()
; -----------------------------------------------------------------------------
;	Sets score/ring/life counters to their default values.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_InitCounters:		;$225B
	; set the life counters
	ld	a, $03
	ld	(LifeCounter), a
	ld	(LivesOnEntry), a
	
	xor	a
	
	; reset the ring count
	ld	(RingCounter), a
	
	; reset the 3-byte Score
	ld	(Score), a
	ld	(Score+1), a
	ld	(Score+2), a
	
	ld	($D2A2), a			;\ 
	ld	($D2A3), a			; |
	ld	($D2A4), a			; | used in score card tallying 
	ld	($D2A5), a			; |
	ld	($D2A6), a			; |
	ld	($D2A7), a			;/

	ld	a, ($D294)
	or	a
	ret	nz

	ld	(CurrentLevel), a
	ld	(CurrentAct), a
	ret	


; =============================================================================
;	Engine_LoadAuxLevelHeader()
; -----------------------------------------------------------------------------
;	Loads the auxiliary level header into memory. Aux level header contains
;	ring art source/dest pointers, collision data pointers & dynamic palette
;	numbers.
; -----------------------------------------------------------------------------
;	In:
;	(CurrentLevel) - The level number.
;	(CurrentAct)	- The act number.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_LoadAuxLevelHeader:		;$2291
	; clear the ring counter
	xor	a
	ld	(RingCounter), a
	
	; fetch a pointer to the aux header for the current level/act 
	; from the pointer array
	ld	a, (CurrentLevel)
	add	a, a
	ld	l, a
	ld	h, $00
	ld	de, RingArtPointers
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	
	ld	a, (CurrentAct)
	add	a, a
	ld	l, a
	ld	h, $00
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ex	de, hl
	
	; HL now points to the current level/act's auxiliary header
	
	; fetch & store the collision data pointer
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	(Engine_CollisionDataPtr), de
	
	; fetch & store the ring art source pointer
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	(Engine_RingArt_Src), de
	
	; fetch & store the ring art destination pointer
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	(Engine_RingArt_Dest), de
	
	; fetch & store the 2 dynamic palette numbers
	ld	a, (hl)
	ld	(Engine_DynPalette_0), a
	inc	hl
	
	ld	a, (hl)
	ld	(Engine_DynPalette_1), a
	inc	hl
	
	; 2 unused bytes
	ld	a, (hl)
	ld	($D4B6), a
	inc	hl
	
	ld	a, (hl)
	ld	($D4BE), a
	inc	hl
	ret

#include "ring_art_pointers.asm"


LABEL_2416:
;	00000000
;	|||||||`-
;	||||||`--
;	|||||`---
;	||||`---- Load demo flag
;	|||`----- Load title screen flag
;	||`------ Load intro flag
;	|`------- 
;	`-------- Load level flag

ChangeGameMode:
	ld	a, ($D292)
	rlca
	jp	c, LABEL_24BE_48		;Load a level - jump if bit 7 is set
	rlca
	jr	c, LABEL_242F_49
	rlca
	jr	c, LABEL_2439_50		;load the Intro level - jump if bit 5 is set
	rlca
	jr	c, LABEL_2459_51		;load title screen - jump if bit 4 is set
	rlca
	jr	c, DemoSequence_PlayDemo	;load a demo - jump if bit 3 is set
	jr	ChangeGameMode


LABEL_242F_49:
	ld	hl, $D292
	res	6, (hl) ;intro flag
	set	5, (hl) ;title screen flag
	jr	ChangeGameMode


LABEL_2439_50:
	call	_Load_Intro_Level

LABEL_243C:
	xor	a
	ld	($D700), a
	call	PaletteFadeOut
	ld	b, 42
_:	call	Engine_WaitForInterrupt
	djnz	-_
	ld	hl, $D292
	res	5, (hl)	;clear load intro flag
	res	7, (hl)	;clear load level flag
	set	4, (hl)	;set load title screen flag
	jr	ChangeGameMode


LABEL_2459_51:
	call	_Load_Title_Level
	call	PaletteFadeOut	;fade the palette
	ld	b, 42
_:	call	Engine_WaitForInterrupt
	djnz	-_
	ld	hl, $D292
	res	4, (hl)	;clear load title screen flag
	set	3, (hl)	;set load demo flag
	jr	ChangeGameMode


DemoSequence_PlayDemo:		;246F
	di
	call	DemoSequence_ChangeLevel
	ld	a, $40			;set the "Demo mode" flag
	ld	(GlobalTriggers), a
	call	DemoSequence_LoadLevel


LABEL_247B:
	ld	hl, (NextControlByte)
	ld	(ControlByte), hl
	ld	bc, $05DC			;demo timer
	call	LABEL_2530
	call	LABEL_2576
	ld	hl, $D292
	res	7, (hl)
	ld	hl, $0000
	ld	(ControlByte), hl
	xor	a
	ld	(GlobalTriggers), a
	ld	(CurrentLevel), a
	ld	(CurrentAct), a
	ld	hl, $D292
	bit	7, (hl)
	jr	z, +_

	ld	hl, $D292
	res	7, (hl)
	res	3, (hl)
	set	4, (hl)
	jp	ChangeGameMode

_:	ld	hl, $D292
	res	7, (hl)
	res	3, (hl)
	set	6, (hl)
	jp	ChangeGameMode

LABEL_24BE_48:
	;check for level select trigger
	ld	a, (LevelSelectTrg)
	cp	kbdLeft
	jr	nz, ++_
	xor	a
	ld	($D294), a
	call	LevelSelectMenu		;run the level select
	call	PaletteFadeOut
	ld	b, 42
_:	call	Engine_WaitForInterrupt
	djnz	-_
_:	xor	a
	ld	($D292), a
	ld	(GlobalTriggers), a
	ret

DemoSequence_ChangeLevel:
;LABEL_24DD_53:
	ld	a, (DemoNumber)
	inc	a
	and	$07
	ld	(DemoNumber), a
	ld	l, a
	ld	h, $00
	add	hl, hl
	add	hl, hl
	ld	de, LevelDemoHeaders
	add	hl, de
	ld	a, (hl)
	ld	(CurrentLevel), a	;which level is the demo for?
	inc	hl
	ld	a, (hl)
	ld	(DemoBank), a		;which bank is the control sequence in?
	inc	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	(NextControlByte), de	;where is the control sequence?
	xor	a
	ld	(CurrentAct), a		;default to the first act...
	ld	a, (CurrentLevel)
	cp	$01
	ret	nz	
	ld	(CurrentAct), a		;...except for SHZ when we should use act 2
	ret

LevelDemoHeaders:
;	Level
;	|	Bank
;	|	|	Control sequence pointer
;	|----|----|--------|
;.db $01, $1D, $00, $90 ;SHZ demo

;SHZ demo
.db $01
.db 29
.dw DemoControlSequence_SHZ

;GHZ demo
.db $03
.db 29
.dw DemoControlSequence_GHZ

;ALZ demo
.db $02
.db 08
.dw DemoControlSequence_ALZ

;SEZ demo
.db $05
.db 30
.dw DemoControlSequence_SEZ

;SHZ demo
.db $01
.db 29
.dw DemoControlSequence_SHZ

;GHZ demo
.db $03
.db 29
.dw DemoControlSequence_GHZ

;ALZ demo
.db $02
.db 08
.dw DemoControlSequence_ALZ

;SEZ demo
.db $05
.db 30
.dw DemoControlSequence_SEZ


LABEL_2530:
	push	bc
	call	Engine_WaitForInterrupt
	call	Engine_UpdateLevelState
	pop	bc
	ld	a, ($D292)
	bit	7, a
	ret	nz
	ld	a, (GlobalTriggers)
	cp	$40
	ret	nz
	dec	bc				;decrement the demo timer
	ld	a, b
	or	c
	jr	nz, LABEL_2530
	ret

DemoSequence_LoadLevel:	;254A
	di
	ld	hl, GlobalTriggers
	set	2, (hl)	;set "title card" flag
	call	VDP_ClearScreen
	call	TitleCard_LoadAndDraw
	call	ScrollingText_UpdateSprites
	call	PaletteFadeOut
	ld	b, 42		;pause to load the level
_:	call	Engine_WaitForInterrupt
	djnz	-_
	call	Engine_LoadLevel			;load the level
	call	Engine_LoadLevelPalette
	call	Engine_ReleaseCamera			;unlocks camera
	ld	a, $20
	ld	(RingCounter), a	;start level with 32 rings
	ld	hl, GlobalTriggers
	res	2, (hl)			;reset "title card" flag
	ret
	
LABEL_2576:
	call	Engine_WaitForInterrupt
	call	Engine_UpdatePlayerObjectState
	ld	a, (Player.State)
	cp	PlayerState_LostLife
	jr	nz, +_
	ld	a, ($D51D)
	cp	$02
	jr	nz, LABEL_2576
	
_:	; reset dynamic palette numbers
	call	Engine_ClearAuxLevelHeader
	
	; fade out over 1 second
	call	PaletteFadeOut
 	call	wait_1s
	
	ret
	

LABEL_259C:
	call	Engine_WaitForInterrupt
	ld	a, ($D292)
	bit	7, a
	ret	nz
	dec	hl
	ld	a, h
	or	l
	ret	z
	jr	LABEL_259C	;$F0


; =============================================================================
;	Engine_CapLifeCounterValue()
; -----------------------------------------------------------------------------
;	Ensures that the life counter does not exceed 9. Updates the life counter 
;	sprite with the correct char code.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_CapLifeCounterValue:	; $25AC 
	ld	a, ($D292)
	or	a
	ret	nz
	
	ld	a, (LifeCounter)
	cp	9
	jr	c, +_

	ld	a, 9
	
_:	; calculate the sprite number to display
	rlca
	and	$1E
	add	a, $10
	ld	(VDP_WorkingSAT_HPOS + $69), a
	ret


IncrementRingCounter:
LABEL_25C3:
	ld	a, (RingCounter)
	add	a, $01
	daa
	ld	(RingCounter), a
	;check for 100 rings
	or	a
	jr	nz, Engine_UpdateRingCounterSprites
	;we have 100 rings; increment life counter
	ld	hl, LifeCounter
	inc	(hl)
	call	Engine_CapLifeCounterValue


Engine_UpdateRingCounterSprites:	;$25DB
	ld	a, ($D292)
	or	a
	ret	nz

	ld	a, (CurrentLevel)
	cp	$06				;check for crystal egg act 2
	jr	nz, +_
	ld	a, (CurrentAct)
	cp	$02
	ret	z

_:	ld	a, (RingCounter)	;calculate the sprite for the
	rrca	;first BCD digit
	rrca
	rrca
	and	$1E
	add	a, $10
	ld	($DBB1), a

	ld	a, (RingCounter)	;calculate the sprite for the
	rlca	;second BCD digit
	and	$1E
	add	a, $10
	ld	($DBB3), a
	ret


TitleCard_LoadAndDraw:
LABEL_2606:
	di
	call	Engine_ClearLevelAttributes	
	ld	hl, $3800
	ld	de, $1170		;copy $1170 to the name table
	ld	bc, $0380
	call	VDP_Write
	call	TitleCard_LoadTiles
;FIXME: potential optimisations here.
	ei
	ld	hl, BgPaletteControl	;trigger bg palette fade to colour.
	ld	(hl), $80
	inc	hl
	ld	(hl), $03
	ld	a, (CurrentLevel)
	add	a, $1D
	ld	hl, FgPaletteControl	;trigger fg palette fade to colour.
	ld	(hl), $80
	inc	hl
	ld	(hl), a
	ld	b, $0C
_:	call	Engine_WaitForInterrupt
	djnz	-_
#if Language = 1
	call	TitleCard_LoadText
	call	TitleCard_LoadActLogoMappings
	jp	TitleCard_LoadZoneText
#else Language = 2
	call	TitleCard_LoadActLogoMappings
	call	TitleCard_LoadZoneText
	jp	TitleCard_LoadText
#endif

;****************************************
;* Loads the mappings for the zone name *
;* into VRAM				*
;****************************************
TitleCard_LoadText:
LABEL_264E:
	ld	hl, $0038
	ld	(Engine_ObjCharCodePtr), hl
	ld	bc, $0101			;load 1 row + 1 col to start with
	ld	($D118), bc
	ld	a, (CurrentLevel)
	add	a, a
	ld	l, a
	ld	h, $00
	ld	de, TitleCard_Mappings	;pointers to title card mappings
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	hl, $0038
	add	hl, de
	ex	de, hl
	ld	a, (GlobalTriggers)
	bit	2, a
	jr	nz, +_
	ld	de, DATA_2D0C+$0038
_:	ld	($D11A), de
	ld	hl, $3900
	ld	($D11C), hl
	ld	b, $1C
	jp	TitleCard_ScrollTextFromLeft

;****************************************
;* Loads the mappings for the act logo	*
;* into VRAM				*
;****************************************
TitleCard_LoadActLogoMappings:	;$2688
	ld	hl, $001C
	ld	(Engine_ObjCharCodePtr), hl
	ld	bc, $0101
	ld	($D118), bc		;rows/cols
	ld	a, (CurrentAct)	;which logo do we need?
	add	a, a
	ld	l, a
	ld	h, $00
	ld	de, DATA_28FE			;calculate the offset to the pointer
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	($D11A), de		;source address
	ld	hl, $39FE	;VRAM destination
	ld	($D11C), hl
	ld	b, $0E			;count
	jp	TitleCard_ScrollActLogo

;****************************************
;* Loads the mappings for the "Zone"	*
;* text into VRAM			*
;****************************************
TitleCard_LoadZoneText:		;$26B3
	ld	hl, $0028
	ld	(Engine_ObjCharCodePtr), hl
#if Language = 1
	ld	hl, $39C0
#else Language = 2
	ld	hl, $3840
#endif

	ld	de, DATA_299C		;"Zone" text mappings
	ld	bc, $0101
	ld	a, (GlobalTriggers)
	bit	GT_NEXT_ACT_BIT, a
	jr	nz, +_

	bit	GT_NEXT_LEVEL_BIT, a
	jr	z, ++_

_:	ld	hl, $39C0
	ld	de, DATA_2D6C
	jr	+_

_:	ld	($D118), bc	;rows/cols
	ld	($D11A), de	;pointer to mappings
	ld	($D11C), hl	;VRAM address
	ld	b, $14
	jp	TitleCard_ScrollTextFromLeft

TitleCard_ScrollTextFromLeft:		;$26E1
	push	bc
	call	Engine_WaitForInterrupt
	ld	bc, ($D118)	;rows/cols
	ld	de, ($D11A)	;pointer to mappings
	ld	hl, ($D11C)	;VRAM address
	call	Engine_LoadCardMappings
	ld	bc, ($D118)
	ld	de, ($D11A)
	ld	hl, (Engine_ObjCharCodePtr)
	add	hl, de
	ex	de, hl
	push	de
	ld	hl, ($D11C)
	ld	de, $0040
	add	hl, de
	pop	de
	call	Engine_LoadCardMappings
	ld	bc, ($D118)
	inc	c
	ld	($D118), bc
	ld	de, ($D11A)
	dec	de
	dec	de
	ld	($D11A), de
	pop	bc
	djnz	TitleCard_ScrollTextFromLeft
	ret

TitleCard_ScrollActLogo:		;$2722
	push	bc
	ei
	ld	bc, ($D118)
	ld	de, ($D11A)
	ld	hl, ($D11C)
	call	Engine_LoadCardMappings
	ld	bc, ($D118)
	ld	hl, ($D11A)
	ld	de, (Engine_ObjCharCodePtr)
	add	hl, de
	ex	de, hl
	push	de
	ld	hl, ($D11C)
	ld	de, $0040
	add	hl, de
	pop	de
	call	Engine_LoadCardMappings
	ld	bc, ($D118)
	ld	hl, ($D11A)
	ld	de, (Engine_ObjCharCodePtr)
	add	hl, de
	add	hl, de
	ex	de, hl
	push	de
	ld	hl, ($D11C)
	ld	de, $0080
	add	hl, de
	pop	de
	call	Engine_LoadCardMappings
	ld	bc, ($D118)
	ld	hl, ($D11A)
	ld	de, (Engine_ObjCharCodePtr)
	add	hl, de
	add	hl, de
	add	hl, de
	ex	de, hl
	push	de
	ld	hl, ($D11C)
	ld	de, $00C0
	add	hl, de
	pop	de 
	call	Engine_LoadCardMappings
	ld	bc, ($D118)
	ld	hl, ($D11A)
	ld	de, (Engine_ObjCharCodePtr)
	add	hl, de
	add	hl, de
	add	hl, de
	add	hl, de
	ex	de, hl
	push	de
	ld	hl, ($D11C)
	ld	de, $0100
	add	hl, de
	pop	de
	call	Engine_LoadCardMappings
	ld	bc, ($D118)
	inc	c
	ld	($D118), bc
	ld	hl, ($D11C)
	dec	hl
	dec	hl
	ld	($D11C), hl
	pop	bc
	dec	b
	jp	nz, TitleCard_ScrollActLogo
	ret
	
GameOverScreen_DrawScreen:		;27B4
	di
	call	VDP_ClearScreen
	call	Engine_ClearLevelAttributes			;clear data from $D15E->$D290 (level header?)
	ld	hl, $3800
	ld	de, $1107			;clear the screen
	ld	bc, $0380
	call	VDP_Write
	call	GameOverScreen_LoadTiles		;load the "Game Over" text	

	ld	hl, $3AD0
	ld	de, GameOverScreen_Data_TextMappings
	ld	bc, $0212
	call	Engine_LoadCardMappings
	ei
	ld	hl, BgPaletteControl	;fade bg palette to colour
	ld	(hl), $00
	set	7, (hl)
	inc	hl
	ld	(hl), $03
	ld	hl, FgPaletteControl	;fade sprite palette to colour
	ld	(hl), $00
	set	7, (hl)
	inc	hl
	ld	(hl), $1E
	ret

ContinueScreen_DrawScreen:		;27EE
	di
	call	Engine_ClearLevelAttributes			;clear data from $D15E->$D290 (level header?)
	ld	de, $010A			;clear the screen to blank tile $0A (offset from $2000 in VRAM)
	ld	hl, $3800
	ld	bc, $0380
	call	VDP_Write
	call	ContinueScreen_LoadTiles
	call	ContinueScreen_LoadNumberTiles

	ld	a, 15
	call	Engine_SwapFrame2

	ld	hl, $3A50
	ld	de, ContinueScreen_Data_TextMappings
	ld	bc, $0212
	call	Engine_LoadCardMappings
	ei
	ld	hl, BgPaletteControl	;fade background palette to colour
	ld	(hl), $00
	set	7, (hl)
	inc	hl
	ld	(hl), $03
	ld	hl, FgPaletteControl	;fade sprite palette to colour
	ld	(hl), $00
	set	7, (hl)
	inc	hl
	ld	(hl), $1E
	ret
	
ContinueScreen_LoadNumberMappings:		;282B
	di
	ld	a, 15
	call	Engine_SwapFrame2

	ld	a, (ContinueScreen_Count)	;calculate the offset to the mappings
	ld	e, a
	ld	d, $08
	mlt	de
	ld	hl, ContinueScreen_Data_NumberMappings
	add	hl, de
	ex	de, hl
	ld	hl, $3B5E				;load the mappings into VRAM
	ld	bc, $0202
	jp	Engine_LoadCardMappings

	
LABEL_2849:	;TODO: unused?
	push	bc
	push	de
	push	hl
	ld	bc, $0001
	call	VDP_Copy
	call	Engine_WaitForInterrupt
	call	Engine_WaitForInterrupt
	pop	hl
	inc	hl
	pop	de
	inc	de
	pop	bc
	djnz	LABEL_2849
	ret

ScrollingText_UpdateSprites:		;285D
	ld	hl, $003C
_:	push	hl
	call	LABEL_107C
	call	Engine_WaitForInterrupt
	pop	hl
	dec	hl
	ld	a, h
	or	l
	jr	nz, -_
	ret

TitleCard_Mappings:	;28F0
#include "titlecard_mappings.asm"

Engine_UpdatePlayerObjectState:	; $2FA8
	ld	ix, PlayerObj
	
	; return if the player object slot is empty
	ld	a, (Player.ObjID)
	or	a
	ret	z
	
	; check the kill trigger
	ld	a, (Player_KillTrigger)
	or	a
	call	nz, Player_SetState_Dead
	
	; swap in the bank with the object's logic
	; and run the update routine
	ld	a, 31
	call	Engine_SwapFrame2
	call	Engine_UpdatePlayerObject
	
	ld	a, 31
	call	Engine_SwapFrame2
	call	LABEL_6139
	jp	LABEL_47C9		;check monitor collisions?


LABEL_2FCB:
	;check to see if we're on the intro screen
	push	iy
	ld	(ix + Object.ix0A), $40
	ld	(ix + Object.ix0B), $00
	ld	(ix + Object.AnimFrame), $10
	ld	a, (CurrentLevel)
	cp	Level_Intro
	jr	z, +_

	ld	(ix + Object.SpriteCount), $08
	; set max x-velocity
	ld	hl, $0400
	ld	(Player_MaxVelX), hl
	
	call	LABEL_48C4
	res	OBJ_F4_FACING_LEFT, (ix + Object.Flags04)
	pop	iy
	inc	(ix + Object.StateNext)
	ret	

_:	ld	(ix + Object.SpriteCount), $04
	pop	iy
	ld	(ix + Object.StateNext), $0F
	ret	


Player_SetState_Standing:
LABEL_3011:
	res	0, (ix+$03)
	res	1, (ix+$03)
	ld	(ix+$02), PlayerState_Standing
	ld	hl, $0000
	ld	(IdleTimer), hl
	ld	(ix+$16), l
	ld	(ix+$17), h
	ld	hl, $0400
	ld	(Player_MaxVelX), hl
	call	LABEL_48C4
	jp	Player_CalculateBalance	;check to see if sonic is balancing on a ledge

Player_SetState_Walking:
LABEL_3032:
	res	0, (ix+$03)
	res	1, (ix+$03)
	res	6, (ix+$03)
	ld	(ix+$02), PlayerState_Walking
	ld	hl, $0400
	ld	(Player_MaxVelX), hl		;set maximum horizontal velocity
	call	LABEL_48C4
	call	CalculatePlayerDirection
	ld	a, $80
	ld	($D289), a
	ret	

Player_SetState_LookUp:
LABEL_3054:
	ld	hl, $0000
	ld	(ix+$16), l
	ld	(ix+$17), h
	ld	(ix+$02), PlayerState_LookUp
	ret	

Player_SetState_Crouch:
LABEL_305F:
	ld	hl, $0000
	ld	(ix+$16), l
	ld	(ix+$17), h
	res	1, (ix+$03)	;lose rings on collision with enemy
	res	6, (ix+$03)
	ld	(ix+$02), PlayerState_Crouch
	ret	

Player_SetState_SpinDash:
	ld	hl, $0000
	ld	($D516), hl
	ld	(ix+$02), PlayerState_SpinDash
	set	1, (ix+$03)	;set flag to destroy enemies on collision
	ret 

Player_SetState_Running:
LABEL_3072:
	res	0, (ix+$03)
	res	1, (ix+$03)	;lose rings on collision with enemy
	ld	(ix+$02), PlayerState_Running
	ret	

Player_SetState_SkidRight:
LABEL_307F:
	bit	0, (ix+$03)
	ret	nz
	res	1, (ix+$03)	;lose rings on collision with enemy
	ld	(ix+$02), PlayerState_SkiddingRight
	ret	

Player_SetState_SkidLeft
LABEL_3092:
	bit	0, (ix+$03)
	ret	nz
	res	1, (ix+$03)	;lose rings on collision with enemy
	ld	(ix+$02), PlayerState_SkiddingLeft
	ret	

Player_SetState_Roll:
LABEL_30A5:
	ld	a, (ix+$17)
	or	a
	jr	z, Player_SetState_Crouch
	ld	(ix+$02), PlayerState_Rolling
	ld	hl, $0600
	ld	(Player_MaxVelX), hl
	call	LABEL_48C4
	res	0, (ix+$03)
	set	1, (ix+$03)		;set flag to destroy enemies on collision
	ret	

Player_SetState_Roll_SpinDashRelease:
	ld	(ix+$02), PlayerState_Rolling
	ld	hl, $0600
	ld	(Player_MaxVelX), hl
	call	LABEL_48C4
	res	0, (ix+$03)
	set	1, (ix+$03)		 ;set flag to destroy enemies on collision
	ret

Player_SetState_JumpFromRamp:
LABEL_30C7:
	ld	(ix+$02), PlayerState_JumpFromRamp
	set	0, (ix+$03)
	set	1, (ix+$03)
	res	1, (ix+$22)
	ret	

Player_SetState_VerticalSpring: 
LABEL_30D8:
	bit	7, (ix+$19)
	ret	nz
	ld	(ix+$02), PlayerState_VerticalSpring
	ld	(ix+$18), l	;set Y-axis velocity to HL
	ld	(ix+$19), h 
	set	0, (ix+$03)
	res	1, (ix+$03)
	res	2, (ix+$03)
	res	1, (ix+$22)	;trigger the movement
	ret	

Player_SetState_DiagonalSpring:
LABEL_30FD:
	bit	7, (ix+$19)
	ret	nz
	ld	(ix+$02), PlayerState_DiagonalSpring	;set sprite animation ($D502)
	ld	(ix+$18), l	;set Y-axis velocity to HL
	ld	(ix+$19), h
	set	0, (ix+$03)	;flag movement on Y-axis
	set	1, (ix+$03)	;flag movement on X-axis
	res	1, (ix+$22)	;trigger the movement
	ret	

Player_SetState_HorizontalSpring:
LABEL_3138:
	ld	(ix+$02), PlayerState_Rolling	;set sprite animation
	ld	(ix+$16), l	;set the X-axis speed to HL
	ld	(ix+$17), h
	ld	(Player_MaxVelX), hl
	res	0, (ix+$03)	;flag no movement on the Y-axis
	set	1, (ix+$03)	;flag movement on X-axis
	res	1, (ix+$22)	;trigger movement update
	ret	

Player_SetState_Falling:		;$3157
	ld	a, (ix+$01)
	cp	PlayerState_Jumping
	ret	z
	ld	(ix+$02), PlayerState_Falling
	ld	(ix+$18), $00	;vertical velocity
	ld	(ix+$19), $01
	set	0, (ix+$03)	;set player in air
	res	1, (ix+$03)	;lose rings on collision with badnik
	res	1, (ix+$22)
	ret	

LABEL_3176:
	ld	(ix+$02), $1d
	ld	(ix+$18), $80
	ld	(ix+$19), $00
	set	0, (ix+$03)
	res	1, (ix+$03)
	res	1, (ix+$22)
	ret	

LABEL_318F:	;alz slippery slope logic
	ld	(ix+$02), PlayerState_ALZSlope	;$1A
	res	0, (ix+$03)
	set	1, (ix+$22)
	ld	hl, $0400
	ld	(Player_MaxVelX), hl
	call	LABEL_48C4
	ld	a, $80				;reset camera offset
	ld	($D289), a
	ret	

CalculatePlayerDirection:		; $31AA
	ld	a, (Engine_InputFlags)
	rlca
	rlca
	and	$30
	ret	z
	and	$10
	ld	b, a
	ld	a, (ix+$04)
	and	$EF
	or	b
	ld	(ix+$04), a
	ret

;************************************************************************
;* Handle a button press when the player is standing (not idle).	*
;************************************************************************
Player_HandleStanding:		;$31BF
LABEL_31BF:
	ld	a, $80
	ld	($D289), a
	call	LABEL_3A62			;Check for input?
	ld	a, ($D502)
	cp	PlayerState_Standing		;Compare to "standing" animation
	ret	nz				
	ld	hl, (Player.VelX)		;Check to see if we should display the
	ld	a, h				;walking sprite
	or	l
	jp	nz, Player_SetState_Walking
	ld	hl, Engine_InputFlags
	ld	a, (hl)
	and	BTN_LEFT | BTN_RIGHT		;check for left & right buttons
	jp	nz, Player_SetState_Walking			
	bit	BTN_UP_BIT, (hl)		;check for up button
	jp	nz, Player_SetState_LookUp
	bit	BTN_DOWN_BIT, (hl)		;check for down button
	jp	nz, Player_SetState_Crouch
	ld	hl, (IdleTimer)			;increment the wait timer
	inc	hl
	ld	(IdleTimer), hl
	ld	a, h
	cp	$02				;check for wait time >= 512 frames
	ret	c
	ld	(ix+$02), PlayerState_Idle ;change sprite to the "wait" animation
	ret

;************************************************************************
;* Handle a button press when the player is balancing on a ledge.	*
;************************************************************************
Player_HandleBalance:
LABEL_31F8:
	ld	a, $80				;reset the camera
	ld	($D289), a
	call	LABEL_3A62
	ld	a, ($D502)
	cp	PlayerState_Balance
	ret	nz
	ld	hl, (Player.VelX)
	ld	a, h
	or	l
	jp	nz, Player_SetState_Walking
	ld	hl, Engine_InputFlags		
	ld	a, (hl)
	and	BTN_LEFT | BTN_RIGHT	;check for left/right buttons
	jp	nz, Player_SetState_Walking
	bit	BTN_UP_BIT, (hl)		;check for up button
	jp	nz, Player_SetState_LookUp
	bit	BTN_DOWN_BIT, (hl)		;check for down button
	jp	nz, Player_SetState_Crouch
	ret

;****************************************************************
;* Handle a button press when the player is standing idle.	*
;****************************************************************
Player_HandleIdle:
LABEL_3222:
	call	LABEL_3A62
	ld	a, ($D502)
	cp	PlayerState_Idle
	ret	nz
	ld	hl, Engine_InputFlags
	ld	a, (hl)
	and	BTN_1 | BTN_2			;check for button 1/2
	jp	nz, Player_SetState_Jumping
	ld	a, (hl)
	and	BTN_LEFT | BTN_RIGHT		;check for left/right
	jp	nz, Player_SetState_Walking
	bit	BTN_UP_BIT, (hl)		;check for up
	jp	nz, Player_SetState_LookUp
	bit	BTN_DOWN_BIT, (hl)		;check for down button
	jp	nz, Player_SetState_Crouch
	ret

;*********************************************************
;* Handle a button press when the player is looking up.	 *
;*********************************************************
Player_HandleLookUp:		;$3245
LABEL_3245:
	ld	a, $B8
	ld	($D289), a
	call	LABEL_3A62
	ld	a, (Player.StateNext)
	cp	PlayerState_LookUp
	ret	nz
	ld	hl, Engine_InputFlags
	ld	a, (hl)
	and	BTN_LEFT | BTN_RIGHT		;check for left/right buttons
	jp	nz, Player_SetState_Walking
	bit	BTN_DOWN_BIT, (hl)		;check for down button
	jp	nz, Player_SetState_Crouch
	bit	BTN_UP_BIT, (hl)
	jp	z, Player_SetState_Standing
	ret	

;********************************************************
;* Handle a button press when the player is crouched.	*
;********************************************************
Player_HandleCrouched:
LABEL_3267:
	ld	a, $30
	ld	($D289), a
	call	LABEL_3A62
	ld	a, (Player.StateNext)
	cp	PlayerState_Crouch
	ret	nz
	ld	hl, Engine_InputFlags
	bit	BTN_UP_BIT, (hl)		;check for up button
	jp	nz, Player_SetState_LookUp
	bit	BTN_DOWN_BIT, (hl)		;check for down button
	jp	z, Player_SetState_Standing
	ret	

;****************************************************************
;* Handle a button press when the player is Spin Dashing.	*
;****************************************************************
Player_HandleSpinDash:
	bit	OBJ_F3_IN_AIR, (ix + Object.Flags03) ;is the player in air?
	jp	nz, Player_SetState_Roll_SpinDashRelease
	ld	a, $80					;reset the camera offset 
	ld	($D289), a
	call	LABEL_3A62
	ld	hl, Engine_InputFlags
	bit	1, (hl)			 ;check for down button
	ret	nz
	ld	hl, $0600			 ;facing right
	bit	OBJ_F4_FACING_LEFT, (ix + Object.Flags04) ; check which way we're facing
	jr	z, +_
	ld	hl, $FA00			 ;facing left
_:	ld	(ix+$16), l
	ld	(ix+$17), h
	jp	Player_SetState_Roll_SpinDashRelease
	ret	

;********************************************************
;* Handle a button press when the player is walking.	*
;********************************************************
Player_HandleWalk:		; $3283
	ld	a, $80				;reset the camera offset when we start
	ld	($D289), a		;to move.
	call	LABEL_3A62
	ld	a, (ix + Object.StateNext)
	cp	PlayerState_Walking
	ret	nz
	call	CalculatePlayerDirection	;which direction are we facing?
	call	LABEL_3676			;check for collisions with loops?
	ld	a, (ix + Object.VelX + 1)	;increase horizontal velocity
	inc	a
	cp	$02
	jr	c, +_
	ld	hl, Engine_InputFlags
	bit	BTN_DOWN_BIT, (hl)		;check for down button
	jp	nz, Player_SetState_Roll
_:	ld	a, (Player_UnderwaterFlag)
	or	a
	jr	nz, ++_
	ld	hl, (Player.VelX)
	bit	7, h				;if Player.VelX is negative we need to 
	jr	z, +_				;++. 2's comp the value.
	dec	hl
	ld	a, h
	cpl	
	ld	h, a
	ld	a, l
	cpl	
	ld	l, a
_:	ld	a, (Player_MaxVelX + 1)
	cp	h
	jp	z, Player_SetState_Running
_:	call	Player_CheckFinishSkid
	jp	Player_CheckSkid


; =============================================================================
;	Player_CheckFinishSkid(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Checks to see if the player object should leave the skidding state.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to player object.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Player_CheckFinishSkid:	; $32C8
	ld	a, (Engine_InputFlags)
	and	BTN_LEFT | BTN_RIGHT		;check for left/right buttons
	ret	nz
	
	; calculate absolute velocity
	ld	hl, (Player.VelX)
	bit	7, h
	jr	z, +_
	dec	hl
	push	de
	ex	de, hl
	ld	hl, $FFFF
	or	a
	sbc	hl, de
	ex	de, hl
	pop	de
	
_:	; if velocity has dropped below $00E0 change to the
	; standing state
	ld	a, l
	and	$E0
	or	h
	jp	z, Player_SetState_Standing

	ret	


; =============================================================================
;	Player_RollingCheckSkid(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Checks to see if the player object is moving in one direction but the
;	opposite direction is pressed in the input flags.
;	Called from the handler for the "Rolling" state.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to player object.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Player_RollingCheckSkid:		; $32E4
	; load HL with a pointer to the input flags
	ld	hl, Engine_InputFlags
	
	; fetch the high byte of the player's x velocity
	ld	a, (Player.VelX + 1)
	
	; jump if the player is moving left (MSB set
	bit	7, a
	jr	nz, +_
	
	; player moving right. check the left button in the input flags
	bit	BTN_LEFT_BIT, (hl)
	jr	z, ++_
	; player moving right & left button pressed - skid to a stop
	jp	Player_SetState_SkidRight


_:	; player is moving left. check the right button in the input flags
	bit	BTN_RIGHT_BIT, (hl)
	jr	z, +_
	; player moving left & right button pressed - skid
	jp	Player_SetState_SkidLeft


_:	; dont change if velocity adjustment value is non-zero
	ld	a, ($D363)
	or	a
	jr	nz, ++_

	; get the player's x velocity
	ld	hl, (Player.VelX)
	
	; if the player is moving left (MSB set) 2's comp the value
	bit	7, h
	jr	z, +_

	dec	hl
	ld	a, h
	cpl	
	ld	h, a
	ld	a, l
	cpl	
	ld	l, a
	
_:	; copy the low-byte into A
	ld	a, l
	
	; check for a minimum speed
	and	$F0
	or	h
	ret	nz

	; player not moving. set the object's state.
	ld	a, (Engine_InputFlags)
	; check the input flags for the "down" button
	bit	BTN_DOWN_BIT, a
	jp	nz, Player_SetState_Crouch	;crouch...
	jp	Player_SetState_Standing	;...or stand

_:	ret	


; =============================================================================
;	Player_CheckSkid(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Checks to see if the player object is moving in one direction but the
;	opposite direction is pressed in the input flags.
;	Called from the handler for the "Walking" and "Running" states.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to player object.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Player_CheckSkid:		; $3321
	; get a pointer to the input flags
	ld	hl, Engine_InputFlags
	
	; return if the upper byte of the x-velocity is zero (not moving
	; fast enough).
	ld	a, (Player.VelX + 1)
	or	a
	ret	z

	; return if the velocity is negative ( = $FF)
	inc	a
	ret	z

	; check the player's direction
	bit	7, (ix + Object.VelX + 1)
	
	; jump if player moving left
	jr	nz, +_
	
	; skid if player moving right + left button pressed
	bit	BTN_LEFT_BIT, (hl)
	jp	nz, Player_SetState_SkidRight
	ret
	
_:	; skid if player moving left + right button pressed
	bit	BTN_RIGHT_BIT, (hl)
	jp	nz, Player_SetState_SkidLeft
	ret	


; =============================================================================
;	Player_HandleRunning(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Handler for the player object's "running" state.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to player object.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Player_HandleRunning:		;$333D
	; update velocity/position variables
	call	LABEL_3A62
	
	; make sure that the object is in the "running" state.
	ld	a, (Player.StateNext)
	cp	PlayerState_Running
	ret	nz
	
	; check loop variables?
	call	LABEL_3676
	
	; if down button is pressed change to the "rolling" state
	ld	hl, Engine_InputFlags
	bit	BTN_DOWN_BIT, (hl)
	jp	nz, Player_SetState_Roll
	
	; if absolute velocity has dropped below $400 change to
	; the "walking" state
	ld	a, (Player.VelX+1)
	bit	7, a
	jr	z, +_
	neg
_:	cp	$04
	jp	c, Player_SetState_Walking

	jp	Player_CheckSkid


; =============================================================================
;	Player_HandleSkidRight(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Handler for the player object's "skidding right" state.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to player object.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Player_HandleSkidRight:	; $3362
	call	LABEL_3A62
	
	; make sure that the object is in the "skidding right" state
	ld	a, (Player.StateNext)
	cp	PlayerState_SkiddingRight
	ret	nz
	
	call	Player_CheckFinishSkid
	call	CalculatePlayerDirection
	ld	a, (Player.VelX+1)
	and	$80
	ld	b, a
	ld	a, (Engine_InputFlags)
	rrca	
	rrca	
	rrca	
	rrca	
	and	$80
	xor	b
	ret	z
	jp	Player_SetState_Walking

;************************************************************************
;* Handle a button press when the player is skidding to the left.	*
;************************************************************************
Player_HandleSkidLeft:
LABEL_3385:
	call	LABEL_3A62
	ld	a, ($D502)
	cp	PlayerState_SkiddingLeft
	ret	nz
	call	Player_CheckFinishSkid
	call	CalculatePlayerDirection
	ld	a, (Player.VelX+1)
	and	$80
	ld	b, a
	ld	a, (Engine_InputFlags)
	rlca	
	rlca	
	rlca	
	rlca	
	and	$80
	xor	b
	ret	z
	jp	Player_SetState_Walking

Player_HandleRolling:		;$33A8
LABEL_33A8:
	call	LABEL_3A62
	ld	a, ($D502)
	cp	PlayerState_Rolling
	ret	nz
	call	LABEL_3676
	jp	Player_RollingCheckSkid

LABEL_33B7:
	call	LABEL_3A62
	ld	a, ($D502)
	cp	PlayerState_JumpFromRamp
	ret	nz
	bit	1, (ix+$23)
	ret	z
	res	0, (ix+$03)
	call	LABEL_3676
	ld	a, (Engine_InputFlags)
	and	BTN_1 | BTN_2
	jp	nz, Player_SetState_Jumping
	ld	hl, ($D516)
	bit	7, h
	jr	z, +_
	dec	hl
	ld	a, h
	cpl	
	ld	h, a
	ld	a, l
	cpl	
	ld	l, a
_:	and	$C0
	or	h
	jp	z, Player_SetState_Standing
	ret	

Player_HandleJumping:
LABEL_33EA:
	ld	hl, $D3AA		;increase D3AA as long as button 1/2 is held.
	ld	a, (Engine_InputFlags)
	and	BTN_1 | BTN_2
	jr	nz, +_
	ld	(hl), $20
	jr	+++_
_:	inc	(hl)
	ld	a, (hl)
	cp	$0E
	jr	nc, ++_
	ld	hl, $FBC0
	ld	a, (Player_UnderwaterFlag)
	or	a
	jr	z, +_
	ld	hl, $FCC0
_:	ld	(Player.VelY), hl
_:	call	LABEL_3A62
	ld	a, (Player.StateNext)
	cp	PlayerState_Jumping
	ret	nz
	bit	1, (ix+$23)
	ret	z
	ld	a, ($D366)
	cp	$8D
	jp	nz, Player_SetState_Walking
	ret	

Player_HandleVerticalSpring:		; $3424
	call	LABEL_3A62
	ld	a, (Player.StateNext)
	cp	PlayerState_VerticalSpring
	ret	nz
	bit	1, (ix+$23)		;check to see if we're standing on something
	jp	nz, Player_SetState_Walking
	bit	7, (ix + Object.VelY + 1)		;check sign bit of vertical velocity
	jp	z, Player_SetState_Falling
	jp	CalculatePlayerDirection


Player_HandleDiagonalSpring:		; $343E
	call	LABEL_3A62
	ld	a, (Player.StateNext)
	cp	PlayerState_DiagonalSpring
	ret	nz

	bit	1, (ix + $23)		;check to see if we're standing on something
	jp	nz, Player_SetState_Walking
	bit	7, (ix + Object.VelY + 1)		;check sign bit of vertical velocity
	jp	z, Player_SetState_Falling	
	ret	


Player_HandleFalling:		;$3456
	call	LABEL_3A62
	ld	a, (Player.StateNext)
	cp	PlayerState_Falling
	ret	nz
	bit	1, (ix+$23)
	jp	nz, Player_SetState_Walking
	ret


LABEL_3467:
#if Version = 2
	res	7, (ix + Object.Flags04)
	ld	hl, -256
#else
	ld	hl, -192
#endif
	ld	(ix + Object.VelX), l
	ld	(ix + Object.VelX + 1), h
	call	LABEL_3A62
	bit	1, (ix+$23)	;check to see if we're standing on something
	ret	z

#if Version = 1
	ld	hl, -256
	ld	(ix + Object.VelX), l	;set Player.VelX
	ld	(ix + Object.VelX + 1), h
#endif
	jp	Player_SetState_Walking

	

LABEL_3484:
	call	LABEL_3A62
	bit	1, (ix+$23)	;check to see if we're standing on something
	jp	nz, Player_SetState_Walking
	ret	

LABEL_348F:
	res	7, (ix+$04)
	call	LABEL_7378
	call	LABEL_6938
	call	CalculatePlayerDirection
	call	LABEL_376E
	xor	a
	ld	(Player_AirTimerHi), a
	ret	


;Reset the air timer. Called after a collision with an air bubble.
LABEL_34A4:
	xor	a
	ld	(Player_AirTimerHi), a
	ret

LABEL_34A9:
	ld	b, $04
	ld	a, ($D365)
	cp	$07
	jr	c, +_
	ld	b, $08
	cp	$10
	jr	c, ++_
	cp	$17
	jr	nc, ++_
_:	ld	a, b
	ld	(Engine_InputFlags), a
	xor	a
	ld	(Engine_InputFlagsLast), a
	call	CalculatePlayerDirection
_:	call	LABEL_3A62
	ld	a, ($D366)
	cp	$00
	jp	z, Player_SetState_Falling
	ld	a, ($D363)
	or	a
	jp	z, Player_SetState_Walking
	ret	

LABEL_34DA:
	res	7, (ix+$04)
	jp	Player_UpdatePlayer.VelY
	
LABEL_34E1:
	res	7, (ix+$04)
	ld	hl, $0080
	ld	a, ($D51C)
	cp	$D8
	jr	c, +_
	ld	hl, GlobalTriggers
	set	3, (hl)
	ld	hl, $1000
_:	ld	(Player.VelY), hl
	jp	Player_UpdatePlayer.VelY


Player_HandleEndOfLevel:		; $34FD
	; reset the object's Y velocity
	xor	a
	ld	(ix + Object.VelY), a
	ld	(ix + Object.VelY + 1), a

	; check for GMZ act 1	(zone exit to left)
	ld	a, (CurrentLevel)
	cp	Level_GMZ
	jr	nz, +_

	ld	a, (CurrentAct)
	or	a
	jr	z, Player_HandleEndOfLevel_ExitLeft

_:	res	4, (ix + Object.Flags04)
	
	; calculate the object's position relative to the camera
	ld	de, (Camera_X)
	ld	l, (ix + Object.X)
	ld	h, (ix + Object.X + 1)
	xor	a
	sbc	hl, de
	
	; check to see if the object has moved offscreen
	ld	de, $0120
	xor	a
	sbc	hl, de
	
	; if object is still on screen increase velocity
	jp	c, Player_HandleEndOfLevel_ExitRight
	
	; object is offscreen
	; FALLTHROUGH

Player_HandleEndOfLevel_IncLevel:		; $352A
	xor	a
	ld	(ix + Object.VelX), a
	ld	(ix + Object.VelX + 1), a
	
	ld	a, (CurrentAct)
	cp	Act3
	jr	nc, +_
	
	ld	hl, GlobalTriggers
	set	GT_NEXT_ACT_BIT, (hl)
	ret	

_:	ld	hl, GlobalTriggers
	set	GT_NEXT_LEVEL_BIT, (hl)
	ret	


Player_HandleEndOfLevel_ExitRight:		; $3544
	; make sure that player's velocity is >= 0
	; i.e. "velocity = max(velocity, 0);"
	ld	hl, (Player.VelX)
	bit	7, h
	jr	z, +_
	
	ld	hl, $0000
	ld	(ix + Object.VelX), l
	ld	(ix + Object.VelX + 1), h
	
_:	; increase the velocity by 16 until velocity == $0600
	ld	a, h
	cp	$06
	jr	nc, +_

	ld	de, $0010
	add	hl, de
	ld	(ix + Object.VelX), l
	ld	(ix + Object.VelX + 1), h

_:	; update the object's position
	jp	Engine_UpdateObjectPosition


Player_HandleEndOfLevel_ExitLeft:		; $3563
	set	4, (ix + Object.Flags04)

	;calculate the object's position, relative to the camera
	ld	hl, (Camera_X)
	ld	e, (ix + Object.X)
	ld	d, (ix + Object.X + 1)
	xor	a
	sbc	hl, de
	jr	c, +_
	
	; object is offscreen
	jp	Player_HandleEndOfLevel_IncLevel


_:	; object is still onscreen. increase negative velocity.
	ld	hl, (Player.VelX)
	bit	7, h
	jr	nz, +_

	ld	hl, -64
	ld	(ix + Object.VelX), l
	ld	(ix + Object.VelX + 1), h

_:	ld	a, h
	cp	$FB
	jr	c, +_

	ld	de, -16
	add	hl, de
	ld	(ix + Object.VelX), l
	ld	(ix + Object.VelX + 1), h
_:	jp	Engine_UpdateObjectPosition


;********************************
;*	Loads loop motion data.	*
;********************************
LABEL_359B:
	ld	a, 09
	call	Engine_SwapFrame2
	ld	l, (ix+$16)	 ;get horizontal velocity
	ld	h, (ix+$17)
	ld	de, ($D399)
	ld	a, ($D39B)
	add	hl, de
	jr	nc, +_
	inc	a
_:	ld	($D399), hl
	ld	($D39B), a

	ld	hl, ($D39A)
	add	hl, hl
	ld	de, LoopMotionData	;loop motion data?
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	
	ld	l, (ix+$3C)
	ld	h, (ix+$3D)
	add	hl, de
	ld	(ix+$14), l	 ;set vertical pos
	ld	(ix+$15), h

	ld	hl, ($D39A)
	add	hl, hl
	ld	de, LoopMotionData+$046E
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	l, (ix+$3A)
	ld	h, (ix+$3B)
	add	hl, de
	ld	(ix+$11), l	 ;set horizontal pos
	ld	(ix+$12), h

	ld	hl, ($D39A)
	ld	de, $00B0
	xor	a
	sbc	hl, de
	jr	nc, +_
	ld	l, (ix+$16)	 ;get horizontal speed
	ld	h, (ix+$17)
	ld	de, $0007
	xor	a
	sbc	hl, de
	jr	c, LABEL_3638
	ld	(ix+$16), l	 ;set horizontal speed
	ld	(ix+$17), h
	jr	++_

_:	ld	l, (ix+$16)
	ld	h, (ix+$17)
	ld	de, $000C
	add	hl, de
	ld	(ix+$16), l
	ld	(ix+$17), h

_:	ld	hl, ($D39A)
	ld	de, $0230
	xor	a
	sbc	hl, de
	ret	c

	ld	(ix+$02), $06
	ld	hl, (Player_MaxVelX)
	ld	(ix+$16), l
	ld	(ix+$17), h
	call	LABEL_3A62
	ld	a, $10
	ld	($D39C), a
	ret	

LABEL_3638:
	ld	l, (ix+$3A)
	ld	h, (ix+$3B)
	ld	e, (ix+$11)
	ld	d, (ix+$12)
	xor	a
	sbc	hl, de
	jr	c, LABEL_365C
	ld	l, (ix+$11)
	ld	h, (ix+$12)
	ld	de, $0008
	add	hl, de
	ld	(ix+$11), l
	ld	(ix+$12), h
	jp	LABEL_3176

LABEL_365C:
	ld	l, (ix+$11)
	ld	h, (ix+$12)
	ld	de, -2
	add	hl, de
	ld	(ix+$11), l
	ld	(ix+$12), h
	jp	LABEL_3176



;Called when player is at bottom of loop, moving 
;backwards
Player_SetState_MoveBack:	;$366F		
	ld	(ix+$02), PlayerState_Running
	jp	LABEL_3A62

LABEL_3676:
	ld	a, ($D39C)
	or	a
	jr	z, LABEL_3681
	dec	a
	ld	($D39C), a
	ret	

LABEL_3681:	;collide with ALZ-1 loop
	ld	a, (CurrentLevel)	;check for ALZ
	cp	$02
	jr	nz, LABEL_36B2
	ld	a, (CurrentAct)	;check for ACT 1
	or	a
	ret	nz
	ld	hl, ($D511)	;horizontal pos in level
	ld	de, $075E
	xor	a
	sbc	hl, de
	ret	c
	ld	a, h
	or	a
	ret	nz
	ld	a, l
	and	$F8
	ret	nz
	ld	hl, ($D514)	;vertical pos in level
	ld	de, $0160
	xor	a
	sbc	hl, de
	ret	c
	ld	a, h
	or	a
	ret	nz
	ld	a, l
	and	$E0
	ret	nz
	jp	LABEL_3725

LABEL_36B2:	;collide with GHZ-1 loop
	ld	a, (CurrentLevel)	;check for GHZ
	cp	$03
	ret	nz
	ld	a, (CurrentAct)	;check for ACT 1
	or	a
	jr	nz, LABEL_3703		;check for ACT 2
	ld	hl, ($D511)	;horizontal pos in level
	ld	de, $0D5E
	xor	a
	sbc	hl, de
	jr	c, LABEL_36E1
	ld	a, h
	or	a
	jr	nz, LABEL_36E1
	ld	a, l
	and	$F8
	jr	nz, LABEL_36E1
	ld	hl, ($D514)	;vertical pos in level
	ld	de, $0140
	xor	a
	sbc	hl, de
	jr	c, LABEL_36E1
	jr	LABEL_3725

LABEL_36E1:
	ld	hl, ($D511)	;horizontal pos in level
	ld	de, $0F3E
	xor	a
	sbc	hl, de
	jr	c, LABEL_3702
	ld	a, h
	or	a
	jr	nz, LABEL_3702
	ld	a, l
	and	$F8
	jr	nz, LABEL_3702
	ld	hl, ($D514)	;vertical pos in level
	ld	de, $0160
	xor	a
	sbc	hl, de
	jr	c, LABEL_3702
	jr	LABEL_3725
	
LABEL_3702:
	ret	

LABEL_3703:
	ld	a, (CurrentAct)	;check for ACT 2
	dec	a
	ret	nz
	ld	hl, ($D511)	;horizontal pos in level
	ld	de, $0AFE
	xor	a
	sbc	hl, de
	ret	c
	ld	a, h
	or	a
	ret	nz
	ld	a, l
	and	$F8
	ret	nz
	ld	hl, ($D514)	;vertical pos in level
	ld	de, $0160
	xor	a
	sbc	hl, de
	ret	c
	;FALL THROUGH

;load loop motion data?
LABEL_3725:
	ld	a, (ix+$0A)
	cp	$80
	jr	nc, +_
	ld	(ix+$02), PlayerState_OnLoop
	
	ld	l, (ix+$11)	;store copy of object h-pos
	ld	h, (ix+$12)
	ld	(ix+$3A), l
	ld	(ix+$3B), h
	
	ld	l, (ix+$14)	;store copy of object v-pos
	ld	h, (ix+$15)
	ld	de, $0000
	add	hl, de
	ld	(ix+$3C), l
	ld	(ix+$3D), h

	xor	a				;clear all loop variables
	ld	($D399), a
	ld	($D39A), a
	ld	($D39B), a
	pop	af
	ret	

_:	ld	(ix+$02), $0D
	pop	af
	ret	

Player_Nop:		; $375E
	ret	

LABEL_375F:
	ld	hl, $0180
	ld	(Player_MaxVelX), hl
	ld	hl, $0008
	ld	(Player_DeltaVX), hl
	jp	Player_UpdatePositionX

LABEL_376E:
	bit	OBJ_F3_BIT7, (ix + Object.Flags03)
	jp	nz, Player_FlashObject
	
	; check to see if the player has the invincibility power-up
	ld	a, (Player.PowerUp)
	cp	$02
	jr	nz, +_

	; player is invincible - clear the "hurt" trigger &
	; any colliding object values
	xor	a
	ld	(Player_HurtTrigger), a
	ld	(Player.CollidingObj), a
	ret
 
	
_:	; jump if the "hurt" trigger is zero
	ld	a, (Player_HurtTrigger)
	or	a
	jr	z, LABEL_3796

	; player has been hit - change object state
	xor	a
	ld	(Player_HurtTrigger), a
	res	OBJ_F23_BIT0, (ix + Object.ix23)
	jp	Player_SetState_Hurt


LABEL_3796:
	; fetch the number of the object that is colliding with the player
	ld	a, (Player.CollidingObj)
	or	a
	ret	z
	
	; calculate a pointer to the object
	call	Engine_GetObjectDescriptorPointer
	
	; get the object type
	ld	a, (hl)
	
	; jump if the object is a glider or mine cart
	cp	Object_Glider
	jp	z, Player_ClearCollidingObject
	cp	Object_MineCart
	jp	z, Player_ClearCollidingObject
	
	bit	OBJ_F3_BIT1, (ix + Object.Flags03)
	jp	nz, LABEL_384E

Player_SetState_Hurt:		;$37B0
	ld	a, (RingCounter)	;check for 0 rings
	or	a
	jr	z, Player_SetState_Dead
	rrca	;calculate the number of rings to
	rrca	;drop based on the value of the 
	rrca	;high nibble of the ring counter.
	rrca	
	and	$0F
	inc	a		
	cp	$08	
	jp	c, +_
	ld	a, $07	;drop up to 7 rings
_:	ld	b, a
	ld	c, Object_DroppedRing	
	ld	h, $00
_:	push	bc
	call	Engine_AllocateObjectHighPriority
	pop	bc
	inc	h
	djnz	-_
	
	set	7, (ix+$03)		;Flash player sprite on/off
	set	6, (ix+$03)
	ld	a, $78				;for $78 frames
	ld	($D3A9), a
	
	xor	a					;reset the ring counter
	ld	(RingCounter), a
	call	Engine_UpdateRingCounterSprites
	
Player_PlayHurtAnimation:		;$37EA
	ld	(ix+$20), $00
	ld	(ix+$02), PlayerState_Hurt
	set	0, (ix+$03)
	res	2, (ix+$03)
	res	1, (ix+$22)
	ld	hl, $FC00		;make player sprite "bounce" out of the way
	bit	0, (ix+$22)
	jr	z, +_
	ld	hl, $0000
_:	ld	($D518), hl		;move sprite up
	ld	hl, $0100
	bit	3, (ix+$23)
	jp	nz, +_
	ld	hl, -256
	ld	($D516), hl		;move sprite back
_:	ld	hl, $0000
	ld	(Player_DeltaVX), hl
	ret	


Player_SetState_Dead:	;$3823
	ld	(ix + Object.StateNext), PlayerState_LostLife
	set	0, (ix+$03)
	ld	(ix+$04), $00
	
	ld	hl, $FB00				;make the object bounce up first
	ld	(ix + Object.VelY), l
	ld	(ix + Object.VelY+1), h
	
	ld	hl, $0000				;reset horizontal acceleration.
	ld	(Player_DeltaVX), hl
	
	res	1, (ix+$22)
	ld	hl, GlobalTriggers
	set	3, (hl)
	
	xor	a
	ld	(Player_KillTrigger), a
	ret	


LABEL_384E:
	bit	4, (ix+$21)		;collision occurred at bottom of other object
	jr	nz, ++_
	bit	5, (ix+$21)		;collision occurred at top of other object
	jr	nz, +++_
	
_:	xor	a
	ld	(Player.CollidingObj), a				;reset colliding object index
	ret

_:
#if Version = 2
	ld	a, ($D501)
	cp	PlayerState_Rolling
	jr	z, --_
#endif
	set	0, (ix+$03)
	ld	hl, $0080				;make player rebound down
	ld	(ix + Object.VelY), l
	ld	(ix + Object.VelY+1), h
	jr	--_

_:	set	0, (ix+$03)
	res	1, (ix+$22)			;reset "bottom collision" in background flags
	ld	hl, $FD00				;make player rebound up
	ld	(ix + Object.VelY), l
	ld	(ix + Object.VelY+1), h
	jr	---_


; =============================================================================
;	Player_FlashObject(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Flashes the player object after taking damage.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to the player object.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Player_FlashObject:		; $387B
	; check to see if the counter is zero
	ld	a, (Player_FlashCounter)
	or	a
	jr	z, +++_
	
	; decrement the counter
	dec	a
	ld	(Player_FlashCounter), a
	rrca
	rrca
	jr	c, ++_
	
_:	; set object invisible
	res	OBJ_F4_VISIBLE, (ix + Object.Flags04)
	ret

_:	; set object visible
	set	OBJ_F4_VISIBLE, (ix + Object.Flags04)
	ret	

_:	; counter is zero - reset the flags
	res	OBJ_F4_VISIBLE, (ix + Object.Flags04)
	res	OBJ_F3_BIT7, (ix + Object.Flags03)
	res	OBJ_F3_BIT6, (ix + Object.Flags03)
	
	; clear the hurt trigger & colliding object
	xor	a
	ld	(Player_HurtTrigger), a
	ld	(ix + Object.CollidingObj), a
	jr	---_


; =============================================================================
;	Player_ClearCollidingObject(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Clears the CollidingObj field in the object structure.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to the player object.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Player_ClearCollidingObject:		; $38A8
	ld	(ix + Object.CollidingObj), 0
	ret	


; =============================================================================
;	Player_CalculateBalance(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Calculates whether the player is balancing at the edge of a block.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to player object.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Player_CalculateBalance:		;$38AD
	; get collision data for the block to the bottom-left of the object
	ld	bc, -4		;horizontal offset	(-4)
	ld	de, 4		;vertical offset	(+4)	i.e. check bottom left of object
	call	Engine_GetCollisionDataForBlock
	
	; get the horizontal collision value
	ld	a, (Cllsn_CollisionValueX)
	
	; push the collision value onto the stack
	ld	b, a
	push	bc

	; get collision data for the block to the bottom-right of the object
	ld	bc, 4		;horizontal offset	(+4)
	ld	de, 4		;vertical offset	(+4)	i.e. check bottom right of object
	call	Engine_GetCollisionDataForBlock
	
	; get the metatile's horizontal collision value
	ld	a, (Cllsn_CollisionValueX)

	; restore the other collision value from the stack
	pop	bc
	; b = collision value at left, c = collision value at right
	ld	c, a

	; subtract left from right collision value
	sub	b
	
	; jump if difference is positive (i.e. left value <= right value)
	jr	nc, +_
	
	; difference is negative (right value is > left).
	; negate the value
	neg

_:	; return if difference is < 16
	cp	16
	ret	c
	
	; compare the left with the right collision value
	ld	a, c
	cp	b
	
	; jump if they are equal
	jr	z, Player_CalculateBalance_None
	
	; jump if left > right
	jp	c, Player_CalculateBalance_Right

Player_CalculateBalance_Left:
	; set the object's state and position flags to show that 
	; it is at the left edge of a block
	ld	(ix + Object.StateNext), PlayerState_Balance
	set	OBJ_F4_FACING_LEFT, (ix + Object.Flags04)
	ret	

Player_CalculateBalance_Right:	;$38E0
	; set the object's state and position flags to show that 
	; it is at the right edge of a block
	ld	(ix + Object.StateNext), PlayerState_Balance
	res	OBJ_F4_FACING_LEFT, (ix + Object.Flags04)
	ret	

Player_CalculateBalance_None:	;$38E9
	; set the object's state to show that it is not at 
	; the edge of a block
	ld	(ix + Object.StateNext), PlayerState_Standing
	ret


; =============================================================================
;	Player_ChangeFrameDisplayTime(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Calculates the animation frame display counter value based on the object's
;	current horizontal velocity.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to player object.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Player_ChangeFrameDisplayTime:	;$38EE
	; increment the counter value and cap at 6
	ld	hl, Player.ix2F
	inc	(hl)
	ld	a, (hl)
	cp	$06
	jr	c, +_			;jump if $D52F < 6

	; counter value >= 6. reset to 0.
	xor	a
	ld	(hl), a

_:	inc	a

	; set the frame number
	ld	(ix + Object.AnimFrame), a
	
	; get the high-byte of the current velocity
	ld	a, (Player.VelX + 1)
	; check the sign bit (i.e. moving left or right)
	and	a
	jp	p, +_
	
	; if the player is moving left negate the value
	neg

_:	; change the frame display counter based on the current speed
	ld	l, a
	ld	h, $00
	ld	de, _Player_ChangeFrameDisplayTime_WalkFrameCounters
	add	hl, de
	ld	a, (hl)
	ld	(ix+$07), a	;set frame display time
	ret	

; frame display times
_Player_ChangeFrameDisplayTime_WalkFrameCounters:	; $3913
.db $0A, $08, $06, $04, $04, $04, $04, $04 
.db $04, $04, $04, $04, $04, $04, $04, $04 



; =============================================================================
;	Player_Anim_CalcBalanceFrame(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Calculates the animation frame and display counter if the player is
;	balancing on the edge of an object.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to player object.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Player_Anim_CalcBalanceFrame:		; $3923
	; increase the counter and cap at $14
	ld	hl, Player.ix2F
	inc	(hl)
	ld	a, (hl)
	cp	$14
	jp	c, +_
	xor	a
	ld	(hl), a

_:	; use the counter as an index ito the array of frame numbers
	ld	c, a
	ld	b, $00
	ld	hl, _Player_Anim_BalanceFrames
	add	hl, bc

	; set the current animation frame
	ld	a, (hl)
	ld	(ix + Object.AnimFrame), a


	; if there is no collision at the bottom edge of the object
	; we need to use the collision flags for calculation
	bit	OBJ_COL_BOTTOM, (ix + Object.BgColFlags)	
	jr	z, Player_Anim_CalcBalanceFrame_UseInputFlags


	; clear the "facing left" bit
	res	OBJ_F4_FACING_LEFT, (ix + Object.Flags04)

	; get the player's horizontal velocity
	ld	a, (Player.VelX + 1)
	and	a
	jp	p, +_

	; if the player is moving left negate the value and
	; set the "facing left" flag
	neg	
	set	OBJ_F4_FACING_LEFT, (ix + Object.Flags04)

_:	; use the velocity value as an index into the array
	; of frame display counters
	ld	l, a
	ld	h, $00
	ld	de, _Player_Anim_BalanceFrameCounters
	add	hl, de

	; set frame display time
	ld	a, (hl)
	ld	(ix + Object.FrameCounter), a
	ret	

; balance anim frame numbers
_Player_Anim_BalanceFrames:	; $395C
.db $11, $12, $13, $14, $15, $12, $13, $14
.db $11, $15, $13, $14, $11, $12, $15, $14
.db $11, $12, $13, $15

; frame display times
_Player_Anim_BalanceFrameCounters:		; $3970
.db $0A, $08, $06, $04, $04, $04, $04, $04
.db $04, $04, $04, $04, $04, $04, $04, $04



; check input flags to calculate balance position - used as a
; last resort if the collision flags can't be used
Player_Anim_CalcBalanceFrame_UseInputFlags:		;$3980
	ld	a, (Engine_InputFlags)		;get input flags
	
	; jump if the right button is not pressed
	bit	BTN_RIGHT_BIT, a
	jr	z, +_

	; flag player balancing at right-edge
	res	OBJ_F4_FACING_LEFT, (ix + Object.Flags04)
	jp	++_

_:	; jump if the left button is not pressed
	bit	BTN_LEFT_BIT, a
	jr	z, +_

	; flag player balancing at left-edge
	set	OBJ_F4_FACING_LEFT, (ix + Object.Flags04)

_:	; set the frame display counter
	ld	a, 3
	ld	(ix + Object.FrameCounter), a
	ret	


;calculate the animation frame to display after the 
;player falls away from a loop
Player_CalculateLoopFallFrame:		;$399B
	ld	hl, ($D53C)		;get player's original vpos
	ld	de, ($D514)		;get player's current vpos
	
	xor	a
	sbc	hl, de			;use distance from original vpos
	srl	l			;to calculate the frame to display
	srl	l
	srl	l
	srl	l
	ld	h, $00
	add	hl, hl
	ld	de, Data_SonicLoopFallFrames
	add	hl, de
	ld	a, (hl)
	cp	(ix+$06)
	jr	nz, +_
	
	inc	hl

_:	ld	a, (hl)
	ld	(ix+$06), a
	ld	(ix+$07), $06
	ret	

Data_SonicLoopFallFrames:		;$39C4
.db $01, $03, $01, $03, $1E, $1F, $1E, $1F
.db $21, $20, $22, $23, $24, $25, $27, $26
.db $28, $29, $2A, $2B, $2D, $2C, $2E, $2F
.db $30, $31, $33, $32, $34, $35, $36, $37
.db $39, $38, $3A, $3B


;calculate which animation frame to display
Player_CalculateLoopFrame:		;$39E8
	ld	hl, ($D39A)			;get player's position in loop
	ld	e, $1B				;divide by 27
	call	Engine_Divide_16_by_u8
	
	ld	h, $00				;calculate an index into the array
	add	hl, hl				;of loop animations
	ld	de, Data_SonicLoopAnimations
	add	hl, de

	ld	a, (hl)				;compare with current frame
	cp	(ix+$06)
	jp	nz, +_

	inc	hl					;move to next frame

_:	ld	a, (hl)
	ld	(ix+$06), a			;set the current frame
	ld	(ix+$07), $06		;set frame display time
	ret	

Data_SonicLoopAnimations:		;$3A07
.db $1E, $1F, $1E, $1F, $21, $20, $22, $23
.db $24, $25, $27, $26, $28, $29, $2A, $2B
.db $2D, $2C, $2E, $2F, $30, $31, $33, $32
.db $34, $35, $36, $37, $39, $38, $3A, $3B
.db $01, $03, $01, $03, $01, $03, $01, $03
.db $01, $03, $01, $03, $01, $03, $01, $03
.db $01, $03, $01, $03



; =============================================================================
;	Engine_GetObjectScreenPos(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Calculates the onscreen position of an object.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Object pointer.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_GetObjectScreenPos:		;$3A3B
	; fetch the object's x coordinate
	ld	l, (ix + Object.X)		;sprite horiz. offset in level
	ld	h, (ix + Object.X + 1)
	; fetch the camera position
	ld	de, (Camera_X)
	xor	a
	; calculate the object's onscreen position
	sbc	hl, de
	ld	(ix + Object.ScreenX), l
	ld	(ix + Object.ScreenX + 1), h
	
	; fetch the object's y coordinate
	ld	l, (ix + Object.Y)
	ld	h, (ix + Object.Y + 1)
	; fetch the camera y coordinate
	ld	de, (Camera_Y)
	xor	a
	; calculate the object's onscreen position
	sbc	hl, de
	ld	(ix + Object.ScreenY), l
	ld	(ix + Object.ScreenY + 1), h
	ret


LABEL_3A62:
	ld	a, (CurrentLevel)	;Check for ALZ
	cp	Level_ALZ
	call	z, LABEL_4887		;under water stuff
	
	; calculate an acceleration value
	call	Player_CalcAccel
	
	; if( playerState < Walking ) MetaTileDeltaVX = 0
	ld	a, (ix + Object.State)
	cp	PlayerState_Walking
	jr	nc, +_
	ld	hl, $0000
	ld	(Player_MetaTileDeltaVX), hl
	
_:	call	Player_UpdatePositionX
	call	Player_UpdatePlayer.VelY

	call	LABEL_6BF2		;check collisions
	call	LABEL_376E

	ld	a, (Engine_InputFlags)
	and	BTN_1 | BTN_2		;check for either button 1 or button 2
	ret	z

	ld	a, ($D501)                
	cp	PlayerState_Crouch
	jp	z, Player_SetState_SpinDash

	cp	PlayerState_SpinDash
	ret	z


Player_SetState_Jumping:		;$3A8C
	ld	a, ($D501)	;check to see if player is sliding
	cp	PlayerState_ALZSlope	;down an ALZ slope.
	ret	z

	bit	0, (ix+$03)
	ret	nz				;return if player is already in the air
	
	bit	2, (ix+$03)
	ret	nz

	xor	a
	ld	($D3AA), a		;reset the jump hold counter
	
	set	0, (ix+$03)		;flag player in air
	set	1, (ix+$03)		;destroy enemies on collision
	ld	(ix+$02), PlayerState_Jumping	;set player state
	
	ld	hl, $FBC0		;set jump velocity (under water)
	
	ld	a, (Player_UnderwaterFlag)
	or	a				;if player is under water use increased
	jr	z, +_				;jump velocity
	
	ld	hl, $FCC0		;set jump velocity (normal)
	
_:	ld	(Player.VelY), hl

	ld	a, $80			;adjust the camera vertical offset
	ld	($D289), a
	
	res	1, (ix+$22)		;clear "collision at bottom" flag
	ret	

;called when jumping & colliding with horizontal spring
LABEL_3ACA:
	set	0, (ix+$03)		;player rolling
	set	1, (ix+$03)		;destroy enemy on collision
	ld	(ix+$02), PlayerState_Jumping
	ld	hl, $0000
	ld	(Player.VelY), hl
	res	1, (ix+$22)
	ret	


; =============================================================================
;	Player_UpdatePositionX(uint16 plyr_obj_ptr)
; -----------------------------------------------------------------------------
;	Updates the player object's x-velocity and adds the resulting value to the
;	3-byte X coordinate.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to player object structure.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Player_UpdatePositionX:		;$3AE1
	ld	hl, (Player.VelX)
	
	; add inertia?
	ld	de, (Player_DeltaVX)
	add	hl, de
	
	; add gradient adjustment/friction?
	ld	de, (Player_MetaTileDeltaVX)
	add	hl, de
	
	; check the sign bit of the calculated value
	; if it's negative the player is moving left
	bit	7, h
	jr	nz, +_
	
	; player moving right - check speed against maximum
	; test for collision at right edge & stop if required
	bit	2, (ix + Object.ix23)
	jp	nz, Player_UpdatePositionX_SetZero

	ld	(ix + Object.ix0A), $40
	
	; limit horizontal velocity to maximum
	ld	a, (Player_MaxVelX + 1)
	ld	b, a
	ld	a, h
	cp	b
	jr	c, ++_
	
	ld	hl, (Player_MaxVelX)
	jr	++_


_:	; test for collision at left edge & stop if required
	bit	3, (ix + Object.ix23)
	jp	nz, Player_UpdatePositionX_SetZero
	
	ld	(ix + Object.ix0A), $C0	
	
	; since the object is moving left, we need to negate the max
	; value before comparing
	ld	a, (Player_MaxVelX + 1)
	neg	
	ld	b, a
	ld	a, h
	cp	b
	jr	nc, +_
	
	; enforce the limit. 2's comp the maximum value and set
	; it as the object's X velocity
	ld	hl, (Player_MaxVelX)
	dec	hl
	ld	a, h
	cpl	
	ld	h, a
	ld	a, l
	cpl	
	ld	l, a

_: 	; set the player's horizontal velocity
	ld	(Player.VelX), hl
	
	ld	c, $00
	
	; check the velocity sign bit
	bit	7, h
	jr	z, +_
	
	; sign is negative. set C = $FF
	dec	c
	
_:	xor	a
	; adjust the 3-byte x-coordinate
	ld	de, (Player.SubPixelX)
	add	hl, de
	ld	(Player.SubPixelX), hl
	adc	a, c			;add carry to 3rd byte
	add	a, (ix + Object.X + 1)
	ld	(Player.X + 1), a
	
	ret	

Player_UpdatePositionX_SetZero:		;$3B44
	; set velocity & accelleration to 0
	ld	hl, $0000
	ld	(Player.VelX), hl
	ld	(Player_DeltaVX), hl
	ret	


Player_UpdatePlayer.VelY:		;$3B4E
	; check to see if the object is standing on ground
	bit	OBJ_F3_IN_AIR, (ix + Object.Flags03)
	jp	nz, Player_CalcGravity
	
	ld	a, ($D3B9)
	or	a
	ret	nz

	; fetch the player object's y velocity
	ld	hl, (Player.VelY)
	
	; check the value's sign bit
	ld	a, h
	and	a
	; jump if sign is positive
	jp	p, Player_UpdateVPOS
	
	
	; sign is negative. 2's comp the value
	dec	hl
	ld	a, h
	cpl	
	ld	h, a
	ld	a, l
	cpl	
	ld	l, a
	jp	Player_UpdateVPOS


;****************************************************************
;*	Calculates gravity based on the player's current	*
;*	state.							*
;****************************************************************
Player_CalcGravity:		;$3B6A
	ld	hl, (Player.VelY)
	ld	a, (Player_UnderwaterFlag)			;check to see if player is underwater
	or	a
	jp	nz, Player_CalcGravity_Underwater
	
	ld	a, (ix + Object.State)
	
	ld	de, $0018						;deceleration from vertical spring
	cp	PlayerState_VerticalSpring
	jr	z, +_
	
	ld	de, $0024						;deceleration from ramp jump
	cp	PlayerState_JumpFromRamp
	jr	z, +_
	
	ld	de, $0030						;deceleration from normal jump
	
_:	add	hl, de							;adjust the vertical velocity
	ld	a, h
	and	a
	jp	m, Player_UpdateVPOS	;jump if resulting velocity is negative
	cp	$07
	jp	c, +_
	ld	hl, $0700						;cap gravity at $700
_:	jr	Player_UpdateVPOS


;****************************************************************
;*	Calculates gravity for underwater sections based on 	*
;*	the player's current state.				*
;****************************************************************
Player_CalcGravity_Underwater:		;$3B96
	ld	a, (ix + Object.State)
	
	ld	de, $000C					;deceleration after collision with spring
	cp	PlayerState_VerticalSpring
	jr	z, +_
	
	ld	de, $0012					;deceleration after ramp jump
	cp	PlayerState_JumpFromRamp
	jr	z, +_
	
	ld	de, $0018					;deceleration for other conditions

_:	add	hl, de						;adjust the vertical velocity
	ld	a, h
	and	a
	jp	m, Player_UpdateVPOS		;jump if negative
	cp	$04
	jr	c, Player_UpdateVPOS		;jump if HL < $400
	ld	hl, $0400					;cap gravity at $400


Player_UpdateVPOS:		;$3BB7
	bit	1, (ix+$22)		;is there a collision at the bottom edge?
	jr	z, +_		;jump if there isn't
	
	ld	hl, $0700
	
_:	ld	(Player.VelY), hl
	ld	c, $00
	bit	7, h			;is velocity negative?
	jr	z, +_
	
	dec	c

_:	xor	a
	
	ld	de, ($D513)		;get player vpos
	add	hl, de			;add velocity to vpos
	ld	($D513), hl
	adc	a, c
	add	a, (ix+$15)
	ld	($D515), a
	ret	


; =============================================================================
;	Player_CalcAccel()
; -----------------------------------------------------------------------------
;	Calculates player object's acceleration/deceleration value based on the
;	current state & which buttons are pressed.
;
;	FIXME: massive amounts of code duplication here.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Player_CalcAccel:		; $3BDD
	; calculate the player's onscreen position and apply
	; the limits accordingly
	ld	hl, (Player.X)
	ld	de, (Camera_X)
	xor	a
	sbc	hl, de
	ld	a, l
	; check to see if the player is at the far-left of the level
	ld	bc, 16
	cp	16
	jp	c, Engine_LimitScreenPos_Right
	; check to see if the player is at the far-right of the level.
	ld	bc, $00F7
	cp	$F8
	jp	nc, Engine_LimitScreenPos_Right


	; don't change acceleration value if player is hurt
	ld	a, (ix + Object.State)
	cp	PlayerState_Hurt
	ret	nc

	; if player is under water jump to alternate routine
	ld	a, (Player_UnderwaterFlag)
	or	a
	jp	nz, Player_CalcAccel_UnderWater

	; get the player's state multiply it so that it can be used
	; as an index into an array of dwords
	ld	a, (ix + Object.State)
	add	a, a
	add	a, a
	ld	l, a
	ld	h, $00

	; check to see if the left/right buttons are being pressed
	; (i.e. do we need to apply acceleration?)
	ld	a, (Engine_InputFlags)
	and	BTN_LEFT | BTN_RIGHT
	jp	z, Player_CalcAccel_NoBtnPress

	; use this array if the player is moving left
	ld	de, Data_AccelerationValues_Left
	bit	7, (ix + Object.VelX + 1)
	jr	nz, +_
	
	; use this array if the player is moving right
	ld	de, Data_AccelerationValues_Right
	
_:	ld	bc, $0000

	; check the input flags to see if the left button is pressed.
	bit	BTN_LEFT_BIT, a
	jp	nz, Player_CalcAccel_GetValue
	
	; left button not pressed
	ld	bc, $0002

Player_CalcAccel_GetValue:		; $3C2B
	; adjust the index to point to either the left or right value
	add	hl, bc
	add	hl, de
	
	; fetch the acceleration value from the array
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	
	; get the player's x velocity
	ld	hl, (Player.VelX)
	
	; make sure that the velocity value is positive
	bit	7, h
	jr	z, +_
	dec	hl
	ld	a, h
	cpl	
	ld	h, a
	ld	a, l
	cpl	
	ld	l, a

_:	; if velocity >= $80 double the delta value
	ld	bc, $0080
	add	hl, bc
	ld	a, h
	or	a
	jr	nz, +_
	ex	de, hl		;de *= 2
	add	hl, hl
	ex	de, hl

_:	; set the acceleration value
	ld	(Player_DeltaVX), de

	; fetch the metatile's speed modifier index
	ld	a, ($D363)
	; use the value as an index into the array of gradient
	; delta-v values.
	ld	l, a
	ld	h, $00
	ld	de, DATA_4016
	add	hl, de
	; fetch & store the gradient delta-v
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	(Player_MetaTileDeltaVX), de
	ret	

Player_CalcAccel_UnderWater:		; $3C5F
	; get the player's state multiply it so that it can be used
	; as an index into an array of dwords
	ld	a, (ix + Object.State)
	ld	l, a
	ld	h, $04
	mlt	hl

	; check to see if left/right button is pressed
	ld	a, (Engine_InputFlags)
	and	BTN_LEFT | BTN_RIGHT
	jr	z, Player_CalcAccel_NoBtnPress

	; use this array if the player is moving left
	ld	de, Data_AccelerationValues_Left_UnderWater
	bit	7, (ix + Object.VelX + 1)
	jr	nz, +_
	
	; use this array if the player is moving right
	ld	de, Data_AccelerationValues_Right_UnderWater
	
_:	; check the input flags to see if the left button is pressed.
	ld	bc, $0000
	bit	BTN_LEFT_BIT, a
	jp	nz, Player_CalcAccel_GetValue
	; right button pressed
	ld	bc, $0002
	jp	Player_CalcAccel_GetValue


Player_CalcAccel_NoBtnPress:		; $3CB8
	; reset the delta value
	ld	de, $0000
	ld	(Player_DeltaVX), de

	; return if the player is not moving
	ld	bc, (Player.VelX)
	ld	a, b
	or	c
	ret	z

	; index into the deceleration values
	ld	de, Data_DecelerationValues
	
	; adjust the index value depending on whether the
	; player is moving left or right
	ld	bc, $0000
	bit	7, (ix + Object.VelX + 1)
	jp	nz, Player_CalcAccel_GetValue
	ld	bc, $0002
	jp	Player_CalcAccel_GetValue

Engine_LimitScreenPos_Right:	;$3CE6
	ld	hl, (Camera_X)		;horizontal cam offset
	add	hl, bc
	ld	(Player.X), hl
	xor	a
	ld	(Player.SubPixelX), a

_:	;subtract velocity from hpos
	ld	hl, (Player.SubPixelX)
	ld	de, (Player.VelX)
	ld	c, 0
	
	; if velocity is negative, C = $FF
	bit	7, d
	jr	z, +_
	dec	c

_:	; update the 3-byte x-position value
	xor	a
	sbc	hl, de
	ld	(Player.SubPixelX), hl
	ld	a, (ix + Object.X + 1)
	sbc	a, c
	ld	(ix + Object.X + 1), a

	; reset velocity & delta-v
	ld	hl, $0000
	ld	(Player_DeltaVX), hl
	ld	(Player.VelX), hl
	ret	

#if Version = 2
.db $D5, $C9
#endif

Data_AccelerationValues_Right:		; $3D16
#import "misc/accel_values_right.bin"

Data_AccelerationValues_Left:		; $3D96
#import "misc/accel_values_left.bin"

Data_DecelerationValues:			; $3E16
#import "misc/decel_values.bin"

Data_AccelerationValues_Right_UnderWater:		; $3E96
#import "misc/accel_values_right_water.bin"

Data_AccelerationValues_Left_UnderWater:		; $3F16
#import "misc/accel_values_left_water.bin"


;gradient delta-v values
DATA_4016:
.dw $0000
.dw $FFE1
.dw $001F
.dw $FFE8
.dw $0018
.dw $FFF0
.dw $0010

LABEL_4024:
	res	0, (ix+$03)
	set	2, (ix+$03)
	ld	(ix+$02), $11
	ld	hl, $0000
	ld	($D516), hl
	ret

LABEL_4037:
	res	0, (ix+$03)
	set	2, (ix+$03)
	ld	(ix+$02), $12
	ret

LABEL_4044:	
	bit	1, (ix+$22)
	jr	nz, LABEL_404F
	ld	(ix+$02), $13
	ret

LABEL_404F:
	set	0, (ix+$03)
	ld	(ix+$02), $13
	ld	(ix+$18), $00
	ld	(ix+$19), $fe
	res	1, (ix+$22)
	ret

LABEL_4064:
	ld	(ix+$02), PlayerState_HangGliderBack
	ld	(ix+$18), $00
	ld	(ix+$19), $fe
	set	0, (ix+$03)
	res	1, (ix+$22)
	ret

LABEL_4079:
	ld	(ix+$02), PlayerState_HangGliderFwd
	ld	(ix+$18), $80
	ld	(ix+$19), $00
	set	0, (ix+$03)
	res	1, (ix+$22)
	ret

LABEL_408E:
	res	7, (ix+$04)
	call	LABEL_3A62
	ld	hl, ($D516)
	bit	7, h
	jr	z, +_
	dec	hl
	ld	a, h
	cpl	
	ld	h, a
	ld	a, l
	cpl	
	ld	l, a
_:	ld	a, l
	and	$F0
	or	h
	jr	nz, LABEL_4037
	bit	1, (ix+$22)
	jr	z, LABEL_4044
	ret

LABEL_40B2:
	res	7, (ix+$04)
	call	LABEL_3A62
	bit	1, (ix+$22)
	jr	z, LABEL_4044
	ld	hl, ($D516)
	bit	7, h
	jr	z, +_
	dec	hl
	ld	a, h
	cpl	
	ld	h, a
	ld	a, l
	cpl	
	ld	l, a
_:	ld	a, l
	and	$F0
	or	h
	jp	z, LABEL_4024
	ret

LABEL_40D6:
	res	7, (ix+$04)
	call	LABEL_4137
	call	LABEL_6BF2
LABEL_40E0:
	call	LABEL_376E
	bit	1, (ix+$22)
	jr	z, LABEL_40F0
	res	2, (ix+$03)
	jp	LABEL_3032

LABEL_40F0:
	ld	a, (ix+$22)
	and	$0F
	jr	nz, +_
	call	LABEL_4109
	jr	c, +_
	ld	a, (Engine_InputFlags)
	and	BTN_1 | BTN_2
	ret	z
_:	res	2, (ix+$03)
	jp	Player_SetState_Falling

LABEL_4109:
	ld	de, ($D174)
	ld	hl, ($D511)
	xor	a
	sbc	hl, de
	jr	c, LABEL_4135
	
	ld	a, h
	or	a
	jr	nz, LABEL_4135
	
	ld	a, l
	cp	$F0
	jp	nc, LABEL_4135
	
#if Version = 2
	ld	hl, ($D176)
	ld	de, $0020
	add	hl, de
	ld	de, ($D514)
	ex	de, hl
#else
	ld	de, ($D176)
	ld	hl, ($D514)
#endif
	xor	a
	sbc	hl, de
	
#if Version = 2
	jp	nc, +_
	ld	($D514), de
_:
#else
	jr	c, LABEL_4135
	ld	a, h
	or	a
	jr	nz, LABEL_4135
#endif
	xor	a
	ret

LABEL_4135:
	scf	
	ret

LABEL_4137:
	call	LABEL_4204
	ld	de, $0004
	ld	bc, $0200
	call	Engine_SetObjectVerticalSpeed
	call	Engine_UpdateObjectPosition
	ld	a, (Engine_InputFlags)
	bit	BTN_LEFT_BIT, a
	jr	nz, LABEL_415F
	bit	BTN_RIGHT_BIT, a
	jr	nz, LABEL_415A
	ld	a, ($D440)
	cp	$02
	jr	z, LABEL_415F
	ret

LABEL_415A:
	ld	(ix+$02), $15
	ret

LABEL_415F:
	ld	e, (ix+$16)
	ld	d, (ix+$17)
	ld	l, e
	ld	h, d
	ld	bc, $01C0
	xor	a
	sbc	hl, bc
	jr	c, +_
	ld	de, $01C0
_:	ld	l, (ix+$18)
	ld	h, (ix+$19)
	add	hl, de
	srl	h
	rr	l
	bit	7, h
	jr	nz, +_
	ex	de, hl
	ld	hl, $0000
	xor	a
	sbc	hl, de
	ld	de, $0080
	add	hl, de
	jr	c, +_
	ld	(ix+$18), l
	ld	(ix+$19), h
_:	ld	(ix+$02), $14
	ret

LABEL_4199:
	res	7, (ix+$04)
	call	LABEL_41A6
	call	LABEL_6BF2
	jp	LABEL_40E0

LABEL_41A6:
	call	Engine_UpdateObjectPosition
	call	LABEL_4226
	ld	a, (Engine_InputFlags)
	bit	BTN_RIGHT_BIT, a
	jr	nz, +_
	ld	a, ($D440)
	cp	$02
	ret	z
_:	ld	de, $0008
	ld	bc, $0400
	call	Engine_SetObjectVerticalSpeed
	ld	a, (Engine_InputFlags)
	bit	BTN_LEFT_BIT, a
	ret	nz
	ld	a, (ix+$19)
	bit	7, a
	jr	z, +_
	ld	hl, $0000
	ld	(ix+$18), l
	ld	(ix+$19), h
_:	ld	(ix+$02), $13
	ret

LABEL_41DD:
	res	7, (ix+$04)
	call	LABEL_41EA
	call	LABEL_6BF2
	jp	LABEL_40E0

LABEL_41EA:
	call	LABEL_4226
	ld	de, $0010
	ld	bc, $0400
	call	Engine_SetObjectVerticalSpeed
	call	Engine_UpdateObjectPosition
	ld	a, (Engine_InputFlags)
	bit	BTN_RIGHT_BIT, a
	ret	nz
	ld	(ix+$02), $13
	ret

LABEL_4204:
	ld	l, (ix+$16)
	ld	h, (ix+$17)
	ld	de, $0006
	add	hl, de
	ld	e, l
	ld	d, h
	bit	7, h
	jr	nz, +_
	ld	bc, $0280
	xor	a
	sbc	hl, bc
	jr	c, +_
	ld	de, $0280
_:	ld	(ix+$16), e
	ld	(ix+$17), d
	ret

LABEL_4226:
	ld	l, (ix+$16)
	ld	h, (ix+$17)
	ld	de, $000A
	xor	a
	sbc	hl, de
	ld	e, l
	ld	d, h
	bit	7, h
	jr	nz, +_
	ld	bc, $0060
	xor	a
	sbc	hl, bc
	jp	nc, ++_
_:	ld	de, $0060
_:	ld	(ix+$16), e
	ld	(ix+$17), d
	ret

LABEL_424A:	;handle GMZ wheel
	call	LABEL_376E
	res	7, (ix + Object.Flags04)
	ld	a, (Engine_InputFlags)
	and	BTN_LEFT | BTN_RIGHT
	jr	z, ++++_
	ld	de, $0010
	and	$08
	jr	nz, +_
	ld	de, -16
_:	ld	hl, ($D3C7)
	add	hl, de
	ld	e, l
	ld	d, h
	ld	bc, $0300
	xor	a
	sbc	hl, bc
	jr	nc, +_
	ld	de, $0300
_:	ld	l, e
	ld	h, d
	ld	bc, $07FF
	xor	a
	sbc	hl, bc
	jr	c, +_
	ld	de, $07FF
_:	ld	($D3C7), de
_:	ld	a, ($D3C6)
	ld	b, a
	ld	a, ($D3C8)
	add	a, b
	ld	($D3C6), a
	call	LABEL_42B7
	ld	a, (Engine_InputFlags)
	and	BTN_1 | BTN_2
	ret	z
	xor	a
	ld	($D3CD), a
	ld	(ix+$02), $0B
	ld	a, ($D3C6)
	add	a, $40
	ld	(ix+$0A), a
	ld	a, ($D3C8)
	add	a, a
	add	a, a
	add	a, a
	add	a, a
	add	a, a
	ld	(ix+$0B), a
	jp	LABEL_64D4

LABEL_42B7:
	ld	a, ($D3C6)
	ld	c, a
	ld	b, $00
	ld	hl, DATA_330
	add	hl, bc
	ld	a, (hl)
	and	a
	jp	m, LABEL_42E8
	ld	e, $50
	ld	hl, $D3CA
	bit	7, (hl)
	jr	z, +_
	ld	e, $38
_:	ld	hl, $0000
	ld	d, $00
	ld	b, $08
_:	rrca	
	jr	nc, +_
	add	hl, de
_:	sla	e
	rl	d
	djnz	--_
	ld	l, h
	ld	h, $00
	jr	LABEL_4310

LABEL_42E8:
	neg	
	ld	e, $50
	ld	hl, $D3CA
	bit	7, (hl)
	jr	z, +_
	ld	e, $38
_:	ld	hl, $0000
	ld	d, $00
	ld	b, $08
_:	rrca	
	jr	nc, +_
	add	hl, de
_:	sla	e
	rl	d
	djnz	--_
	ld	de, $0000
	ex	de, hl
	xor	a
	sbc	hl, de
	ld	a, h
	ld	hl, -1
	ld	l, a
LABEL_4310:
	ld	de, ($D3C9)
	ld	a, d
	and	$7F
	ld	d, a
	add	hl, de
	ld	(ix + Object.X), l
	ld	(ix + Object.X + 1), h
	ld	a, ($D3C6)
	add	a, $C0
	ld	c, a
	ld	b, $00
	ld	hl, DATA_330
	add	hl, bc
	ld	a, (hl)
	and	a
	jp	m, LABEL_4352
	ld	e, $50
	ld	hl, $D3CA
	bit	7, (hl)
	jr	z, +_
	ld	e, $38
_:	ld	hl, $0000
	ld	d, $00
	ld	b, $08
_:	rrca
	jr	nc, +_
	add	hl, de
_:	sla	e
	rl	d
	djnz	--_
	ld	l, h
	ld	h, $00
	jp	LABEL_437A

LABEL_4352:
	neg
	ld	e, $50
	ld	hl, $D3CA
	bit	7, (hl)
	jr	z, +_
	ld	e, $38
_:	ld	hl, $0000
	ld	d, $00
	ld	b, $08
_:	rrca
	jp	nc, +_
	add	hl, de
_:	sla	e
	rl	d
	djnz	--_
	ld	de, $0000
	ex	de, hl
	xor	a
	sbc	hl, de
	ld	a, h
	ld	hl, -1
	ld	l, a
LABEL_437A:
	ld	de, ($D3CB)
	add	hl, de
	ld	de, $000C
	add	hl, de
	ld	(ix+$14), l
	ld	(ix+$15), h
	ret

LABEL_438A:
	res	7, (ix+$04)
	ld	a, ($D3C4)
	ld	b, a
	ld	a, ($D365)
	ld	($D3C4), a
	cp	b
	jr	z, +_
	xor	a
	ld	($D3C5), a
_:	ld	a, ($D365)
	sub	$30
	ld	b, a
	jr	c, LABEL_43AF
	cp	$10
	jp	nc, LABEL_43AF
	jr	LABEL_43BF

LABEL_43AF:
	ld	a, ($D367)
	sub	$30
	ld	b, a
	jr	c, LABEL_43F9
	cp	$10
	jp	nc, LABEL_43F9
	jr	LABEL_43C5

LABEL_43BF:
	ld	a, ($D3C5)
	or	a
	jr	nz, LABEL_43F3
LABEL_43C5:
	ld	a, b
	add	a, a
	ld	e, a
	ld	d, $00
	ld	hl, DATA_43D3
	add	hl, de
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	jp	(hl)

DATA_43D3:
.dw LABEL_4414 
.dw LABEL_441A 
.dw LABEL_45A8 
.dw LABEL_45C6 
.dw LABEL_45E4 
.dw LABEL_4602 
.dw LABEL_4420 
.dw LABEL_4482 
.dw LABEL_4546 
.dw LABEL_44E4 
.dw LABEL_4620 
.dw LABEL_4408 
.dw LABEL_440E 
.dw LABEL_4623 
.dw LABEL_4629 
.dw LABEL_4408

LABEL_43F3:
	call	Engine_UpdateObjectPosition
	jp	LABEL_6BF2

LABEL_43F9:
	xor	a
	ld	(Player_HurtTrigger), a
	ld	(ix+$21), a
	jp	Player_SetState_JumpFromRamp

LABEL_4408:
LABEL_440E:
LABEL_441A:
	call	LABEL_468D
	jp	LABEL_43F3

LABEL_4414:
	call	LABEL_469D
	jp	LABEL_43F3

LABEL_4420:
	ld	a, (ix+$17)
	or	a
	jr	z, LABEL_445F
	bit	7, (ix+$17)
	jr	z, LABEL_4446
	call	LABEL_462F
	jp	nc, LABEL_43F3
	ld	a, (Engine_InputFlags)
	bit	BTN_UP_BIT, a
	jr	nz, LABEL_4440
	call	LABEL_465D
	jp	LABEL_43F3

LABEL_4440:
LABEL_4459:
	call	LABEL_467D
	jp	LABEL_43F3

LABEL_4446:
	call	LABEL_4637
	jp	nc, LABEL_43F3
	ld	a, (Engine_InputFlags)
	bit	BTN_UP_BIT, a
	jr	nz, LABEL_4459
	call	LABEL_464D
	jp	LABEL_43F3
	
LABEL_445F:
	call	LABEL_4640
	jp	nc, LABEL_43F3
	ld	a, (Engine_InputFlags)
	bit	BTN_RIGHT_BIT, a		;right button
	jr	nz, LABEL_4476
	bit	BTN_LEFT_BIT, a			;left button
	jr	nz, LABEL_447C
	call	LABEL_467D
	jp	LABEL_43F3

LABEL_4476:
	call	LABEL_464D
	jp	LABEL_43F3


LABEL_447C:
	call	LABEL_465D
	jp	LABEL_43F3

LABEL_4482:
	ld	a, (ix+$17)
	or	a
	jr	z, LABEL_44C1
	bit	7, (ix+$17)
	jr	z, LABEL_44A8
	call	LABEL_462F
	jp	nc, LABEL_43F3
	ld	a, (Engine_InputFlags)
	bit	BTN_DOWN_BIT, a
	jr	nz, LABEL_44A2
	call	LABEL_465D
	jp	LABEL_43F3

LABEL_44A2:
	call	LABEL_466D
	jp	LABEL_43F3

LABEL_44A8:
	call	LABEL_4637
	jp	nc, LABEL_43F3
	ld	a, (Engine_InputFlags)
	bit	BTN_DOWN_BIT, a
	jr	nz, LABEL_44BB
LABEL_44D8:
	call	LABEL_464D
	jp	LABEL_43F3

LABEL_44C1:
	call	LABEL_464B
	jp	nc, LABEL_43F3
	ld	a, (Engine_InputFlags)
	bit	BTN_RIGHT_BIT, a
	jr	nz, LABEL_44D8
	bit	BTN_LEFT_BIT, a
	jr	nz, LABEL_44DE
LABEL_44BB:
	call	LABEL_466D
	jp	LABEL_43F3

LABEL_44DE:
LABEL_4504:
LABEL_451D:
	call	LABEL_465D
	jp	LABEL_43F3
	
LABEL_44E4:
	ld	a, (ix+$17)
	or	a
	jr	nz, LABEL_4523
	bit	7, (ix+$19)
	jr	z, LABEL_450A
	call	LABEL_464B
	jp	nc, LABEL_43F3
	ld	a, (Engine_InputFlags)
	bit	BTN_LEFT_BIT, a
	jr	nz, LABEL_4504
LABEL_453A:
	call	LABEL_467D
	jp	LABEL_43F3

LABEL_450A:
	call	LABEL_4640
	jp	nc, LABEL_43F3
	ld	a, (Engine_InputFlags)
	bit	BTN_LEFT_BIT, a
	jr	nz, LABEL_451D
	call	LABEL_466D
	jp	LABEL_43F3

LABEL_4523:
	call	LABEL_4637
	jp	nc, LABEL_43F3
	ld	a, (Engine_InputFlags)
	bit	BTN_UP_BIT, a
	jr	nz, LABEL_453A
	bit	BTN_DOWN_BIT, a
	jr	nz, LABEL_4540
	call	LABEL_465D
	jp	LABEL_43F3
	
LABEL_4540:
	call	LABEL_466D
	jp	LABEL_43F3

LABEL_4546:
	ld	a, (ix+$17)
	or	a
	jr	nz, LABEL_4585
	bit	7, (ix+$19)
	jr	z, LABEL_456C
	call	LABEL_464B
	jp	nc, LABEL_43F3
	ld	a, (Engine_InputFlags)
	bit	BTN_RIGHT_BIT, a
	jr	nz, LABEL_4566
	call	LABEL_467D
	jp	LABEL_43F3
LABEL_456C:
	call	LABEL_4640
	jp	nc, LABEL_43F3
	ld	a, (Engine_InputFlags)
	bit	BTN_RIGHT_BIT, a
	jr	nz, LABEL_457F
	call	LABEL_466D
	jp	LABEL_43F3

LABEL_4585:
	call	LABEL_462F
	jp	nc, LABEL_43F3
	ld	a, (Engine_InputFlags)
	bit	BTN_UP_BIT, a
	jr	nz, LABEL_459C
	bit	BTN_DOWN_BIT, a
	jr	nz, LABEL_45A2
LABEL_4566:
LABEL_457F:
	call	LABEL_464D
	jp	LABEL_43F3

LABEL_459C:
	call	LABEL_467D
	jp	LABEL_43F3

LABEL_45A2:
	call	LABEL_466D
	jp	LABEL_43F3

LABEL_45A8:
	ld	a, (ix+$17)
	or	a
	jr	nz, LABEL_45BA
	call	LABEL_464B
	jp	nc, LABEL_43F3
	call	LABEL_464D
	jp	LABEL_43F3

LABEL_45BA:
	call	LABEL_462F
	jp	nc, LABEL_43F3
	call	LABEL_466D
	jp	LABEL_43F3

LABEL_45C6:
	ld	a, (ix+$17)
	or	a
	jr	nz, LABEL_45D8
	call	LABEL_464B
	jp	nc, LABEL_43F3
	call	LABEL_465D
	jp	LABEL_43F3

LABEL_45D8:
	call	LABEL_4637
	jp	nc, LABEL_43F3
	call	LABEL_466D
	jp	LABEL_43F3

LABEL_45E4:
	ld	a, (ix+$17)
	or	a
	jr	nz, LABEL_45F6
	call	LABEL_4640
	jp	nc, LABEL_43F3
	call	LABEL_464D
	jp	LABEL_43F3

LABEL_45F6:	
	call	LABEL_462F
	jp	nc, LABEL_43F3
	call	LABEL_467D
	jp	LABEL_43F3

LABEL_4602:
	ld	a, (ix+$17)
	or	a
	jr	nz, LABEL_4614
	call	LABEL_4640
	jp	nc, LABEL_43F3
	call	LABEL_465D
	jp	LABEL_43F3


LABEL_4614:
	call	LABEL_4637
	jp	nc, LABEL_43F3
	call	LABEL_467D
	jp	LABEL_43F3

LABEL_4620:
	jp	LABEL_43F3
			
LABEL_4623:
	call	LABEL_469D
	jp	LABEL_43F3

LABEL_4629:
	call	LABEL_469D
	jp	LABEL_43F3

LABEL_462F:
	ld	a, (ix+$11)
	and	$1F
	cp	$0E
	ret

LABEL_4637:
	ld	a, (ix+$11)
	and	$1F
	cp	$0E
	ccf	
	ret

LABEL_4640:
	ld	a, (ix+$14)
	sub	$0E
	and	$1F
	cp	$14
	ccf	
	ret

LABEL_464B:
	scf	
	ret

LABEL_464D:
	call	LABEL_469D
	ld	hl, $0000
	ld	($D518), hl
	ld	hl, $0600
	ld	($D516), hl
	ret

LABEL_465D:
	call	LABEL_469D
	ld	hl, $0000
	ld	($D518), hl
	ld	hl, $FA00
	ld	($D516), hl
	ret

LABEL_466D:
	call	LABEL_468D
	ld	hl, $0600
	ld	($D518), hl
	ld	hl, $0000
	ld	($D516), hl
	ret

LABEL_467D:
	call	LABEL_468D
	ld	hl, $FA00
	ld	($D518), hl
	ld	hl, $0000
	ld	($D516), hl
	ret

LABEL_468D:
	ld	a, (ix+$11)
	and	$E0
	add	a, $0E
	ld	(ix+$11), a
	ld	a, $FF
	ld	($D3C5), a
	ret

LABEL_469D:
	ld	l, (ix+$14)
	ld	h, (ix+$15)
	ld	de, -16
	add	hl, de
	ld	a, l
	and	$E0
	ld	l, a
	ld	de, $002A
	add	hl, de
	ld	(ix+$14), l
	ld	(ix+$15), h
	ld	a, $FF
	ld	($D3C5), a
	ret

LABEL_46BB:
	ld	(ix+$02), $17
	ret

;called on initial collision with mine cart
LABEL_46C0:
	res	7, (ix+$04)
	ld	hl, $D3A0
	ld	(hl), $00
	inc	hl
	ld	(hl), $02
	inc	hl
	ld	(hl), $04
	inc	hl
	ld	(hl), $6A
	inc	hl
	ld	(hl), $6C
	inc	hl
	ld	(hl), $6E
	inc	hl
	ld	(hl), $70
	inc	hl
	ld	(hl), $72
	ld	iy, ($D39E)
	call	LABEL_4727
	set	7, (iy+$04)
	ret

;called once per frame when in a mine cart
LABEL_46EA:
	ld	iy, ($D39E)
	call	LABEL_4727
	call	LABEL_7378
	call	LABEL_376E
	ld	a, (ix+$02)
	cp	$1E
	jr	z, +_
	res	0, (ix+$03)
	ld	a, (Engine_InputFlags)
	and	BTN_1 | BTN_2
	ret	z
_:	ld	iy, ($D39E)
	res	7, (iy+$04)
	ld	(iy+$1F), $10
	set	6, (iy+$03)
	ld	a, (iy+$3F)
	ld	(iy+$02), a
	ld	hl, $0000
	ld	($D39E), hl
	jp	Player_SetState_Jumping

LABEL_4727:
	ld	l, (iy+$11)
	ld	h, (iy+$12)
	ld	($D511), hl
	ld	l, (iy+$14)
	ld	h, (iy+$15)
	ld	($D514), hl
	ld	l, (iy+$16)
	ld	h, (iy+$17)
	ld	($D516), hl
	ld	l, (iy+$18)
	ld	h, (iy+$19)
	ld	($D518), hl
	ld	hl, $D503
	set	1, (hl)
	call	Player_CheckHorizontalLevelCollision
	ld	a, (iy+$3F)
	cp	$02
	jr	z, LABEL_475F
	set	4, (ix+$04)
	ret

LABEL_475F:
	res	4, (ix+$04)
	ret

;************************************************
;*	UGZ Mine Cart input handling routines	*
;************************************************
Player_MineCart_Handle:
LABEL_4764:
	ld	a, (Engine_InputFlags)
	ld	de, MineCart_LookingUp
	bit	BTN_UP_BIT, a			;check for up button
	jr	nz, +_
	ld	de, MineCart_LookingDown
	bit	BTN_DOWN_BIT, a			;check for down button
	jr	nz, +_
	ld	de, MineCart_LookingAhead
_:	ld	a, (ix+$1E)		;frame number
	bit	7, (ix+$17)
	jr	nz, MineCart_UpdateAnimation
	inc	a
	jr	MineCart_SetSprite

MineCart_UpdateAnimation:		;4784
	dec	a				;next frame
MineCart_SetSprite:			;4785
	and	$03			;cap at 4 frames
	ld	(ix+$1E), a	;store frame number
	add	a, a			;calculate offset
	add	a, (ix+$1E)
	ld	l, a
	ld	h, $00
	add	hl, de
	ld	a, (hl)		;sprite state?
	ld	(ix+$06), a
	inc	hl
	ld	a, (hl)		;wheel left
	ld	($D3A6), a
	inc	hl
	ld	a, (hl)		;wheel right
	ld	($D3A7), a
	ld	(ix+$07), $03	;?
	ret

;		Wheel (left)
;	?	|	Wheel (right)
;	|----|----|----|
MineCart_LookingAhead:
.db $59, $70, $72 
.db $59, $74, $76 
.db $5A, $78, $7A
.db $5A, $7C, $7E

MineCart_LookingUp:
.db $5B, $70, $72 
.db $5B, $74, $76 
.db $5B, $78, $7A 
.db $5B, $7C, $7E

MineCart_LookingDown:
.db $5C, $70, $72
.db $5C, $74, $76
.db $5C, $78, $7A
.db $5C, $7C, $7E


;************************************************
;*	Power-up monitor collision routines.	*
;************************************************
LABEL_47C9:
	ld	a, (Player.PowerUp)		;check for power-up
	or	a
	jr	z, Collision_Monitor

	ld	hl, (Engine_PowerUpTimer)	;increment counter
	inc	hl
	ld	(Engine_PowerUpTimer), hl

	ld	bc, $04B0		;check to see if timer has expired
	xor	a
	sbc	hl, bc
	jr	c, Collision_Monitor	;jump if timer hasn't expired

	xor	a				;reset power-up
	ld	(Player.PowerUp), a

	ld	hl, $0000		;reset timer
	ld	(Engine_PowerUpTimer), hl

	ld	a, ($D4A2)		;check the boss flag
	or	a
	ret	nz

	ld	a, (GlobalTriggers)		;check bit 6 of the game mode
	and	$BF
	ret	nz

#if Version = 2
	ld	a, (Player.State)
	cp	PlayerState_EndOfLevel
	ret	z
#endif

Collision_Monitor:			;$47F6
	ld	hl, Engine_MonitorCllsnType
	ld	a, (hl)
	bit	0, a
	jr	nz, Collision_Monitor_Rings
	bit	1, a
	jr	nz, Collision_Monitor_Life
	bit	4, a
	jr	nz, Collision_Monitor_Continue
	bit	5, a
	jr	nz, LABEL_4845
	bit	2, a
	jr	nz, Collision_Monitor_Sneakers
	bit	3, a
	jr	nz, Collision_Monitor_Invincibility
	bit	6, a
#if Version = 2
	jp	nz, LABEL_4884
#else
	jr	nz, LABEL_4884
#endif
	ret

Collision_Monitor_Rings:	;4817
	res	0, (hl)
	ld	a, (RingCounter)
	add	a, $10		;add 10 rings to the counter (bcd)
	daa	
	ld	(RingCounter), a

#if Version = 2
	call	Engine_UpdateRingCounterSprites
	
	ld	a, (RingCounter)
	cp	$10
	ret	nc
	
	ld	a, (LifeCounter)
	inc	a
	ld	(LifeCounter), a
	jp	Engine_CapLifeCounterValue
#else
	jp	Engine_UpdateRingCounterSprites
#endif

Collision_Monitor_Life:	;482A
	res	1, (hl)
	ld	a, (LifeCounter)
	inc	a
	ld	(LifeCounter), a
	jp	Engine_CapLifeCounterValue

Collision_Monitor_Continue:
LABEL_483B:
	res	4, (hl)
	ld	a, ($D2BD)		;used by continue screen
	inc	a
	ld	($D2BD), a
	ret

LABEL_4845:
	res	5, (hl)
	ret

Collision_Monitor_Sneakers:	;4848
	res	2, (hl)
	ld	a, $01			;power-up type = speed sneakers
	ld	(Player.PowerUp), a
	ld	hl, $0000		;timer (count up)
	ld	(Engine_PowerUpTimer), hl
	ld	c, Object_SpeedShoesStar
	ld	h, $00			;set up first star sprite
	call	Engine_AllocateObjectHighPriority
	ld	h, $01			;set up second star sprite
	jp	Engine_AllocateObjectHighPriority

Collision_Monitor_Invincibility:		; $4866
	res	3, (hl)
	ld	a, $02			;power-up type = invincibility
	ld	(Player.PowerUp), a
	ld	hl, $0000
	ld	(Engine_PowerUpTimer), hl	;timer
	ld	c, Object_InvincibilityStar ;show the spinning stars
	ld	h, $00
	call	Engine_AllocateObjectHighPriority
	ld	h, $01			;causes the second sprite to be opposite the first
	jp	Engine_AllocateObjectHighPriority


LABEL_4884:
	res	6, (hl)
	ret

LABEL_4887:
	call	LABEL_48F0			;update the "UnderWater" flag for the current act
	
	; check to see if the player is under water
	ld	a, (Player_UnderwaterFlag)
	or	a
	jr	nz, Engine_WaterLevel_IncAirTimer
	
	; player is not under water - clear the air timer
	xor	a
	ld	(Player_AirTimerHi), a
	ret



Engine_WaterLevel_IncAirTimer:		; $4895
	; increment the timer lo-byte for 120 frames
	; before incrementing the hi-byte.
	ld	hl, Player_AirTimerLo
	inc	(hl)
	ld	a, (hl)
	cp	Time_2Seconds
	ret	c

	; reset the lo-byte
	ld	(hl), $00
	
	call	Engine_WaterLevel_SpawnBubble

	; increment the upper byte
	ld	hl, Player_AirTimerHi
	inc	(hl)
	ld	a, (hl)

	; create the counter object after 22 seconds
	cp	11
	jr	z, Engine_WaterLevel_SpawnCountObj
	ret


Engine_WaterLevel_SpawnCountObj:		; $48B0
	ld	c, Object_AirCountdown		;countdown object number
	ld	h, $00
	jp	Engine_AllocateObjectHighPriority	;allocate a slot for the object


Engine_WaterLevel_DoNothing:		; $48B7 
	ret


Engine_WaterLevel_SpawnBubble:		; $48B8
	; use the R register as a "random" value
	ld	a, r
	and	4
	ret	nz

	; spawn a bubble
	ld	c, Object_ALZ_Bubble
	ld	h, 3
	jp	Engine_AllocateObjectHighPriority


LABEL_48C4:
	ld	a, (Player_UnderwaterFlag)
	or	a
	ret	z
	ld	hl, (Player_MaxVelX)
	srl	h
	rr	l
	ld	(Player_MaxVelX), hl
	ret


LABEL_48D4:
	ret

LABEL_48D5:
	ld	a, (Player_UnderwaterFlag)
	or	a
	ret	z
	inc	(ix+$30)
	ld	a, (ix+$30)
	and	$03
	ret	z
	ld	de, $0000
	ld	(Player_DeltaVX), de
	ld	(Player_MetaTileDeltaVX), de
	pop	de
	ret

LABEL_48F0:
	; return if we're not in ALZ
	ld	a, (CurrentLevel)
	cp	Level_ALZ
	ret	nz
	
	ld	a, (CurrentAct)
	or	a
	jr	z, LABEL_4944
	dec	a
	jr	z, Engine_UpdateUnderWaterFlag		;update for ALZ-2
	ld	hl, (Player.X)
	ld	bc, $0880
	xor	a
	sbc	hl, bc
	jr	c, LABEL_4917		;update for ALZ-3 (part 1)
	ld	hl, (Player.X)
	ld	bc, $0900
	xor	a
	sbc	hl, bc
	jr	c, LABEL_4926		;update for ALZ-3 (part 2)
	jr	LABEL_4935			;update for ALZ-3 (part 3)


LABEL_4917:
	ld	hl, (Player.Y)
	ld	bc, $0120
	xor	a
	sbc	hl, bc
	jr	c, Engine_ClearUnderWater
	jr	Engine_SetUnderWater

LABEL_4926:
	ld	hl, (Player.Y)
	ld	bc, $0160
	xor	a
	sbc	hl, bc
	jr	c, Engine_ClearUnderWater
	jr	Engine_SetUnderWater

LABEL_4935
	ld	hl, (Player.Y)
	ld	bc, $0140
	xor	a
	sbc	hl, bc
	jr	c, Engine_ClearUnderWater
	jr	Engine_SetUnderWater

LABEL_4944:	;handle water level for ALZ-1
	ld	hl, (Player.X)
	ld	bc, $0650
	xor	a
	sbc	hl, bc
	jr	c, LABEL_4951
	jr	LABEL_4960

LABEL_4951:
	ld	hl, (Player.Y)
	ld	bc, $01C0
	xor	a
	sbc	hl, bc
	jr	c, Engine_ClearUnderWater
	jr	Engine_SetUnderWater

LABEL_4960
	ld	hl, (Player.Y)
	ld	bc, $0220
	xor	a
	sbc	hl, bc
	jr	c, Engine_ClearUnderWater
	jr	Engine_SetUnderWater

Engine_UpdateUnderWaterFlag:		;$496F
	;check whether the player is below the zone's water level
	ld	hl, (Player.Y)
	ld	bc, ($D4A4)
	xor	a
	sbc	hl, bc
	jr	c, Engine_ClearUnderWater
	jr	Engine_SetUnderWater

	
Engine_ClearUnderWater:
	xor	a
	ld	(Player_UnderwaterFlag), a
	ret

Engine_SetUnderWater:
	ld	a, $FF
	ld	(Player_UnderwaterFlag), a
	ret

Engine_UpdateCameraPos:
LABEL_498A:
	ld	ix, LevelAttributes
	bit	LVP_CAMERA_LOCKED, (ix + LevelDescriptor.ViewportFlags)
	ret	z

	call	LABEL_5D93
	ld	a, ($D162)			;bank with 32x32 mappings
	call	Engine_SwapFrame2
	call	Engine_UpdateCameraXPos
	call	Engine_UpdateCameraYPos
	call	Engine_CalculateBgScroll
	set	6, (ix+$00)
	ret

;enable camera movement
Engine_ReleaseCamera:		;$49AA
	ld	hl, $D15E
	set	7, (hl)
	ret

;lock camera movement
Engine_LockCamera:			;$49B0
	ld	hl, $D15E
	res	7, (hl)
	ld	hl, ($D174)
	ld	($D280), hl
	ret

;****************************************************************
;*	Set the camera position and lock in place.		*
;*								*
;*	ld	BC		Horizontal camera offset.	*
;*	ld	DE		Vertical camera offset.		*
;*	destroys:	HL					*
;****************************************************************
Engine_SetCameraAndLock:		;$49BC
	ld	hl, $D15E
	set	7, (hl)		;lock camera
	ld	hl, $D15F
	set	0, (hl)		;update camera pos
	ld	($D2CE), bc	;horizontal camera offset
	ld	($D2D0), de	;vertical camera offset
	ret

LABEL_49CF:
	ld	hl, $D15E
	set	7, (hl)
	ld	hl, $D15F
	res	0, (hl)
	ret

Engine_SetMinimumCameraX:		;$49DA
	ld	hl, ($D280)	;minimum camera X pos
	ld	de, (Camera_X)		;current horiz. cam position?
	xor	a
	sbc	hl, de
	ret	nc
	ld	($D280), de
	ret

Engine_SetMaximumCameraX:		;$49EA
	ld	hl, ($D282)	;maximum camera x pos
	ld	de, (Camera_X)		;current horiz. cam position?
	xor	a
	sbc	hl, de
	ret	c
	ld	($D282), de
	ret


;update camera horizontal position
Engine_UpdateCameraXPos:	;$49FA
	ld	hl, ($D284)		;horiz sprite offset?
	ld	de, ($D280)		;minimum camera X pos
	xor	a
	sbc	hl, de
	jr	c, Engine_UpdateCameraXPos_Limit		;limit camera to minimum x pos
	ld	hl, ($D284)
	ld	de, ($D282)					;level width
	xor	a
	sbc	hl, de
	jr	nc, Engine_UpdateCameraXPos_Limit		;limit camera to level width
	ld	a, (Camera_X)
	ld	b, a
	ld	a, ($D284)
	xor	b
	jp	nz, Engine_LoadMappings32_Column		;load a column of tiles from the 32x32 mappings
	ret

;limit the camera position
Engine_UpdateCameraXPos_Limit:	
	ld	hl, (Camera_X)
	ld	($D284), hl
	ret


Engine_UpdateCameraYPos:		;$4A37
	ld	hl, ($D286)		;vertical offset
	ld	de, ($D27C)		;minimum camera y pos
	xor	a
	sbc	hl, de
	jr	c, Engine_UpdateCameraYPos_Limit		;limit camera to minimum y position
	ld	hl, ($D286)
	ld	de, ($D27E)		;level height
	xor	a
	sbc	hl, de
	jr	nc, Engine_UpdateCameraYPos_Limit		;limit camera to level height
	ld	a, (Camera_Y)
	and	$F8
	ld	b, a
	ld	a, ($D286)
	and	$F8
	xor	b
	jp	nz, Engine_LoadMappings32_Row		;load a row of mappings from the 32x32 mappings
	ret

;limit camera y position
Engine_UpdateCameraYPos_Limit:	;$4A75
	ld	hl, (Camera_Y)
	ld	($D286), hl
	ret

Engine_CalculateBgScroll:		;$4A7C
	ld	a, (Camera_X)		;calculate horiz. scroll
	inc	a
	neg
	ld	($D172), a		;store h-scroll
	ld	hl, (Camera_Y)	;Calculate the vertical scroll value
	ld	de, $0011
	add	hl, de
	ld	e, $E0		;224 (screen height)
_:	xor	a
	sbc	hl, de
	jr	nc, -_
	add	hl, de
	ld	a, l
	ld	($D173), a		;store v-scroll
	ret


; =============================================================================
;	Engine_Mappings_GetBlockXY(uint16 vert_ofst)
; -----------------------------------------------------------------------------
;	Calculates the address of the metatile at the left (or right - depending
;	on which direction the level is scrolling) edge of the camera with the 
;	specified vertical offset.
; -----------------------------------------------------------------------------
;	In:
;	DE	- Vertical offset (added to camera y coordinate before calculating
;			the metatile address).
;	ld:
;	Updates the following fields in the LevelAttributes struct:
;		MetaTileX		- X index of the metatile within layout data.
;		MetaTileY		- Y index of the metatile within layout data.
;
;	Camera_MetatilePtr - Pointer to the metatile within layout data.
;	HL				- same as above.
;
;	Destroys:
;	A, BC, DE, HL
; -----------------------------------------------------------------------------
Engine_Mappings_GetBlockXY:	;$4A9B
	; calculate the metatile x-coordinate and store in the
	; level attributes structure
	ld	hl, (Camera_X)
	
	; if the level is scrolling right add 8 to the coordinate
	bit	LVP_SCROLL_LEFT, (ix + LevelDescriptor.ViewportFlags)
	jr	z, +_
	ld	bc, 8
	add	hl, bc
	
_:	; shift the metatile index into the upper byte
	sla	l
	rl	h		;hl *= 2
	sla	l
	rl	h		;hl *= 2
	sla	l
	rl	h		;hl *= 2
	ld	(ix + LevelDescriptor.MetaTileX), h

	
	; calculate the metatile y-coordinate and store in the
	; level attributes structure
	ld	hl, (Camera_Y)
	; add the adjustment value
	add	hl, de
	sla	l
	rl	h		;hl *= 2
	sla	l
	rl	h		;hl *= 2
	sla	l
	rl	h		;hl *= 2
	ld	(ix + LevelDescriptor.MetaTileY), h
	
	; use the metatile y-index to calculate an offset into
	; the level's stride table
	ld	l, h
	ld	h, $00
	add	hl, hl
	ld	de, (LevelAttributes.StrideTable)
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	
	; DE now contains the stride value
	
	; calculate the metatile's address within the level layout data
	ld	l, (ix + LevelDescriptor.MetaTileX)
	ld	h, $00
	add	hl, de
	ld	de, LevelLayout
	add	hl, de
	
	
	; store the metatile pointer
	ld	(Camera_MetatilePtr), hl
	ret


;Precalculated address offsets for each row of blocks
;for a given level width (the stride tables)
#include "level_width_multiples.asm"



; =============================================================================
;	Engine_LoadLevelLayout()
; -----------------------------------------------------------------------------
;	Decompresses the level layout data into RAM. The level attributes struct
;	must be correct before calling this func.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_LoadLevelLayout:		;$5305
	di
	ld	ix, LevelAttributes

	; swap in the bank with the level layout data
	ld	a, (ix + LevelDescriptor.LayoutBank)
	call	Engine_SwapFrame2
	
	; load HL with a pointer to the compressed layout data
	ld	l, (ix + LevelDescriptor.LayoutPtr)
	ld	h, (ix + LevelDescriptor.LayoutPtr + 1)
	
	; load DE with a pointer to the destination for the decompressed data.
	ld	de, LevelLayout
	
	; copy the compressed data pointer into IY
	push	hl
	pop	iy
	
	; start of decompression loop
_:	; make sure that we dont overflow the space allocated for the
	; decompressed data ($C001 -> $CFFF)
	ld	a, d
	and	$F0
	cp	$C0	;cp	LevelLayout >> 8
	jr	nz, Engine_LoadLevel_DrawScreen
	
	; read a byte from the compressed stream
	ld	a, (iy + 0)
	
	; is the byte a compression marker?
	cp	$FD
	jr	nz, Engine_LoadLevelLayout_CopyByte
	
	; the byte was a compression marker. RLE decode
	; read the repeat counter. if the counter is zero then we have
	; reached the end of the compressed data stream.
	ld	a, (iy + 1)
	or	a
	jr	z, Engine_LoadLevel_DrawScreen
	
	; load the loop counter
	ld	b, a
	
_:	; check array bounds again
	ld	a, d
	and	$F0
	cp	$C0	;cp	LevelLayout >> 8
	jr	nz, Engine_LoadLevel_DrawScreen
	
	; read the data byte and copy it into RAM
	; FIXME: optimise this by using a register rather than a memory read.
	ld	a, (iy + 2)
	ld	(de), a
	inc	de
	
	djnz	-_

	; move the compressed data pointer pointer
	lea	iy, iy+3
	jr	--_


Engine_LoadLevelLayout_CopyByte:
	; copy a single byte to RAM (no compression)
	ld	a, (iy + 0)
	ld	(de), a
	inc	de
	inc	iy
	jr	--_



;****************************************************************
;*	Load the starting sprite & camera X/Y coordinates	*
;*	for the current level/act, then load the tiles for	*
;*	the screen viewport.					*
;****************************************************************
Engine_LoadLevel_DrawScreen:		;$5353	;interrupt happens immediately after this
	call	Engine_LoadLevel_SetInitialPositions
	ld	hl, ($D2CA)	;set the screen X pos
	ld	(Camera_X), hl
	ld	($D284), hl
	ld	hl, ($D2CC)	;set the screen Y pos
	ld	(Camera_Y), hl
	ld	($D286), hl
	;load the tiles for the initial screen (one row at a time)
	ld	b, $1D			;29
_:	di
	push	bc
	ld	hl, (Camera_Y)		;get screen Y pos
	ld	de, $0008		;move to next row
	add	hl, de
	ld	($D286), hl
	ld	a, ($D162)		;bank for 32x32 mappings
	call	Engine_SwapFrame2
	call	Engine_LoadMappings32_Row	;load a row of tiles
	set	6, (ix+$00)
	call	Engine_WaitForInterrupt
	pop	bc
	djnz	-_
	
	ld	a, $80			;setup camera offset
	ld	($D288), a
	ld	a, $78
	ld	($D289), a
	call	Engine_CalculateCameraBounds
	
	ld	hl, ($D2CA)	;set screen x pos
	ld	de, $0008
	add	hl, de
	ld	($D284), hl
	ld	(Camera_X), hl
	
	ld	hl, ($D2CC)	;set screen y pos
	ld	($D286), hl
	ld	(Camera_Y), hl
	
	ld	de, $0010		;calculate vertical bg scroll value
	add	hl, de
	ld	de, $00E0
_:	xor	a
	sbc	hl, de
	jr	nc, -_
	add	hl, de
	ld	a, l
	ld	($D173), a		;store v-scroll value
	ei	
	ret

;************************************************
;*	Loads initial camera X/Y and sprite X/Y	*
;*	for each level/act.			*
;************************************************
Engine_LoadLevel_SetInitialPositions:		;$53C0
	ld	a, (CurrentLevel)
	add	a, a
	ld	l, a
	ld	h, $00
	ld	de, LevelLayout_Data_InitPos
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	a, (CurrentAct)
	add	a, a
	ld	l, a
	ld	h, $00
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	pop	iy
	ld	l, (iy+$00)	;load initial screeen X pos
	ld	h, (iy+$01)
	ld	($D2CA), hl
	ld	l, (iy+$02)	;load initial screen Y pos
	ld	h, (iy+$03)
	ld	($D2CC), hl
	ld	l, (iy+$04)	;initial player x pos
	ld	h, (iy+$05)
	ld	($D511), hl
	ld	l, (iy+$06)	;initial player y pos
	ld	h, (iy+$07)
	ld	($D514), hl
	ret

#include "level_layout_initial_positions.asm"


; =============================================================================
;	Engine_ClearLevelAttributes()
; -----------------------------------------------------------------------------
;	Clears level attributes, viewport variables & tile row/col buffers.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_ClearLevelAttributes:		;$5531
	ld	hl, LevelAttributes
	ld	de, LevelAttributes + 1
	ld	bc, $0132
	ld	(hl), 0
	ldir
	ret

Engine_LoadLevelHeader:		;$553F
	;load the pointer to the level header
	ld	a, (CurrentLevel)
	add	a, a
	ld	l, a
	ld	h, $00
	ld	de, LevelHeaders
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	;load the pointer for the current act
	ld	a, (CurrentAct)
	add	a, a
	ld	l, a
	ld	h, $00
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	pop	iy
	ld	ix, LevelAttributes		;destination for the level header
	
	ld	a, (iy+$00)			;$D162 - Bank number for 32x32 mappings
	ld	(ix+LevelDescriptor.MetaTileBank), a
	
	ld	a, (iy+$01)			;$D164-D165 - pointer to 32x32 mappings
	ld	(ix+LevelDescriptor.MetaTilePtr), a
	ld	a, (iy+$02)
	ld	(ix+LevelDescriptor.MetaTilePtr+1), a
	
	ld	a, (iy+$03)			;$D163 - Bank number for level layout
	ld	(ix+LevelDescriptor.LayoutBank), a
	
	ld	a, (iy+$04)			;$D166-D167 - Pointer to level layout
	ld	(ix+LevelDescriptor.LayoutPtr), a
	ld	a, (iy+$05)
	ld	(ix+LevelDescriptor.LayoutPtr+1), a
	
	ld	a, (iy+$06)			;$D16C-D16D - level width in blocks
	ld	(ix+LevelDescriptor.Width), a
	ld	a, (iy+$07)
	ld	(ix+LevelDescriptor.Width+1), a

	ld	a, (iy+$08)			;$D16A-D16B - 2's comp. level width
	ld	(ix+LevelDescriptor.WidthNeg), a
	ld	a, (iy+$09)
	ld	(ix+LevelDescriptor.WidthNeg+1), a
	
	ld	a, (iy+$0A)			;$D16E-D16F - Vertical offset into layout data
	ld	(ix+LevelDescriptor.DataOffset), a	
	ld	a, (iy+$0B)
	ld	(ix+LevelDescriptor.DataOffset+1), a
	
	ld	l, (iy+$0C)	;minimum camera x pos
	ld	h, (iy+$0D)
	ld	($D280), hl

	ld	l, (iy+$0E)	;minimum camera y pos
	ld	h, (iy+$0F)
	ld	($D27C), hl
	
	ld	l, (iy+$10)	;maximum camera x pos
	ld	h, (iy+$11)
	ld	($D282), hl
	
	ld	l, (iy+$12)	;maximum camera y pos
	ld	h, (iy+$13)
	ld	($D27E), hl

	ld	a, (iy+$14)	;$D168
	ld	(ix+LevelDescriptor.StrideTable), a
	ld	a, (iy+$15)	;$D169
	ld	(ix+LevelDescriptor.StrideTable+1), a
	
	ld	a, $80
	ld	($D288), a
	ld	a, $78
	ld	($D289), a
	jp	Engine_CalculateCameraBounds	

#include "level_headers.asm"


; =============================================================================
;	Engine_LoadMappings32_Column()
; -----------------------------------------------------------------------------
;	Copy a column of tile index values from the metatiles at the edge of the
;	level viewport to the column buffer.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_LoadMappings32_Column:	;$585B
	; fetch the address of the metatile at the edge of the screen
	; (left or right, depending on scroll direction) and with a y-offset 
	; of 8 pixels
	ld	de, 8
	call	Engine_Mappings_GetBlockXY
	
	; HL now contains a pointer to the metatile at the specified
	; level coordinate
	
	; adjust the pointer depending on whether the viewport is 
	; scrolling or right
	ld	de, $0008
	bit	LVP_SCROLL_RIGHT, (ix + LevelDescriptor.ViewportFlags)
	jr	nz, +_
	ld	de, $0000
_:	add	hl, de

	; load shadow DE register with a pointer to the tile column buffer
	exx	
	ld	de, Camera_MetatileColBuffer
	exx

	; load the loop counter (8 metatiles in a column)
	ld	b, 8
	
	; preserve loop counter & level data pointer
_:	push	bc
	push	hl
	
	; load HL with the mapping number
	ld	e, (hl)
	ld	d, $00
	ex	de, hl
	
	; calculate a pointer to the metatile's tile data
	add	hl, hl
	ld	bc, (LevelAttributes.MetaTilePtr)
	add	hl, bc
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	
	; DE now points to the tile indices for the metatile
	
	; calculate the column offset within the metatile (correcting
	; for the viewport scroll direction)
	ld	a, (Camera_X)
	bit	LVP_SCROLL_LEFT, (ix + LevelDescriptor.ViewportFlags)
	jr	z, +_
	add	a, 8
	
_:	; adjust the pointer to the correct column
	rrca
	rrca
	and	%00000110
	ld	l, a
	ld	h, $00
	add	hl, de
	
	; load the loop counter (4 tiles per metatile)
	; and the copy the data pointer into shadow HL
	ld	b, 4
	push	hl
	exx	
	pop	hl
	exx
	
_:	exx
	; copy the 2-byte tile index value to the buffer
	ldi
	ldi
	dec	hl

	; move the data pointer to the next row (i.e. add 7 to index).
	ld	a, 7
	add	a, l
	ld	l, a
	exx
	
	; loop back and copy the next tile value
	djnz	-_
	
	; move the data pointer to the next row (i.e. add level width)
	pop	hl
	ld	de, (LevelAttributes.Width)
	add	hl, de
	
	; restore the loop counter and copy from the next metatile
	pop	bc
	djnz	---_
	
	; flag to show that VRAM needs updating with the new tile data
	set	LVP_COL_UPDATE_PENDING, (ix + LevelDescriptor.ViewportFlags)
	ret



Engine_CopyMappingsToVRAM_Column:	;$58BA
	ld	hl, (Camera_Y)		;HL = camera vpos
	ld	bc, 8			;adjust vert offset value
	add	hl, bc			;calculate start address of offscreen tile
	srl	h			;buffer, relative to the nametable address.
	rr	l			;E.g. if offset is $100 the offscreen tile
	srl	h			;buffer starts at $3800 + $100 = $3900.
	rr	l
	srl	h
	rr	l
	add	hl, hl
	ld	bc, Data_OffscreenBufferOffsets
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	
	ld	a, (Camera_X)		;get lo-byte of camera hpos
	bit	2, (ix+0)		;is level scrolling left?
	jr	z, +_			;jump if level scrolling right
	add	a, $08			;adjust camera hpos

_:	rrca
	rrca
	and	$3E
	ld	l, a
	ld	h, $38
	add	hl, bc
	ld	bc, $0040		;BC = 2 * width of display in tiles (64).
					;this is used to increment the VRAM
					;address pointer
	ld.lil	iy, SegaVRAM+$3F07	;IY is used to cap the VRAM address pointer and prevent overflow
	ex	de, hl
	exx
	ld	a, (Camera_Y)		;A = lo-byte of camera vpos.
	add	a, $08			;caluclate the source address to copy
	rrca				;the tile data from.
	rrca
	and	$06
	inc	hl
	ld	l, a
	ld	h, $00
	ld.lil	de, Camera_MetatileColBuffer+romStart	;source of tile data
	add.lil	hl, de	

	call.il	Engine_CopyMappingsColumnToVRAM+romStart
	ld	hl, DrawTilemapTrig
	set	0, (hl)
	ret

Engine_CopyMappingsColumnToVRAM:
.ASSUME ADL=1
	ld	a, $1B
	push	hl
	exx
	ld	hl, SegaVRAM
	add	hl, de
	pop	de

_:	push	af
	ld	a, h
	cp	iyh			;check that the VRAM address pointer 
	jr	c, +_			;is within bounds
	
	sub	iyl			;pointer not within bounds - adjust value
	ld	h, a
_:	ex	de, hl
	ldi				;write tile data to VRAM
	ldi
	inc	bc
	inc	bc
	dec	de
	dec	de

	ex	de, hl
	add	hl, bc			;increment the VRAM address pointer
	pop	af
	dec	a
	jr	nz, --_		  	;move to next tile
	res.sis	5, (ix+0)	  	;reset the "VRAM column update required" flag
	ret.sis
.ASSUME ADL=0

Engine_LoadMappings32_Row:	;$5920
	ld	de, $0000
	call	Engine_Mappings_GetBlockXY
	
	ld	de, (LevelAttributes.DataOffset)	;get vertical offset value
	bit	1, (ix+0)				;is level scrolling down?
	jr	nz, +_					;jump if it is	
	ld	de, $0000				;level is scrolling up	
_:	add	hl, de					;add block's address to vertical offset value

	exx
	ld	de, $D1F8
	exx
	ld	b, $09
_:	push	bc
	push	hl
	ld	e, (hl)
	ld	d, $00
	ex	de, hl
	add	hl, hl
	ld	de, (LevelAttributes.MetaTilePtr)	;pointer to 32x32 mappings
	add	hl, de					;calculate offset into mappings pointer array
	ld	e, (hl)					;get the pointer to the tile data
	inc	hl
	ld	d, (hl)
	ld	a, (Camera_Y)		;get the tile scroll value by removing the
	and	$18			;"fine scroll" value from the lower 3 bits
	ld	l, a
	ld	h, $00
	add	hl, de
	push	hl
	exx
	pop	hl
	ld	bc, $0008
	ldir
	exx
	pop	hl
	inc	hl
	pop	bc
	djnz	-_
	set	4, (ix+0)
	ret


;*********************************************************
;*	Copy the row of mapping data at $D1F8 to the row *
;*	above or below the camera.			 *
;*********************************************************
Engine_CopyMappingsToVRAM_Row:		;$5966
	ld	a, (Camera_X)		;camera hpos
	bit	2, (ix+0)		;is level scrolling left?
	jr	z, +_			;jump if level scrolling right
	
	add	a, $08			;adjust camera hpos
	
_:	rrca				;calculate the RAM address to copy tile
	rrca	;data from
	and	$06
	ld	l, a
	ld	h, $00
	ld.lil	de, $D2D1F8	;source of new row data
	add.lil	hl, de
	ex.lil	de, hl
	
	ld	hl, (Camera_Y)	;HL = camera vpos
	srl	h
	rr	l		;hl /= 2
	srl	h
	rr	l		;hl /= 2	
	srl	h		;this division and the following ADD ensures
	rr	l		;that the offset is a multiple of 2.
	add	hl, hl
	
	ld	bc, Data_OffscreenBufferOffsets
	add	hl, bc			;calculate the start of the tile buffer
	ld	c, (hl)
	inc	hl
	ld	b, (hl)

	ld	a, (Camera_X)		;A = lo-byte of camera vpos
	bit	2, (ix+0)		;is level scrolling left?
	jr	z, +_			;jump if level scrolling right
	add	a, $08			;adjust vpos
	
_:	rrca
	rrca
	and	$3E
	ld	l, a
	ld	h, $38			;calculate VRAM command byte to set 
	add	hl, bc			;address pointer

	ld	b, $21			;number of tile values to copy
	ld	c, $FF
	bit	2, (ix+0)		;is level scrolling left?
	jr	z, +_			;jump if scrolling right
	dec	b			;scrolling left - decrement tile count

_:	call.il	Engine_CopyMappingsRowToVRAM+romStart
	ld	hl, DrawTilemapTrig
	set	0, (hl)
	ret	

Engine_CopyMappingsRowToVRAM:
.ASSUME ADL=1
_:	push	de			;set up to write to the screen map in VRAM
	ld	de, SegaVRAM
	add	hl, de
	pop	de
	ex	de, hl

_:	ldi				;write the 2-byte tile value to VRAM
	ldi
	ld	a, e
	and	$3F
	jr	nz, +_
	
	push	hl
	ex	de, hl
	ld	de, $0040
	or	a
	sbc	hl, de
	ex	de, hl
	pop	hl
_:	djnz	--_
.ASSUME ADL=0
	res.s	4, (ix+0)		;reset the "VRAM row update required" flag
	ret.s

;***********************************************************
;*	Lookup table of off-screen buffer address offsets. *
;***********************************************************
Data_OffscreenBufferOffsets:		;$59DB
#import "misc\offscreen_buffer_offsets.bin"

LABEL_5D93:				;updates current position in level
	; clear the scroll bits from the viewport flags
	ld	a, (LevelAttributes.ViewportFlags)
	and	%11110000
	ld	(LevelAttributes.ViewportFlags), a
	
	bit	0, (ix + LevelDescriptor.ix01)
	jp	nz, LABEL_5EA1
	
	call	Engine_CameraAdjust
	
	ld	a, ($D28A)
	ld	b, a

	ld	hl, (Player.X)
	ld	de, (Camera_X)
	xor	a
	sbc	hl, de
	jr	z, ++++_

	ld	a, l
	cp	b
	jr	c, ++_
	
	ld	a, ($D28B)
	ld	b, a
	ld	a, l
	cp	b
	jr	c, ++++_
	
	sub	b
	cp	9
	jr	c, +_
	ld	a, 8
_:	ld	l, a

	ld	de, (Camera_X)
	add	hl, de
	ld	($D284), hl
	set	LVP_SCROLL_RIGHT, (ix + LevelDescriptor.ViewportFlags)
	jr	+++_

_:	ld	a, ($D28C)
	ld	b, a
	ld	a, l
	cp	b
	jr	nc, ++_

	sub	b
	cp	$F7
	jr	nc, +_
	ld	a, $F8
_:	ld	hl, -1
	ld	l, a
	ld	de, (Camera_X)
	add	hl, de
	ld	($D284), hl
	set	LVP_SCROLL_LEFT, (ix + LevelDescriptor.ViewportFlags)

_:	ld	a, ($D28D)
	ld	b, a
	ld	hl, (Player.Y)
	ld	de, ($D286)
	xor	a
	sbc	hl, de
	ret	z

	ld	a, l
	cp	b
	jr	c, LABEL_5E24
	ld	a, ($D28E)
	ld	b, a
	ld	a, l
	cp	b
	ret	c
	
	sub	b
	cp	9
	jr	c, +_
	ld	a, 8
_:	ld	l, a
	ld	de, (Camera_Y)
	add	hl, de
	ld	($D286), hl
	set	LVP_SCROLL_DOWN, (ix + LevelDescriptor.ViewportFlags)
	ret	

LABEL_5E24:
	ld	a, ($D28F)
	ld	b, a
	ld	a, l
	cp	b
	ret	nc
	sub	b
	cp	$F7
	jr	nc, +_
	ld	a, $F8
_:	ld	hl, -1
	ld	l, a
	ld	de, (Camera_Y)
	add	hl, de
	ld	($D286), hl
	set	LVP_SCROLL_UP, (ix + LevelDescriptor.ViewportFlags)
	ret	


;********************************************************
;*	Adjust the camera position to look up/down	*
;*	or left/right.					*
;********************************************************
Engine_CameraAdjust:
LABEL_5E42:
	ld	a, ($D28A)
	ld	b, a
	ld	a, ($D288)		;horizontal cam adjustment
	cp	b
	jr	z, LABEL_5E62
	jr	c, +_	;is adjustment < D28A?
	inc	b
	inc	b
	jr	++_
_:	dec	b
	dec	b
_:	ld	a, b			;set camera bounds
	ld	($D28A), a
	sub	$08
	ld	($D28C), a
	add	a, $10
	ld	($D28B), a
LABEL_5E62:
	ld	a, ($D28D)
	ld	b, a
	ld	a, ($D289)
	cp	b
	ret	z
	jr	c, +_	;is adjustment < $D28D?
	inc	b
	jr	++_
_:	dec	b
_: 	ld	a, b
	ld	($D28D), a		;set camera bounds
	sub	$10
	ld	($D28F), a
	add	a, $20
	ld	($D28E), a
	ret

Engine_CalculateCameraBounds:	;$5E80
	ld	a, ($D288)
	ld	($D28A), a
	sub	$08
	ld	($D28C), a		;camera left bounds
	add	a, $10
	ld	($D28B), a		;camera right bounds
	ld	a, ($D289)
	ld	($D28D), a
	sub	$10
	ld	($D28F), a		;camera top bounds
	add	a, $20
	ld	($D28E), a		;camera bottom bounds
	ret	

LABEL_5EA1:
	ld	hl, ($D2CE)	;horizotal camera lock position?
	ld	de, ($D174)	;camera hpos
	xor	a
	sbc	hl, de
	jr	z, ++_		;jump if cam hpos == lock hpos
	jr	c, +_		;++. jump if cam hpos > lock hpos
	
	inc	de
	ld	($D284), de
	set	3, (ix+$00)	;set "level scrolling right" flag
	jr	++_
	
_:	dec	de
	ld	($D284), de
	set	2, (ix+$00)	;set "level scrolling left" flag

_:	ld	hl, ($D2D0)	;vertical camera lock position?
	ld	de, ($D176)	;DE = camera vpos
	xor	a
	sbc	hl, de
	ret	z				;return if lock vpos == camera vpos
	
	jr	c, +_		;jump if cam vpod > lock vpos
	inc	de
	ld	($D286), de
	set	1, (ix+$00)
	ret

_:	dec	de
	ld	($D286), de
	set	0, (ix+$00)
	ret

Engine_UpdateAllObjects:
LABEL_5EE4:
	xor	a
	ld	($D521), a		;reset player object's collision flags
	ld	ix, $D540		;get pointer to first, non-player, object descriptor
	ld	b, $13			;number of descriptors to iterate over
_:	push	bc
	di	
	call	LABEL_5EFD
	ei	
	lea	ix, ix+$40		;move to next object descriptor structure
	pop	bc
	djnz	-_
	ret


;************************************************
;	Updates the object pointed to by the	*
;	IX register.				*
;************************************************
LABEL_5EFD:
	; fetch the object ID
	ld	a, (ix + Object.ObjID)
	; dont update if the ID is zero
	or	a
	ret	z

	cp	$F0					;jump if object >= $F0
#if Version = 2
	jp	nc, LABEL_5F73
#else
	jp	nc, LABEL_5F51
#endif	
	cp	$50
	jr	nc, LABEL_5F3D		;object types >= 80 are in bank 30
	
	cp	$20
	jr	nc, LABEL_5F29		;object types >= 32 < 80 are in bank 28
		
	ld	a, 31			;object types >= 0 < 32 are in bank 31
	call	Engine_SwapFrame2
	call	Engine_UpdateObject

	ld	a, 31
	call	Engine_SwapFrame2	
	call	LABEL_6139
	
	ld	a, (ix + Object.State)
	or	a
	call	nz, LABEL_617C
	ret	

LABEL_5F29: ;badniks & minecart
	ld	a, 28
	call	Engine_SwapFrame2
	call	Engine_UpdateObject

	ld	a, 28
	call	Engine_SwapFrame2

	call	LABEL_6139
	jp	LABEL_617C	

LABEL_5F3D:
	ld	a, 30
	call	Engine_SwapFrame2
	call	Engine_UpdateObject

	ld	a, 30
	call	Engine_SwapFrame2

	call	LABEL_6139
	jp	LABEL_617C	

#if Version = 2
LABEL_5F73:
	cp	$FE
	jp	z, LABEL_6212
	cp	$FF
	jp	z, Engine_DeallocateObject
	ret

#else

LABEL_5F51:
	and	$0F
	sub	$0E
	ret	p
	jp	z, LABEL_6212
	jp	Engine_DeallocateObject
#endif


Logic_Pointers:		;$5F81
#include "object_logic_pointers.asm"


; =============================================================================
;	Engine_UpdatePlayerObject(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Checks the player's state and optionally processes any state sequence logic.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to player object structure.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_UpdatePlayerObject:		;$603F
	; dont run any state update logic if the player is dead
	ld	a, (Player.State)
	cp	PlayerState_LostLife
	jr	z, +_
	cp	PlayerState_Drowning
	jr	z, +_
	; FALL THROUGH


; =============================================================================
;	Engine_UpdateObject(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Checks the object's state and optionally processes any state sequence logic.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to object structure.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_UpdateObject:		;$604A
	; fetch the logic sequence pointer. 
	ld	a, (ix + Object.LogicSeqPtr)
	or	(ix + Object.LogicSeqPtr + 1)
	; if the pointer is zero fetch the value from the object's
	; logic pointer array
	jr	z, Engine_UpdateObject_GetLogicPtr

	; check to see if the state has changed
	ld	a, (ix + Object.StateNext)
	cp	(ix + Object.State)
	; if the state has changed process the logic sequence data
	jr	nz, Engine_UpdateObject_State
	
_:	; decrement the frame counter and update the animation variables
	; if it is zero
	dec	(ix + Object.FrameCounter)
	jr	z, Engine_UpdateObject_ProcessLogic

	ret


Engine_UpdateObject_State:
	; copy the "next" state value to the "current state".
	ld	a, (ix + Object.StateNext)
	ld	(ix + Object.State), a
	; FALL THROUGH


Engine_UpdateObject_GetLogicPtr:		;$6067
	; fetch the object ID and use it to calculate a pointer to
	; the logic sequence data
	ld	a, (ix + Object.ObjID)
	dec	a
	add	a, a
	ld	l, a
	ld	h, $00
	; add the offset to the base pointer
	ld	de, Logic_Pointers
	add	hl, de
	
	; fetch the object's logic sequence pointer
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	
	; fetch the sequence pointer for the current state
	ld	a, (ix + Object.State)
	ld	l, a
	ld	h, $00
	add	hl, hl

	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	
	; store the pointer in the object structure
	ld	(ix + Object.LogicSeqPtr), e
	ld	(ix + Object.LogicSeqPtr + 1), d
	;FALL THROUGH


Engine_UpdateObject_ProcessLogic:		; $6087
	; fetch the logic sequence pointer
	ld	l, (ix + Object.LogicSeqPtr)
	ld	h, (ix + Object.LogicSeqPtr + 1)
	
	; fetch the next byte from the sequence
	ld	a, (hl)
	
	; check to see if the value is a command byte
	cp	$FF
	jp	z, Logic_ProcessCommand
	
	; set the value as the frame display counter
	ld	(ix + Object.FrameCounter), a
	inc	hl
	
	; fetch the next byte and set as the frame number
	ld	a, (hl)
	ld	(ix + Object.AnimFrame), a
	
	; fetch the next word and set as the logic subroutine pointer
	inc	hl
	ld	a, (hl)
	ld	(ix + Object.LogicPtr), a
	inc	hl
	ld	a, (hl)
	ld	(ix + Object.LogicPtr + 1), a
	
	; store the updated logic sequence pointer
	inc	hl
	ld	(ix + Object.LogicSeqPtr), l
	ld	(ix + Object.LogicSeqPtr + 1), h
	; FALL THROUGH


Engine_UpdateObject_Animation:		;$60AC
	; update the object's animation-related variables
	
	; swap in the bank with the frame mapping data
	ld	a, 31
	call	Engine_SwapFrame2

	; calculate a pointer to the object's frame mapping pointers
	ld	l, (ix + Object.ObjID)
	ld	h, $00
	add	hl, hl
	ld	de, Object_AnimFrameMappings
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	
	; calculate a pointer to the current frame's mapping data
	ld	l, (ix + Object.AnimFrame)
	ld	h, $00
	add	hl, hl
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ex	de, hl

	; at this point HL contains a pointer to the mapping data
	; for the current animation frame
	
	; read & store the sprite count
	ld	a, (hl)
	ld	(ix + Object.SpriteCount), a

	; read & store object width in tiles
	inc	hl
	ld	a, (hl)
	ld	(ix + Object.Width), a
	
	; read & store object height in tiles
	inc	hl
	ld	a, (hl)
	ld	(ix + Object.Height), a

	; read & store the sprite arrangement data pointer
	inc	hl
	ld	a, (hl)
	ld	(ix + Object.SprMappgPtr), a
	inc	hl
	ld	a, (hl)
	ld	(ix + Object.SprMappgPtr + 1), a

	; store the resulting sprite attribute pointer 
	; (pointer to horiz/vert offsets & char codes)
	inc	hl
	ld	(ix + Object.SprOffsets), l
	ld	(ix + Object.SprOffsets + 1), h
	ret	


LABEL_60E9:
	ld	a, (ix+$00)		;check that object == 1 (sonic)
	dec	a
	ret	nz

	ld	a, (ix+$06)		;get animation frame number
	ld	($D34F), a	;set the pattern load trigger (see $1274)
	
	cp	$11
	jr	c, +_
	
	cp	$16
	jr	c, LABEL_6131
	
_:	ld	hl, Engine_InputFlags
	bit	BTN_LEFT_BIT, (hl)	;check for left button
	jr	nz, LABEL_6127
	bit	BTN_RIGHT_BIT, (hl)	;check for right button
	jr	nz, LABEL_611D
	res	4, (ix+$04)
	ld	a, ($D350)
	and	$40
	or	$80
	ld	($D34E), a
	and	$40
	ret	z
	set	4, (ix+$04)
	ret	

LABEL_611D:
	ld	a, $80
	ld	($D34E), a
	res	4, (ix+$04)
	ret	

LABEL_6127:	
	ld	a, $C0
	ld	($D34E), a
	set	4, (ix+$04)
	ret	

LABEL_6131:	
	bit	7, (ix+$17)
	jr	z, LABEL_611D
	jr	LABEL_6127

LABEL_6139:
	ld	l, (ix+$0C)
	ld	h, (ix+$0D)
	ld	a, h
	or	l
	ret	z
	jp	(hl)
	ret	

;find an open object slot (entire range)
Engine_AllocateObjectHighPriority:		;$6144
	push	ix
	ld	ix, $D540
	ld	b, $10
_:	ld	a, (ix+$00)
	or	a
	jr	z, LABEL_615C
	lea	ix, ix+$40
	djnz	-_
	pop	ix
	ret	

LABEL_615C:
	ld	(ix+$00), c
	ld	(ix+$3F), h
	pop	ix
	ret	

;find an open object slot (badnik range)
Engine_AllocateObjectLowPriority:		;$6165
	ld	iy, $D700
	ld	de, $0040
	ld	b, $0B
_:	ld	a, (iy+$00)
	or	a
	jr	z, +_
	add	iy, de
	djnz	-_
	scf
	ret
_:	xor	a
	ret	

LABEL_617C:
	bit	OBJ_F4_BIT1, (ix + Object.Flags04)
	ret	nz
	
	res	OBJ_F4_BIT6, (ix + Object.Flags04)
	
	; fetch the object's X coordinate and add 32
	ld	l, (ix + Object.X)
	ld	h, (ix + Object.X + 1)
	ld	bc, $0020		
	add	hl, bc
	
	; fetch the camera X coordinate
	ld	bc, (Camera_X)
	
	; clear carry flag
	xor	a
	; calculate the object's onscreen x position
	sbc	hl, bc
	
	srl	h
	rr	l
	srl	h
	rr	l
	
	ld	a, l
	cp	$50
	jr	nc, LABEL_61C2
	
	ld	l, (ix+$14)
	ld	h, (ix+$15)
	ld	bc, $0020
	add	hl, bc
	ld	bc, ($D176)
	xor	a
	sbc	hl, bc
	srl	h
	rr	l
	srl	h
	rr	l
	ld	a, l
	cp	$50
	jr	nc, LABEL_61C2
	ret	

LABEL_61C2:
	bit	0, (ix+$04)
	jp	nz, Engine_DeallocateObject
	set	6, (ix+$04)
	ld	l, (ix+$11)
	ld	h, (ix+$12)
	ld	bc, $0180
	add	hl, bc
	ld	bc, ($D174)
	xor	a
	sbc	hl, bc
	ld	a, h
	cp	$04
	jr	nc, LABEL_61FA
	ld	l, (ix+$14)
	ld	h, (ix+$15)
	ld	bc, $0180
	add	hl, bc
	ld	bc, ($D176)
	xor	a
	sbc	hl, bc
	ld	a, h
	cp	$04
	jr	nc, LABEL_61FA
	ret	

LABEL_61FA:
	ld	a, (ix+$3e)
	or	a
	jr	z, LABEL_620F
	ld	(ix+$00), $fe
	ld	(ix+$01), $00
	ret	

LABEL_620F:
	ld	(ix+$00), $ff
	ld	(ix+$01), $00
	ret	

LABEL_6212:
	ld	l, (ix+$3a)
	ld	h, (ix+$3b)
	ld	bc, $0180
	add	hl, bc
	ld	bc, ($d174)
	xor	a
	sbc	hl, bc
	ld	a, h
	cp	$04
	jr	nc, LABEL_623F
	ld	l, (ix+$3c)
	ld	h, (ix+$3d)
	ld	bc, $0180
	add	hl, bc
	ld	bc, ($D176)
	xor	a
	sbc	hl, bc
	ld	a, h
	cp	$04
	jr	nc, LABEL_623F
	ret	

LABEL_623F:
	ld	(ix+$00), $ff
	ld	(ix+$01), $00
	ret	


Engine_DeallocateObject:		;$6248
	ld	a, (ix+$3E)		;get the index of this object
	or	a			;in the active objects array
	jr	z, +_

	dec	a
	ld	e, a
	ld	d, $00
	ld	hl, $D400	;pointer to the active objects array
	add	hl, de
	ld	(hl), $00		;remove the object from the array

_:	lea	hl, ix
	ld	(hl), $00		;clear this object's descriptor slot
	ld	e, l
	ld	d, h
	inc	de
	ld	bc, $3E
	ldir	
	ret	

Engine_MoveObjectToPlayer:		;$6267
	ld	bc, ($D511)	;copy player's position to another object
	ld	de, ($D514)
	ld	(ix+$11), c
	ld	(ix+$12), b
	ld	(ix+$14), e
	ld	(ix+$15), d
	ret	


;********************************************************************************
;*	Check to see if an object should be destroyed by a collision		*
;*	with the player object. Destroys object if required.			*
;*										*
;*	ld	IX		Pointer to object's descriptor.			*
;*	destroys	A & possibly DE, HL, BC if the object is destroyed.	*
;********************************************************************************
Logic_CheckDestroyObject:			;$627C
	ld	a, (ix+$21)	;get the object's object-to-object collision flags
	and	$0F
	ret	z				;return if no collisions
	ld	a, ($D503)		;check the "destroy enemies on collision" flag
	bit	1, a
	ret	z				;return if "destroy enemies" flag not set
	ld	(ix+$3F), $80

Engine_DisplayExplosionObject:		;$628C
	call	LABEL_62A7			;update score
	ld	(ix+$00), $0F		;display an explosion
	xor	a
	ld	(ix+$01), a
	ld	(ix+$02), a
	ld	(ix+$04), a
	ld	(ix+$07), a
	ld	(ix+$0E), a
	ld	(ix+$0F), a
	ret	

;updates score after a sonic -> object collision
LABEL_62A7:
	ld	a, (ix+$00)	;get object type
	sub	$20
	ret	c
	cp	$20			;make sure that object type >= 20 & < 40
	ret	nc
	add	a, a
	ld	l, a			;jump based on object type
	ld	h, $00
	ld	de, DATA_62BD
	add	hl, de
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	jp	(hl)
	
DATA_62BD:	;object collision type jump vectors
.dw LABEL_62FD
.dw LABEL_62FD	
.dw LABEL_62FD
.dw Score_AddBadnikValue	;badnik score value (crab)
.dw LABEL_62FD
.dw LABEL_62FD
.dw LABEL_62FD
.dw LABEL_62FD
.dw LABEL_62FD
.dw LABEL_62FD
.dw LABEL_62FD
.dw Score_AddBadnikValue	;badnik score value
.dw LABEL_62FD
.dw LABEL_62FD
.dw LABEL_62FD
.dw LABEL_62FD
.dw LABEL_62FD
.dw LABEL_62FD
.dw Score_AddBadnikValue	;badnik score value
.dw Score_AddBadnikValue	;badnik score value
.dw Score_AddBadnikValue	;badnik score value
.dw Score_AddBadnikValue	;badnik score value
.dw LABEL_62FD
.dw Score_AddBadnikValue	;badnik score value
.dw Score_AddBadnikValue	;badnik score value
.dw LABEL_62FD
.dw Score_AddBadnikValue	;badnik score value
.dw LABEL_62FD
.dw LABEL_62FD
.dw LABEL_62FD
.dw LABEL_62FD
.dw LABEL_62FD

LABEL_62FD:
	ret	

;********************************************************
;*	Sets a object's vertical velocity but enforces	*
;*	a maximum value.				*
;*							*
;*	ld	DE	Value to adjust velocity by.	*
;*	ld	BC	Maximum velocity.		*
;*	ld	DE	Vertical velocity		*
;*	destroys	HL, DE, A			*
;********************************************************
Engine_SetObjectVerticalSpeed:		;$62FE
	ld	l, (ix+$18)	;get vertical velocity
	ld	h, (ix+$19)
	add	hl, de
	ld	e, l
	ld	d, h
	bit	7, h
	jr	nz, LABEL_6313	;jump if object is moving up
	xor	a
	sbc	hl, bc			;set velocity if below threshold
	jr	c, LABEL_6313
	ret	

LABEL_6311:
	ld	e, c
	ld	d, b
LABEL_6313:
	ld	(ix+$18), e	;set vertical velocity
	ld	(ix+$19), d
	ret	

LABEL_631A:
	ld	bc, $0000
	ld	de, $0000
	push	hl
	call	Engine_GetCollisionValueForBlock			;collide with background tiles
	pop	hl
	
	bit	7, a				;is block value >= $80?
	jr	z, LABEL_634C		;if not, clear Z flag and return
	
	ld	e, (ix+$18)			;DE = object's vertical speed
	ld	d, (ix+$19)
	bit	7, d
	jr	nz, LABEL_634C		;jump if object moving up (clear Z flag)
	
	xor	a					;this part makes the object bounce
	sbc	hl, de				;HL -= DE
	jr	c, LABEL_6344		;jump if object now moving up
	
	ld	hl, $0000			;object still moving down - set vertical
	ld	(ix+$18), l			;velocity to 0
	ld	(ix+$19), h
	xor	a					;set Z flag
	scf
	ret	

LABEL_6344:
	ld	(ix+$18), l
	ld	(ix+$19), h
	xor	a					;set Z flag
	ret	

LABEL_634C:
	xor	a
	dec	a					;clear Z flag
	ret	

;************************************************************************
;*	Test for collision between an object and the player then	*
;*	move/update the player object accordingly.			*
;************************************************************************
Engine_CheckCollisionAndAdjustPlayer:	;$634F
	call	Engine_CheckCollision
	jp	Engine_AdjustPlayerAfterCollision


LABEL_6355:
	call	Engine_CheckCollision
	call	Engine_AdjustPlayerAfterCollision
LABEL_635B:
	ld	a, ($D501)				;check for jumps/rolls
	cp	PlayerState_Jumping
	jr	z, LABEL_636B
	cp	PlayerState_Rolling
	jr	z, LABEL_636B
	cp	PlayerState_JumpFromRamp
	jr	z, LABEL_636B
	ret	

LABEL_636B:
	ld	a, (ix+$21)
	and	$0F
	ret	z
	bit	0, a
	jr	nz, +_
	bit	1, a
	jr	nz, ++_
	ld	hl, ($D518)
	ld	a, l
	or	h
	jr	z, ++_
_:	ld	hl, $FC00		;set vertical speed
	ld	($D518), hl
_: 	ld	a, PlayerState_JumpFromRamp
	ld	($D502), a
	ld	bc, $0400
	ld	hl, ($D511)	;get player's horizontal position into HL
	ld	e, (ix+$11)	;get object's horizontal position into DE
	ld	d, (ix+$12)
	xor	a
	sbc	hl, de
	jr	nc, +_			;jump if object is behind player
	ld	bc, $FC00
_:	ld	($D516), bc	;horizonal velocity
	ret	

LABEL_63A9:
	call	LABEL_6355
	ld	a, (ix+$1f)
	or	a
	jr	nz, LABEL_63E5
	res	5, (ix+$04)
	res	7, (ix+$04)
	ld	(ix+$21), $00
	ret	

LABEL_63C0:
	call	Engine_CheckCollisionAndAdjustPlayer
	ld	a, (ix+$1f)
	or	a
	jr	nz, LABEL_63E5
	res	5, (ix+$04)
	res	7, (ix+$04)
	ld	a, (ix+$21)
	and	$0f
	ret	z
	ld	(ix+$1f), $40
	dec	(ix+$24)
	ret	

LABEL_63E5:
	dec	(ix+$1f)
	set	5, (ix+$04)
	ld	(ix+$21), $00
	ret	

;****************************************************************
;*	Checks an object's collision flags (ix+$21) and 	*
;*	adjusts the player object accordingly.			*
;*	Should be called after Engine_CheckCollision.		*
;****************************************************************
Engine_AdjustPlayerAfterCollision:		;$63F1
	ld	a, (ix+$21)	;check the object for collisions
	and	$0F
	ret	z				;return if no collisions

	ld	l, a			;calculate a jump based on the
	ld	h, $00			;type of collision
	add	hl, hl
	ld	de, DATA_6404
	add	hl, de
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	jp	(hl)

DATA_6404:
.dw LABEL_6424		;$00 - no collision
.dw LABEL_643C		;$01 - collision at top
.dw LABEL_6425		;$02 - collision at bottom
.dw LABEL_6424		;$03 - invalid (collision at top & bottom)
.dw LABEL_6483		;$04 - collision at right
.dw LABEL_6424		;$05 - invalid (collision top-right)
.dw LABEL_6424		;$06 - invalid (collision bottom-right)
.dw LABEL_6424		;$07 - invalid (right-top-bottom)
.dw LABEL_6454		;$08 - collision at left
.dw LABEL_6424
.dw LABEL_6424
.dw LABEL_6424
.dw LABEL_6424
.dw LABEL_6424
.dw LABEL_6424
.dw LABEL_6424

LABEL_6424:
	ret

LABEL_6425:	;collision at bottom
	ld	a, ($D523)		;test for collision at bottom
	bit	1, a
	ret	nz
	ld	a, ($D52D)		;get player object's height
	ld	e, a
	ld	d, $00
	ld	l, (ix+$14)	;add to object's vpos
	ld	h, (ix+$15)
	add	hl, de
	ld	($D514), hl
	ret	

LABEL_643C:
	ld	a, ($d523)
	bit	0, a
	ret	nz
	ld	e, (ix+$2d)
	ld	d, $00
	ld	l, (ix+$14)
	ld	h, (ix+$15)
	xor	a
	sbc	hl, de
	ld	($d514), hl
	ret	

LABEL_6454:
	ld	a, ($D523)
	bit	3, a
	ret	nz
	ld	hl, ($D174)
	ld	de, $0020
	add	hl, de
	ld	de, ($D511)
	xor	a
	sbc	hl, de
	ret	nc
	ld	e, (ix+$2c)
	ld	d, $00
	ld	a, ($d52c)
	ld	l, a
	ld	h, $00
	add	hl, de
	ex	de, hl
	ld	l, (ix+$11)
	ld	h, (ix+$12)
	xor	a
	sbc	hl, de
	ld	($d511), hl
	ret	

LABEL_6483:
	ld	a, ($d523)
	bit	2, a
	ret	nz
	ld	hl, ($d174)
	ld	de, $00e0
	add	hl, de
	ld	de, ($d511)
	xor	a
	sbc	hl, de
	ret	c
	ld	e, (ix+$2c)
	ld	d, $00
	ld	a, ($d52c)
	ld	l, a
	ld	h, $00
	add	hl, de
	ex	de, hl
	ld	l, (ix+$11)
	ld	h, (ix+$12)
	add	hl, de
	ld	($d511), hl
	ret	

DoNothingStub:		;$64B0
	ret	


;used by prison capsule to reset the count of child animal
;objects that it has spawned (stored at ix+$1F).
LABEL_64B1:
	xor	a
	ld	(ix+$1F), a
	ret	

; =============================================================================
;	Engine_GetObjectIndexFromPointer(uint 16)
; -----------------------------------------------------------------------------
;	Calculates an object slot number given the descriptor pointer.
; -----------------------------------------------------------------------------
;	In:
;	HL - Descriptor pointer.
;	ld:
;	A - Slot number.
;	Destroys:
;	DE, HL
; -----------------------------------------------------------------------------
Engine_GetObjectIndexFromPointer:		;64B6
	ld	de, Engine_ObjectSlots
	xor	a
	sbc	hl, de
	ld	a, h
	sla	l
	rla	
	sla	l
	rla	
	inc	a
	ret	


; =============================================================================
;	Engine_GetObjectDescriptorPointer(uint 8)
; -----------------------------------------------------------------------------
;	Calculates a pointer to an object descriptor given its slot number.
; -----------------------------------------------------------------------------
;	In:
;	A	- Object slot number.
;	ld:
;	HL - Descriptor pointer.
;	Destroys:
;	A, DE
; -----------------------------------------------------------------------------
Engine_GetObjectDescriptorPointer:		;$64C5
	dec	a
	ld	h, a
	xor	a
	srl	h
	rra	
	srl	h
	rra	
	ld	l, a
	ld	de, Engine_ObjectSlots
	add	hl, de
	ret	


;horizontal platform?
LABEL_64D4:
	xor	a
	ld	(ix+$16), a	;reset object's horizontal velocity
	ld	(ix+$17), a
	ld	(ix+$18), a	;reset object's vertical velocity
	ld	(ix+$19), a

	ld	a, (ix+$0B)
	or	a
	ret	z

	ld	d, $00
	ld	e, (ix+$0A)
	ld	hl, DATA_330
	add	hl, de
	ld	a, (hl)

	ld	e, a
	and	$80
	rlca	
	neg	
	ld	d, a
	ld	hl, $0000
	ld	b, (ix+$0B)

_:	add	hl, de
	djnz	-_

	ld	a, l
	sra	h
	rra	
	sra	h
	rra	
	sra	h
	rra	
	sra	h
	rra	
	ld	(ix+$16), a		;set object's horizontal velocity
	ld	(ix+$17), h

	ld	a, (ix+$0A)
	add	a, $C0
	ld	e, a
	ld	d, $00
	ld	hl, DATA_330
	add	hl, de
	ld	a, (hl)

	ld	e, a
	and	$80
	rlca	
	neg	
	ld	d, a
	ld	hl, $0000
	ld	b, (ix+$0B)

_:	add	hl, de
	djnz	-_

	ld	a, l
	sra	h
	rra	
	sra	h
	rra	
	sra	h
	rra	
	sra	h
	rra	
	ld	(ix+$18), a		;set object's vertical velocity
	ld	(ix+$19), h
	ret


LABEL_6544:
	xor	a
	ld	(ix+$22), a
	ld	l, (ix+$2C)
	ld	h, $00
	bit	7, (ix+$17)
	jr	z, +_
	ex	de, hl
	ld	hl, $0000
	xor	a
	sbc	hl, de
_:	push	hl
	pop	bc
	ld	de, -17
	call	Engine_GetCollisionValueForBlock		;collide with background tiles
	cp	$81
	jr	z, LABEL_656B
	cp	$8D
	jr	z, LABEL_656B
	ret	

LABEL_656B:
	bit	7, (ix+$17)
	jr	nz, LABEL_6576
	set	2, (ix+$22)
	ret
LABEL_6576:
	set	3, (ix+$22)
	ret	

;********************************************************
;*	Change an object's direction flags based on the	*
;*	current horizontal velocity.			*
;*							*
;*	destroys	A, H				*
;********************************************************
Logic_UpdateObjectDirectionFlag:	;$657B
	ld	h, (ix+$17)	;test object's horizontal velocity
	ld	a, (ix+$16)
	or	h
	ret	z				;return if velocity is 0
	ld	a, h
	and	$80			;which direction is the object moving?
	jr	nz, +_			;jump if object moving left
	
	res	4, (ix+$04)	;flag object moving right
	ret

_:	set	4, (ix+$04)	;flag object moving left
	ret	


;****************************************************************
;*	Change an object's direction flags so that the next	*
;*	update will move the object towards the player.		*
;*								*
;*	destroys	A, DE, HL				*
;****************************************************************
Logic_ChangeDirectionTowardsPlayer:	;$6592
	ld	de, ($D511)	;DE = player hpos

;****************************************************************
;*	Change an object's direction flags so that the next	*
;*	update will move the object towards another object.	*
;*								*
;*	ld	DE		The other object's hpos		*
;*	destroys	A, HL					*
;****************************************************************
Logic_ChangeDirectionTowardsObject:	;$6596
	ld	l, (ix+$11)	;HL = object's hpos
	ld	h, (ix+$12)

	xor	a
	sbc	hl, de			;compare both objects' hpos
	ret	z				;return if objects are overlapping

	jr	nc, +_			;jump if DE < HL

	res	4, (ix+$04)	;flag object moving right
	ret

_:	set	4, (ix+$04)	;flag object moving left
	ret


;************************************************************************
;*	Moves object A towards player on the x-axis by calculating	*
;*	the direction to move A and setting its speed accordingly.	*
;*	Will try to set speed to $0400					*
;*									*
;*	ld	DE		Adjustment value to apply to B's h-pos.	*
;*	ld BC		Actual horiz. velocity applied to object A.	*
;*	destroys	A, DE, HL					*
;************************************************************************
Logic_MoveHorizontalTowardsPlayerAt0400:	;$65AC
	ld	hl, ($D511)
	ld	bc, $0400
	;FALL THROUGH

;********************************************************************************
;*	Moves object A horizontally towards object B by calculating		*
;*	the direction to move A and setting its speed accordingly.		*
;*										*
;*	ld	HL		Object B's horizontal position.			*
;*	ld	DE		Adjustment value to apply to B's h-pos.		*
;*	ld	BC		Desired horiz. velocity to apply to object A.	*
;*	ld BC		Actual horiz. velocity applied to object A.		*
;*	destroys	A, DE, HL						*
;********************************************************************************
Logic_MoveHorizontalTowardsObject:		;$65B5
	bit	4, (ix+$04)	;which direction is the object facing
	jr	z, +_		;jump if facing right
	
	dec	de				;2's comp DE
	ld	a, d
	cpl	
	ld	d, a
	ld	a, e
	cpl	
	ld	e, a
	
_:	add	hl, de			;add DE to other object's hpos
	ld	a, l
	and	$F8
	ld	l, a
	ld	e, (ix+$11)	;DE = object hpos
	ld	d, (ix+$12)
	ld	a, e
	and	$F8
	ld	e, a
	xor	a
	sbc	hl, de			;subtract object hpos from other
							;object's adjusted hpos
	jr	nc, +_		;jump if object is to left of other object
	
	dec	bc				;2's comp bc (i.e. move in reverse)
	ld	a, b
	cpl	
	ld	b, a
	ld	a, c
	cpl	
	ld	c, a
	
_:	ld	a, l
	or	h
	jr	nz, +_			;jump if HL != 0 (i.e. objects are not on
							;top of each other).
	ld	bc, $0000		;set horizontal velocity to 0
	
_:	ld	(ix+$17), b		;set object's horizontal velocity
	ld	(ix+$16), c
	ret	


;********************************************************************************
;*	Moves object A towards object B on the Y-axis by			*
;*	calculating the direction to move A and setting its speed		*
;*	accordingly.								*
;*										*
;*	ld	HL		Object B's vertical position.			*
;*	ld	DE		Adjustment value to apply to B's v-pos.		*
;*	ld	BC		Desired vert. velocity to apply to object A.	*
;*	ld BC		Actual vert. velocity applied to object A.		*
;*	destroys	A, DE, HL						*
;********************************************************************************
Logic_MoveVerticalTowardsObject:		;$65EB
	add	hl, de			;adjust object B's vpos
	ld	a, l
	and	$FC
	ld	l, a
	
	ld	e, (ix+$14)	;DE = object A's vpos
	ld	d, (ix+$15)
	ld	a, e
	and	$FC
	ld	e, a
	
	xor	a
	sbc	hl, de			;compare A's vpos with B's
	jr	nc, +_			;jump if A is above B
	
	dec	bc				;2's comp desired velocity
	ld	a, b
	cpl	
	ld	b, a
	ld	a, c
	cpl	
	ld	c, a

_:	ld	a, l			;if objects are overlapping
	or	h				;set object A's speed to 0
	jr	nz, +_
	ld	bc, $0000
	
_:	ld	(ix+$19), b	;set A's vertical velocity
	ld	(ix+$18), c
	ret	


; =============================================================================
;	Engine_RemoveBreakableBlock()
; -----------------------------------------------------------------------------
;	Removes a breakable block from the level layout data and generates
;	the block fragment objects.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_RemoveBreakableBlock:		;$6614
	; save the current page so that we can restore it later
	ld	a, (Frame2Page)
	push	af

	; update the collision variables
	call	Engine_GetCollisionValueForBlock
	
	; swap in the bank with the mappings
	ld	a, (LevelAttributes.MetaTileBank)
	call	Engine_SwapFrame2
	
	; set the metatile number in the level data
	ld	a, $FD
	ld	hl, (Cllsn_LevelMapBlockPtr)
	ld	(hl), a

	; calculate a pointer to the metatile's data
	ld	l, a
	ld	h, $00
	add	hl, hl
	ld	a, (LevelAttributes.MetaTilePtr)
	ld	c, a
	ld	a, (LevelAttributes.MetaTilePtr + 1)
	ld	b, a
	add	hl, bc
	ld	e, (hl)
	inc	hl
	ld	d, (hl)

	; update VRAM with the new metatile data
	call	Engine_UpdateMappingBlock

	; calculate and store the metatile's X coordinate
	ld	hl, (Cllsn_AdjustedX)
	ld	a, l
	and	$E0
	ld	l, a
	ld	(Cllsn_MetaTileX), hl
	
	; calculate and store the metatile's Y coordinate
	ld	hl, (Cllsn_AdjustedY)
	ld	a, l
	and	$E0
	ld	l, a
	ld	(Cllsn_MetaTileY), hl


	; spawn some block fragment objects
	ld	c, Object_BlockFragment

	; check the breakable block's metatile number
	ld	a, (Cllsn_MetatileIndex)
	cp	$F7
	jr	nz, +_

	ld	c, Object_BlockFragment2

_:	ld	h, $00				;create 4 fragment objects
	call	Engine_AllocateObjectHighPriority
	ld	h, $01
	call	Engine_AllocateObjectHighPriority
	ld	h, $02
	call	Engine_AllocateObjectHighPriority
	ld	h, $03
	call	Engine_AllocateObjectHighPriority

	; restore the previously saved page
	pop	af
	jp	Engine_SwapFrame2	

	
;interprets a command in the object logic
Logic_ProcessCommand:			;$6675
	inc	hl
	ld	a, (hl)			;"command" byte 
	inc	hl
	ld	(ix+$0E), l		;store an updated pointer to the object's logic
	ld	(ix+$0F), h
	ld	l, a
	ld	h, $00
	add	hl, hl			;jump based on the value of the command byte
	ld	de, Logic_CommandVTable
	add	hl, de
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	jp	(hl)

Logic_CommandVTable:		;$668B
.dw Logic_Cmd_RestartSequence	;$00 - load next animation
.dw Logic_Cmd_Deallocate	;$01 - Deallocate the object
.dw Logic_Cmd_Call		;$02 - Execute logic using following 2 bytes as function pointer.
.dw Logic_Cmd_DoNothing		;$03 - do nothing stub
.dw Logic_Cmd_SetSpeed		;$04 - Set sprite's horizontal/vertical velocity
.dw LABEL_66FB			;$05 - Change sprite state (e.g. write to $D502 for sonic) & load next animation frame
.dw LABEL_670F			;$06 - Load a new sprite.
.dw LABEL_6791			;$07 - Run new input logic.
.dw LABEL_67B1			;$08 - triggers loading of a monitor or chaos emerald
.dw Logic_Cmd_PlaySound		;$09 - former sound logic routine
.dw Logic_Cmd_ProcessLogic	;$0A - load the next animation frame
.dw Logic_Cmd_ProcessLogic	;$0B - 
.dw Logic_Cmd_ProcessLogic	;$0C -
.dw Logic_Cmd_ProcessLogic	;$0D - 
.dw Logic_Cmd_ProcessLogic	;$0E - 
.dw Logic_Cmd_ProcessLogic	;$0F - 


Logic_Cmd_ProcessLogic:		; $66AB
	jp	Engine_UpdateObject_ProcessLogic


Logic_Cmd_RestartSequence:		; $66AE
	jp	Engine_UpdateObject_GetLogicPtr


Logic_Cmd_Deallocate:		; $66B1
	jp	Engine_DeallocateObject


Logic_Cmd_Call:	; $66B4
	; command sequence $FF $02 - jump to pointer
	; fetch the sequence pointer
	ld	l, (ix + Object.LogicSeqPtr)
	ld	h, (ix + Object.LogicSeqPtr + 1)
	
	; read the function pointer
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl

	; store the updated sequence pointer
	ld	(ix + Object.LogicSeqPtr), l
	ld	(ix + Object.LogicSeqPtr + 1), h
	
	; push this to the stack as the return address
	; for the subroutine
	ld	hl, Engine_UpdateObject_ProcessLogic
	push	hl
	
	; jump to the function
	ex	de, hl
	jp	(hl)


Logic_Cmd_DoNothing:		; $66CA
	ret


Logic_Cmd_SetSpeed:	; $66CB
	; read the sequence pointer
	ld	l, (ix + Object.LogicSeqPtr)
	ld	h, (ix + Object.LogicSeqPtr + 1)
	
	; fetch the new x speed
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	
	; fetch the new y speed
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	inc	hl
	
	; store the updated sequence pointer
	ld	(ix + Object.LogicSeqPtr), l
	ld	(ix + Object.LogicSeqPtr + 1), h
	
	; if the object is facing left we need to 
	; invert the horizontal speed value
	bit	OBJ_F4_FACING_LEFT, (ix + Object.Flags04)
	jr	z, +_
	
	ld	hl, $0000
	xor	a
	sbc	hl, de
	ex	de, hl
	
_:	; set the new speed values
	ld	(ix + Object.VelX), e
	ld	(ix + Object.VelX + 1), d
	ld	(ix + Object.VelY), c
	ld	(ix + Object.VelY + 1), b
	jp	Engine_UpdateObject_ProcessLogic

LABEL_66FB:
	ld	l, (ix+$0e)
	ld	h, (ix+$0f)
	ld	a, (hl)
	inc	hl
	ld	(ix+$0e), l
	ld	(ix+$0f), h
	ld	(ix+$02), a
	jp	Engine_UpdateObject_ProcessLogic


LABEL_670F:	;command sequence $FF $06 - load a sprite
	call	Engine_AllocateObjectLowPriority
	jr	c, LABEL_677C	;if no sprite slots
	ld	l, (ix+$0E)
	ld	h, (ix+$0F)
	ld	a, (hl)
	ld	(iy+$00), a
	inc	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	inc	hl
	ld	a, (hl)
	ld	(iy+$3F), a
	inc	hl
	ld	(ix+$0E), l
	ld	(ix+$0F), h
	bit	4, (ix+$04)
	jr	z, +_
	ld	hl, $0000
	xor	a
	sbc	hl, de
	ex	de, hl
_:	ld	l, (ix+$11)
	ld	h, (ix+$12)
	add	hl, de
	ld	(iy+$11), l
	ld	(iy+$12), h
	ld	(iy+$3A), l
	ld	(iy+$3B), h
	ld	l, (ix+$14)
	ld	h, (ix+$15)
	add	hl, bc
	ld	(iy+$14), l
	ld	(iy+$15), h
	ld	(iy+$3C), l
	ld	(iy+$3D), h
	ld	a, (ix+$04)
	and	$10
	ld	(iy+$04), a
	ld	a, (ix+$08)
	ld	(iy+$08), a
	ld	a, (ix+$09)
	ld	(iy+$09), a
	jp	Engine_UpdateObject_ProcessLogic

LABEL_677C:	;no open sprite slots
	ld	l, (ix+$0E)	;skip over the data for the "load sprite"
	ld	h, (ix+$0F)	;command and continue with the next frame
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	ld	(ix+$0E), l
	ld	(ix+$0F), h
	jp	Engine_UpdateObject_ProcessLogic



LABEL_6791:
	ld	l, (ix+$0E)
	ld	h, (ix+$0F)
	ld	e, (hl)		;pointer to subroutine
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	a, (hl)
	ld	(ix+$0c), a	;store new input handler
	inc	hl
	ld	a, (hl)
	ld	(ix+$0d), a
	inc	hl
	ld	(ix+$0E), l
	ld	(ix+$0F), h
	ld	hl, Engine_UpdateObject_Animation	;push this as the return address for the sub
	push	hl
	ex	de, hl
	jp	(hl)			;jump to subroutine

LABEL_67B1:	;triggers loading tiles for a monitor or chaos emerald
	ld	l, (ix+$0E)
	ld	h, (ix+$0F)
	ld	a, (hl)		;which tiles should we load?
	inc	hl
	ld	(ix+$0E), l
	ld	(ix+$0F), h
	ld	(PatternLoadCue), a	;the tiles to load
	jp	Engine_UpdateObject_ProcessLogic

Logic_Cmd_PlaySound:	;just in case a SFX command wasn't deleted
	ld	l, (ix+$0e)
	ld	h, (ix+$0f)
	inc	hl
	ld	(ix+$0e), l
	ld	(ix+$0f), h
	jp	Engine_UpdateObject_ProcessLogic


; =============================================================================
;	Logic_SetObjectFacingRight(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Clears the object's "facing left" flag.
;	NOTE: any routines using this function should be changed since it is
;	inefficient.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to object.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Logic_SetObjectFacingRight:	; $67EC
	res	OBJ_F4_FACING_LEFT, (ix + Object.Flags04)
	ret	


; =============================================================================
;	Logic_SetObjectFacingLeft(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Sets the object's "facing left" flag.
;	NOTE: any routines using this function should be changed since it is
;	inefficient.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to object.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Logic_SetObjectFacingLeft:		; $67F1
	set	OBJ_F4_FACING_LEFT, (ix + Object.Flags04)
	ret	


; =============================================================================
;	Logic_ToggleObjectDirection(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Inverts the object's direction flag.
;	NOTE: any routines using this function should be changed since it is
;	inefficient.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to object.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Logic_ToggleObjectDirection:	; $67F6
	ld	a, (ix + Object.Flags04)
	xor	1 << OBJ_F4_FACING_LEFT
	ld	(ix + Object.Flags04), a
	ret


; =============================================================================
;	Engine_UpdateObjectPosition(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Adds the object's horizontal & vertical velocities (Q8.8) to its current
;	position (Q16.8).
; -----------------------------------------------------------------------------
;	In:
;	IX - Object pointer.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_UpdateObjectPosition:		;$67FF
	ld	l, (ix + Object.SubPixelX)
	ld	h, (ix + Object.X)
	ld	e, (ix + Object.VelX)
	ld	d, (ix + Object.VelX + 1)
	ld	b, (ix + Object.X + 1)
	ld	a, d
	and	$80
	rlca	
	dec	a
	cpl	
	add	hl, de			;add h-velocity to hpos
	adc	a, b
	ld	(ix + Object.X + 1), a
	ld	(ix + Object.SubPixelX), l
	ld	(ix + Object.X), h
	
	ld	l, (ix + Object.SubPixelY)	;update vertical position
	ld	h, (ix + Object.Y)
	ld	e, (ix + Object.VelY)
	ld	d, (ix + Object.VelY + 1)
	ld	b, (ix + Object.Y + 1)
	ld	a, d
	and	$80
	rlca	
	dec	a
	cpl	
	add	hl, de
	adc	a, b
	ld	(ix + Object.Y + 1), a
	ld	(ix + Object.SubPixelY), l
	ld	(ix + Object.Y), h
	ret	


; =============================================================================
;	Engine_CheckCollision(uint16 obj_ptr)
; -----------------------------------------------------------------------------
;	Checks for a collision between an object and the player.
; -----------------------------------------------------------------------------
;	In:
;	ix	- Pointer to the object descriptor.
;	ld:
;	Updates player & object collision flags.
;	Destroys:
;	A, BC, DE, HL
; -----------------------------------------------------------------------------
Engine_CheckCollision:		;$6840
	; check for invincibility power up
	ld	a, (Player.PowerUp)
	cp	$02
	jr	nz, +_

	; flag player as invulnerable
	ld	hl, Player.Flags03
	set	1, (hl)
	set	OBJ_F3_BIT7, (hl)

_:	xor	a
	; reset colliding object index
	ld	(ix + Object.CollidingObj), a
	; clear collision axis flags (lower 4 bits)
	ld	a, (ix + Object.SprColFlags)
	and	%11110000
	ld	(ix + Object.SprColFlags), a
	
	; don't record the collision of the player has lost a life
	ld	a, (Player.State)
	cp	PlayerState_LostLife
	ret	z
	cp	PlayerState_Drowning
	ret	z

	bit	OBJ_F3_BIT6, (ix + Object.Flags03)
	ret	nz
	
	bit	OBJ_F3_BIT7, (ix + Object.Flags03)
	jr	nz, +_

	ld	a, (Player.Flags03)
	bit	OBJ_F3_BIT6, a
	ret	nz

_:	; determine the object's location relative to the player
	ld	hl, (Player.X)
	ld	e, (ix + Object.X)
	ld	d, (ix + Object.X + 1)
	xor	a
	sbc	hl, de
	
	; is the player to the left?
	jr	c, Engine_CheckCollision_Left
	
	; player is to the right of the object
	; test proximity (i.e. difference < 256)
	ld	a, h
	or	a
	jp	nz, Engine_CheckCollision_Return
	
	; test proximity on the horizontal axis
	ld	a, (Player.Width)
	add	a, (ix + Object.Width)
	cp	l
	jp	c, Engine_CheckCollision_Return
	
	; store the overlap value in C and flag the collision
	ld	c, l
	set	OBJ_COL_RIGHT, (ix + Object.SprColFlags)
	jr	Engine_CheckCollision_Bottom


;Tests for a collision at the objects' left-edge
Engine_CheckCollision_Left:	;$6899
	ld	a, h
	inc	a
	jp	nz, Engine_CheckCollision_Return
	ld	a, l
	neg	
	jp	z, Engine_CheckCollision_Return
	ld	l, a
	
	; test proximity
	ld	a, (Player.Width)
	add	a, (ix + Object.Width)
	cp	l
	jp	c, Engine_CheckCollision_Return
	
	; store the overlap value in C and flag the collision
	ld	c, l
	set	OBJ_COL_LEFT, (ix + Object.SprColFlags)


;Tests for a collision at the object's bottom edge
Engine_CheckCollision_Bottom:	;$68B4
	; compare the player's vertical position with the object's
	ld	hl, (Player.Y)
	ld	e, (ix + Object.Y)
	ld	d, (ix + Object.Y + 1)
	xor	a
	sbc	hl, de

	; jump if player is above object
	jr	c, Engine_CheckCollision_Top
	
	ld	a, h
	or	a
	jr	nz, Engine_CheckCollision_Return
	
	; test proximity
	ld	a, (Player.Height)
	cp	l
	jr	c, Engine_CheckCollision_Return
	
	; flag the collision
	set	OBJ_COL_BOTTOM, (ix + Object.SprColFlags)
	jr	Engine_CheckCollision_UpdateObjectFlags

;Tests for a collision at the top of the object
Engine_CheckCollision_Top:		;$68D3
	ld	a, h
	inc	a
	jr	nz, Engine_CheckCollision_Return
	ld	a, l
	neg	
	jr	z, Engine_CheckCollision_Return
	
	; store the overlap value in L
	ld	l, a
	
	; test proximity
	ld	a, (ix + Object.Height)
	cp	l
	jr	c, Engine_CheckCollision_Return
	
	; Flag the collision
	set	OBJ_COL_TOP, (ix + Object.SprColFlags)

;updates flags on both objects after a collision
Engine_CheckCollision_UpdateObjectFlags:	;$68E7
	; determine which overlap is deeper (horizontal or vertical)
	ld	a, l
	cp	c
	
	; keep the flag bits corresponding to the deepest collision
	ld	b, (1 << OBJ_COL_RIGHT) | ( 1 << OBJ_COL_LEFT)
	jr	c, +_
	ld	b, (1 << OBJ_COL_BOTTOM) | ( 1 << OBJ_COL_TOP)
_:	ld	a, (ix + Object.SprColFlags)
	and	b
	ld	(ix + Object.SprColFlags), a
	
	; is player collidable?
	ld	a, (Player.Flags03)
	bit	OBJ_F3_BIT7, a
	jr	nz, +_
	
	; record a collision with the player object
	ld	(ix + Object.CollidingObj), 1
	
_:	bit	OBJ_F3_BIT7, (ix + Object.Flags03)
	jr	nz, +_

	; calculate the object's index and store in the player object
	; structure as the colliding object
	lea	hl, ix
	call	Engine_GetObjectIndexFromPointer
	ld	(Player.CollidingObj), a


_:	; get the object's collision axis flags
	ld	a, (ix + Object.SprColFlags)
	and	%00001111
	ld	b, a
	
	; invert the collision flags
	and	%00000011
	ld	c, %00001100	
	jr	z, +_
	ld	c, %00000011
_:	ld	a, b
	xor	c
	
	; store the object's collision flags in the upper
	; bits of the player's collision flags
	rlca
	rlca	
	rlca	
	rlca	
	ld	b, a
	ld	a, (Player.SprColFlags)
	and	%00001111
	or	b
	ld	(Player.SprColFlags), a
	ret	


Engine_CheckCollision_Return:		;$692F
	ld	a, (ix + Object.SprColFlags)
	and	%11110000
	ld	(ix + Object.SprColFlags), a
	ret	



LABEL_6938:
	ld	b, (ix+$22)	;b = background collision flags
	ld	a, ($D3B9)
	or	a
	jr	nz, +_
	bit	1, (ix+$03)
	jr	nz, ++_
	
_:	ld	a, (ix+$21)	;a = object collision flags
	rrca
	rrca
	rrca
	rrca
	and	$0F
	or	b
	ld	b, a
	
_:	ld	(ix+$23), b	;copy collision flags here
	ret	


;SHZ-2 wind
Engine_UpdateSHZ2Wind:
LABEL_6956:
	ld	a, (CurrentLevel)	;check for SHZ-2
	dec	a
	ret	nz
	ld	a, (CurrentAct)
	dec	a
	ret	nz
	call	LABEL_6B61
	ld	a, ($D440)			;wind
	and	$03
	ld	l, a
	ld	h, $00
	add	hl, hl
	ld	de, DATA_6975
	add	hl, de
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	jp	(hl)

DATA_6975:
.dw LABEL_697D 
.dw LABEL_698F 
.dw LABEL_69F5
.dw LABEL_6B47

LABEL_697D: 
	ld	a, ($DB2C)
	cp	$E0
	ret	z
	ld	a, $E0
	ld	hl, $DB2C
	ld	b, $08
_:	ld	(hl), a
	inc	hl
	djnz	-_
	ret	

LABEL_698F:
	ld	b, $08
	ld	de, DATA_6B27
	exx	
	ld	de, ($D176)
	exx	
	ld	ix, $D445
_:	ld	a, (de)
	exx	
	ld	l, a
	ld	h, $00
	add	hl, de
	ld	(ix+$00), l
	ld	(ix+$01), h
	exx	
	lea	ix, ix+2
	inc	de
	inc	de
	djnz	-_
	ld	b, $08
	ld	de, DATA_6B27+1
	exx	
	ld	de, ($D174)
	exx	
	ld	ix, $D455
_:	ld	a, (de)
	exx	
	ld	l, a
	ld	h, $00
	add	hl, de
	ld	(ix+$00), l
	ld	(ix+$01), h
	exx	
	lea	ix, ix+2
	inc	de
	inc	de
	djnz	-_
	ld	b, $08
	ld	hl, $DB99
_:	ld	a, $f6
	add	a, b
	ld	(hl), a
	inc	hl
	inc	hl
	djnz	-_
	ld	a, $02
	ld	($D440), a
	ld	a, $08
	ld	($D444), a
	ld	hl, $0078
	ld	($D442), hl
	ret
	
LABEL_69F5:
	ld	a, ($D441)
	inc	a
	ld	($D441), a
	ld	b, $08
	ld	ix, $D445
	ld	iy, $D455
	ld	hl, $DB98
_:	push	hl
	call	LABEL_6A7E
	pop	hl
	ld	a, ($D441)
	and	$01
	call	z, LABEL_6B17
	inc	hl
	inc	hl
	lea	ix, ix+2
	lea	iy, iy+2
	djnz	-_
	;FALL THROUGH
	
LABEL_6A25:
	ld	b, $08
	ld	ix, $D445
	ld	de, ($D176)
	exx	
	ld	de, $DB2C
	exx	
_:	ld	l, (ix+$00)
	ld	h, (ix+$01)
	xor	a
	sbc	hl, de
	ld	a, l
	exx	
	ld	(de), a
	inc	de
	exx	
	lea	ix, ix+2
	djnz	-_
	ld	b, $08
	ld	ix, $D455
	ld	de, ($D174)
	exx	
	ld	de, $DB98
	exx	
_:	ld	l, (ix+$00)
	ld	h, (ix+$01)
	xor	a
	sbc	hl, de
	ld	a, l
	exx	
	ld	(de), a
	inc	de
	inc	de
	exx	
	cp	$08
	jr	nc, +_
	ld	a, ($D444)
	cp	b
	jr	nc, +_
	exx	
	dec	de
	ld	a, $FE
	ld	(de), a
	inc	de
	exx	
_:	lea	ix, ix+2
	djnz	--_
	ret	

LABEL_6A7E:
	ld	l, (ix+$00)
	ld	h, (ix+$01)
	ld	de, -4
	add	hl, de
	ld	(ix+$00), l
	ld	(ix+$01), h
	ld	de, $0040
	add	hl, de
	ld	de, ($D176)
	xor	a
	sbc	hl, de
	jr	c, LABEL_6ACD
	ld	de, $0010
	xor	a
	sbc	hl, de
	jr	c, LABEL_6ACD
	ld	l, (iy+$00)
	ld	h, (iy+$01)
	ld	de, $0005
	add	hl, de
	ld	(iy+$00), l
	ld	(iy+$01), h
	ld	de, $0040
	add	hl, de
	ld	de, ($D174)
	xor	a
	sbc	hl, de
	jr	c, LABEL_6ACD
	ld	de, $0140
	xor	a
	sbc	hl, de
	jr	nc, LABEL_6ACD
	ret	

LABEL_6ACD:
	lea	hl, ix
	ld	de, $D445
	xor	a
	sbc	hl, de
	ld	a, ($D441)
	add	a, l
	ld	c, a
	ld	a, r	;point of interest - used for random value?
	add	a, c
	ld	c, a
	ld	a, ($D511)
	add	a, c
	ld	c, a
	ld	a, (LevelTimer)
	add	a, c
	ld	c, a
	ld	a, ($D2BC)
	add	a, c
	and	$0F
	add	a, a
	ld	hl, DATA_6B27
	add	a, l
	ld	l, a
	xor	a
	adc	a, h
	ld	h, a
	ld	a, (hl)
	inc	hl
	ld	c, (hl)
	ld	e, a
	ld	d, $00
	ld	hl, ($D176)
	add	hl, de
	ld	(ix+$00), l
	ld	(ix+$01), h
	ld	e, c
	ld	d, $00
	ld	hl, ($D174)
	add	hl, de
	ld	(iy+$00), l
	ld	(iy+$01), h
	ret	

LABEL_6B17:
	inc	hl
	ld	a, (hl)
	cp	$FE
	jr	z, ++_
	inc	a
	cp	$F9
	jr	c, +_
	ld	a, $F6
_:	ld	(hl), a
_:	dec	hl
	ret	

DATA_6B27:
.db $E0, $00, $E0, $20, $C0, $40, $E0, $60
.db $C0, $80, $30, $00, $68, $08, $80, $10
.db $D0, $10, $C8, $28, $D0, $48, $C8, $50
.db $90, $00, $C4, $40, $68, $00, $A8, $08
	
LABEL_6B47:
	xor	a
	ld	($D444), a
	ld	hl, ($D442)
	dec	hl
	ld	($D442), hl
	ld	a, h
	and	$80
	jr	nz, +_
	ld	a, h
	or	l
	jp	nz, LABEL_69F5
_:	xor	a
	ld	($D440), a
	ret	

LABEL_6B61:
	ld	hl, ($D174)
	ld	a, h
	and	$0F
	sla	l
	rla	
	sla	l
	rla
	ld	e, a
	ld	d, $00
	ld	hl, DATA_6BB2
	add	hl, de
	ld	a, (hl)
	inc	a
	and	$07
	ld	l, a
	ld	h, $00
	add	hl, hl
	ld	de, LABEL_6B85
	add	hl, de
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	jp	(hl)

LABEL_6B85:
.dw LABEL_6B95
.dw LABEL_6B96
.dw LABEL_6B9B
.dw LABEL_6B95
.dw LABEL_6BA7
.dw LABEL_6B95
.dw LABEL_6B95
.dw LABEL_6B95

LABEL_6B95:
	ret

LABEL_6B96:
	xor	a
	ld	($d440), a
	ret	

LABEL_6B9B:
	ld	a, ($d440)
	cp	$02
	ret	z
	ld	a, $01
	ld	($d440), a
	ret

LABEL_6BA7:
	ld	a, ($d440)
	or	a
	ret	z
	ld	a, $03
	ld	($d440), a
	ret	

DATA_6BB2:
.db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.db $FF, $FF, $FF, $03, $01, $03, $00, $FF
.db $FF, $FF, $FF, $03, $01, $01, $03, $00
.db $FF, $FF, $FF, $FF, $01, $01, $01, $03
.db $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $03
.db $01, $01, $01, $01, $03, $01, $03, $00
.db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

LABEL_6BF2: ;collision with ring object?
	call	LABEL_6C3C
	call	Player_CheckHorizontalLevelCollision
	call	Player_CheckTopLevelCollision
	call	LABEL_7378
	jp	LABEL_6938

LABEL_6C01:
	ld	a, (Player_MaxVelX)
	and	a
	jp	p, +_
	neg	
_:	cp	$04
	jr	nc, LABEL_6C2D
	bit	0, (ix+$07)
	jr	z, LABEL_6C21
	call	LABEL_6C3C
	call	Player_CheckTopLevelCollision
	call	LABEL_7378
	jp	LABEL_6938

LABEL_6C21:
	call	LABEL_6C3C
	call	Player_CheckHorizontalLevelCollision
	call	LABEL_7378
	jp	LABEL_6938

LABEL_6C2D:
	call	LABEL_6C3C
	call	Player_CheckHorizontalLevelCollision
	call	Player_CheckTopLevelCollision
	call	LABEL_7378
	jp	LABEL_6938


LABEL_6C3C:
	ld	a, ($D363)		;get the speed modifier value
	ld	($D364), a		;and copy here
	
	xor	a				;clear previous modifier value
	ld	($D363), a
	
	ld	bc, $0000		;horiz. offset
	ld	de, $0000		;vert. offset
	call	Engine_GetCollisionDataForBlock

	ld	a, (Cllsn_MetatileIndex)		;get current mapping number
	ld	($D365), a
	ld	($D367), a
	
	call	LABEL_6F82
	ld	a, (Cllsn_MetaTileSurfaceType)
	ld	($D366), a
	and	$7F
	ld	l, a
	ld	h, $00
	add	hl, hl
	ld	de, Cllsn_MetaTileTriggerFuncPtrs
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ex	de, hl
	jp	(hl)

Cllsn_MetaTileTriggerFuncPtrs:		; $6C70
.dw LABEL_6DAA	;$00
.dw LABEL_6CA0	;$01 - solid block
.dw LABEL_6CA1	;
.dw LABEL_6C9C
.dw LABEL_6C9C
.dw LABEL_6CE2	;$05 - spikes
.dw LABEL_6DAA	;$06 - 
.dw LABEL_6DAA
.dw LABEL_6D49	;$08 - ALZ slippery slope (unused?)
.dw LABEL_6CA2	;$09 - vertical spring
.dw LABEL_6DAA	;$0A - horizontal spring
.dw LABEL_6C9C	;$0B
.dw LABEL_6D52	;$0C - falling platform (e.g. SHZ bridge)
.dw LABEL_6CF7	;$0D - breakable block
.dw LABEL_6D0D	;$0E
.dw LABEL_6C9C
.dw LABEL_6E30
.dw LABEL_6C9C
.dw LABEL_6C9D
.dw LABEL_6EB1	;$13 - SEZ pipes
.dw LABEL_6CAD	;$14 - diagonal spring
.dw LABEL_6C9C

LABEL_6C9C:
LABEL_6C9D:
LABEL_6CA0:
LABEL_6CA1:
	ret	

LABEL_6CA2:				;hit vertical spring
	bit	1, (ix+$22)
	ret	z
	ld	hl, -1920		;jump velocity
	jp	Player_SetState_VerticalSpring	


LABEL_6CAD:				;diagonal spring
	bit	1, (ix+$22)
	ret	z
	ld	hl, -1920
	set	4, (ix+$04)
	ld	a, ($d365)
	cp	$80
	jr	nc, +_
	ld	hl, $0780
	res	4, (ix+$04)
_:	ld	(ix+$16), l		;horizontal velocity
	ld	(ix+$17), h
	ld	hl, -1296
	ld	a, (CurrentLevel)
	cp	$03				;check to see if we're on GHZ
	jr	z, +_
	ld	hl, -1792			
_:	jp	Player_SetState_DiagonalSpring


LABEL_6CE2:				;hit spikes
	ld	a, ($D365)
	and	$fe
	cp	$f4
	ret	z
	bit	1, (ix+$22)
	ret	z
	bit	7, (ix+$03)
	ret	nz
	jp	Player_SetState_Hurt

	
LABEL_6CF7:				;hit breakable block
	bit	1, (ix+$03)
	ret	z				;return if player is not rolling
	ld	hl, -1088
	ld	($D518), hl	;set vertical speed
	res	1, (ix+$22)
	set	0, (ix+$03)
	jp	Player_CollideBreakableBlock_UpdateMappings	;update level layout


LABEL_6D0D:	; GMZ rotating discs
	bit	1, (ix + Object.BgColFlags)
	ret	z
	
	; check to see if the metatile index is in the array below
	ld	a, ($D365)
	ld	hl, DATA_6D41
	ld	bc, DATA_6D41_End - DATA_6D41
	cpir 
	; if the metatile is in the array load hl with -256
	; otherwise load hl with +256
	jr	z, +_
	ld	hl, 256
	jr	++_
_:	ld	hl, -256

	; FIXME: do this after the CPIR so that we dont have
	;to compare again here
_:	ld	c, $00
	bit	7, h
	jr	z, +_
	dec	c

_:	; clear the carry flag
	xor	a
	; add the adjustment value to the player's position.
	ld	de, (Player.SubPixelX)
	add	hl, de
	ld	(Player.SubPixelX), hl
	adc	a, c
	add	a, (ix + Object.X + 1)
	ld	(ix + Object.X + 1), a
	ret	


DATA_6D41:
.db $DF, $E0, $E3, $E4, $E5, $E6, $E7, $F0
DATA_6D41_End:

LABEL_6D49:	;alz slippery slope
	ld	a, (ix+$02)
	cp	$1A
	ret	z
	jp	LABEL_318F

LABEL_6D52:
	ld	a, (Cllsn_CollisionValueX)		;vertical collision value
	cp	$20
	ret	nz
	ld	a, ($D365)
	ld	c, $FF
	cp	$EF
	jr	nz, +_
	ld	a, ($D511)		;get player h-pos
	ld	c, $ED
	and	$10
	jr	z, +_
	inc	c
_:	push	bc
	res	1, (ix+$22)
	call	Engine_AllocateObjectLowPriority
	pop	bc
	ret	c
	ld	(iy+$00), $2d
	jr	LABEL_6D81

LABEL_6D81:
	ld	a, (Frame2Page)
	push	af
	ld	a, ($D162)	;bank with 32x32 mappings
	call	Engine_SwapFrame2
	ld	a, c
	ld	hl, (Cllsn_LevelMapBlockPtr)
	ld	(hl), a
	ld	l, a
	ld	h, $00
	add	hl, hl
	ld	a, ($D164)	;BC = pointer to 32x32 mappings
	ld	c, a
	ld	a, ($D165)
	ld	b, a
	add	hl, bc
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	Engine_UpdateMappingBlock
	pop	af
	call	Engine_SwapFrame2
	jr	LABEL_6DD5

LABEL_6DAA:
	res	1, (ix+$22)
	ld	a, ($D501)
	cp	PlayerState_Rolling
	jr	z, +_
	cp	PlayerState_JumpFromRamp
	jr	z, +_
	jr	LABEL_6DD5
_:	ld	a, ($D364)
	or	a
	jr	z, LABEL_6DD5
	bit	7, (ix+$17)
	jr	nz, LABEL_6DCC
	bit	1, a
	jr	z, LABEL_6DD5
	jp	Player_RampLaunch

LABEL_6DCC:
	bit	1, a
	jr	nz, LABEL_6DD5
	jp	Player_RampLaunch

LABEL_6DD5: 
	call	LABEL_6938
	bit	1, (ix+$23)
	ret	nz
	bit	0, (ix+$03)	;player in air?
	ret	nz
	ld	a, (ix+$01)
	cp	PlayerState_Rolling
	jp	nz, Player_SetState_Falling
	jp	LABEL_3ACA

;called when launching from a ramp
Player_RampLaunch:
LABEL_6DED:
	ld	l, (ix+$16)
	ld	h, (ix+$17)
	bit	7, h				;is horizontal velocity negative?
	jr	nz, LABEL_6E10
	ld	d, h			;take horizontal velocity, divide by 2 and add to vertical velocity
	ld	e, l
	srl	h
	rr	l
	add	hl, de
	dec	hl
	ld	a, h
	cpl	
	ld	h, a
	ld	a, l
	cpl	
	ld	l, a
	ld	($D518), hl
	jp	Player_SetState_JumpFromRamp

;launch from ramp with negative velocity
LABEL_6E10:
	dec	hl			;2's comp horizontal velocity, divide by 2 and
	ld	a, h		;add to vertical velocity.
	cpl	
	ld	h, a
	ld	a, l
	cpl	
	ld	l, a
	ld	d, h
	ld	e, l
	srl	h
	rr	l
	add	hl, de
	dec	hl
	ld	a, h
	cpl	
	ld	h, a
	ld	a, l
	cpl	
	ld	l, a
	ld	($D518), hl
	jp	Player_SetState_JumpFromRamp
	
LABEL_6E30:
	ld	a, (Cllsn_CollisionValueX)
	bit	7, a
	ret	nz
	bit	1, (ix+$22)
	ret	z
	ld	a, ($D365)
	cp	$2D
	ret	nz
	ld	hl, (Player.VelX)
	bit	7, h
	ret	nz
	ld	a, h
	neg	
	ld	h, a
	ld	a, l
	neg	
	ld	l, a
	ld	(Player.VelX), hl
	ld	(Player.VelY), hl
	ret	
	
LABEL_6E56:
	ld	a, (Cllsn_CollisionValueX)
	bit	6, a
	jr	nz, LABEL_6E8B
	and	$3F
	ld	b, a
	ld	a, (Cllsn_AdjustedY)
	and	$1F
	add	a, b
	cp	$20
	ret	c
	sub	$20
	ld	c, a
	ld	b, $00
	ld	h, (ix+$15)
	ld	l, (ix+$14)
	xor	a
	sbc	hl, bc
	ld	(ix+$15), h
	ld	(ix+$14), l
	set	1, (ix+$22)
	call	LABEL_6938
	ld	a, ($D100)
	ld	($D363), a
	ret	

LABEL_6E8B:
	and	$3F
	ld	b, a
	ld	a, (Cllsn_AdjustedY)
	and	$1F
	add	a, c
	sub	b
	ret	nc
	neg	
	ld	c, a
	ld	b, $00
	ld	h, (ix+$15)
	ld	l, (ix+$14)
	xor	a
	sbc	hl, bc
	ld	(ix+$15), h
	ld	(ix+$14), l
	set	1, (ix+$22)
	jp	LABEL_6938

LABEL_6EB1:
	ld	a, ($D365)
	ld	($D367), a


;************************************************************************
;*	Tests to see if the player is entering or leaving a		*
;*	pipe.								*					
;************************************************************************
Player_EnterPipe:		;$6EB7
	res	1, (ix+$22)
	set	0, (ix+$03)
	ld	a, (Cllsn_MetatileIndex)	;get current mapping index
	cp	$3B
	jr	z, Player_EnterPipe_Top		;vertical entrance - top
	cp	$3C
	jr	z, Player_EnterPipe_Bottom	;vertical entrance - bottom
	cp	$3D
	jr	z, Player_EnterPipe_Left	;horizontal entrance - left
	cp	$3E
	jp	z, Player_EnterPipe_Right	;horizontal entrance - right
	jp	Player_EnterPipe_Return


;************************************************
;*	Player entering pipe from below.	*
;************************************************
Player_EnterPipe_Bottom:		;$6ED6
	ld	a, (ix+$01)		;check to see if the player
	cp	PlayerState_InPipe	;is already in the pipe
	jp	z, Player_EnterPipe_Return
	bit	7, (ix+$19)
	jp	z, Player_EnterPipe_Return		;bail out if player is moving down
	ld	(ix+$02), PlayerState_InPipe	;set player state
	ld	hl, $FA00			;set vertical speed
	ld	(ix+$18), l
	ld	(ix+$19), h
	ld	hl, $0000			;set horizontal speed
	ld	(ix+$16), l
	ld	(ix+$17), h
	jp	Player_EnterPipe_Return


;************************************************
;*	Player entering pipe from above.	*
;************************************************
Player_EnterPipe_Top:		;$6F03
	ld	a, (ix+$01)		;check to see if the player
	cp	PlayerState_InPipe	;is already in the pipe
	jr	z, Player_EnterPipe_Return
	bit	7, (ix+$19)
	jp	nz, Player_EnterPipe_Return	;bail out if player is moving up	
	ld	(ix+$02), PlayerState_InPipe	;set player state
	ld	hl, $0600			;set vertical speed
	ld	(ix+$18), l
	ld	(ix+$19), h
	ld	hl, $0000			;set horizontal speed
	ld	(ix+$16), l
	ld	(ix+$17), h
	jp	Player_EnterPipe_Return


;****************************************
;*	Player entering pipe from left. *
;****************************************
Player_EnterPipe_Left:		;$6F2E
	ld	a, (ix+$01)		;check to see if the player
	cp	PlayerState_InPipe	;is already in the pipe
	jr	z, Player_EnterPipe_Return
	bit	7, (ix+$17)
	jp	nz, Player_EnterPipe_Return	;bail out if player is moving left
	ld	(ix+$02), PlayerState_InPipe	;set player state
	ld	hl, $0600			;set horizontal speed
	ld	(ix+$16), l
	ld	(ix+$17), h
	ld	hl, $0000			;set vertical speed
	ld	(ix+$18), l
	ld	(ix+$19), h
	jp	Player_EnterPipe_Return


;************************************************
;*	Player entering pipe from right.	*
;************************************************
Player_EnterPipe_Right:	;$6F59
	ld	a, (ix+$01)		;check to see if the player
	cp	PlayerState_InPipe	;is already in the pipe
	jr	z, Player_EnterPipe_Return
	bit	7, (ix+$17)
	jr	z, Player_EnterPipe_Return		;bail out if player is moving right
	ld	(ix+$02), PlayerState_InPipe	;set player state
	ld	hl, $FA00			;set horizontal speed
	ld	(ix+$16), l
	ld	(ix+$17), h
	ld	hl, $0000			;set vertical speed
	ld	(ix+$18), l
	ld	(ix+$19), h

Player_EnterPipe_Return:	;$6F81
	ret


;A == mapping number
LABEL_6F82:
	cp	$F2
	jr	nc, ++_				;jump if mapping >= $F2 (ugz lava block)
	
	cp	$DF				;jump if mapping >= $DF & < $F2
	jr	nc, LABEL_6FCE			;i.e. the GMZ conveyor belts
	
	cp	$88				;return if mapping >= $88 & < $DF
	ret	nc

	cp	$78				;jump if mapping >= $78 & < $88
	jr	nc, +_				;e.g. springs & spikes

	cp	$70				;return if mapping >= $70 & < $78
	ret	nc				;i.e. ring blocks

_:	cp	$40				;jump if mapping >= $40 & < $70
	jr	nc, LABEL_6FCE

_:	ld	a, (Cllsn_CollisionValueX)	;get the block's collision value
	and	$3F
	cp	$20
	call	z, Cllsn_ProjectVertical
	
	ld	a, (Cllsn_AdjustedY)		;get the lo-byte of the vertical position
	and	$1F
	ld	c, a				;c = position on the block
	ld	a, (Cllsn_CollisionValueX)	;a = collision value
	and	$3F
	add	a, c				;a += c
	cp	$20
	ret	c				;return if a < $20
	sub	$20				;calculate a projection value 
	
	ld	c, a
	ld	b, $00
	ld	hl, (Player.Y)
	xor	a
	sbc	hl, bc
	ld	(Player.Y), hl			;adjust the vertical position

	set	1, (ix + $22)			;flag the collision
	
	call	LABEL_6938
	ld	a, ($D100)
	ld	($D363), a
	ret	

LABEL_6FCE:
	bit	7, (ix+$19)
	ret	nz					;return if the player is moving up
	ld	a, (Cllsn_CollisionValueX)		;get vert collision value
	and	$3F
	call	z, Cllsn_ProjectVertical
	res	1, (ix+$22)
	ld	a, (ix+$19)				;hi-byte of vertical velocity
	add	a, $09
	ld	b, a
	ld	a, (Cllsn_AdjustedY)			;lo-byte of adjusted vert. pos
	and	$1F					;calculate current position in block
	ld	c, a
	ld	a, (Cllsn_CollisionValueX)		;get vert projection value
	add	a, c
	cp	$20
	ret	c
	sub	$20
	cp	b
	ret	nc
	ld	c, a
	ld	b, $00
	ld	hl, ($D514)				;adjust vertical pos in level
	xor	a
	sbc	hl, bc
	ld	($D514), hl
	set	1, (ix+$22)
	call	LABEL_6938
	ld	a, ($D100)
	ld	($D363), a
	ret	

; =============================================================================
;	Cllsn_ProjectVertical(uint16 obj)
; -----------------------------------------------------------------------------
;	Moves an object vertically in response to a collision with the background
;	tiles.
; -----------------------------------------------------------------------------
;	In:
;	
;	ld:
;	
; -----------------------------------------------------------------------------
Cllsn_ProjectVertical:		; $7010
	push	bc
	; calculate the address of the metatile that the object
	; is currently overlapping
	ld	hl, (Cllsn_LevelMapBlockPtr)
	ld	de, (LevelAttributes.WidthNeg)
	add	hl, de
	
	; get the metatile value
	ld	a, (hl)
	
	; calculate a pointer to the metatile's collision data
	ld	l, a
	ld	h, $00
	add	hl, hl
	ld	de, (Engine_CollisionDataPtr)
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ex	de, hl
	
	; read the collision type?
	ld	a, (hl)
	
	; if collision value == $82 calculate the projection value and
	; store in memory but dont apply it to the object's position.
	cp	$82
	jr	z, Cllsn_ProjectVertical_NoAlter
	
	
	; if the MSB is zero, don't bother projecting out
	bit	7, a
	jr	z, Cllsn_ProjectVertical_Epilogue
	
	inc	hl				;get speed modifier value
	ld	a, (hl)
	ld	($D100), a
	
	inc	hl				;BC = pointer to collision data
	ld	c, (hl)
	inc	hl
	ld	b, (hl)

	ex	de, hl
	
	; calculate the object's horizontal position
	; within the metatile...
	ld	a, (Cllsn_AdjustedX)
	and	$1F
	ld	l, a
	ld	h, $00
	add	hl, bc
	; ...and read the collision value
	ld	a, (hl)
	
	and	$3F
	jr	z, Cllsn_ProjectVertical_Epilogue

	; project out of the collision
	ld	c, a
	ld	b, $00
	ld	h, (ix + Object.Y + 1)		;adjust vertical position
	ld	l, (ix + Object.Y)
	xor	a
	sbc	hl, bc
	ld	(ix + Object.Y + 1), h
	ld	(ix + Object.Y), l

Cllsn_ProjectVertical_Epilogue:	; $7066
	pop	bc
	ret	


Cllsn_ProjectVertical_NoAlter:		; $706F
	; move the pointer past the collision type &
	; speed modifier bytes
	inc	hl
	inc	hl
	
	; HL now points to the collision data pointers
	
	ld	c, (hl)		;read the pointer
	inc	hl
	ld	b, (hl)
	ex	de, hl
	
	; calculate the object's horizontal position
	; within the metatile...
	ld	a, (Cllsn_AdjustedX)
	and	$1F
	ld	l, a
	ld	h, $00
	add	hl, bc
	; ...and read the collision value
	ld	a, (hl)
	
	and	$3F
	jr	z, Cllsn_ProjectVertical_Epilogue

	; add 32 to the projection value and store
	ld	b, a
	add	a, 32
	ld	(Cllsn_CollisionValueX), a	
	jr	Cllsn_ProjectVertical_Epilogue


LABEL_708D:
	cp	$88
	ret	nc
	
	cp	$40
	jr	nc, Engine_Collision_AdjustVerticalPos
	
	ld	a, (Cllsn_CollisionValueX)
	and	$3F
	cp	$20
	call	z, Cllsn_ProjectVertical

	ld	a, (Cllsn_AdjustedY)
	and	$1F
	ld	c, a
	ld	a, (Cllsn_CollisionValueX)
	and	$3F
	add	a, c
	cp	$20
	ret	c
	sub	$20
	ld	c, a
	ld	b, $00
	ld	h, (ix+$15)	;move the player on the y-axis
	ld	l, (ix+$14)
	xor	a
	sbc	hl, bc
	ld	(ix+$15), h
	ld	(ix+$14), l
	set	1, (ix+$22)
	ret	

Engine_Collision_AdjustVerticalPos:	;70C7
	bit	7, (ix+$19)		;is object moving up or down?
	ret	nz
	
	ld	a, (Cllsn_CollisionValueX)		;vert projection value
	and	$3F
	call	z, Cllsn_ProjectVertical
	
	ld	a, (ix+$19)		;hi-byte of vertical velocity
	add	a, $07
	ld	b, a
	
	ld	a, (Cllsn_AdjustedY)		;get lo-byte of adjusted vertical position
	and	$1F				;get current position on block
	ld	c, a
	
	ld	a, (Cllsn_CollisionValueX)		;vert projection value
	add	a, c
	cp	$20
	ret	c
	
	sub	$20				;do we need to adjust the vertical
	cp	b				;position?
	ret	nc
	
	ld	c, a			;adjust vertical position
	ld	b, $00
	ld	h, (ix+$15)
	ld	l, (ix+$14)
	xor	a
	sbc	hl, bc
	ld	(ix+$15), h
	ld	(ix+$14), l
	
	set	1, (ix+$22)		;flag collision at bottom edge
	ret	


;********************************************************
;*	Tests for a collision on the X-axis between the	*
;*	player object and a level block.		*
;********************************************************
Player_CheckHorizontalLevelCollision:		;$7102
	ld	hl, $D522
	res	2, (hl)		;clear "right-edge collision" flag
	res	3, (hl)		;clear "left-edge collision" flag
;first check for a collision at the left edge of the player object
;then check the right edge
	call	Player_CheckHorizontalLevelCollision_Left
	
	ld	bc, $000A		;check for a collision at the right-hand
	ld	de, -12			;edge of the player
	call	Engine_GetCollisionDataForBlock
	ld	a, (Cllsn_MetaTileSurfaceType)
	cp	$81	;solid block
	jr	z, Player_CollideRightWithSolidBlock
	cp	$0A	;horizontal spring
	jr	z, Player_CollideRightWithSolidBlock
	cp	$05	;spikes
	jp	z, Player_CollideRightWithSpikeBlock
	cp	$8D	;breakable block
	jp	z, Player_CollideRightBreakableBlock
	cp	$13	;SEZ tubes
	jr	z, Player_CollideHorizontalWithPipeBlock
	ret	

;****************************************************************
;*	Handle a collision with a pipe block (e.g. ALZ2 or SEZ) *
;****************************************************************
Player_CollideHorizontalWithPipeBlock:		;$7130
	ld	a, (Cllsn_MetatileIndex)		;copy current block value
	ld	($D367), a		;here
	jp	Player_EnterPipe


;****************************************************************
;*	Handle a collision with a solid (or horizontal spring)	*
;*	block at the right-edge of the player object.		*
;****************************************************************
Player_CollideRightWithSolidBlock:	;$7139
	ld	a, (Cllsn_AdjustedX)		;get adjusted hpos
	and	$1F
	ld	c, a			;c = position on current block
	ld	a, (Cllsn_CollisionValueY)
	ld	b, a			;b = horizontal collision value
	and	$3F
	ret	z				;return if collision value == 0
	cp	$20
	jr	z, +_
	bit	6, b
	ret	z				;return if value < $40
_:	add	a, c			;collision value += position on block
	cp	$20
	ret	c				;return if result is < $20
	sub	$20
	ld	c, a			;c = object projection value
	ld	b, $00
	ld	hl, ($D511)
	xor	a
	sbc	hl, bc			;subtract the value from the object's hpos
	ld	($D511), hl		;move the object on the X-axis
	set	2, (ix+$22)		;set the "right-edge collision" flag
	call	LABEL_6938
	ld	a, (Cllsn_MetaTileSurfaceType)		;get the block surface type
	cp	$0A				;is the block an horizontal spring type?
	ret	nz				;return if block is not an horizontal spring
	
	ld	hl, $FA00		;block is a spring - move player accordingly
	jp	Player_SetState_HorizontalSpring


;****************************************************************
;*	Tests for a collision at the player's left edge.	*
;****************************************************************
Player_CheckHorizontalLevelCollision_Left:
LABEL_7172:
	ld	bc, -10			;check for collision at left-hand
	ld	de, -12			;edge of player
	call	Engine_GetCollisionDataForBlock
	ld	a, (Cllsn_MetaTileSurfaceType)		;get block type
	cp	$81	;solid block
	jr	z, Player_CollideLeftSolidBlock
	cp	$0A	;horizontal spring
	jr	z, Player_CollideLeftSolidBlock
	cp	$05	;spikes
	jp	z, Player_CollideLeftWithSpikeBlock
	cp	$8D	;breakable block
	jr	z, Player_CollideLeftBreakableBlock
	cp	$13
	jr	z, Player_CollideHorizontalWithPipeBlock
	ret


;****************************************************************
;*	Handle a collision with a solid (or horizontal spring)	*
;*	block at the left-edge of the player object.		*
;****************************************************************
Player_CollideLeftSolidBlock:		;$7195
	ld	a, (Cllsn_AdjustedX)		;get horizontal position
	and	$1F			;calculate position on current block
	ld	c, a
	ld	a, (Cllsn_CollisionValueY)		;get horizontal collision value
	ld	b, a
	and	$3F
	ret	z
	cp	$20
	jr	z, +_
	bit	6, b
	ret	nz
_:	cp	c
	ret	c				;return if A < C
	sub	c
	ld	c, a
	ld	b, $00
	ld	hl, ($D511)	;get horizontal pos in level
	add	hl, bc			;adjust horizontal pos
	ld	($D511), hl
	set	3, (ix+$22)
	call	LABEL_6938
	ld	a, (Cllsn_MetaTileSurfaceType)		;surface type?
	cp	$0A			;check for horizontal spring
	ret	nz
	ld	hl, $0600
	jp	Player_SetState_HorizontalSpring

;********************************************************
;*	Handle a collision with a breakable block at	*
;*	the player's right edge.			*
;********************************************************
Player_CollideRightBreakableBlock:		;$71C9
	ld	a, ($D501)                
	cp	PlayerState_SpinDash
	jp	z, Player_CollideBreakableBlock_UpdateMappings

	bit	1, (ix+$03)
	jp	z, Player_CollideRightWithSolidBlock
	ld	a, ($D517)
	bit	7, a
	jr	z, +_
	neg	
_:	cp	$03
	jp	c, Player_CollideRightWithSolidBlock
	ld	hl, ($D516)
	ld	a, h
	cp	$07
	jr	nc, +_
	ld	bc, $0040
	add	hl, bc
	ld	($D516), hl
_:	jr	Player_CollideBreakableBlock_UpdateMappings


;********************************************************
;*	Handle a collision with a breakable block at	*
;*	the player's left edge.				*
;********************************************************
Player_CollideLeftBreakableBlock:		;$71EF
	bit	1, (ix+$03)	;check to see if the player is rolling
	jr	z, Player_CollideLeftSolidBlock	;not rolling - act as solid block
	
	ld	a, ($D517)
	bit	7, a			;check player's direction
	jr	z, +_
	neg	;negate value if player moving left
_:	cp	$03			;check player's speed
	jp	c, Player_CollideLeftSolidBlock	;not fast enough - act as solid
	ld	hl, ($D516)
	ld	a, h
	neg	
	cp	$07
	jr	nc, Player_CollideBreakableBlock_UpdateMappings
	ld	bc, -64
	add	hl, bc
	ld	($D516), hl


;*********************************************************
;*	Updates the level layout mappings after a	 *
;*	collision with a breakable block.		 *
;*********************************************************
Player_CollideBreakableBlock_UpdateMappings:	;$7215
	ld	a, ($D162)		;load bank with 32x32 mappings
	call	Engine_SwapFrame2
	ld	a, $FD			;the block value to replace with
	ld	hl, (Cllsn_LevelMapBlockPtr)		;address of current block in layout data
	ld	(hl), a			;replace the value in the layout
	
	ld	l, a
	ld	h, $00
	add	hl, hl
	
	ld	a, ($D164)		;get pointer to mappings
	ld	c, a
	ld	a, ($D165)
	ld	b, a
							;calculate the mapping pointer
	add	hl, bc			;for the current block (i.e. $FD)
	
	ld	e, (hl)			;update the block in VRAM
	inc	hl
	ld	d, (hl)
	call	Engine_UpdateMappingBlock
	
	ld	hl, (Cllsn_AdjustedX)		;get the collision hpos
	ld	a, l
	and	$E0				;calculate the x-coord of the block
	ld	l, a			;involved in the collision
	ld	($D35A), hl		;and store here

	ld	hl, (Cllsn_AdjustedY)		;get the collision vpos
	ld	a, l
	and	$E0				;calculate the y-coord of the block
	ld	l, a			;involved in the collision
	ld	($D35C), hl		;and store here


;********************************************************
;*	Create the block fragment objects that are	*
;*	displayed after a collision with a breakable	*
;*	block.						*
;********************************************************
Engine_CreateBlockFragmentObjects:		;$7248
	ld	c, $04
	ld	a, (Cllsn_MetatileIndex)		;get block type
	cp	$F7
	jr	nz, +_
	ld	c, Object_BlockFragment2		;create the block fragment objects
_:	ld	h, $00
	call	Engine_AllocateObjectHighPriority
	ld	h, $01
	call	Engine_AllocateObjectHighPriority
	ld	h, $02
	call	Engine_AllocateObjectHighPriority
	ld	h, $03
	jp	Engine_AllocateObjectHighPriority


;****************************************************************
;*	Handle a collision between the player's right edge	*
;*	and a spike block that points either up or down.	*
;****************************************************************
Player_CollideRightWithSpikeBlock		;$7267
	ld	a, (Cllsn_MetatileIndex)		;get the block type
	and	$FE
	cp	$F2
	jr	z, +_
	;check to see if the player is riding the mine cart.
	;the spike blocks act as breakable blocks if the
	;collision occurred while riding the minecart.
	ld	a, ($D502)
	cp	PlayerState_InMineCart
	jp	z, Player_CollideRightBreakableBlock
	
	cp	PlayerState_Hurt
	ret	z				;return if the player is hurt
	
_:	call	Player_CollideRightWithSolidBlock	;spikes act like a solid block
	call	LABEL_6938
	
	ld	a, (Cllsn_MetatileIndex)		;get the block type
	cp	$F4			;check for a collision with left-facing spikes
	ret	nz				;return if not block type $F4
	jp	Player_CollideSpikeBlock_PlayerHurt


;****************************************************************
;*	Handle a collision between the player's left edge	*
;*	and a spike block that points either up or down.	*
;****************************************************************
Player_CollideLeftWithSpikeBlock:		;$728A
	ld	a, (Cllsn_MetatileIndex)		;get the block type
	and	$FE
	cp	$F2
	jr	z, +_
	;check to see if the player is riding the mine cart.
	;the spike blocks act as breakable blocks if the
	;collision occurred while riding the minecart.
	ld	a, ($D502)		;current player state
	cp	PlayerState_InMineCart
	jp	z, Player_CollideLeftBreakableBlock
	
	cp	PlayerState_Hurt
	ret	z				;return if player is hurt

_:	call	Player_CollideLeftSolidBlock	;spikes act like a solid block
	call	LABEL_6938

	ld	a, (Cllsn_MetatileIndex)		;get the block type
	cp	$F5			;check for a collision with right-facing spikes
	ret	nz				;return if not block type $F5

;****************************************************
;*	Player collided with spikes - cause damage. *
;****************************************************
Player_CollideSpikeBlock_PlayerHurt:	;$72AA
	bit	7, (ix+$03)
	ret	nz
	ld	hl, $0100
	ld	($D518), hl
	jp	Player_SetState_Hurt


;********************************************************
;*	Tests for a collision on between the top of the *
;*	player object and a level block.		*
;********************************************************
Player_CheckTopLevelCollision:			;$72B8
	bit	1, (ix+$22)
	ret	nz
	res	0, (ix+$22)
	
	ld	bc, $0000		;check for collision at top edge
	ld	de, -24			;of player object
	call	Engine_GetCollisionDataForBlock
	
	ld	a, (Cllsn_MetaTileSurfaceType)		;get block type
	cp	$81		;solid block
	jr	z, Player_CollideTopSolidBlock
	cp	$8D		;breakable block
	jp	z, Player_CollideBreakableBlock_UpdateMappings
	cp	$15		;vertical spring on ceiling
	jr	z, Player_CollideTopVerticalSpring
	cp	$13		;SEZ/ALZ pipes
	jp	z, Player_CollideVerticalWithPipeBlock
	cp	$05		;spike block
	jr	z, Player_CollideTopWithSpikeBlock
	ret	


;****************************************************************
;*	Handle a collision with a solid block at the top-edge	*
;*	of the player object.					*
;****************************************************************
Player_CollideTopSolidBlock:	;$72E6
	ld	a, (Cllsn_AdjustedY)		;adjusted vertical pos
	and	$1F				;get offset on block
	ld	c, a			;c = vert pos on block
	ld	a, (Cllsn_CollisionValueX)		;get block's vert. heightmap
	ld	b, a
	and	$3F
	ret	z
	
	cp	$20
	jr	z, +_

	bit	6, b
	ret	nz

_:	cp	c
	ret	c
	sub	c
	ld	c, a
	ld	b, $00
	ld	l, (ix+$14)		;get sprite's vpos
	ld	h, (ix+$15)
	add	hl, bc			;calculate the new vpos
	ld	(ix+$14), l
	ld	(ix+$15), h
	
	set	0, (ix+$22)		;flag collision at top edge
	call	LABEL_6938

LABEL_7314:
	ld	hl, $0100
	ld	($D518), hl
	ret	


;****************************************************************
;*	Handle a collision with a downward-facing spring at the *
;*	top edge of the player object.				*
;****************************************************************
Player_CollideTopVerticalSpring:	;$731B
	ld	hl, $0780
	ld	($D518), hl	;set player vertical speed
	jp	Player_SetState_JumpFromRamp


;****************************************************************
;*	Handle a collision between the top of the player	*
;*	object and a spike block.				*
;****************************************************************
Player_CollideTopWithSpikeBlock:		;$7329
	ld	a, (Cllsn_AdjustedY)		;get lo-byte of adjusted vert pos
	and	$1F
	ld	c, a			;c = object position on block
	
	ld	a, (Cllsn_CollisionValueX)		;a = vertical collision value
	ld	b, a			;b = vertical collision value
	and	$3F
	ret	z
	
	cp	$20
	jr	z, +_
	bit	6, b
	ret	z
_:	cp	c
	ret	c				;return if a < c (player not colliding with block)
	sub	c				;calculate number of pixels to move player
	ld	c, a			;BC = projection value
	ld	b, $00
	ld	l, (ix+$14)
	ld	h, (ix+$15)
	add	hl, bc
	ld	(ix+$14), l	;move the player out of the collision
	ld	(ix+$15), h
	
	set	0, (ix+$22)	;flag a collision at the top of the player
	call	LABEL_6938

	ld	a, (ix+$01)	;return if the player is hurt
	cp	PlayerState_Hurt
	ret	z

	ld	a, (Cllsn_MetatileIndex)		;get current block number
	and	$FE			;check to see if the block was one of the
	cp	$F4			;wall spikes (mappings 244 & 245)
	jr	z, LABEL_7314
	bit	7, (ix+$03)	;check to see if player is invincible
	ret	nz
	jp	Player_SetState_Hurt


;****************************************************************
;*	Handle a vertical collision with a pipe block (e.g.	*
;*	ALZ2 or SEZ)						*
;****************************************************************
Player_CollideVerticalWithPipeBlock:		;$736F
	ld	a, (Cllsn_MetatileIndex)		;copy current block value
	ld	($D367), a		;here
	jp	Player_EnterPipe


LABEL_7378:
	ld	bc, $0000
	ld	de, -26
	bit	0, (ix+$07)
	jr	z, +_
	ld	de, -16
_:	ld	a, ($D465)			;copy the previous collision value.
	ld	($D466), a
	call	Engine_GetCollisionValueForBlock	;collide with background tiles
	ld	($D465), a			;store block collision value here
	cp	$07				;was the collision with a block of rings?
	jr	z, Player_CollideWithRingBlock
	jp	Player_ALZ_WaterBounce


;****************************************************************
;*	Handles a player-ring block collision. Increments	*
;*	the ring counter and updates the level layout to	*
;*	remove the ring.					*
;****************************************************************
Player_CollideWithRingBlock:			;$739A
	; swap in the bank with the metatiles
	ld	a, (LevelAttributes.MetaTileBank)
	call	Engine_SwapFrame2
	
	ld	a, (Cllsn_MetatileIndex)			;get the block number
	
	; calculate & store a zero-based block index
	; i.e. subtract 112 (ring mappings start at index 112).
	sub	$70				
	ld	(Cllsn_RingBlock), a 
	
	ld	l, a
	ld	h, $04
	mlt	hl
	ld	de, Data_RingCollision_MetaTiles
	add	hl, de
	ld	a, (Cllsn_AdjustedX)			;get lo-byte of adjusted hpos
	rrca	
	rrca	
	rrca	
	rrca	
	and	$01
	ld	c, a
	ld	b, $00
	add	hl, bc
	ld	a, (Cllsn_AdjustedY)			;get lo-byte of adjusted vpos
	rrca	
	rrca	
	rrca	
	and	$02
	ld	e, a
	ld	d, $00
	add	hl, de
	ld	a, (hl)
	or	a
	ret	z
	ex	de, hl
	add	hl, bc
	ex	de, hl
	ld	bc, $0020
	add	hl, bc
	ld	a, (hl)
	ld	hl, (Cllsn_LevelMapBlockPtr)		;get address of the 32x32 block
	ld	(hl), a			;and change it
	ld	l, a
	ld	h, $00
	add	hl, hl
	ld	a, ($D164)			;get pointer to mappings into BC
	ld	c, a
	ld	a, ($D165)
	ld	b, a
	add	hl, bc
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	Engine_UpdateMappingBlock
	ld	hl, (Cllsn_AdjustedX)		;store copy of adjusted hpos
	ld	($D35A), hl
	ld	hl, (Cllsn_AdjustedY)		;store copy of adjusted vpos
	ld	($D35C), hl
	ld	c, Object_RingSparkle	;display a ring "sparkle"
	ld	h, $00
	call	Engine_AllocateObjectHighPriority
	jp	IncrementRingCounter


; Mapping indices used by the above routine to
; remove "collected" rings from the level layout
Data_RingCollision_MetaTiles:	; $7407
.db $FF, $FF, $00, $00
.db $00, $00, $FF, $FF
.db $FF, $00, $00, $FF
.db $00, $FF, $FF, $00
.db $FF, $00, $00, $00
.db $00, $FF, $00, $00
.db $00, $00, $FF, $00
.db $00, $00, $00, $FF
.db $75, $74, $FE, $FE
.db $FE, $FE, $77, $76
.db $77, $FE, $FE, $74
.db $FE, $76, $75, $FE
.db $FE, $FE, $FE, $FE
.db $FE, $FE, $FE, $FE
.db $FE, $FE, $FE, $FE
.db $FE, $FE, $FE, $FE



; =============================================================================
;	Player_ALZ_WaterBounce()
; -----------------------------------------------------------------------------
;	Logic that causes the player object to bounce when rolling & colliding
;	with a water metatile.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Player_ALZ_WaterBounce:	;$7447
	; check that the current level is ALZ
	ld	a, (CurrentLevel)
	cp	Level_ALZ
	ret	nz
	
	; check to see if the player is colliding with 
	; a water metatile
	ld	a, (Cllsn_MetatileIndex)
	or	1
	cp	$8F
	ret	nz
	
	ld	a, ($D466)
	cp	$06
	ret	z

	; check to see if the player is moving up or down
	ld	a, (Player.VelY + 1)
	bit	7, a					; FIXME: might be more efficient to use	OR A; jr M +
	jr	nz, +_		
	
	; the player is moving down - create a "splash" object
	ld	c, Object_WaterSplash
	ld	h, 0
	call	Engine_AllocateObjectHighPriority	;find an open object slot
	
_:	; check to see if the player is rolling and return if they aren't
	bit	1, (ix + Object.Flags03)
	ret	z

	; check to see if the player is moving left or right
	ld	a, (Player.VelX + 1)
	bit	7, a					; FIXME: might be more efficient to use OR A; jr P +
	jr	z, +_
	
	neg	

_:	; return if the player is not moving fast enough
	cp	3
	ret	c

	; set the vertical velocity so that sonic bounces off of the water
	ld	hl, $FD00			
	ld	(Player.VelY), hl
	ret	


; =============================================================================
; Engine_GetCollisionDataForBlock(uint16 object_ptr, int16 x_adj, int16 y_adj)
; -----------------------------------------------------------------------------
;	Fetches collision data for the metatile that the specified object is
;	colliding with.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to the object descriptor.
;	BC	- Horizontal position offset.
;	DE	- Vertical position offset.
;	ld:
;	($D353) - Metatile number.
;	($D354) - Pointer to metatile within level data.
;	($D356) - Adjusted x coordinate.
;	($D358) - Adjusted y coordinate.
;	($D35E) - Metatile surface type.
;	($D35F) - 3rd pointer in metatile collision header.
;	($D361) - Vertical collision value.
;	(Cllsn_CollisionValueX) - Horizontal collision value.
; -----------------------------------------------------------------------------
Engine_GetCollisionDataForBlock:		;$7481		
	; get object's x coordinate
	ld	h, (ix + Object.X + 1)
	ld	l, (ix + Object.X)
	; adjust the x coordinate
	add	hl, bc
	; store the adjusted position
	ld	(Cllsn_AdjustedX), hl
	
	; shift the coordinate word left 3 places so that the
	; metatile index is held in the upper byte
	sla	l	;hl *= 2
	rl	h
	sla	l	;hl *= 2
	rl	h
	sla	l	;hl *= 2
	rl	h
	; store the metatile X index in the B register
	ld	b, h
	
	; get the object's Y coordinate
	ld	h, (ix + Object.Y + 1)
	ld	l, (ix + Object.Y)
	; adjust the Y coordinate
	add	hl, de
	ld	de, $0012
	add	hl, de
	; store the adjusted coordinate
	ld	(Cllsn_AdjustedY), hl
	
	; shift the coordinate word left 3 places so that the
	; metatile index is held in the upper byte
	sla	l
	rl	h
	sla	l
	rl	h
	sla	l
	rl	h
	; store the metatile Y index in the A register
	ld	a, h
	
	; use the metatile Y index as an index into the level width
	; stride table
	add	a, a
	ld	l, a
	ld	h, $00
	ld	de, (LevelAttributes.StrideTable)
	add	hl, de
	; fetch the row offset from the stride table
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	; adjust the offset to the correct X index
	ld	l, b
	ld	h, $00
	add	hl, de
	; add the offset to the level data base pointer
	ld	de, $C001
	add	hl, de
	
	; make sure we don't overflow the level data bounds
	ld	a, h
	and	$F0
	cp	$C0
	jp	nz, Engine_GetCollisionData_HandleOverflow
	
	
	; HL now contains a pointer to the metatile index within the level data array.
	; store the pointer
	ld	(Cllsn_LevelMapBlockPtr), hl
	; fetch the metatile index value from the level data and store 
	ld	a, (hl)
	ld	(Cllsn_MetatileIndex), a
	
	; fetch a pointer to the metatile's collision header data.
	; add the metatile number to the collision header base pointer
	ld	l, a
	ld	h, $00
	add	hl, hl
	ld	de, (Engine_CollisionDataPtr)
	add	hl, de	  
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ex	de, hl
	
	; HL now contains the pointer to the metatile's collision header data.
	; fetch and store the surface type
	ld	a, (hl)
	ld	(Cllsn_MetaTileSurfaceType), a
	
	; TODO: what is $D100?
	inc	hl
	ld	a, (hl)
	ld	($D100), a
	
	; fetch the pointer to the horizontal collision data
	inc	hl
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	
	; keep the metatile collision header pointer in DE
	ex	de, hl
	
	; calculate the object's horizontal position in the metatile
	ld	a, (Cllsn_AdjustedX)
	; extract the lower 5 bits (tile & pixel offset)
	and	$1F
	ld	l, a
	ld	h, $00
	; add the value to the collision data pointer
	add	hl, bc
	; fetch the collision value and store
	ld	a, (hl)
	ld	(Cllsn_CollisionValueX), a
	
	; move the collision header pointer back into HL
	ex	de, hl
	; get a pointer to the vertical collision data
	inc	hl
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	
	; keep the header pointer in DE
	ex	de, hl
	
	; calculate the object's vertical position within the metatile
	ld	a, (Cllsn_AdjustedY)
	; extract the lower 5 bits (tile & pixel offset)
	and	$1F
	ld	l, a
	ld	h, $00
	; offset into the vertical collision data
	add	hl, bc
	; fetch and store the collision value
	ld	a, (hl)
	ld	(Cllsn_CollisionValueY), a
	ret

; =============================================================================
; Engine_GetCollisionValueForBlock(uint16 object_ptr, int16 x_adj, int16 y_adj)
; -----------------------------------------------------------------------------
;	Fetches collision data for the metatile that the specified object is
;	colliding with.
; -----------------------------------------------------------------------------
;	In:
;	IX	- Pointer to the object descriptor.
;	BC	- Horizontal position offset.
;	DE	- Vertical position offset.
;	ld:
;	($D353) - Metatile number.
;	($D354) - Pointer to metatile within level data.
;	($D356) - Adjusted x coordinate.
;	($D358) - Adjusted y coordinate.
;	($D35E) - Metatile surface type.
; -----------------------------------------------------------------------------
Engine_GetCollisionValueForBlock:		;$752E
	; get object's x coordinate
	ld	h, (ix + Object.X + 1)
	ld	l, (ix + Object.X)
	; adjust the x coordinate
	add	hl, bc
	; store the adjusted position
	ld	(Cllsn_AdjustedX), hl
	
	; shift the coordinate word left 3 places so that the
	; metatile index is held in the upper byte
	sla	l
	rl	h
	sla	l
	rl	h
	sla	l
	rl	h
	; store the metatile X index in the B register
	ld	b, h
	
	; get the object's Y coordinate
	ld	h, (ix + Object.Y + 1)
	ld	l, (ix + Object.Y)
	; adjust the Y coordinate
	add	hl, de
	ld	de, $0012
	add	hl, de
	; store the adjusted coordinate
	ld	(Cllsn_AdjustedY), hl
	
	; shift the coordinate word left 3 places so that the
	; metatile index is held in the upper byte
	sla	l
	rl	h
	sla	l
	rl	h
	sla	l
	rl	h
	; store the metatile Y index in the A register
	ld	a, h
	
	; use the metatile Y index as an index into the level width
	; stride table
	add	a, a
	ld	l, a
	ld	h, $00
	ld	de, (LevelAttributes.StrideTable)
	add	hl, de
	; fetch the row offset from the stride table
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	; adjust the offset to the correct X index
	ld	l, b
	ld	h, $00
	add	hl, de
	; add the offset to the level data base pointer
	ld	de, LevelLayout
	add	hl, de
	
	; make sure we don't overflow the level data bounds
	ld	a, h
	and	$F0
	cp	$C0
	jp	nz, Engine_GetCollisionData_HandleOverflow
	
	; HL now contains a pointer to the metatile index within the level data array.
	; store the pointer
	ld	(Cllsn_LevelMapBlockPtr), hl
	; fetch the metatile index value from the level data and store 
	ld	a, (hl)
	ld	(Cllsn_MetatileIndex), a
	
	; fetch a pointer to the metatile's collision header data.
	; add the metatile number to the collision header base pointer
	ld	l, a
	ld	h, $00
	add	hl, hl
	ld	de, (Engine_CollisionDataPtr)
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	
	; DE now contains the pointer to the metatile's collision header data.
	; fetch and store the surface type
	ld	a, (de)
	ld	(Cllsn_MetaTileSurfaceType), a
	; FALL THROUGH

Engine_GetCollisionData_CleanUp:			;$759F
	ld	a, (Cllsn_MetaTileSurfaceType)		;restore block type to A
	ret	

Engine_GetCollisionData_HandleOverflow:	;$75AA
	ld	hl, $CFFF	;store as address of block
	ld	(Cllsn_LevelMapBlockPtr), hl
	ld	a, $FF			;store as value of block
	ld	(Cllsn_MetatileIndex), a
	xor	a
	ld	(Cllsn_MetaTileSurfaceType), a
	ld	(Cllsn_CollisionValueY), a
	ld	(Cllsn_CollisionValueX), a		;store vertical collision value
	jr	Engine_GetCollisionData_CleanUp

;--------------------------------------------

;gets called when player is hurt
LABEL_75C5:
	; reset the "bottom collision" flag
	res	OBJ_COL_BOTTOM, (ix + Object.BgColFlags)
	
	; get the collision data for the metatile at the 
	; object's origin
	ld	bc, $0000
	ld	de, $0000
	call	Engine_GetCollisionDataForBlock	;collide with level tiles
	
	;FIXME: this routine expects A to contain the mapping number but
	;Engine_GetCollisionDataForBlock returns the current bank number 
	;in the A register. Is this a bug or deliberate?
	call	LABEL_708D
	
	; fetch the metatile surface type
	ld	a, (Cllsn_MetaTileSurfaceType)
	and	$7F
	or	a
	ret	nz

LABEL_7614:
	; dont change anything if the object is floating in the air
	bit	OBJ_F3_IN_AIR, (ix + Object.Flags03)
	ret	nz
	
	set	OBJ_F3_BIT4, (ix + Object.Flags03)
	ret	


LABEL_761E:	;seems to be unused
	; dont update anything if there is no collision
	; at the object's bottom edge
	bit	OBJ_COL_BOTTOM, (ix + Object.BgColFlags)
	ret	z
	
	ld	hl, -256
	
	; get the	metatile number
	ld	a, (Cllsn_MetatileIndex)
	
	; is this metatile a conveyor belt block?
	cp	$F0 
	jr	z, +_

	; the block is not a conveyor belt. load HL with +256
	ld	hl, 256

_:	; adjust the object's X coordinate
	ld	e, (ix + Object.X)
	ld	d, (ix + Object.X + 1)
	add	hl, de
	ld	(ix + Object.X), l
	ld	(ix + Object.X + 1), h
	ret

; =============================================================================
;	Engine_LoadLevelTiles()
; -----------------------------------------------------------------------------
;	Parse the level/act's tileset header entries and decompress the tilesets
;	into VRAM.
; -----------------------------------------------------------------------------
;	In:
;	(CurrentLevel)
;	(CurrentAct)
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_LoadLevelTiles:		;$763F
	di
	; clear any existing tile data out of VRAM
	call	Engine_ClearVRAM
	
	; use the level/act number to calculate an offset into the
	; array of tileset headers
	ld	a, (CurrentLevel)
	ld	c, a
	add	a, a
	add	a, c
	ld	c, a
	ld	a, (CurrentAct)
	add	a, c
	ld	l, a
	ld	h, $07
	mlt	hl
	ld	de, LevelTilesets
	add	hl, de
	push	hl
	pop	iy
	
	; IY now contains a pointer to the level's tileset header chain.
	
	; bank number
	ld	a, (iy + 0)
	call	Engine_SwapFrame2
	
	; set the vram address pointer
	ld	l, (iy + 1)
	ld	h, (iy + 2)
	call	VDP_SetAddress
	
	; read the tile source pointer and copy to vram
	ld	l, (iy + 3)
	ld	h, (iy + 4)
	xor	a
	call	LoadTiles

	; read the tileset header chain pointer into IY
	ld	l, (iy + 5)
	ld	h, (iy + 6)
	push	hl
	pop	iy
	

	; iterate over the tileset header entries and load
	; the data into VRAM
	
_:	; check for the end-of-chain marker
	ld	a, (iy + 0)
	cp	$FF
	ret	z
	
	; swap in the bank number. We're not interested in the
	; MSB yet so AND it out.
	and	LastBankNumber
	call	Engine_SwapFrame2

	; read the vram destination address and set the VDP's 
	; address pointer accordingly.
	ld	l, (iy + 1)
	ld	h, (iy + 2)
	di
	call	VDP_SetAddress
	
	; read the source data pointer.
	ld	l, (iy + 3)
	ld	h, (iy + 4)
	
	; read the MSB from the "bank number" field. if the MSB is
	; set then the tiles will be flipped horizontally
	ld	a, (iy + 0)
	and	$80
	
	; decompress the tiles into VRAM	
	call	LoadTiles
	
	; move to the next tileset header entry
	lea	iy, iy+5
	jr	-_


; =============================================================================
;	Engine_LoadLevelPalette()
; -----------------------------------------------------------------------------
;	Fetches the level's fg/bg palette indices and flags for a fade-in.
; -----------------------------------------------------------------------------
;	In:
;	(CurrentLevel)
;	(CurrentAct)
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_LoadLevelPalette:		;$76AD
	ld	a, (CurrentLevel)
	ld	b, a
	add	a, a
	add	a, b
	ld	b, a
	ld	a, (CurrentAct)
	add	a, b
	ld	l, a
	ld	h, $00
	add	hl, hl
	ld	de, LevelPaletteValues
	add	hl, de
	
	; read the BG palette index
	ld	a, (hl)
	ld	(BgPaletteIndex), a
	inc	hl
	
	; read the FG palette index
	ld	a, (hl)
	ld	(FgPaletteIndex), a
	
	; flag both palettes to fade in
	ld	hl, BgPaletteControl
	ld	(hl), $00
	set	7, (hl)
	inc	hl
	inc	hl
	ld	(hl), $00
	set	7, (hl)
	ret


; =============================================================================
;	LevelSelect_LoadFont()
; -----------------------------------------------------------------------------
;	Decompresses the level select font into VRAM.
;	NOTE: This routine disables interrupts and DOES NOT reenable them.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
LevelSelect_LoadFont:		; $76D7
	di
	; Page in the bank containing the font
	ld	a, $09
	call	Engine_SwapFrame2	
	
	; set the VRAM address pointer to $2400
	ld	hl, $2400					
	call	VDP_SetAddress
	
	; decompress the tiles
	ld	hl, Art_LevelSelect_Font
	xor	a
	call	LoadTiles
	ei
	ret

TitleCard_LoadTiles:		;76EB
	di
	ld	a, $09
	call	Engine_SwapFrame2	

	ld	hl, $2000		;set up to write to VRAM at $2000
	call	VDP_SetAddress
	ld	hl, Art_TitleCard_Text_Tiles
	xor	a
	call	LoadTiles

	ld	hl, $3020		;set up to write to VRAM at $3020
	call	VDP_SetAddress
	ld	hl, Art_TitleCard_Unknown
	xor	a
	call	LoadTiles

	ld	hl, $30C0		;set up to write to VRAM at $30C0
	call	VDP_SetAddress
	ld	hl, Art_TitleCard_Unknown2
	xor	a
	call	LoadTiles

	ld	a, $07
	call	Engine_SwapFrame2	


	ld	hl, $1000
	call	VDP_SetAddress
	ld	hl, Art_Scrolling_Text_Background
	xor	a
	call	LoadTiles
	ld	a, (GlobalTriggers)		;check to see if we need to display the score card
	bit	2, a
	jp	z, ScoreCard_LoadMappings

	ld	a, 25
	call	Engine_SwapFrame2	

	ld	hl, $0000
	call	VDP_SetAddress
	ld	a, (CurrentLevel)		;which level do we need the picture for?
	ld	l, a				;calcuate the offset into the pointer array
	ld	h, $04
	mlt	hl
	ld	de, TitleCard_PicturePointers
	add	hl, de
	ld	e, (hl)				;get the pointer to the mappings
	inc	hl
	ld	d, (hl)
	push	de
	inc	hl				;get the pointer to the tiles
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ex	de, hl
	xor	a
	call	LoadTiles		;load the tiles into VRAM
	pop	de			;load the mappings into VRAM
	ld	bc, $0810
	ld	hl, $3B90
	; FIXME: use tail recursion here.
	jp	Engine_LoadCardMappings


TitleCard_PicturePointers:
_DATA_7761:
;	Mappings
;		|	Tiles
;	|------|-----|
;.dw $B806, $8000
;.dw $B906, $89A0
;.dw $BA06, $9410
;.dw $BB06, $9DC0
;.dw $BC06, $A446
;.dw $BD06, $AC26
;.dw $BE06, $B0A6

.dw UGZ_Title_Pic_Mappings, UGZ_Title_Pic_Art
.dw SHZ_Title_Pic_Mappings, SHZ_Title_Pic_Art
.dw ALZ_Title_Pic_Mappings, ALZ_Title_Pic_Art
.dw GHZ_Title_Pic_Mappings, GHZ_Title_Pic_Art
.dw GMZ_Title_Pic_Mappings, GMZ_Title_Pic_Art
.dw SEZ_Title_Pic_Mappings, SEZ_Title_Pic_Art
.dw CEZ_Title_Pic_Mappings, CEZ_Title_Pic_Art

GameOverScreen_LoadTiles:	;777D
	di

	ld	a, 15	;switch to bank 15.
	call	Engine_SwapFrame2	

	ld	hl, $2000					;write to VRAM at $2000
	call	VDP_SetAddress
	ld	hl, GameOverScreen_Data_GameOverTiles
	xor	a
	; FIXME: use tail recursion here.
	jp	LoadTiles					;load the art

;Used by end of game sequence?
ContinueScreen_LoadTiles:	;7791
	di
	ld	a, 15
	call	Engine_SwapFrame2	

	ld	hl, $2000
	call	VDP_SetAddress
	ld	hl, ContinueScreen_Data_ContinueTiles
	xor	a
	; FIXME: use tail recursion here.
	jp	LoadTiles

ContinueScreen_LoadNumberTiles:	;77A5
	di

	ld	a, 15
	call	Engine_SwapFrame2

	ld	hl, $2240
	call	VDP_SetAddress
	ld	hl, ContinueScreen_Data_NumberTiles
	xor	a
	; FIXME: use tail recursion here.
	jp	LoadTiles

ScoreCard_LoadMappings:	;77B9
	ld	hl, $3B90
	ld	de, DATA_2D98
	ld	bc, $0205
	call	Engine_LoadCardMappings

	ld	hl, $3C10
	ld	de, DATA_2DAC
	ld	bc, $0205
	call	Engine_LoadCardMappings

	ld	hl, $3C90
	ld	de, DATA_2DC0
	ld	bc, $0205
	call	Engine_LoadCardMappings

	ld	hl, $3BA8
	ld	de, DATA_2DD4
	ld	bc, $0604
	call	Engine_LoadCardMappings
	call	LABEL_1D4F
	call	LABEL_1D60
	; FIXME: use tail recursion here.
	jp	LABEL_1D6F

; =============================================================================
;	Engine_ClearVRAM()
; -----------------------------------------------------------------------------
;	Clears the contents of VRAM to zero.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_ClearVRAM:		; $77F3
	di
	
	; turn the display off
	call	VDP_SetMode2Reg_DisplayOff
	
	; prep the counter
	ld.lil	hl, VRAM
	ld.lil	de, VRAM+1
	ld.lil	bc, VRAMEnd-VRAM
	ld.lil	(hl), $00
	ldir.lil
	
	;clear the tile cache
	ld.lil	hl, SegaTileCache
	ld.lil	de, SegaTileCache+1
	ld	bc, $3FFF
	ld.lil	(hl), $00
	ldir.lil

	; turn the display on
	jp	VDP_SetMode2Reg_DisplayOn

; =============================================================================
;	Engine_ClearPaletteRAM()
; -----------------------------------------------------------------------------
;	Clears the contents of colour memory to zero.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_ClearPaletteRAM:	; $782D
	di
	;write to CRAM at address $E30200
	ld.lil	hl, CRAM
	ld.lil	de, CRAM+1
	;write $0 to VRAM
	ld.lil	(hl), $00
	;loop 32 times
	ld	bc, $0020
	ldir.lil
	ret


;/**************************************************************************
;			START OF PLC HANDLER CODE
;***************************************************************************/
#define PatternLoadCue	$D3AB	;PLC index
#define PLC_BankNumber	$D3AC	;Bank number to load tile data from
#define PLC_ByteCount	$D3AD	;Number of bytes to copy
#define PLC_SourceAddr	$D3AE	;Source ROM address (in bank 2 - i.e. >$8000)
#define PLC_VRAMAddr	$D3B0	;Destination VRAM address
#define PLC_Descriptor	$D3B2	;pointer to current PLC descriptor


Engine_HandlePLC:		;$783B
	ld	a, (PatternLoadCue)
	or	a
	ret	z						;return if the PLC is zero

	ld	a, (PLC_BankNumber)				;jump if the bank is zero (load boss,
	or	a						;chaos emeralds or monitors).
	call	z, Engine_HandlePLC_NoBank

	ld	a, (PatternLoadCue)				;the PLC NoBank handler may have changed
	or	a						;the PatternLoadCue variable so we need to
	ret	z						;check it again.

	ld	a, (PLC_ByteCount)				;if byte count is zero load from a PLC
	or	a						;descriptor (address of which stored at $D3B2)
	call	z, Engine_HandlePLC_ParseDescriptor

	di						;no interrupts - we're accessing VRAM here
	ld	a, (PLC_BankNumber)			;if the msb of the bank number is set we 
	bit	7, a					;need to mirror the tile horizontally
	jr	nz, Engine_HandlePLC_CopyMirrored


	call	Engine_SwapFrame2		;swap the correct bank into page 2
	ld	de, (PLC_VRAMAddr)
	ld.lil	hl, SegaVRAM
	add.lil	hl, de
	ex.lil	de, hl

	ld	hl, (PLC_SourceAddr)
	ld.lil	bc, romStart
	add.lil	hl, bc

	ld	a, (PLC_ByteCount)		;check for >0 bytes
	or	a
	jp	z, Engine_HandlePLC_CleanUp ;bail out if nothing to do

	cp	$04
	jr	c, +_
	ld	a, $04					;copy 4 bitplanes
_:	ld	b, a
	ld	c, $20					;do this 32 times
	mlt	bc
	ldir.lil
	;FALL THROUGH

LABEL_7881:
	ei
	ld	(PLC_SourceAddr), hl	;hl points to next tile. Store as new SourceAddr.
	ld	hl, (PLC_VRAMAddr)
	ld	bc, $0080
	add	hl, bc					;calculate offset of next tile in VRAM...
	ld	(PLC_VRAMAddr), hl		;...and store as new VRAMAddr

	ld	a, (PLC_ByteCount)
	sub	$04
	ld	(PLC_ByteCount), a		;subtract 4 bytes from ByteCount
	ret	nc						;return if >= 0

	xor	a
	ld	(PLC_ByteCount), a		;reset ByteCount to 0
	ret

;takes the tile data and, in effect "flips" it horizontally
;on the fly to create a mirrored sprite
Engine_HandlePLC_CopyMirrored:		;$789D
	and	LastBankNumber			;cap bank number
	call	Engine_SwapFrame2

	ld	hl, (PLC_SourceAddr)

	ld	a, (PLC_ByteCount)		;make sure that bytecount > 0
	or	a
	jr	z, Engine_HandlePLC_CleanUp

	cp	$04			;loop a minimum of 4 times
	jr	c, +_
	ld	a, $04

_:	push	ix
	ld	ix, (PLC_VRAMAddr)	;IX is now the VRAM pointer
	ld.lil	bc, SegaVRAM
	add.lil	ix, bc
	
	ld	b, a			;b = number of tiles to copy
	;set up to load data from $100 onwards
	ld	d, $01

_:	ld	c, $20			;loop 32 times (copy one tile)
	
_:	ld	e, (hl)			;get the index stored at HL
	ld	a, (de)			;index into data at $100
	ld.lil	(ix), a			;copy value to VRAM
	inc	hl			;move to next index address
	inc.lil	ix
	dec	c
	jr	nz, -_			;copy next byte
	djnz	--_			;copy next tile

	pop	ix
	jp	LABEL_7881
	
;load monitor, chaos emerald or boss tiles
Engine_HandlePLC_NoBank:	;$78CA
	ld	a, (PatternLoadCue)

	cp	$10			;if PLC < 10, load monitor art
	jp	c, Engine_HandlePLC_MonitorArt

	cp	$20			;if PLC >= 20, load chaos emerald
	jp	nc, Engine_HandlePLC_ChaosEmerald

	sub	$10			;PLC between 0 and $10
	ld	l, a
	ld	h, $00
	add	hl, hl			;load end-of-level art (boss/signpost)
	ld	de, PLC_EndOfLevelPatterns
	add	hl, de
	ld	e, (hl)			;get a pointer to the pattern descriptor
	inc	hl
	ld	d, (hl)
	ld	(PLC_Descriptor), de
	;FALL THROUGH

;parse a PLC descriptor and set the variables in RAM
Engine_HandlePLC_ParseDescriptor:	;$78EB
	ld	hl, (PLC_Descriptor)
	ld	a, (hl)				;check for the $FF terminator byte
	cp	$FF
	jr	z, Engine_HandlePLC_CleanUp

	ld	(PLC_BankNumber), a	;Store bank number
	inc	hl
	ld	a, (hl)
	ld	(PLC_ByteCount), a	;store the byte count
	inc	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	(PLC_VRAMAddr), de	;destination VRAM address
	inc	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	(PLC_SourceAddr), de	;source address
	inc	hl
	ld	(PLC_Descriptor), hl	;store pointer to next descriptor in chain
	ret	

Engine_HandlePLC_CleanUp:		;$7910
	xor	a
	ld	(PatternLoadCue), a
	ld	($D3AC), a
	ld	(PLC_ByteCount), a
	ld	hl, $0000
	ld	(PLC_VRAMAddr), hl
	ld	(PLC_SourceAddr), hl
	ret	

;PLC descriptor chains for end-of-level events
PLC_EndOfLevelPatterns:	;$7924
.dw PLC_EOL_PrisonCapsule			; $3A, $79	;End of boss level part1
.dw PLC_EOL_PrisonCapsuleAnimals		; $41, $79	;End of boss level part2
.dw PLC_EOL_SignPost				; $48, $79	;End-of-level signpost
.dw PLC_EOL_GMZ_Boss				; $4F, $79	;GMZ Boss
.dw PLC_EOL_SHZ_Boss				; $5C, $79	;SHZ Boss
.dw PLC_EOL_ALZ_Boss				; $63, $79	;ALZ Boss
.dw PLC_EOL_GHZ_Boss				; $70, $79	;GHZ boss
.dw PLC_EOL_UGZ_Boss				; $77, $79	;UGZ boss
.dw PLC_EOL_SEZ_Boss				; $7E, $79
.dw PLC_EOL_Unknown_2				; $8B, $79
.dw PLC_EOL_Unknown_3				; $8C, $79


;	Bank	VRAM Address		Terminator
;	| Count	|	ROM Addr.	|
;	|----|----|---------|---------|----|
;	$aa, $bb, $cc, $cc, $dd, $dd, $FF

PLC_EOL_PrisonCapsule:
.db 07
	.db $46
	.dw $0C40
	.dw Art_Prison_Capsule
.db $FF ;End of boss prison capsule

PLC_EOL_PrisonCapsuleAnimals:	;End of boss prison capsule animals
.db 07
	.db $30
	.dw $1500
	.dw Art_Animals
.db $FF

PLC_EOL_SignPost:		;End-of-level signpost
.db 07
	.db $64
	.dw $0C40
	.dw Art_Signpost
.db $FF

PLC_EOL_GMZ_Boss:
.db 26
	.db $4A
	.dw $0C40
	.dw Art_GMZ_Boss
.db 26 + $80			;mirror the tiles
	.db $4A
	.dw $1580
	.dw Art_GMZ_Boss
.db $FF ;$794A - GMZ Boss

PLC_EOL_SHZ_Boss:
.db 26
	.db $6E
	.dw $0C40
	.dw Art_SHZ_Boss	;$8940
.db $FF	;$795C - SHZ Boss

PLC_EOL_ALZ_Boss:
.db 26
	.db $4C
	.dw $0C40
	.dw Art_ALZ_Boss
.db 26 + $80	;mirror the tiles
	.db $4C
	.dw $15C0
	.dw Art_ALZ_Boss
.db $FF	;$7963 - ALZ Boss

PLC_EOL_GHZ_Boss:		;$7970 - GHZ Boss
.db 26
	.db $96
	.dw $0C40
	.dw Art_GHZ_Boss	;$A080
.db $FF

PLC_EOL_UGZ_Boss:		;$7977 - UGZ Boss
.db 20
	.db $6A
	.dw $0C40
	.dw Art_Boss_UGZ		;$A102
.db $FF

PLC_EOL_SEZ_Boss:
.db 07
	.db $44
	.dw $0C40
	.dw Art_SilverSonic
.db 07 + $80		;mirror the tiles
	.db $44
	.dw $14C0
	.dw Art_SilverSonic
.db $FF

PLC_EOL_Unknown_2:
.db $FF

PLC_EOL_Unknown_3:
.db 26
	.db $48
	.dw $0C40
	.dw Art_Tails	;$B48A
.db $FF


Engine_HandlePLC_ChaosEmerald:	;$7993
	di	;Disable interrupts - we're accessing VRAM

	ld	a, 20
	call	Engine_SwapFrame2		;swap in bank 20

	ld	a, (PatternLoadCue)	;subract $20 from PLC value and calculate
	sub	$20			;an offset into the pointer array
	ld	l, a
	ld	h, $00
	add	hl, hl
	ld	de, ChaosEmeraldData
	add	hl, de

	ld	e, (hl)				;get the source address
	inc	hl
	ld	d, (hl)
	ex	de, hl
	ld	de, $0A80				;VRAM address
	ld	bc, $0080				;byte count
	call	VDP_Copy

	ei	;enable interrupts
	jp	Engine_HandlePLC_CleanUp

#include "chaos_emerald_pointers.asm"


Engine_HandlePLC_MonitorArt:	;$79C7
	di	;Disable interrupts - we're accessing VRAM

	ld	a, 07	;swap in bank 7
	call	Engine_SwapFrame2

	ld	a, (PatternLoadCue)		;calculate an offset into the pointer array
	ld	l, a
	ld	h, $00
	add	hl, hl
	ld	de, Monitor_Art_Pointers-2
	add	hl, de
	
	ld	e, (hl)				;source address
	inc	hl
	ld	d, (hl)
	ex	de, hl
	ld	de, $0A80			;VRAM destination
	ld	bc, $00C0			;byte count
	call	VDP_Copy

	di	;enable interrupts
	jp	Engine_HandlePLC_CleanUp

Monitor_Art_Pointers:		;$79E9
.dw Art_Monitor_0
.dw Art_Monitor_1	; rings
.dw Art_Monitor_2
.dw Art_Monitor_3
.dw Art_Monitor_4
.dw Art_Monitor_5
.dw Art_Monitor_6
.dw Art_Monitor_7
.dw Art_Monitor_8


;/**************************************************************************
;	END	OF PLC HANDLER CODE
;***************************************************************************/


LevelTilesets:			;$79FB
#include "zone_tilesets.asm"



LevelPaletteValues:		;$7CAD
.db $0E, $09
.db $0E, $09
.db $0E, $09
;shz
.db $0F, $05
.db $10, $06
.db $0F, $05
;alz
.db $11, $07
.db $12, $08
.db $11, $07
;ghz
.db $13, $04
.db $13, $04
.db $13, $04

.db $14, $0A
.db $14, $0A
.db $14, $0A

.db $15, $0B
.db $15, $0B
.db $15, $0B

.db $16, $0C
.db $16, $0C
.db $17, $0D

.db $24, $25
.db $24, $25
.db $24, $25

.db $16, $0C
.db $16, $0C
.db $17, $0D

.db $1A, $18
.db $1B, $19
.db $1B, $19



Engine_UpdateCyclingPalettes:		;$7CE9
	;check to see if we have palettes that should cycle
	ld	a, (BgPaletteControl)
	or	a
	ret	nz
	ld	iy, Engine_DynPalette_0	;first cycling palette index
	ld	b, $02	;update 2 cycling palettes
_:	push	bc
	call	UpdateCyclingPaletteBank
	lea	iy, iy+8
	pop	bc
	djnz	-_
	ret

UpdateCyclingPaletteBank:		;$7D01
	ld	a, (iy)	;get palette index number
	ld	l, a
	ld	h, $00
	add	hl, hl
	ld	de, UpdateCyclingPalette_JumpVectors
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ex	de, hl
	jp	(hl)


;Jump vectors to code that updates a specific cycling palette
UpdateCyclingPalette_JumpVectors:
.dw UpdateCyclingPalette_DoNothing
.dw UpdateCyclingPalette_DoNothing2
.dw UpdateCyclingPalette_Rain			;SHZ2 rain palette
.dw UpdateCyclingPalette_SHZ_Lightning		;SHZ2 lightning
.dw UpdateCyclingPalette_Lava			;UGZ lava palette
.dw UpdateCyclingPalette_Water			;ALZ water palette
.dw UpdateCyclingPalette_Unknown2
.dw UpdateCyclingPalette_Conveyor		;GMZ conveyor & wheel palette
.dw UpdateCyclingPalette_Orb			;CEZ1 orb palette
.dw UpdateCyclingPalette_Lightning		;CEZ3 boss lightening palette
.dw UpdateCyclingPalette_Lightning2		;CEZ3 boss lightening palette
.dw UpdateCyclingPalette_WallLighting		;CEZ3 wall lighting
.dw UpdateCyclingPalette_Orb			;CEZ1 orb palette
.dw LABEL_7F46					;ending sequence
.dw LABEL_7F7E
.dw UpdateCyclingPalette_DoNothing

UpdateCyclingPalette_DoNothing:
	ret


; =============================================================================
;	Engine_ClearAuxLevelHeader()
; -----------------------------------------------------------------------------
;	Clears ring art dest pointer & dynamic palette numbers from the aux
;	level header memory.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_ClearAuxLevelHeader:		; $7D32
	 ; reset dynamic palette numbers
	 xor	a
	 ld	(Engine_DynPalette_0), a 
	 ld	(Engine_DynPalette_1), a
	 
	 ; clear ring art destination pointer
	 ld	hl, $0000
	 ld	(Engine_RingArt_Dest), hl
	 ret


UpdateCyclingPalette_DoNothing2:
	 ret

;Update the cycling palette for SHZ2's rain
UpdateCyclingPalette_Rain:		;$7D41
	 inc	(iy+$03)
	 ld	a, (iy+$03)
	 cp	$04
	 ret	c
	 ld	(iy+$03), $00
	 ld	a, (iy+$02)
	 inc	a
	 cp	$03
	 jr	c, +_
	 xor	a
_:	 ld	(iy+$02), a
	 add	a, a
	 add	a, (iy+$02)
	 ld	e, a
	 ld	d, $00
	 ld	hl, DATA_B30_AF4A
	 add	hl, de
	 ld	de, $D4CA
	 ld	bc, $0003
	 ldir
	 ld	a, $FF
	 ld	 (Palette_UpdateTrig), a
	 ret

;unknown palette. gets called in SHZ2
UpdateCyclingPalette_SHZ_Lightning:	;$7D73
	inc	(iy+$03)
	ld	a, (iy+$03)
	cp	$78
	ret	c
	inc	(iy+$02)
	ld	a, $3C
	ld	bc, $330F
	bit	1, (iy+$02)
	jr	nz, +_
	ld	a, $10
_:	ld	bc, $1010
	ld	hl, $D4D1
	ld	(hl),a
	ld	a, $FF
	ld	(Palette_UpdateTrig),a
	ld	a, (iy+$02)
	cp	$10
	ret	c
	ld	(iy+$03), $00
	ld	(iy+$02), $00
	ret

;Update the cycling palette for UGZ's lava
UpdateCyclingPalette_Lava:		;$7DA7
	inc	(iy+$03)
	ld	a, (iy+$03)
	cp	$08
	ret	c		;update every 8th frame
	ld	(iy+$03), $00
	ld	a, (iy+$02)
	inc	a
	cp	$03
	jr	c, +_
	xor	a		;reset counter
_:	ld	(iy+$02), a
	add	a, a
	add	a, (iy+$02)
	ld	e, a
	ld	d, $00
	ld	hl, DATA_B30_AF41
	add	hl, de
	ld	de, $D4D3	;update 3 colours in CRAM
	ld	bc, $0003
	ldir	
	ld	a, $FF
	ld	(Palette_UpdateTrig), a
	ret

;update the cycling palette for ALZ's water
UpdateCyclingPalette_Water:	;$7DD9
	inc	(iy+$03)
	ld	a, (iy+$03)
	cp	$08
	ret	c
	ld	(iy+$03), $00
	ld	a, (iy+$02)
	inc	a
	cp	$03
	jr	c, +_
	xor	a
_:	ld	(iy+$02), a
	add	a, a
	add	a, (iy+$02)
	ld	e, a
	ld	d, $00
	ld	hl, DATA_B30_AF53
	add	hl, de
	ld	de, $D4D3
	ld	bc, $0003
	ldir	
	ld	a, $FF
	ld	(Palette_UpdateTrig), a
	ret	

;Update the GMZ conveyor belt and wheel palette
UpdateCyclingPalette_Conveyor:		;$7E0B
	inc	(iy+$03)
	ld	a, (iy+$03)
	cp	$04
	ret	c
	ld	(iy+$03), $00
	ld	a, (iy+$02)
	inc	a
	cp	$03
	jr	c, +_
	xor	a
_:	ld	(iy+$02), a
	add	a, a
	add	a, (iy+$02)
	ld	e, a
	ld	d, $00
	ld	hl, Alt_Palette_GMZ_Conveyor
	add	hl, de
	ld	de, $D4D3
	ld	bc, $0003
	ldir
	ld	a, $FF
	ld	(Palette_UpdateTrig), a
	ret

UpdateCyclingPalette_Unknown2:		;$7E3D
	inc	(iy+$03)
	ld	a, (iy+$03)
	cp	$04
	ret	c
	ld	(iy+$03), $00
	ld	a, (iy+$02)
	inc	a
	cp	$0C
	jr	c, +_
	xor	a
_:	ld	(iy+$02), a
	add	a, a
	ld	e, a
	ld	d, $00
	ld	hl, DATA_B30_AF65
	add	hl, de
	ld	de, $D4D1
	ld	bc, $0002
	ldir	
	ld	a, $FF
	ld	(Palette_UpdateTrig), a
	ret

;Update the CEZ3 wall lights
UpdateCyclingPalette_WallLighting:		;$7E6C
	inc	(iy+$03)
	ld	a, (iy+$03)
	cp	$04
	ret	c
	ld	(iy+$03), $00
	ld	a, (iy+$02)
	inc	a
	cp	$06
	jr	c, +_
	xor	a
_:	ld	(iy+$02), a
	ld	e, a
	ld	d, $00
	ld	hl, DATA_B30_AF7D
	add	hl, de
	ld	a, (hl)
	ld	de, $D4CA
	ld	(de), a
	ld	a, $FF
	ld	(Palette_UpdateTrig), a
	ret

;update the CEZ1 orb cycling palette
UpdateCyclingPalette_Orb:		;$7E97
	inc	(iy+$03)
	ld	a, (iy+$03)
	cp	$04
	ret	c
	ld	(iy+$03), $00
	ld	a, (iy+$02)
	inc	a
	cp	$0e
	jr	c, +_
	xor	a
_:	ld	(iy+$02), a
	add	a, a
	ld	e, a
	ld	d, $00
	ld	hl, DATA_B30_AF83
	add	hl, de
	ld	de, $D4D3
	ld	bc, $0002
	ldir	
	ld	a, $FF
	ld	(Palette_UpdateTrig), a
	ret

;Update palette for CEZ3 boss lightening
UpdateCyclingPalette_Lightning:	;$7EC6
	inc	(iy+$03)
	ld	a, (iy+$03)
	cp	$02
	ret	c
	ld	(iy+$03), $00
	ld	a, (iy+$02)
	inc	a
	cp	$03
	jr	c, +_
	xor	a
_:	ld	(iy+$02), a
	ld	e, a
	ld	d, $10
	mlt	de
	ld	hl, DATA_B30_AF9F
	add	hl, de
	ld	de, WorkingCRAM
	ld	bc, $0010
	ldir
	ld	a, $FF
	ld	(Palette_UpdateTrig), a
	ret

;Update palette for CEZ3 boss lightning (part 2)
UpdateCyclingPalette_Lightning2:		;$7EF8
	ld	hl, DATA_B30_AF9F
	ld	de, WorkingCRAM
	ld	bc, $0010
	ldir
	ld	a, $FF
	ld	(Palette_UpdateTrig), a
	ld	(iy+$00), $00
	ld	(iy+$03), $00
	ld	(iy+$02), $00
	ret

UpdateCyclingPalette_ScrollingText:	;$7F15
	ld	a, ($D12F)		;get the frame counter
	and	$03
	ret	nz

	ld	hl, DATA_B30_AFCF
	ld	a, ($D12F)			;use the frame counter to alternate
	bit	2, a				;the palettes
	jr	z, +_
	ld	hl, DATA_B30_AFD5	;copy the palette to working copy of CRAM
_:	ld	de, WorkingCRAM + $09
	ld	bc, $0006
	ldir

	ld	a, $FF			;flag for a VRAM palette update
	ld	(Palette_UpdateTrig), a
	ret

LABEL_7F46:	;update the palette for the end sequence
	ld	l, (iy+$04)
	ld	h, (iy+$05)
	inc	hl
	ld	(iy+$04), l
	ld	(iy+$05), h
	ld	bc, $0280
	xor	a
	sbc	hl, bc
	ret	c
	ld	(iy+$04), $00
	ld	(iy+$05), $00
	inc	(iy+$02)
	ld	a, (iy+$02)
	cp	$0A
	jr	c, LABEL_7F74
	xor	a
	ld	(iy+$00), a
	ld	(iy+$02), a
	ret

LABEL_7F74:
	add	a, $25			;load palette $25
	ld	hl, BgPaletteControl
	set	5, (hl)		;reset palette
	inc	hl
	ld	(hl), a
	ret

LABEL_7F7E:
	inc	(iy + $03)
	ld	a, (iy + $03)
	cp	$06
	ret	c
	ld	(iy + $03), $00
	ld	a, (iy + $02)
	inc	a
	cp	$06
	jr	c, +_
	xor	a
_:	ld	(iy + $02), a
	add	a, a
	ld	e, a
	ld	d, $00
	ld	hl, DATA_B30_AFDB
	add	hl, de
	ld	a, (hl)
	ld	($D4CF), a
	inc	hl
	ld	a, (hl)
	ld	($D4D5), a
	
	; flag for a palette update with the next vsync
	ld	a, $FF
	ld	(Palette_UpdateTrig), a

	ret


; =============================================================================
;	Engine_AnimateRingArt()
; -----------------------------------------------------------------------------
;	Updates the ring animation frame counter & copies ring art to VRAM.
; -----------------------------------------------------------------------------
;	In:
;	None.
;	ld:
;	None.
; -----------------------------------------------------------------------------
Engine_AnimateRingArt:		;$7FAE
	; update the ring art every 7th frame
	ld	a, (FrameCounter)
	and	7
	ret	nz

	; increment the ring animation frame number. wrap the counter at 6.
	ld	a, (Engine_RingAnimFrame)
	inc	a
	cp	$06
	jr	c, +_
	xor	a 
	; store the updated counter value
_:	ld	(Engine_RingAnimFrame), a

	; use the counter to calculate an offset from the source pointer
	; (i.e. pointer to the art data for the frame).
	ld	l, a
	ld	h, 128
	mlt	hl
	ld	de, (Engine_RingArt_Src)
	add	hl, de
	
	; HL now contains a pointer to the frame art
	; fetch the VRAM destination pointer
	ld	de, (Engine_RingArt_Dest)

	; check for null ptr and bail out if necessary
	ld	a, d
	or	e
	ret	z

	di

	; swap in the bank with the ring art
	ld	a, 29
	ex	de, hl
	call.lil GetDataPTR + romStart

	push.lil hl
	ld.lil	hl, SegaVRAM
	add.lil	hl, de
	ex.lil	de, hl
	pop.lil	hl
	
	; copy 128 bytes to VRAM
	ld	bc, 128
	ldir.lil
	ld	hl, DrawTilemapTrig
	set	0, (hl)
	ret

LoadSHCScreen:
	ld a, 32
	call Engine_SwapFrame2
	jp $8000

ROM_HEADER:				;$7FF0
.db "TMR SEGA" 
.db $00, $00			;reserved
#if Version = 1
	.db $99, $5F		;checksum
#else
	.db $6C, $9E
#endif
.db $15, $90			;product code	
#if Version = 1
	.db $00			;version
#else
	.db $01
#endif
.db $40				;region code/rom size

#include "palette_routines.asm"
#include "cycling_palette_data.asm"

#include	"includes/ti_equates.asm"
#include	"appvars.asm"
#include	"screen_drawing_routines.asm"

#include	"appvars/bank_equates.inc"
#undef Listing
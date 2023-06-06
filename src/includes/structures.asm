;These defines are used by the level loading routines 
;to load the locate the compressed art for each zone.

	#define TilesetHeader.BankNum		$00		;ROM bank to load tiles from
	#define TilesetHeader.VRAMAddress	$01		;Address to copy tiles to
	#define TilesetHeader.SourceAddress	$03
	#define TilesetHeader.Entries		$05	;pointer to the chain of tileset entries

	#define TilesetEntry.BankNum		$00	;ROM Bank to load from. Bit 7 is the indexed tiles flag that is passed to the LoadTiles routine.
	#define TilesetEntry.VRAMAddress	$01	;Address to copy tiles to
	#define TilesetEntry.SourceAddress	$03

;Used by the sprite loading routine at $10BF  
;to load the playersprites into VRAM at $0000.

	#define SpriteDef.BankNum			$00
	#define SpriteDef.SourceAddress		$01
	#define SpriteDef.LineCount			$03	;LineCount = TileCount/2 (two tiles are copied for each line).

; =============================================================================
;  LEVEL STRUCTURE & FLAGS
; -----------------------------------------------------------------------------
	#define LevelDescriptor.ViewportFlags	$00
	#define LevelDescriptor.ix01			$01
	#define LevelDescriptor.MetaTileX		$02 ; x-index of metatile (see: Engine_Mappings_GetBlockXY)
	#define LevelDescriptor.MetaTileY		$03 ; y-index of metatile (see: Engine_Mappings_GetBlockXY)
	#define LevelDescriptor.MetaTileBank	$04
	#define LevelDescriptor.LayoutBank		$05
	#define LevelDescriptor.MetaTilePtr		$06
	#define LevelDescriptor.LayoutPtr		$08
	#define LevelDescriptor.StrideTable		$0A
	#define LevelDescriptor.WidthNeg		$0C
	#define LevelDescriptor.Width			$0E
	#define LevelDescriptor.DataOffset		$10



; Viewport Flag bits
#define LVP_SCROLL_UP			0
#define LVP_SCROLL_DOWN			1
#define LVP_SCROLL_LEFT			2
#define LVP_SCROLL_RIGHT		3
#define LVP_ROW_UPDATE_PENDING	4
#define LVP_COL_UPDATE_PENDING	5
#define LVP_CAMERA_UPDATE_RQD	 	6
#define LVP_CAMERA_LOCKED		7


; =============================================================================
;  OBJECT STRUCTURE & FLAGS
; -----------------------------------------------------------------------------
	#define Object.ObjID		$00	; $00 - object number
	#define Object.State		$01	; $01
	#define Object.StateNext	$02	; $02
	#define Object.Flags03		$03	; $03
	#define Object.Flags04		$04	; $04
	#define Object.SpriteCount	$05	; $05
	#define Object.AnimFrame	$06   ; $06
	#define Object.FrameCounter	$07	; $07
	#define Object.RightFacingIdx	$08	; $08
	#define Object.LeftFacingIdx 	$09	; $09
	#define Object.ix0A		$0A  	; movement flags?
	#define Object.ix0B		$0B
	#define Object.LogicPtr		$0C 	; $0C - Pointer to logic subroutine.
	#define Object.LogicSeqPtr	$0E	; $0E - Pointer to logic sequence data
	#define Object.SubPixelX	$10	; $10 - fractional part of xpos
	#define Object.X			$11	; $11 - x pos in level
	#define Object.SubPixelY	$13	; $13 - fractional part of ypos
	#define Object.Y			$14	; $14 - y pos in level
	#define Object.VelX		$16 	; $16 - x velocity (Q8.8)
	#define Object.VelY		$18	; $18 - y velocity (Q8.8)
	#define Object.ScreenX		$1A	; $1A - x offset on screen
	#define Object.ScreenY		$1C	; $1C - y offset on screen
	#define Object.ix1E		$1E
	#define Object.ix1F		$1F
	#define Object.CollidingObj	$20	; $20 - index of colliding object
	#define Object.SprColFlags	$21	; $21 - background collision flags
	#define Object.BgColFlags	$22  	; $22 - sprite collision flags
	#define Object.ix23		$23	; $23 - bg + obj collision flags?
	#define Object.ix24		$24
	#define Object.ix25		$25
	#define Object.ix26		$26
	#define Object.ix27		$27
	#define Object.SprMappgPtr	$28	; $28 - pointer to sprite mapping data for current anim frame
	#define Object.SprOffsets	$2A  	; $2A - pointer to sprite SAT offsets (2 words in object anim data)
	#define Object.Width		$2C   ; $2C
	#define Object.Height		$2D	; $2D
	#define Object.FlashCounter	$2E	; $2E - counter used to toggle sprite visibility
	#define Object.ix2F		#2F
	#define Object.D530		$30
	#define Object.D531		$31
	#define Object.PowerUp		$32	; $32 - current power-up 
	#define Object.D533		$33
	#define Object.D534		$34
	#define Object.D535		$35
	#define Object.D536		$36
	#define Object.D537		$37
	#define Object.D538		$38
	#define Object.D539		$39
	#define Object.InitialX		$3A	; $3A - initial x coordinate
	#define Object.InitialY		$3C	; $3C - initial y coordinate
	#define Object.ActvObjIdx	$3E  	; $3E - index of object within active objects array
	#define Object.ix3F		$3F

; ---------------------------------------------------------
;  Object Flag Byte F3 bits
; ---------------------------------------------------------
#define OBJ_F3_IN_AIR	  	0
#define OBJ_F3_BIT1		1
#define OBJ_F3_BIT2		2
#define OBJ_F3_BIT3		3
#define OBJ_F3_BIT4		4
#define OBJ_F3_BIT5		5
#define OBJ_F3_BIT6		6
#define OBJ_F3_BIT7		7

; ---------------------------------------------------------
;  Object Flag Byte F4 bits
; ---------------------------------------------------------
#define OBJ_F4_BIT0		0
#define OBJ_F4_BIT1		1
#define OBJ_F4_BIT2		2
#define OBJ_F4_BIT3		3
#define OBJ_F4_FACING_LEFT 	4
#define OBJ_F4_FLASHING		5
#define OBJ_F4_BIT6		6
#define OBJ_F4_VISIBLE	 	7

; ---------------------------------------------------------
;  Collision flags (SprColFlags)
; ---------------------------------------------------------
#define OBJ_COL_TOP		0
#define OBJ_COL_BOTTOM	 	1
#define OBJ_COL_RIGHT	 	2
#define OBJ_COL_LEFT	  	3

; ---------------------------------------------------------
;  Object Flag Byte ix23 bits
; ---------------------------------------------------------
#define OBJ_F23_BIT0	   	0
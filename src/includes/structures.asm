;These structures are used by the level loading routines 
;to load the locate the compressed art for each zone.

#macro TilesetHeader
	#define BankNum		;ROM bank to load tiles from
	#define VRAMAddress	;Address to copy tiles to
	#define SourceAddress
	#define Entries		;pointer to the chain of tileset entries
#endmacro

#macro TilesetEntry
	#define BankNum		;ROM Bank to load from. Bit 7 is the indexed tiles flag that is passed to the LoadTiles routine.
	#define VRAMAddress	;Address to copy tiles to
	#define SourceAddress
#endmacro


;Used by the sprite loading routine at $10BF  
;to load the playersprites into VRAM at $0000.

#macro SpriteDef
	#define BankNum	
	#define SourceAddress
	#define LineCount		;LineCount = TileCount/2 (two tiles are copied for each line).
#endmacro


; =============================================================================
;  LEVEL STRUCTURE & FLAGS
; -----------------------------------------------------------------------------
	#define LevelDescriptor.ViewportFlags	0
	#define LevelDescriptor.ix01			1
	#define LevelDescriptor.MetaTileX		2 ; x-index of metatile (see: Engine_Mappings_GetBlockXY)
	#define LevelDescriptor.MetaTileY		3 ; y-index of metatile (see: Engine_Mappings_GetBlockXY)
	#define LevelDescriptor.MetaTileBank	4
	#define LevelDescriptor.LayoutBank		5
	#define LevelDescriptor.MetaTilePtr		6
	#define LevelDescriptor.LayoutPtr		7
	#define LevelDescriptor.StrideTable		8
	#define LevelDescriptor.WidthNeg		9
	#define LevelDescriptor.Width			10
	#define LevelDescriptor.DataOffset		11

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
	#define Object.ObjID		0	; $00 - object number
	#define Object.State		1	; $01
	#define Object.StateNext	2	; $02
	#define Object.Flags03		3	; $03
	#define Object.Flags04		4	; $04
	#define Object.SpriteCount	5	; $05
	#define Object.AnimFrame	6   	; $06
	#define Object.FrameCounter	7	; $07
	#define Object.RightFacingIdx	8	; $08
	#define Object.LeftFacingIdx 	9	; $09
	#define Object.ix0A		10  	; movement flags?
	#define Object.ix0B		11
	#define Object.LogicPtr		12 	; $0C - Pointer to logic subroutine.
	#define Object.LogicSeqPtr	13	; $0E - Pointer to logic sequence data
	#define Object.SubPixelX	14	; $10 - fractional part of xpos
	#define Object.X			15	; $11 - x pos in level
	#define Object.SubPixelY	16	; $13 - fractional part of ypos
	#define Object.Y			17	; $14 - y pos in level
	#define Object.VelX		18  	; $16 - x velocity (Q8.8)
	#define Object.VelY		19	; $18 - y velocity (Q8.8)
	#define Object.ScreenX		20	; $1A - x offset on screen
	#define Object.ScreenY		21	; $1C - y offset on screen
	#define Object.ix1E		22
	#define Object.ix1F		23
	#define Object.CollidingObj	24	; $20 - index of colliding object
	#define Object.SprColFlags	25 	; $21 - background collision flags
	#define Object.BgColFlags	26  	; $22 - sprite collision flags
	#define Object.ix23		27	; $23 - bg + obj collision flags?
	#define Object.ix24		28
	#define Object.ix25		29
	#define Object.ix26		30
	#define Object.ix27		31
	#define Object.SprMappgPtr	32	; $28 - pointer to sprite mapping data for current anim frame
	#define Object.SprOffsets	33  	; $2A - pointer to sprite SAT offsets (2 words in object anim data)
	#define Object.Width		34   	; $2C
	#define Object.Height		35	; $2D
	#define Object.FlashCounter	36	; $2E - counter used to toggle sprite visibility
	#define Object.ix2F		37
	#define Object.D530		38
	#define Object.D531		39
	#define Object.PowerUp		40	; $32 - current power-up 
	#define Object.D533		41
	#define Object.D534		42
	#define Object.D535		43
	#define Object.D536		44
	#define Object.D537		45
	#define Object.D538		46
	#define Object.D539		47
	#define Object.InitialX	  	48	; $3A - initial x coordinate
	#define Object.InitialY	 	49	; $3C - initial y coordinate
	#define Object.ActvObjIdx	50  	; $3E - index of object within active objects array
	#define Object.ix3F		51


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
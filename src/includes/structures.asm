;These structures are used by the level loading routines to
;load the locate the compressed art for each zone.

#macro TilesetHeader
	call BankNum		;ROM bank to load tiles from
	call VRAMAddress		;Address to copy tiles to
	call SourceAddress
	call Entries		;pointer to the chain of tileset entries
#endmacro

#macro TilesetEntry
	call BankNum		;ROM Bank to load from. Bit 7 is the indexed tiles flag that is passed to the LoadTiles routine.
	call VRAMAddress		;Address to copy tiles to
	call SourceAddress
#endmacro


;Used by the sprite loading routine at $10BF to load the player
;sprites into VRAM at $0000.

#macro SpriteDef
	call BankNum	
	call SourceAddress
	call LineCount		;LineCount = TileCount/2 (two tiles are copied for each line).
#endmacro


; =============================================================================
;  LEVEL STRUCTURE & FLAGS
; -----------------------------------------------------------------------------
#macro LevelDescriptor
	call  ViewportFlags
	call ix01
	call MetaTileX	; x-index of metatile (see: Engine_Mappings_GetBlockXY)
	call MetaTileY	; y-index of metatile (see: Engine_Mappings_GetBlockXY)
	call MetaTileBank
	call LayoutBank
	call MetaTilePtr
	call LayoutPtr
	call StrideTable
	call WidthNeg
	call Width
	call DataOffset
#endmacro

; Viewport Flag bits
#define LVP_SCROLL_UP			  0
#define LVP_SCROLL_DOWN			1
#define LVP_SCROLL_LEFT			2
#define LVP_SCROLL_RIGHT		   3
#define LVP_ROW_UPDATE_PENDING	 4
#define LVP_COL_UPDATE_PENDING	 5
#define LVP_CAMERA_UPDATE_RQD	  6
#define LVP_CAMERA_LOCKED		  7


; =============================================================================
;  OBJECT STRUCTURE & FLAGS
; -----------------------------------------------------------------------------
#macro Object
	call ObjID			; $00 - object number
	call State			; $01
	call StateNext		; $02
	call Flags03		; $03
	call Flags04		; $04
	call SpriteCount		; $05
	call AnimFrame	   	; $06
	call FrameCounter	; $07
	call RightFacingIdx  	; $08
	call LeftFacingIdx  	; $09
	call ix0A		  	; movement flags?
	call ix0B	
	call LogicPtr	 	; $0C - Pointer to logic subroutine.
	call LogicSeqPtr		; $0E - Pointer to logic sequence data
	call SubPixelX		; $10 - fractional part of xpos
	call X			; $11 - x pos in level
	call SubPixelY	   	; $13 - fractional part of ypos
	call Y			; $14 - y pos in level
	call VelX		  	; $16 - x velocity (Q8.8)
	call VelY			; $18 - y velocity (Q8.8)
	call ScreenX		; $1A - x offset on screen
	call ScreenY		; $1C - y offset on screen
	call ix1E	
	call ix1F
	call CollidingObj	; $20 - index of colliding object
	call SprColFlags	 	; $21 - background collision flags
	call BgColFlags	  	; $22 - sprite collision flags
	call ix23			; $23 - bg + obj collision flags?
	call ix24	
	call ix25	
	call ix26	
	call ix27	
	call SprMappgPtr		; $28 - pointer to sprite mapping data for current anim frame
	call SprOffsets	  	; $2A - pointer to sprite SAT offsets (2 words in object anim data)
	call Width		   	; $2C
	call Height		; $2D
	call FlashCounter	; $2E - counter used to toggle sprite visibility
	call ix2F	
	call D530	
	call D531	
	call PowerUp		; $32 - current power-up 
	call D533	
	call D534	
	call D535	
	call D536	
	call D537	
	call D538	
	call D539	
	call InitialX	  	; $3A - initial x coordinate
	call InitialY	 	; $3C - initial y coordinate
	call ActvObjIdx	  	; $3E - index of object within active objects array
	call ix3F	
#endmacro


; ---------------------------------------------------------
;  Object Flag Byte F3 bits
; ---------------------------------------------------------
#define OBJ_F3_IN_AIR	  0
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
#define OBJ_F4_FACING_LEFT 4
#define OBJ_F4_FLASHING	5
#define OBJ_F4_BIT6		6
#define OBJ_F4_VISIBLE	 7

; ---------------------------------------------------------
;  Collision flags (SprColFlags)
; ---------------------------------------------------------
#define OBJ_COL_TOP		0
#define OBJ_COL_BOTTOM	 1
#define OBJ_COL_RIGHT	  2
#define OBJ_COL_LEFT	   3

; ---------------------------------------------------------
;  Object Flag Byte ix23 bits
; ---------------------------------------------------------
#define OBJ_F23_BIT0	   0

; =============================================================================
;  Memory Layout
; -----------------------------------------------------------------------------
;  This file contains memory address definitions for variables.
; -----------------------------------------------------------------------------

	#define LevelLayout				gameMem+$C001
	#define unk_01					gameMem+$D001
	#define Frame1Page 				gameMem+$D12A
	#define Frame2Page				gameMem+$D12B
	#define LevelSelectTrg	 			gameMem+$D12C
	#define unk_02					gameMem+$D12D
	#define FrameCounter				gameMem+$D12F
	#define unk_03					gameMem+$D130
	#define PaletteResetTrg			gameMem+$D131
	#define unk_04					gameMem+$D132
	#define LevelAttributes			gameMem+$D15D
	#define LevelAttributes.ViewportFlags	gameMem+$D15D
	#define LevelAttributes.ix01		gameMem+$D15E
	#define LevelAttributes.MetaTileX		gameMem+$D15F ; x-index of metatile (see: Engine_Mappings_GetBlockXY)
	#define LevelAttributes.MetaTileY		gameMem+$D160 ; y-index of metatile (see: Engine_Mappings_GetBlockXY)
	#define LevelAttributes.MetaTileBank	gameMem+$D161
	#define LevelAttributes.LayoutBank	gameMem+$D162
	#define LevelAttributes.MetaTilePtr	gameMem+$D163
	#define LevelAttributes.LayoutPtr		gameMem+$D165
	#define LevelAttributes.StrideTable	gameMem+$D167
	#define LevelAttributes.WidthNeg		gameMem+$D169
	#define LevelAttributes.Width		gameMem+$D171
	#define LevelAttributes.DataOffset	gameMem+$D173
	#define unk_05					gameMem+$D174
;----------------------------------------------------------
; =========================================================
;  VDP Variables
;----------------------------------------------------------
	#define VDP_VScroll		gameMem+$D176
	#define VDP_HScroll 		gameMem+$D177
	#define VDP_ViewportX		gameMem+$D178
	#define VDP_ViewportY		gameMem+$D17A
	#define VDP_TileColBuffer 	gameMem+$D17B    ; holds a column of tile indices before copying to the VDP
	#define VDP_TileRowBuffer 	gameMem+$D1BB    ; holds a row of tile indices before copying to the VDP
	#define unk_06			gameMem+$D203
	#define CurrentMetaTileAddr gameMem+$D23D

#define  Engine_ObjCharCodePtr	gameMem+$D110

#define  VDP_SATUpdateTrig		gameMem+$D134
#define  Engine_InterruptServiced	gameMem+$D135       ; byte - set when the interrupt has been serviced
#define  Engine_InputFlags		gameMem+$D137       ; byte - current controller input flags
#define  Engine_InputFlagsLast	gameMem+$D147       ; byte - input flags from the previous frame

#define  Camera_X			gameMem+$D174       ; word
#define  Camera_Y			gameMem+$D176       ; word
#define  Camera_MetatileColBuffer	gameMem+$D178       ; 64 b - a buffer to hold tile data from a column of metatiles.

#define  Camera_MetatilePtr		gameMem+$D278       ; word - points to a metatile in the layout data (see: Engine_Mappings_GetBlockXY)

#define  GlobalTriggers		gameMem+$D293       ; byte - bitfield of various trigger flags (e.g. load level, kill player, etc).
#define  CurrentLevel			gameMem+$D295       ; byte - current level number
#define  CurrentAct			gameMem+$D296       ; byte - current act number
#define  LivesOnEntry			gameMem+$D297       ; byte - player's life counter on entry to the level
#define  LifeCounter			gameMem+$D298       ; byte - player's life counter
#define  RingCounter			gameMem+$D299       ; byte - player's ring counter (BCD)

#define  ContinueCounter		gameMem+$D2BD       ; byte - number of continues remaining.
#define  EmeraldFlags			gameMem+$D2C5       ; byte - one bit flag for each emerald.
#define  HasEmeraldTrg			gameMem+$D2C6       ; byte - set by the chaos emerald collision routines.
#define  VDP_DefaultTileAttribs	gameMem+$D2C7       ; byte

#define  Engine_CollisionDataPtr	gameMem+$D2D4       ; word - pointer to collision data for current level

#define  Engine_DemoSeq_Bank	gameMem+$D2D8

#define  Engine_RingAnimFrame	gameMem+$D351       ; byte - ring animation frame number.
#define  Cllsn_RingBlock		gameMem+$D352       ; byte - used by ring<>player collision routines to store ring metatile number.
#define  Cllsn_MetatileIndex	gameMem+$D353       ; byte - the metatile number stored at (Cllsn_LevelMapBlockPtr)
#define  Cllsn_LevelMapBlockPtr	gameMem+$D354       ; word - pointer to the current metatile block in the level data
#define  Cllsn_AdjustedX		gameMem+$D356       ; word - object's x-coordinate + an adjustment value
#define  Cllsn_AdjustedY		gameMem+$D358       ; word - object's y-coordinate + an adjustment value
#define  Cllsn_MetaTileX		gameMem+$D35A       ; word - metatile's x coordinate
#define  Cllsn_MetaTileY		gameMem+$D35C       ; word - metatile's y coordinate
#define  Cllsn_MetaTileSurfaceType	gameMem+$D35E       ; byte - surface type value for the colliding metatile.
#define  Cllsn_HeaderPtr3		gameMem+$D35F       ; word - 3rd pointer in the metatile's collision header
#define  Cllsn_CollisionValueY	gameMem+$D361       ; byte - vertical collision value for the current position within the metatile.
#define  Cllsn_CollisionValueX	gameMem+$D362       ; byte - horizontal collision value for the current position within the metatile.


#define  Engine_UpdateSpriteAttribs_vpos_ptr   	gameMem+$D369       ; word
#define  Engine_UpdateSpriteAttribs_hpos_ptr   	gameMem+$D36B       ; word
#define  Player_MaxVelX			     		gameMem+$D36D       ; word
#define  Player_DeltaVX			    		gameMem+$D36F       ; word - player object x delta-v?
#define  Player_MetaTileDeltaVX                	gameMem+$D371       ; word - delta-v for platform (gradient/slope)

#define  Engine_UpdateSpriteAttribs_adj_pos  	gameMem+$D393       ; word
#define  Engine_RingArt_Src					gameMem+$D395       ; word - pointer to uncompressed ring art data.
#define  Engine_RingArt_Dest				gameMem+$D40397     ; word - vram destination pointer for ring art tiles.

#define  Player_HurtTrigger					gameMem+$D3A8       ; byte - trigger causes player to lose rings or die
#define  Player_FlashCounter				gameMem+$D3A9       ; byte

#define  Engine_MonitorCllsnType				gameMem+$D39D       ; byte - set by monitor collision routines to indicate monitor type.

#define  Player_UnderwaterFlag				gameMem+$D467       ; byte
#define  Player_AirTimerLo					gameMem+$D468       ; byte
#define  Player_AirTimerHi					gameMem+$D469       ; byte - incremented when lo byte = $78 (~2 seconds)

#define  Player_KillTrigger					gameMem+$D49F       ; byte - causes player to die, regardless of ring count.

#define  UpdatePalettesOnly					gameMem+$D4A3

#define  Engine_PowerUpTimer				gameMem+$D4A0       ; byte - timer for invincibility

#define  Engine_DynPalette_0				gameMem+$D4A6       ; byte

#define  Engine_DynPalette_1				gameMem+$D4AE       ; byte

#define  Palette_UpdateTrig					gameMem+$D4EA       ; causes a CRAM update with the next vblank


; ---------------------------------------------------------
#define  Engine_ObjectSlots			gameMem+$D500

PlayerObj:
	#define Player				gameMem+$D500
	#define Player.ObjID			gameMem+$D500	; 	gameMem+$D500 - object number
	#define Player.State			gameMem+$D501	; 	gameMem+$D501
	#define Player.StateNext		gameMem+$D502	; 	gameMem+$D502
	#define Player.Flags03			gameMem+$D503	; 	gameMem+$D503
	#define Player.Flags04			gameMem+$D504	; 	gameMem+$D504
	#define Player.SpriteCount		gameMem+$D505	; 	gameMem+$D505
	#define Player.AnimFrame		gameMem+$D506	;	gameMem+$D506
	#define Player.FrameCounter		gameMem+$D507	; 	gameMem+$D507
	#define Player.RightFacingIdx	gameMem+$D508	; 	gameMem+$D508
	#define Player.LeftFacingIdx 	gameMem+$D509	; 	gameMem+$D509
	#define Player.ix0A			gameMem+$D50A	; 	movement flags?
	#define Player.ix0B			gameMem+$D50B
	#define Player.LogicPtr		gameMem+$D50C	;	gameMem+$D50C - Pointer to logic subroutine.
	#define Player.LogicSeqPtr		gameMem+$D50E	; 	gameMem+$D50E - Pointer to logic sequence data
	#define Player.SubPixelX		gameMem+$D510	; 	gameMem+$D510 - fractional part of xpos
	#define Player.X				gameMem+$D511	; 	gameMem+$D511 - x pos in level
	#define Player.SubPixelY		gameMem+$D513	; 	gameMem+$D513 - fractional part of ypos
	#define Player.Y				gameMem+$D514	; 	gameMem+$D514 - y pos in level
	#define Player.VelX			gameMem+$D516	; 	gameMem+$D516 - x velocity (Q8.8)
	#define Player.VelY			gameMem+$D518	; 	gameMem+$D518 - y velocity (Q8.8)
	#define Player.ScreenX			gameMem+$D51A	; 	gameMem+$D51A - x offset on screen
	#define Player.ScreenY			gameMem+$D51C	; 	gameMem+$D51C - y offset on screen
	#define Player.ix1E			gameMem+$D51E
	#define Player.ix1F			gameMem+$D51F
	#define Player.CollidingObj		gameMem+$D520	; 	gameMem+$D520 - index of colliding object
	#define Player.SprColFlags		gameMem+$D521	; 	gameMem+$D521 - background collision flags
	#define Player.BgColFlags		gameMem+$D522	; 	gameMem+$D522 - sprite collision flags
	#define Player.ix23			gameMem+$D523	; 	gameMem+$D523 - bg + obj collision flags?
	#define Player.ix24			gameMem+$D524
	#define Player.ix25			gameMem+$D525
	#define Player.ix26			gameMem+$D526
	#define Player.ix27			gameMem+$D527
	#define Player.SprMappgPtr		gameMem+$D528	; 	gameMem+$D528 - pointer to sprite mapping data for current anim frame
	#define Player.SprOffsets		gameMem+$D52A	; 	gameMem+$D52A - pointer to sprite SAT offsets (2 words in object anim data)
	#define Player.Width			gameMem+$D52C	; 	gameMem+$D52C
	#define Player.Height			gameMem+$D52D	; 	gameMem+$D52D
	#define Player.FlashCounter		gameMem+$D52E	; 	gameMem+$D52E - counter used to toggle sprite visibility
	#define Player.ix2F			gameMem+$D52F
	#define Player.D530			gameMem+$D530
	#define Player.D531			gameMem+$D531
	#define Player.PowerUp			gameMem+$D532	; 	gameMem+$D532 - current power-up 
	#define Player.D533			gameMem+$D533
	#define Player.D534			gameMem+$D534
	#define Player.D535			gameMem+$D535
	#define Player.D536			gameMem+$D536
	#define Player.D537			gameMem+$D537
	#define Player.D538			gameMem+$D538
	#define Player.D539			gameMem+$D539
	#define Player.InitialX		gameMem+$D53A	; 	gameMem+$D53A - initial x coordinate
	#define Player.InitialY		gameMem+$D53C	; 	gameMem+$D53C - initial y coordinate
	#define Player.ActvObjIdx		gameMem+$D53E	; 	gameMem+$D53E - index of object within active objects array
	#define Player.ix3F			gameMem+$D53F

; ---------------------------------------------------------


#define  VDP_WorkingSAT            $D5DB00
#define  VDP_WorkingSAT_VPOS       VDP_WorkingSAT
#define  VDP_WorkingSAT_HPOS       VDP_WorkingSAT + 64
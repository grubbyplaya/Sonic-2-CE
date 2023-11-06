; =============================================================================
;  Memory Layout
; -----------------------------------------------------------------------------
;  This file contains memory address definitions for variables.
; -----------------------------------------------------------------------------

	#define LevelLayout				$C001
	#define unk_01					$D001
	#define Frame1Page 				$D12A
	#define Frame2Page				$D12B
	#define LevelSelectTrg	 			$D12C
	#define unk_02					$D12D
	#define FrameCounter				$D12F
	#define unk_03					$D130
	#define PaletteResetTrg				$D131
	#define unk_04					$D132
	#define LevelAttributes				$D15D
	#define LevelAttributes.ViewportFlags		LevelAttributes
	#define LevelAttributes.ix01			LevelAttributes+LevelDescriptor.ix01
	#define LevelAttributes.MetaTileX		LevelAttributes+LevelDescriptor.MetaTileX ; x-index of metatile (see: Engine_Mappings_GetBlockXY)
	#define LevelAttributes.MetaTileY		LevelAttributes+LevelDescriptor.MetaTileY ; y-index of metatile (see: Engine_Mappings_GetBlockXY)
	#define LevelAttributes.MetaTileBank		LevelAttributes+LevelDescriptor.MetaTileBank
	#define LevelAttributes.LayoutBank		LevelAttributes+LevelDescriptor.LayoutBank
	#define LevelAttributes.MetaTilePtr		LevelAttributes+LevelDescriptor.MetaTilePtr
	#define LevelAttributes.LayoutPtr		LevelAttributes+LevelDescriptor.LayoutPtr
	#define LevelAttributes.StrideTable		LevelAttributes+LevelDescriptor.StrideTable
	#define LevelAttributes.WidthNeg		LevelAttributes+LevelDescriptor.WidthNeg
	#define LevelAttributes.Width			LevelAttributes+LevelDescriptor.Width
	#define LevelAttributes.DataOffset		LevelAttributes+LevelDescriptor.DataOffset
	#define unk_05					$D176
;----------------------------------------------------------
; =========================================================
;  VDP Variables
;----------------------------------------------------------
	#define VDP_VScroll		$D177
	#define VDP_HScroll 		$D178
	#define VDP_ViewportX		$D179
	#define VDP_ViewportY		$D17C
	#define VDP_TileColBuffer 	$D17F    ; holds a column of tile indices before copying to the VDP
	#define VDP_TileRowBuffer 	$D1BB    ; holds a row of tile indices before copying to the VDP
	#define unk_06			$D203
	#define CurrentMetaTileAddr	$D23D

#define  Engine_ObjCharCodePtr		$D110

#define  VDP_SATUpdateTrig		$D134
#define  Engine_InterruptServiced	$D135	; byte - set when the interrupt has been serviced
#define  Engine_InputFlags		$D137	; byte - current controller input flags
#define  Engine_InputFlagsLast		$D147	; byte - input flags from the previous frame
#define  Camera_X			$D174	; word
#define  Camera_Y			$D177	; word
#define  Camera_MetatileColBuffer	$D17A	; 64 b - a buffer to hold tile data from a column of metatiles.

#define  Camera_MetatilePtr		$D278	; word - points to a metatile in the layout data (see: Engine_Mappings_GetBlockXY)

#define  GlobalTriggers			$D293	; byte - bitfield of various trigger flags (e.g. load level, kill player, etc).
#define  CurrentLevel			$D295	; byte - current level number
#define  CurrentAct			$D296	; byte - current act number
#define  LivesOnEntry			$D297	; byte - player's life counter on entry to the level
#define  LifeCounter			$D298	; byte - player's life counter
#define  RingCounter			$D299	; byte - player's ring counter (BCD)

#define  ContinueCounter		$D2BD	; byte - number of continues remaining.
#define  EmeraldFlags			$D2C5	; byte - one bit flag for each emerald.
#define  HasEmeraldTrg			$D2C6	; byte - set by the chaos emerald collision routines.
#define  VDP_DefaultTileAttribs		$D2C7	; byte

#define  Engine_CollisionDataPtr	$D2D4	; word - pointer to collision data for current level

#define  Engine_DemoSeq_Bank		$D2D8

#define  Engine_RingAnimFrame		$D351	; byte - ring animation frame number.
#define  Cllsn_RingBlock		$D352	; byte - used by ring<>player collision routines to store ring metatile number.
#define  Cllsn_MetatileIndex		$D353	; byte - the metatile number stored at (Cllsn_LevelMapBlockPtr)
#define  Cllsn_LevelMapBlockPtr		$D354	; word - pointer to the current metatile block in the level data
#define  Cllsn_AdjustedX		$D357	; word - object's x-coordinate + an adjustment value
#define  Cllsn_AdjustedY		$D35A	; word - object's y-coordinate + an adjustment value
#define  Cllsn_MetaTileX		$D35D	; word - metatile's x coordinate
#define  Cllsn_MetaTileY		$D360	; word - metatile's y coordinate
#define  Cllsn_MetaTileSurfaceType	$D363	; byte - surface type value for the colliding metatile.
#define  Cllsn_HeaderPtr3		$D364	; word - 3rd pointer in the metatile's collision header
#define  Cllsn_CollisionValueY		$D367	; byte - vertical collision value for the current position within the metatile.
#define  Cllsn_CollisionValueX		$D368	; byte - horizontal collision value for the current position within the metatile.


#define  Engine_UpdateSpriteAttribs_vpos_ptr   	$D369	; word
#define  Engine_UpdateSpriteAttribs_hpos_ptr   	$D36C	; word
#define  Player_MaxVelX			     	$D36F	; word
#define  Player_DeltaVX				$D372	; word - player object x delta-v?
#define  Player_MetaTileDeltaVX			$D375	; word - delta-v for platform (gradient/slope)

#define  Engine_UpdateSpriteAttribs_adj_pos  	$D393	; word
#define  Engine_RingArt_Src			$D396	; word - pointer to uncompressed ring art data.
#define  Engine_RingArt_Dest			$D399	; word - vram destination pointer for ring art tiles.

#define  Player_HurtTrigger			$D3A8	; byte - trigger causes player to lose rings or die
#define  Player_FlashCounter			$D3A9	; byte

#define  Engine_MonitorCllsnType		$D39D	; byte - set by monitor collision routines to indicate monitor type.

#define  Player_UnderwaterFlag			$D467	; byte
#define  Player_AirTimerLo			$D468	; byte
#define  Player_AirTimerHi			$D469	; byte - incremented when lo byte = $78 (~2 seconds)

#define  Player_KillTrigger			$D49F	; byte - causes player to die, regardless of ring count.

#define  UpdatePalettesOnly			$D4A3

#define  Engine_PowerUpTimer			$D4A0	; byte - timer for invincibility

#define  Engine_DynPalette_0			$D4A6	; byte

#define  Engine_DynPalette_1			$D4AE	; byte

#define  Palette_UpdateTrig			$D4EA	; causes a CRAM update with the next vblank


; ---------------------------------------------------------
#define  Engine_ObjectSlots			$D500

	#define PlayerObj			Engine_ObjectSlots
	#define Player				$D500
	#define Player.ObjID			$D500	; 	$D500 - object number
	#define Player.State			$D501	; 	$D501
	#define Player.StateNext		$D502	; 	$D502
	#define Player.Flags03			$D503	; 	$D503
	#define Player.Flags04			$D504	; 	$D504
	#define Player.SpriteCount		$D505	; 	$D505
	#define Player.AnimFrame		$D506	;	$D506
	#define Player.FrameCounter		$D507	; 	$D507
	#define Player.RightFacingIdx		$D508	; 	$D508
	#define Player.LeftFacingIdx 		$D509	; 	$D509
	#define Player.ix0A			$D50A	; 	movement flags?
	#define Player.ix0B			$D50B
	#define Player.LogicPtr			$D50C	;	$D50C - Pointer to logic subroutine.
	#define Player.LogicSeqPtr		$D50E	; 	$D50E - Pointer to logic sequence data
	#define Player.SubPixelX		$D510	; 	$D510 - fractional part of xpos
	#define Player.X			$D511	; 	$D511 - x pos in level
	#define Player.SubPixelY		$D513	; 	$D513 - fractional part of ypos
	#define Player.Y			$D514	; 	$D514 - y pos in level
	#define Player.VelX			$D516	; 	$D516 - x velocity (Q8.8)
	#define Player.VelY			$D518	; 	$D518 - y velocity (Q8.8)
	#define Player.ScreenX			$D51A	; 	$D51A - x offset on screen
	#define Player.ScreenY			$D51C	; 	$D51C - y offset on screen
	#define Player.ix1E			$D51E
	#define Player.ix1F			$D51F
	#define Player.CollidingObj		$D520	; 	$D520 - index of colliding object
	#define Player.SprColFlags		$D521	; 	$D521 - background collision flags
	#define Player.BgColFlags		$D522	; 	$D522 - sprite collision flags
	#define Player.ix23			$D523	; 	$D523 - bg + obj collision flags?
	#define Player.ix24			$D524
	#define Player.ix25			$D525
	#define Player.ix26			$D526
	#define Player.ix27			$D527
	#define Player.SprMappgPtr		$D528	; 	$D528 - pointer to sprite mapping data for current anim frame
	#define Player.SprOffsets		$D52A	; 	$D52A - pointer to sprite SAT offsets (2 words in object anim data)
	#define Player.Width			$D52C	; 	$D52C
	#define Player.Height			$D52D	; 	$D52D
	#define Player.FlashCounter		$D52E	; 	$D52E - counter used to toggle sprite visibility
	#define Player.ix2F			$D52F
	#define Player.D530			$D530
	#define Player.D531			$D531
	#define Player.PowerUp			$D532	; 	$D532 - current power-up 
	#define Player.D533			$D533
	#define Player.D534			$D534
	#define Player.D535			$D535
	#define Player.D536			$D536
	#define Player.D537			$D537
	#define Player.D538			$D538
	#define Player.D539			$D539
	#define Player.InitialX			$D53A	; 	$D53A - initial x coordinate
	#define Player.InitialY			$D53C	; 	$D53C - initial y coordinate
	#define Player.ActvObjIdx		$D53E	; 	$D53E - index of object within active objects array
	#define Player.ix3F			$D53F

; ---------------------------------------------------------


#define  VDP_WorkingSAT	  	$DB00
#define  VDP_WorkingSAT_VPOS	VDP_WorkingSAT
#define  VDP_WorkingSAT_HPOS	VDP_WorkingSAT + 64
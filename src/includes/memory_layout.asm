; =============================================================================
;  Memory Layout
; -----------------------------------------------------------------------------
;  This file contains memory address definitions for variables.
; -----------------------------------------------------------------------------

.enum $C001
	LevelLayout			dsb $1000
;----------------------------------------------------------
	unk_01				dsb $0129	;//////////////////////
;----------------------------------------------------------
    Frame1Page          db
    Frame2Page          db
	LevelSelectTrg		db
;----------------------------------------------------------
	unk_02				dsb 2		;//////////////////////
;----------------------------------------------------------
	FrameCounter		db
;----------------------------------------------------------
	unk_03				db			;//////////////////////
;----------------------------------------------------------
	PaletteResetTrg		db
;----------------------------------------------------------
	unk_04				dsb $2C		;//////////////////////
;----------------------------------------------------------
	LevelAttributes		instanceof LevelDescriptor
;----------------------------------------------------------
	unk_05				dsb 2		;//////////////////////
;----------------------------------------------------------
	
; =========================================================
;  VDP Variables
; ---------------------------------------------------------
	VDP_VScroll			db
	VDP_HScroll			db
	VDP_ViewportX		dw
	VDP_ViewportY		dw
	VDP_TileColBuffer	dsb	64      ; holds a column of tile indices before copying to the VDP
	VDP_TileRowBuffer	dsb	72      ; holds a row of tile indices before copying to the VDP

;----------------------------------------------------------
	unk_06				dsb 58		;//////////////////////
;----------------------------------------------------------

	CurrentMetaTileAddr	dw
	
    
    SOUND_DRIVER_START: .dw
.ende


#define  Engine_ObjCharCodePtr                 $D110

#define  VDP_SATUpdateTrig                     $D134
#define  Engine_InterruptServiced              $D135       ; byte - set when the interrupt has been serviced
#define  Engine_UpdateSoundOnly                $D136       ; byte - when set only sound driver will update on vsync
#define  Engine_InputFlags                     $D137       ; byte - current controller input flags
#define  Engine_InputFlagsLast                 $D147       ; byte - input flags from the previous frame

#define  Camera_X                              $D174       ; word
#define  Camera_Y                              $D176       ; word
#define  Camera_MetatileColBuffer              $D178       ; 64 b - a buffer to hold tile data from a column of metatiles.

#define  Camera_MetatilePtr                    $D278       ; word - points to a metatile in the layout data (see: Engine_Mappings_GetBlockXY)

#define  GlobalTriggers                        $D293       ; byte - bitfield of various trigger flags (e.g. load level, kill player, etc).
#define  CurrentLevel                          $D295       ; byte - current level number
#define  CurrentAct                            $D296       ; byte - current act number
#define  LivesOnEntry                          $D297       ; byte - player's life counter on entry to the level
#define  LifeCounter                           $D298       ; byte - player's life counter
#define  RingCounter                           $D299       ; byte - player's ring counter (BCD)

#define  ContinueCounter                       $D2BD       ; byte - number of continues remaining.
#define  EmeraldFlags                          $D2C5       ; byte - one bit flag for each emerald.
#define  HasEmeraldTrg                         $D2C6       ; byte - set by the chaos emerald collision routines.
#define  VDP_DefaultTileAttribs                $D2C7       ; byte

#define  Engine_CollisionDataPtr               $D2D4       ; word - pointer to collision data for current level

#define  Engine_DemoSeq_Bank                   $D2D8

#define  Engine_RingAnimFrame                  $D351       ; byte - ring animation frame number.
#define  Cllsn_RingBlock                       $D352       ; byte - used by ring<>player collision routines to store ring metatile number.
#define  Cllsn_MetatileIndex                   $D353       ; byte - the metatile number stored at (Cllsn_LevelMapBlockPtr)
#define  Cllsn_LevelMapBlockPtr                $D354       ; word - pointer to the current metatile block in the level data
#define  Cllsn_AdjustedX                       $D356       ; word - object's x-coordinate + an adjustment value
#define  Cllsn_AdjustedY                       $D358       ; word - object's y-coordinate + an adjustment value
#define  Cllsn_MetaTileX                       $D35A       ; word - metatile's x coordinate
#define  Cllsn_MetaTileY                       $D35C       ; word - metatile's y coordinate
#define  Cllsn_MetaTileSurfaceType             $D35E       ; byte - surface type value for the colliding metatile.
#define  Cllsn_HeaderPtr3                      $D35F       ; word - 3rd pointer in the metatile's collision header
#define  Cllsn_CollisionValueY                 $D361       ; byte - vertical collision value for the current position within the metatile.
#define  Cllsn_CollisionValueX                 $D362       ; byte - horizontal collision value for the current position within the metatile.


#define  Engine_UpdateSpriteAttribs_vpos_ptr   $D369       ; word
#define  Engine_UpdateSpriteAttribs_hpos_ptr   $D36B       ; word
#define  Player_MaxVelX                        $D36D       ; word
#define  Player_DeltaVX                        $D36F       ; word - player object x delta-v?
#define  Player_MetaTileDeltaVX                $D371       ; word - delta-v for platform (gradient/slope)

#define  Engine_UpdateSpriteAttribs_adj_pos    $D393       ; word
#define  Engine_RingArt_Src                    $D395       ; word - pointer to uncompressed ring art data.
#define  Engine_RingArt_Dest                   $D397       ; word - vram destination pointer for ring art tiles.

#define  Player_HurtTrigger                    $D3A8       ; byte - trigger causes player to lose rings or die
#define  Player_FlashCounter                   $D3A9       ; byte

#define  Engine_MonitorCllsnType               $D39D       ; byte - set by monitor collision routines to indicate monitor type.

#define  Player_UnderwaterFlag                 $D467       ; byte
#define  Player_AirTimerLo                     $D468       ; byte
#define  Player_AirTimerHi     				$D469		; byte - incremented when lo byte = $78 (~2 seconds)

#define  Player_KillTrigger                    $D49F       ; byte - causes player to die, regardless of ring count.

#define  UpdatePalettesOnly                    $D4A3

#define  Engine_PowerUpTimer                   $D4A0       ; byte - timer for invincibility

#define  Engine_DynPalette_0                   $D4A6       ; byte

#define  Engine_DynPalette_1                   $D4AE       ; byte

#define  Palette_UpdateTrig                    $D4EA       ; causes a CRAM update with the next vblank


; ---------------------------------------------------------
#define  Engine_ObjectSlots                    $D500

.enum Engine_ObjectSlots
PlayerObj:              .dw
    Player              instanceof Object
.ende
; ---------------------------------------------------------


#define  VDP_WorkingSAT            $DB00
#define  VDP_WorkingSAT_VPOS       VDP_WorkingSAT
#define  VDP_WorkingSAT_HPOS       VDP_WorkingSAT + 64

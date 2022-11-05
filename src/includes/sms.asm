; =========================================================
;  IO Ports
; ---------------------------------------------------------
#define    Ports_GG_Start      $00
#define    Ports_GG_Stereo     $06

#define    Ports_IO_Control    $3F

#define    Ports_IO1           $DC
#define    Ports_IO2           $DD

#define    Ports_VDP_VCounter  $7E
#define    Ports_VDP_HCounter  $7F

#define    Ports_PSG           $7F

#define    Ports_VDP_Data      $BE
#define    Ports_VDP_Control   $BF


; =========================================================
;  Input Bitfield
; ---------------------------------------------------------
;The control code haven't been altered in any way.
;Instead, these defines tell SPASM-ng to interpret the 
;SMS button code as keys on the TI-84+ CE to make it way
;easier to customize the controls.
BTN_UP_BIT = kbitUp
BTN_DOWN_BIT = kbitDown
BTN_LEFT_BIT = kbitLeft
BTN_RIGHT_BIT = kbitRight
BTN_1_BIT = kbit2nd	
BTN_2_BIT = kbitAlpha

BTN_UP = kbdUp
BTN_DOWN = kbdDown
BTN_LEFT = kbdLeft
BTN_RIGHT = kbdRight
BTN_1 = kbd2nd
BTN_2 = kbdAlpha


; =========================================================
;  Display Mode Bitfields
; ---------------------------------------------------------
#define	VDP_DispMode_M1			$01
#define	VDP_DispMode_M2			$02
#define	VDP_DispMode_M3			$04
#define	VDP_DispMode_M4			$08
;SMS mode, 224-line display
#define	VDP_DispMode_SMS_224	VDP_DispMode_M4 | VDP_DispMode_M2 | VDP_DispMode_M1
;SMS mode, 240-line display
#define	VDP_DispMode_SMS_240	VDP_DispMode_M4 | VDP_DispMode_M3 | VDP_DispMode_M2

; =========================================================
;  Mode Control Register 1 (VDP R0) Flags
; ---------------------------------------------------------
#define	VDP_SyncEnableBit		$01
#define	VDP_ExtraHeightBit		$02
#define	VDP_Mode4Bit			$04
#define	VDP_SpriteShiftBit		$08
#define	VDP_LineInterruptsBit	$10
#define	VDP_MaskColumn0Bit		$20
#define	VDP_HScrollBit			$40
#define	VDP_VScrollBit			$80

; =========================================================
;  Mode Control Register 2 (VDP R1) Flags
; ---------------------------------------------------------
#define	VDP_SpriteDoublingBit	$01
#define	VDP_LargeSpritesBit		$02
#define	VDP_240LineSelectBit	$08
#define	VDP_224LineSelectBit	$10
#define	VDP_FrameInterruptsBit	$20
#define	VDP_DisplayVisibleBit	$40



#define    VDP_ScreenMap           $3800
#define    VDP_SATAddress          $3F00

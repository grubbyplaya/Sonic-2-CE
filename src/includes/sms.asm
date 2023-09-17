; =========================================================
;  IO Ports
; ---------------------------------------------------------
#define    Ports_GG_Start      $00

#define    Ports_IO_Control    $3F

#define    Ports_IO1           $DC
#define    Ports_IO2           $DD

#define    Ports_VDP_VCounter  $7E
#define    Ports_VDP_HCounter  $7F

#define    Ports_VDP_Data      $BE
#define    Ports_VDP_Control   $BF


; =========================================================
;  Input Bitfield
; ---------------------------------------------------------

#define    BTN_UP_BIT          $00
#define    BTN_DOWN_BIT        $01
#define    BTN_LEFT_BIT        $02
#define    BTN_RIGHT_BIT       $03
#define    BTN_1_BIT           $04
#define    BTN_2_BIT           $05

#define    BTN_UP              1 << BTN_UP_BIT
#define    BTN_DOWN            1 << BTN_DOWN_BIT
#define    BTN_LEFT            1 << BTN_LEFT_BIT
#define    BTN_RIGHT           1 << BTN_RIGHT_BIT
#define    BTN_1               1 << BTN_1_BIT
#define    BTN_2               1 << BTN_2_BIT

; =========================================================
;  Display Mode Bitfields
; ---------------------------------------------------------
#define	VDP_DispMode_M1		$01
#define	VDP_DispMode_M2		$02
#define	VDP_DispMode_M3		$04
#define	VDP_DispMode_M4		$08
;SMS mode, 224-line display
#define	VDP_DispMode_SMS_224	VDP_DispMode_M4 | VDP_DispMode_M2 | VDP_DispMode_M1
;SMS mode, 240-line display
#define	VDP_DispMode_SMS_240	VDP_DispMode_M4 | VDP_DispMode_M3 | VDP_DispMode_M2

; =========================================================
;  Mode Control Register 1 (VDP R0) Flags
; ---------------------------------------------------------
#define	VDP_SyncEnableBit	$01
#define	VDP_ExtraHeightBit	$02
#define	VDP_Mode4Bit		$04
#define	VDP_SpriteShiftBit	$08
#define	VDP_LineInterruptsBit	$10
#define	VDP_MaskColumn0Bit	$20
#define	VDP_HScrollBit		$40
#define	VDP_VScrollBit		$80

; =========================================================
;  Mode Control Register 2 (VDP R1) Flags
; ---------------------------------------------------------
#define	VDP_SpriteDoublingBit	$01
#define	VDP_LargeSpritesBit	$02
#define	VDP_240LineSelectBit	$08
#define	VDP_224LineSelectBit	$10
#define	VDP_FrameInterruptsBit	$20
#define	VDP_DisplayVisibleBit	$40

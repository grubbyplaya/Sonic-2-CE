; =============================================================================
;  Global Engine Definitions
; -----------------------------------------------------------------------------
;  Constant values used throughout the program code.
; -----------------------------------------------------------------------------


; ---------------------------------------------------------
;  Timing Definitions (based on 60hz display)
; ---------------------------------------------------------
#define  Time_1Second              60
#define  Time_2Seconds             120
#define  Time_3Seconds             180

; ---------------------------------------------------------
;  Global Triggers Bitfield
; ---------------------------------------------------------
#define  GT_BIT_0                  0
#define  GT_BIT_1                  1
#define  GT_TITLECARD_BIT          2
#define  GT_KILL_PLAYER_BIT        3
#define  GT_NEXT_LEVEL_BIT         4
#define  GT_NEXT_ACT_BIT           5
#define  GT_GAMEOVER_BIT           6
#define  GT_END_SEQUENCE_BIT       7

#define  GT_0                      1 << GT_BIT_0
#define  GT_1                      1 << GT_BIT_1
#define  GT_TITLECARD              1 << GT_TITLECARD_BIT
#define  GT_KILL_PLAYER            1 << GT_KILL_PLAYER_BIT
#define  GT_NEXT_LEVEL             1 << GT_NEXT_LEVEL_BIT
#define  GT_NEXT_ACT               1 << GT_NEXT_ACT_BIT
#define  GT_GAMEOVER               1 << GT_GAMEOVER_BIT
#define  GT_END_SEQUENCE           1 << GT_END_SEQUENCE_BIT

; ---------------------------------------------------------
;  Monitor Types
; ---------------------------------------------------------
#define  MonitorType_None0         0
#define  MonitorType_None1         1
#define  MonitorType_Rings         2

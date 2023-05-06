Logic_Sonic:        ;$A6A6
.dl DATA_B31_A70E       ;$00
.dl Sonic_State_01      ;$01
.dl Sonic_State_02      ;$02
.dl Sonic_State_03      ;$03
.dl Sonic_State_04      ;$04
.dl Sonic_State_05      ;$05
.dl Sonic_State_06      ;$06
.dl Sonic_State_07      ;$07
.dl Sonic_State_08      ;$08
.dl Sonic_State_09      ;$09
.dl Sonic_State_0A      ;$0A
.dl Sonic_State_0B      ;$0B
.dl DATA_B31_A78E       ;$0C
.dl Sonic_State_0D      ;$0D
.dl Sonic_State_0E      ;$0E
.dl DATA_B31_A819       ;$0F
.dl DATA_B31_A863       ;$10
.dl DATA_B31_A875       ;$11
.dl DATA_B31_A87B       ;$12
.dl DATA_B31_A895       ;$13
.dl DATA_B31_A8A7       ;$14
.dl DATA_B31_A8B9       ;$15
.dl DATA_B31_A8CB       ;$16
.dl DATA_B31_A8D5       ;$17
.dl Sonic_State_01      ;$18
.dl DATA_B31_A71A       ;$19
.dl DATA_B31_A993       ;$1A
.dl DATA_B31_A772       ;$1B
.dl DATA_B31_A788       ;$1C
.dl DATA_B31_A8DD       ;$1D
.dl DATA_B31_A8E5       ;$1E
.dl DATA_B31_A8EB       ;$1F
.dl DATA_B31_A903       ;$20
.dl DATA_B31_A90B       ;$21
.dl DATA_B31_A921       ;$22
.dl DATA_B31_A937       ;$23
.dl DATA_B31_A953       ;$24
.dl DATA_B31_A987       ;$25
.dl DATA_B31_A99D       ;$26
.dl DATA_B31_A9B7       ;$27
.dl DATA_B31_A8F1       ;$28
.dl DATA_B31_A9D1       ;$29
.dl DATA_B31_A9D1       ;$2A
.dl DATA_B31_A9D1       ;$2B
.dl DATA_B31_A9E9       ;$2C
.dl DATA_B31_AA09       ;$2D
.dl DATA_B31_AA31       ;$2E
.dl DATA_B31_AB7A       ;$2F
.dl DATA_B31_AB84       ;$30
.dl DATA_B31_AA97       ;$31
.dl DATA_B31_AAB1       ;$32
.dl DATA_B31_AAF6       ;$33

DATA_B31_A70E:
.db $FF, $02
    .dl LABEL_200 + $66
.db $FF, $03
Sonic_State_01:        ;$A714
.db $08, $0A
    .dl VF_Player_HandleStanding
.db $FF, $00

DATA_B31_A71A:
.db $10, $5F
    .dl VF_Player_HandleBalance
.db $10, $60
    .dl VF_Player_HandleBalance
.db $FF, $00

Sonic_State_02:        ;$A724
.db $10, $08
    .dl VF_Player_HandleIdle
.db $10, $09
    .dl VF_Player_HandleIdle
.db $FF, $00
DATA_B31_A73E:
.db $FF, $00

Sonic_State_03:        ;$A730
.db $06, $0B
    .dl VF_Player_HandleLookUp
.db $FF, $00

Sonic_State_04:        ;$A736
.db $06, $10
    .dl VF_Player_HandleCrouched
.db $FF, $00

Sonic_State_05:        ;$A73C
.db $FF, $07
    .dl VF_Player_ChangeFrameDisplayTime
    .dl VF_Player_HandleWalk
.db $FF, $00

Sonic_State_06:        ;$A744
.db $04, $0C
    .dl VF_Player_HandleRunning
.db $04, $0D
    .dl VF_Player_HandleRunning
.db $04, $0E
    .dl VF_Player_HandleRunning
.db $04, $0F
    .dl VF_Player_HandleRunning
.db $FF, $00

Sonic_State_07:        ;$A756
.db $08, $16
    .dl VF_Player_HandleSkidRight
.db $08, $17
    .dl VF_Player_HandleSkidRight
.db $FF, $00

Sonic_State_08:        ;$A760
.db $08, $16
    .dl VF_Player_HandleSkidLeft
.db $08, $17
    .dl VF_Player_HandleSkidLeft
.db $FF, $00

Sonic_State_09:        ;$A76A
.db $FF, $07
    .dl VF_Player_Anim_CalcBalanceFrame
    .dl VF_Player_HandleRolling
.db $FF, $00

DATA_B31_A772:
.db $FF, $07
    .dl VF_Player_Anim_CalcBalanceFrame
    .dl LABEL_200 + $E1
.db $FF, $00

Sonic_State_0A:        ;$A77A
.db $FF, $07
    .dl    VF_Player_Anim_CalcBalanceFrame
    .dl VF_Player_HandleJumping
.db $FF, $00

Sonic_State_0B:        ;$A782
.db $08, $1D
    .dl VF_Player_HandleVerticalSpring
.db $FF, $00

DATA_B31_A788:
.db $08, $1D
    .dl VF_Player_HandleDiagonalSpring
.db $FF, $00

DATA_B31_A78E:        ;loop state
.db $FF, $07
    .dl VF_Player_CalculateLoopFrame
    .dl LABEL_200 + $B4
.db $FF, $00


;called when sonic is at bottom of a loop.
;makes sonic move backwards
Sonic_State_0D:        ;$A796
.db $03, $01
    .dl VF_Player_SetState_MoveBack
.db $FF, $00

Sonic_State_0E:        ;$A79C
.db $08, $01
    .dl VF_Player_HandleFalling
.db $08, $02
    .dl VF_Player_HandleFalling
.db $08, $03
    .dl VF_Player_HandleFalling
.db $08, $04
    .dl VF_Player_HandleFalling
.db $08, $05
    .dl VF_Player_HandleFalling
.db $08, $06
    .dl VF_Player_HandleFalling
.db $08, $01
    .dl VF_Player_HandleFalling
.db $08, $02
    .dl VF_Player_HandleFalling
.db $08, $03
    .dl VF_Player_HandleFalling
.db $08, $04
    .dl VF_Player_HandleFalling
.db $08, $05
    .dl VF_Player_HandleFalling
.db $08, $06
    .dl VF_Player_HandleFalling
.db $08, $01
    .dl VF_Player_HandleFalling
.db    $08, $02
    .dl VF_Player_HandleFalling
.db $08, $03
    .dl VF_Player_HandleFalling
.db $08, $04
    .dl VF_Player_HandleFalling
.db    $08, $05
    .dl VF_Player_HandleFalling
.db $08, $06
    .dl VF_Player_HandleFalling
.db $08, $01
    .dl VF_Player_HandleFalling
.db $08, $02
    .dl VF_Player_HandleFalling
.db $08, $03
    .dl VF_Player_HandleFalling
.db $08, $04
    .dl VF_Player_HandleFalling
.db $08, $05
    .dl VF_Player_HandleFalling
.db $08, $06
    .dl VF_Player_HandleFalling
.db $08, $01
    .dl VF_Player_HandleFalling
.db    $08, $02
    .dl VF_Player_HandleFalling
.db $08, $03
    .dl VF_Player_HandleFalling
.db $08, $04
    .dl VF_Player_HandleFalling
.db $08, $05
    .dl VF_Player_HandleFalling
.db $08, $06
    .dl VF_Player_HandleFalling
.db $FF, $00

DATA_B31_A819:
.db $06, $4B
    .dl VF_Player_Nop
.db $06, $4C
    .dl VF_Player_Nop
.db $06, $4D
    .dl VF_Player_Nop
.db $06, $4E
    .dl VF_Player_Nop
.db $06, $4F
    .dl VF_Player_Nop
.db $06, $50
    .dl VF_Player_Nop
.db $06, $4B
    .dl VF_Player_Nop
.db $06, $4C
    .dl VF_Player_Nop
.db $06, $4D
    .dl VF_Player_Nop
.db $06, $4E
    .dl VF_Player_Nop
.db $06, $4F
    .dl VF_Player_Nop
.db $06, $50
    .dl VF_Player_Nop
.db $06, $51
    .dl VF_Player_Nop
.db $06, $52
    .dl VF_Player_Nop
.db $06, $53
    .dl VF_Player_Nop
.db $06, $4E
    .dl VF_Player_Nop
.db $06, $4F
    .dl VF_Player_Nop
.db $06, $50
    .dl VF_Player_Nop
.db $FF, $00

DATA_B31_A863:
.db $04, $54
    .dl LABEL_200 + $C9
.db $04, $55
    .dl LABEL_200 + $C9
.db $04, $56
    .dl LABEL_200 + $C9
.db $04, $57
    .dl LABEL_200 + $C9
.db $FF, $00

DATA_B31_A875:
.db $06, $44
    .dl LABEL_200 + $96
.db $FF, $00

DATA_B31_A87B:
.db $06, $42
    .dl LABEL_200 + $9C
.db $06, $43
    .dl LABEL_200 + $9C
.db $06, $44
    .dl LABEL_200 + $9C
.db $06, $45
    .dl LABEL_200 + $9C
.db $06, $46
    .dl LABEL_200 + $9C
.db $06, $47
    .dl LABEL_200 + $9C
.db $FF, $00

DATA_B31_A895:
.db $06, $3F
    .dl LABEL_200 + $93
.db $06, $40
    .dl LABEL_200 + $93
.db $06, $3F
    .dl LABEL_200 + $93
.db $06, $41
    .dl LABEL_200 + $93
.db $FF, $00

DATA_B31_A8A7:
.db $06, $3C
    .dl LABEL_200 + $99
.db $06, $3D
    .dl LABEL_200 + $99
.db $06, $3C
    .dl LABEL_200 + $99
.db $06, $3E
    .dl LABEL_200 + $99
.db $FF, $00

DATA_B31_A8B9:
.db $06, $48
    .dl LABEL_200 + $90
.db $06, $49
    .dl LABEL_200 + $90
.db $06, $48
    .dl LABEL_200 + $90
.db $06, $4A
    .dl LABEL_200 + $90
.db $FF, $00

DATA_B31_A8CB:
.db $08, $58
    .dl LABEL_200 + $D2
.db $FF, $02
    .dl LABEL_200 + $81
.db $FF, $03
DATA_B31_A8D5:
.db $FF, $07
    .dl LABEL_200 + $DB
    .dl LABEL_200 + $D5
.db $FF, $00

DATA_B31_A8DD:
.db $FF, $07
    .dl VF_Player_CalculateLoopFallFrame
    .dl LABEL_200 + $C0
.db $FF, $00

DATA_B31_A8E5:
.db $06, $1B
    .dl LABEL_200 + $8A
.db $FF, $00 

DATA_B31_A8EB:
.db $80, $63
    .dl LABEL_200 + $87
.db $FF, $00

DATA_B31_A8F1:
.db $08, $18
    .dl LABEL_200 + $108
.db $08, $19
    .dl LABEL_200 + $108
.db $FF, $06
    .db $0A
    .dw $0000
    .dw $0000
    .db $03
.db    $FF, $00

DATA_B31_A903:
.db $FF, $07
    .dl VF_Player_ChangeFrameDisplayTime
    .dl VF_Player_HandleEndOfLevel
.db $FF, $00

DATA_B31_A90B:
.db $03, $11
    .dl LABEL_200 + $AE
.db $03, $12
    .dl LABEL_200 + $AE
.db $03, $13
    .dl LABEL_200 + $AE
.db $03, $14
    .dl LABEL_200 + $AE
.db $03, $15
    .dl LABEL_200 + $AE
.db $FF, $00

DATA_B31_A921:
.db $03, $11
    .dl LABEL_200 + $A2
.db $03, $12
    .dl LABEL_200 + $A2
.db $03, $13
    .dl LABEL_200 + $A2
.db $03, $14
    .dl LABEL_200 + $A2
.db $03, $15
    .dl LABEL_200 + $A2
.db $FF, $00

DATA_B31_A937:
.db $FF, $04
    .dw $0000
    .dw $0000
.db $03, $11 
    .dl VF_DoNothing
.db $03, $12
    .dl VF_DoNothing
.db $03, $13 
    .dl VF_DoNothing
.db $03, $14
    .dl VF_DoNothing
.db $03, $15 
    .dl VF_DoNothing
.db $FF, $00

DATA_B31_A953:
.db $FF, $04
    .dw $0000
    .dw $0000
.db $FF, $07 
    .dl LABEL_B31_A967
    .dl LABEL_200 + $E7
.db $FF, $07
    .dl LABEL_B31_A96E
    .dl LABEL_200 + $E7
.db $FF, $00


LABEL_B31_A967:
    ld    (ix + Object.AnimFrame), $61
    jp    LABEL_B31_A972

LABEL_B31_A96E:
    ld    (ix + Object.AnimFrame), $62
LABEL_B31_A972:
    ld    b, $0C
    ld    a, (Engine_InputFlags)
    and   $03
    jp    z, LABEL_B31_A972
    ld    b, $10
    and   $01
    jp    z, LABEL_B31_A972
    ld    b, $08
    ld    (ix + Object.FrameCounter), b
    ret


DATA_B31_A987:
.db $0C, $1A
    .dl LABEL_200 + $EA
.db $FF, $05 
    .db $0E
.db $FF, $00

;/***************************************** */
;FIXME:
;    These commands will execute jumps to    ;
;    $1C08 and $00FF which are invalid.        ;
;    Check to see if these are used!!        ;
;/***************************************** */
DATA_B31_A993:
.db $08, $1B
.db $FF, $02
    .db $08, $1C
.db $FF, $02
    .db $FF, $00
;/***************************************** */

DATA_B31_A99D:
.db $08, $01
    .dl LABEL_B31_AB34
.db $08, $02
    .dl LABEL_B31_AB34
.db $08, $03
    .dl LABEL_B31_AB34
.db $08, $04
    .dl LABEL_B31_AB34
.db $08, $05
    .dl LABEL_B31_AB34
.db $08, $06
    .dl LABEL_B31_AB34
.db $FF, $00

DATA_B31_A9B7:
.db $08, $01
    .dl LABEL_B31_AB4C
.db $08, $02
    .dl LABEL_B31_AB4C
.db $08, $03
    .dl LABEL_B31_AB4C
.db $08, $04
    .dl LABEL_B31_AB4C
.db $08, $05
    .dl LABEL_B31_AB4C
.db $08, $06
    .dl LABEL_B31_AB4C
.db $FF, $00

DATA_B31_A9D1:
.db $FF, $04 
    .dw $0400
    .dw $0000
.db $04, $0C
    .dl LABEL_B31_AA41
.db $04, $0D
    .dl LABEL_B31_AA41
.db $04, $0E
    .dl LABEL_B31_AA41
.db $04, $0F
    .dl LABEL_B31_AA41
.db $FF, $00

DATA_B31_A9E9:
.db $FF, $04 
    .dw $0100
    .dw $0000
.db $08, $01
    .dl LABEL_B31_AA54
.db $08, $02
    .dl LABEL_B31_AA54
.db $08, $03
    .dl LABEL_B31_AA54
.db $08, $04
    .dl LABEL_B31_AA54
.db $08, $05
    .dl LABEL_B31_AA54
.db $08, $06
    .dl LABEL_B31_AA54
.db $FF, $00

DATA_B31_AA09:
.db $FF, $04 
    .dw $0000
    .dw $0000
.db $FF, $02 
    .dl LABEL_B31_AA37
.db $08, $16
    .dl VF_DoNothing
.db $08, $17
    .dl VF_DoNothing
.db $08, $16
    .dl VF_DoNothing
.db $08, $17
    .dl VF_DoNothing
.db $FF, $02
    .dl LABEL_B31_AA3C
.db $E0, $0B
    .dl VF_DoNothing
.db $E0, $0B
    .dl LABEL_B31_AA6D
.db $FF, $00

DATA_B31_AA31:
.db $E0, $0B
    .dl VF_DoNothing
.db $FF, $00


LABEL_B31_AA37:
    set     4, (ix + Object.Flags04)
    ret

LABEL_B31_AA3C:
    res     4, (ix + Object.Flags04)
    ret

LABEL_B31_AA41:
    call    LABEL_B31_AA81
    ld      a, (gameMem+$D46D)
    cp      $04
    ret     nz
    ld      (ix + Object.StateNext), $2C
    ld      a, $0A
    ld      (gameMem+$D702), a
    ret     

LABEL_B31_AA54:
    call    LABEL_B31_AA81
    ld      hl, (Camera_X)
    ld      de, $0008
    xor     a
    sbc     hl, de
    ld      a, h
    or      l
    ret     nz
    ld      (ix + Object.StateNext), $2D
    ld      a, $02
    ld      (gameMem+$D702), a
    ret

LABEL_B31_AA6D:
    ld      bc, (Camera_X)
    ld      de, $0008
    call    VF_Engine_SetCameraAndLock
    ld      (ix + Object.StateNext), $2E
    ld      a, $03
    ld      (gameMem+$D702), a
    ret

LABEL_B31_AA81
    call    VF_Engine_UpdateObjectPosition
    ld      hl, (Player.X)
    ld      de, -144
    add     hl, de
    ld      a, h
    and     1
    ld      h, a
    ld      de, $0090
    add     hl, de
    ld      (Player.X), hl
    ret     

    
DATA_B31_AA97:
.db $06, $01
    .dl LABEL_B31_AB06
.db $06, $02
    .dl LABEL_B31_AB06
.db $06, $03
    .dl LABEL_B31_AB06
.db $06, $04
    .dl LABEL_B31_AB06
.db $06, $05
    .dl LABEL_B31_AB06
.db $06, $06
    .dl LABEL_B31_AB06
.db $FF, $00

DATA_B31_AAB1:
.db $80, $0B
    .dl VF_DoNothing
.db $80, $0B
    .dl VF_DoNothing
.db $C0, $0B
    .dl VF_DoNothing
.db $C0, $0B
    .dl VF_DoNothing
.db $80, $10
    .dl VF_DoNothing
.db $04, $0A
    .dl VF_DoNothing
.db $08, $10
    .dl VF_DoNothing
.db $04, $0A
    .dl VF_DoNothing
.db $80, $0B
    .dl VF_DoNothing
.db $A0, $0B
    .dl VF_DoNothing
.db $A0, $0A
    .dl VF_DoNothing
.db $80, $0A
    .dl VF_DoNothing
.db $10, $09
    .dl VF_DoNothing
.db $10, $08
    .dl VF_DoNothing
.db $FF, $02
    .dl Logic_Sonic_LoadNextLevel
.db $FF, $05
    .db $33
.db $10, $08
    .dl VF_DoNothing
.db $FF, $00

DATA_B31_AAF6:
.db $10, $09
    .dl VF_DoNothing
.db $10, $08
    .dl VF_DoNothing
.db $FF, $00


Logic_Sonic_LoadNextLevel:      ; $AB00
    ld      hl, GlobalTriggers
    set     GT_NEXT_LEVEL_BIT, (hl)
    ret


LABEL_B31_AB06:
    res     4, (ix + Object.Flags04)
    ld      hl, $0200
    ld      (ix + Object.VelX), l
    ld      (ix + Object.VelX + 1), h
 
    ld      hl, $0300
    ld      (ix + Object.VelY), l
    ld      (ix + Object.VelY + 1), h

    call    LABEL_200 + $60
    call    VF_Engine_UpdateObjectPosition

    ld      l, (ix + Object.X)
    ld      h, (ix + Object.X + 1)
    ld      de, $0450
    xor     a
    sbc     hl, de
    ret     c
    ld      (ix + Object.StateNext), $32
    ret     


LABEL_B31_AB34:
    call    LABEL_B31_AB64
    ld      l, (ix + Object.Y)
    ld      h, (ix + Object.Y + 1)
    ld      de, $0190
    xor     a
    sbc     hl, de
    ret     c
    ld      (ix + Object.StateNext), PlayerState_Falling
    call    VF_Engine_LockCamera
    ret     


LABEL_B31_AB4C:
    call    LABEL_B31_AB64
    ld      l, (ix + Object.Y)
    ld      h, (ix + Object.Y + 1)
    ld      de, $0260
    xor     a
    sbc     hl, de
    ret     c
    ld      (ix + Object.StateNext), PlayerState_Falling
    call    VF_Engine_LockCamera
    ret     

LABEL_B31_AB64:
    call    VF_Engine_UpdateObjectPosition
    ld      de, $0020
    ld      bc, $0500
    call    VF_Engine_SetObjectVerticalSpeed
    ld      bc, $0000
    ld      (ix + Object.VelX), c        ;set horizontal speed to 0
    ld      (ix + Object.VelX + 1), b
    ret     

DATA_B31_AB7A:
.db $10, $08
    .dl LABEL_B31_ABA2
.db $10, $09
    .dl LABEL_B31_ABA2
.db $FF, $00

DATA_B31_AB84:
.db $FF, $07
    .dl LABEL_B31_AB8C
    .dl LABEL_B31_ABC6
.db $FF, $00

LABEL_B31_AB8C:
    ld      hl, Player.ix2F
    inc     (hl)
    ld      a, (hl)
    cp      $04
    jr      c, +_
    xor     a
    ld      (hl), a
    
_:  add     a, $0C            ;set player animation = running
    ld      (Player.AnimFrame), a
    
    ld      a, $04            ;set frame display timer
    ld      (Player.FrameCounter), a
    ret     


LABEL_B31_ABA2:
    ld      hl, $0080        ;set player's hpos
    ld      (Player.X), hl

    ld      hl, $00A0        ;set player's vpos
    ld      (Player.Y), hl

    ld      hl, $0000
    ld      (Player.VelX), hl        ;set player's horiz & vert speed to 0
    ld      (Player.VelY), hl

    ld      a, (gameMem+$D2BD)        ;check level timer frame counter
    bit     7, a
    ret     z                ;return if value is positive

    ld      (ix + Object.StateNext), $30
    ld      (ix + Object.ix1F), $00
    ret     


LABEL_B31_ABC6:
    inc     (ix + Object.ix1F)
    ld      a, (ix + Object.ix1F)
    cp      $78
    ret     c
    ld      (ix + Object.ix1F), $78
    ld      hl, (Player.VelX)        ;player's horizontal speed
    ld      de, $00A0
    add     hl, de
    ld      (Player.VelX), hl
    call    VF_Engine_UpdateObjectPosition
    ret

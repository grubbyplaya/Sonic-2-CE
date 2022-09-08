#macro Sound_IsChannelActive
	bit  Sound_ChannelActiveBit, (ix + Sound_ChnlControl)
#endmacro


#macro Rest
    .db $80
#endmacro


#macro Detune
    .db $E1, \1
#endmacro


#macro AdjustVolume
    .db $E6, \1
#endmacro


#macro RepeatLast
    .db $E7, \1
#endmacro


#macro SetGlblSpeed
    .db $ED, \1
#endmacro


#macro PitchBend
    .db $F0, \1, \2, \3, \4
#endmacro

#macro Stop
    .db $F2
#endmacro


#macro VolumeEnvelope       ;VolumeEffect
    .db $F5, \1
#endmacro


#macro Jump
    .db $F6
    .dw \1
#endmacro


#macro Loop
    .db $F7
    .db \1
    .db \2
    .dw \3
#endmacro


#macro Branch
    .db $F8
    .dw \1
#endmacro


#macro Return
    .db $F9
#endmacro


#macro SetChnlSpeed
    .db $FA, \1
#endmacro


#macro PitchAdjust
    .db $FB, \1
#endmacro


#macro ReadLiteral
    .db $FD, \1
#endmacro


#macro ReadLiteral_On
    .db $FD, 1
#endmacro


#macro ReadLiteral_Off
    .db $FD, 0
#endmacro

; ---------------------------------------------------------
;  RAM Variables
; ---------------------------------------------------------

; If the reset trigger is not 0, for each iteration of the game loop
; the trigger value is decremented and the PSG is intialised.
; If ($0 < value < $80) the sound driver is disabled.
#define    Sound_SpeedCounter          $DD01
#define    Sound_Speed                 $DD02   ; the speed counter reset value
#define    Sound_CurrentMusic          $DD03
#define    Sound_MusicTrigger1         $DD04
#define    Sound_MusicTrigger2         $DD05
#define    Sound_MusicTrigger3         $DD06

#define    Sound_ResetTrg              $DD08
#define    Sound_FadeMajorCount        $DD09
#define    Sound_FadeMinorCount        $DD0A
#define    Sound_FadeMinorReset        $DD0B

#define    Sound_SFXIndex              $DD0D   ; copy of the current sound effect number (see $81C7)

#define    Sound_Priority              $DD0F

; $DD11 - last noise channel command data ($86CF) ?

; $DD15 - something to do with noise channel data?
#define    Sound_NoiseChnlVolume       $DD16   ; noise channel attenuation

; ---------------------------------------------------------
;  Channel Structure Offsets
; ---------------------------------------------------------
#define    Sound_ChnlControl           $00
#define    Sound_ChnlNumber            $01
#define    Sound_ChnlSpeed             $02
#define    Sound_ChnlNextCommand       $03

#define    Sound_ChnlPitchAdjust       $05
#define    Sound_ChnlVolumeAdjust      $06

#define    Sound_ToneEffectFlags       $07     ; if MSB is set the effect is a pitch bend, otherwise it's an envelope.
#define    Sound_VolumeEffectFlags     $08
#define    Sound_ChnlStackPointer      $09		; used as a stack pointer. channel stack starts at (channel + 2F)
#define    Sound_ChnlToneDuration      $0A		; tone duration counter. decremented with each loop
#define    Sound_ChnlToneData          $0B		; Read by routine at $82D0 and written to the PSG.
#define    Sound_ChnlToneDuration_Next $0D		; next tone duration value

#define    Sound_PitchBendDataPtr      $10     ; pointer to data for the pitch bend effect
#define    Sound_ChnlToneAdjustment    $12     ; tone adjustment value (2 bytes). added to value at offset $0B

#define    Sound_PitchBendCountdown    $14     ; countdown value before applying pitch bend effect
#define    Sound_PitchBendLength       $15     ; number of ticks between changing the pitch adjustment value
#define    Sound_PitchBendStepValue    $16     ; value to add to the tone with each application of the effect
#define    Sound_PitchBendRepeat       $17     ; number of times to repeat the effect before negating the step value

#define    Sound_PitchEnvlpIndex       $15     ; note: same offset as Sound_PitchBendLength.

; $1D - flags

#define    Sound_ChnlVolume            $1F
#define    Sound_VolEnvlpIndex         $1F     ; note: shared with Sound_ChnlVolume

; volume effects
#define    Sound_ChnlVolEffectAdjust   $20

#define	Sound_ChnlDetune        	$25		; added to the tone data before writing to the PSG

#define    Sound_ChnlLoopCounters      $27     ; 3 loop counters are available
#define    Sound_ChnlLoopCounter0      Sound_ChnlLoopCounters
#define    Sound_ChnlLoopCounter1      Sound_ChnlLoopCounter0 + 1      
#define    Sound_ChnlLoopCounter2      Sound_ChnlLoopCounter1 + 1

#define    Sound_ChnlBranchSlots       $2A
#define    Sound_ChnlBranchSlot2       Sound_ChnlBranchSlots
#define    Sound_ChnlBranchSlot1       $2C
#define    Sound_ChnlBranchSlot0       $2E


; ---------------------------------------------------------
;  Channel control bits
; ---------------------------------------------------------
#define    Sound_ChnlKeepStateBit      1
#define    Sound_ChnlKeepState         1 << Sound_ChnlKeepStateBit

#define    Sound_ChannelSuppressBit    2
#define    Sound_ChannelSuppress       1 << Sound_ChannelSuppressBit

; if set the next word in the channel data stream is the literal
; tone data value which should be copied into (IX+$0B)
#define    Sound_ChnlReadLiteralBit    3
#define    Sound_ChnlReadLiteral       1 << Sound_ChnlReadLiteralBit

#define    Sound_ChnlVolSuppressBit    4
#define    Sound_ChnlVolSuppress       1 << Sound_ChnlVolSuppressBit

#define    Sound_ChnlVolumeOnlyBit     6
#define    Sound_ChnlVolumeOnly        1 << Sound_ChnlVolumeOnlyBit

#define	Sound_ChannelActiveBit	    7
#define	Sound_ChannelActive		    1 << Sound_ChannelActiveBit


; ---------------------------------------------------------
;  Tone Flag bits
; ---------------------------------------------------------
#define    Sound_ChnlPitchBendBit      7
#define    Sound_ChnlPitchBend         1 << Sound_ChnlPitchBendBit


; ---------------------------------------------------------
;  Volume Flag bits
; ---------------------------------------------------------
#define    Sound_VolPreserveBit        7
#define    Sound_VolPreserve           1 << Sound_VolPreserveBit


; ---------------------------------------------------------
;  PSG Command Bits
; ---------------------------------------------------------
#define    Sound_PSG_Latch             $80
#define    Sound_PSG_Tone0             $00
#define    Sound_PSG_Tone1             1 << 5
#define    Sound_PSG_Tone2             2 << 5
#define    Sound_PSG_Noise             3 << 5
#define    Sound_PSG_Type_Volume       $10


; ---------------------------------------------------------
;  Channel Structure Locations
; ---------------------------------------------------------
#define    Sound_ChannelSize       $30
.enum $DD40
	Sound_Channel_Music_0		dsb	Sound_ChannelSize   ; $DD40
	Sound_Channel_Music_1		dsb	Sound_ChannelSize   ; $DD70
	Sound_Channel_Music_2		dsb	Sound_ChannelSize   ; $DDA0
	Sound_Channel_Music_Noise	dsb	Sound_ChannelSize   ; $DDD0
    ;dsb $10
	Sound_Channel_SFX_0			dsb	Sound_ChannelSize   ; $DE00
	Sound_Channel_SFX_1			dsb	Sound_ChannelSize   ; $DE30
	Sound_Channel_SFX_2			dsb	Sound_ChannelSize   ; $DE60
.ende


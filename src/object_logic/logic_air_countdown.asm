Logic_AirCountdown:		;$B07A
.dl DATA_B31_B07E

DATA_B31_B07E:
.db $01, $00
	.dl AirCountdown_Init
.db $FF, $00

AirCountdown_Init:		;$B0B4
	ld		hl, ($D511)			;copy player's hpos
	ld      (ix+$11), l			;to this object
	ld      (ix+$12), h

	ld      hl, ($D514)			;copy player's vpos
	ld      bc, $FFDE			;subtract 34
	add     hl, bc
	ld      (ix+$14), l			;and set this object's vpos
	ld      (ix+$15), h

	ld      (ix+$08), $0E		;set vram tile indices
	ld      (ix+$09), $0E

	ld      (ix+$02), $01		;set state 01

	set     1, (ix+$04)
	ret     


AirCountdown_Update:		;$B0DB
	ld      hl, ($D511)			;copy player's hpos
	ld      (ix+$11), l			;to this object
	ld      (ix+$12), h

	ld      hl, ($D514)			;copy player's hpos
	ld      bc, $FFD8			;subtract 40
	add     hl, bc
	ld      (ix+$14), l			;and set as this object's hpos
	ld      (ix+$15), h
	
	res     7, (ix+$04)			;toggle the object's visibility
	bit     2, (ix+$07)
	jp      z, +_
	set     7, (ix+$04)

	ld      a, ($D469)			;check the air timer
	or      a
	ret     nz					;return if air timer != 0

	ld      (ix+$00), $FF		;destroy this object
	ret


AirCountdown_TimerExpired:		;$B109
	push    iy
	
	ld      iy, $D500			;set the player object's state
	ld      (iy+$02), PlayerState_Drowning
	
	set     0, (iy+$03)			;set flag - player in air

	ld      (iy+$04), $00
	
	ld      (iy+$18), $00		;reset player vertical speed
	ld      (iy+$19), $00

	ld      hl, $0000			;reset inertia?
	ld      ($D36F), hl

	res     1, (iy+$22)			;clear "collision at bottom" flag

	ld      ($DD04), a

	pop     iy

	ld      hl, ($D176)			;lock camera
	ld      ($D27E), hl

	ld      (ix+$00), $FF		;destroy object
	ret

Logic_AirCountdown:		;$B07A
.dl DATA_B31_B07E

DATA_B31_B07E:
.db $01, $00
	.dl AirCountdown_Init
.db $FF, $00

DATA_B31_B084:
.db $78, $06
	.dl AirCountdown_Update
.db $78, $05
	.dl AirCountdown_Update
.db $78, $04
	.dl AirCountdown_Update
.db $78, $03
	.dl AirCountdown_Update
.db $78, $02
	.dl AirCountdown_Update
.db $78, $01
	.dl AirCountdown_Update
.db $02, $01
	.dl AirCountdown_TimerExpired
.db $FF, $01

AirCountdown_Init:		;$B0B4
	ld	hl, (gameMem+$D511)			;copy player's hpos
	ld	(ix+$11), l			;to this object
	ld	(ix+$12), h

	ld	hl, (gameMem+$D514)			;copy player's vpos
	ld	bc, gameMem+$FFDE			;subtract 34
	add	hl, bc
	ld	(ix+$14), l			;and set this object's vpos
	ld	(ix+$15), h

	ld	(ix+$08), $0E		;set vram tile indices
	ld	(ix+$09), $0E

	ld	(ix+$02), $01		;set state 01

	set	1, (ix+$04)
	ret	


AirCountdown_Update:		;$B0DB
	ld	hl, (gameMem+$D511)			;copy player's hpos
	ld	(ix+$11), l			;to this object
	ld	(ix+$12), h

	ld	hl, (gameMem+$D514)			;copy player's hpos
	ld	bc, gameMem+$FFD8			;subtract 40
	add	hl, bc
	ld	(ix+$14), l			;and set as this object's hpos
	ld	(ix+$15), h
	
	res	7, (ix+$04)			;toggle the object's visibility
	bit	2, (ix+$07)
	jr	z, +_
	set	7, (ix+$04)

_:	ld	a, (gameMem+$D469)			;check the air timer
	or	a
	ret	nz					;return if air timer != 0

	ld	(ix+$00), $FF		;destroy this object
	ret


AirCountdown_TimerExpired:		;$B109
	push    iy
	
	ld	iy, gameMem+$D500			;set the player object's state
	ld	(iy+$02), PlayerState_Drowning
	
	set	0, (iy+$03)			;set flag - player in air

	ld	(iy+$04), $00
	
	ld	(iy+$18), $00		;reset player vertical speed
	ld	(iy+$19), $00

	ld	hl, $0000			;reset inertia?
	ld	(gameMem+$D36F), hl

	res	1, (iy+$22)			;clear "collision at bottom" flag

	ld	(gameMem+$DD04), a

	pop	iy

	ld	hl, (gameMem+$D176)		;lock camera
	ld	(gameMem+$D27E), hl

	ld	(ix+$00), $FF		;destroy object
	ret

Logic_WaterSplash:			;$B4D4
.dl WaterSplash_State_00
.dl WaterSplash_State_01

WaterSplash_State_00:		;$B4D8
.db $01, $00
	.dl WaterSplash_Init
.db $FF, $00

WaterSplash_State_01:		;$B4DE
.db $04, $01
	.dl WaterSplash_DoNothing
.db $08, $02
	.dl WaterSplash_DoNothing
.db $FF, $01


WaterSplash_Init:			;$B4EB
	ld	hl, (gameMem+$D511)		;copy player's hpos
	ld	(ix+$11), l		;to this object's hpos
	ld	(ix+$12), h

	ld	hl, (gameMem+$D514)		;get player's vpos
	ld	bc, $FFF0		;subtract 16
	add	hl, bc
	ld	a, l
	and	$E0				;clear lower 5 bits (keep object
	ld	l, a			;on correct scanline)
	ld	(ix+$14), l		;set this object's vpos
	ld	(ix+$15), h

	ld	(ix+$08), $CC	;set the vram tile index

	ld	(ix+$02), $01	;set state 01

	set	0, (ix+$04)
	ret     

WaterSplash_DoNothing:		;$B512
	ret     

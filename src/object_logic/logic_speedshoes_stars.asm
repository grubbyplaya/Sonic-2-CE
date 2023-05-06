;****************************************************
;*	Logic for stars that surround Sonic with the	*
;*	speed shoes power-up.							*
;****************************************************
Logic_SpeedShoesStars:				;$AD38
.dl Logic_SpeedShoesStars_State0
.dl Logic_SpeedShoesStars_State1
.dl Logic_SpeedShoesStars_State2

Logic_SpeedShoesStars_State0:		;$AD3E
.db $01, $00
	.dl LABEL_B31_AD88
.db $FF, $00

Logic_SpeedShoesStars_State1:		;$AD44
.db $02, $01
	.dl LABEL_B31_ADB3
.db $02, $02
	.dl LABEL_B31_ADB3
.db $02, $03
	.dl LABEL_B31_ADB3
.db $02, $04
	.dl LABEL_B31_ADB3
.db $02, $05
	.dl LABEL_B31_ADB3
.db $02, $06
	.dl LABEL_B31_ADB3
.db $02, $07
	.dl LABEL_B31_ADB3
.db $02, $08
	.dl LABEL_B31_ADB3
.db $FF, $00

Logic_SpeedShoesStars_State2:		;$AD66
.db $02, $05
	.dl LABEL_B31_ADB3
.db $02, $06
	.dl LABEL_B31_ADB3
.db $02, $07
	.dl LABEL_B31_ADB3
.db $02, $08
	.dl LABEL_B31_ADB3
.db $02, $01
	.dl LABEL_B31_ADB3
.db $02, $02
	.dl LABEL_B31_ADB3
.db $02, $03
	.dl LABEL_B31_ADB3
.db $02, $04
	.dl LABEL_B31_ADB3
.db $FF, $00


LABEL_B31_AD88:
	ld	a, (ix+$3F)
	inc	a
	ld	(ix+$02), a
	set	0, (ix+$04)
	call	VF_Engine_MoveObjectToPlayer
	ld	a, (ix+$3F)
	or	a
	ret	nz
	ld	hl, gameMem+$D373
	ld	b, $08
_:	ld	de, (gameMem+$D511)			;player's horiz. position in level.
	ld	(hl), e
	inc	hl
	ld	(hl), d
	inc	hl
	ld	de, (gameMem+$D514)			;player's vert. position in level
	ld	(hl), e
	inc	hl
	ld	(hl), d
	inc	hl
	djnz	-_
	ret	

LABEL_B31_ADB3:
	ld	a, (gameMem+$D532)		;check for speed shoes power-up
	cp	$01
	jr	nz, ++_
	ld	a, (ix+$3F)
	or	a
	jr	nz, +_
	ld	hl, gameMem+$D38E
	ld	de, gameMem+$D392
	ld	bc, $001C
	lddr	
	ld	hl, (gameMem+$D511)			;player's horiz. position in level.
	ld	(gameMem+$D373), hl
	ld	hl, (gameMem+$D514)			;player's vert. position in level.
	ld	(gameMem+$D375), hl
_:	ld	a, (ix+$3F)
	ld	l, a
	add	a, a
	add	a, l
	ld	l, a
	ld	h, $00
	ld	de, DATA_B31_AE00
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	hl, ramStart
	add	hl, de
	ex	de, hl
	ld	a, (hl)			;set sprite's hpos
	ld	(ix+$11), a
	inc	hl
	ld	a, (hl)
	ld	(ix+$12), a
	inc	hl				;set sprite's vertical pos
	ld	a, (hl)
	ld	(ix+$14), a
	inc	hl
	ld	a, (hl)
	ld	(ix+$15), a
	ret	

_:	ld	(ix+$00), $FF
	ret	

DATA_B31_AE00:
.dl gameMem+$D37F
.dl gameMem+$D38F

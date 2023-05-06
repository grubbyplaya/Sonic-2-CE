Logic_InvincibilityStars:		;$AE04
.dl InvincibilityStars_State_00		;DATA_B31_AE0A
.dl InvincibilityStars_State_01
.dl InvincibilityStars_State_02

InvincibilityStars_State_00:	;$AE0A
.db $01, $00
	.dl InvincibilityStars_State_00_Logic_01
.db $FF, $00

InvincibilityStars_State_01:	;$AE10
.db $01, $01
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $02
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $03
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $04
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $05
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $06
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $07
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $08
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $09
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $0A
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $0B
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $0C
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $0D
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $0E
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $0F
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $10
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $11
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $12
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $13
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $14
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $15
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $16
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $17
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $18
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $19
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $1A
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $1B
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $1C
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $1D
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $1E
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $1F
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $20
	.dl InvincibilityStars_State_01_Logic_01
.db $FF, $00

InvincibilityStars_State_02:	;$AE92
.db $01, $05
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $06
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $07
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $08
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $09
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $0A
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $0B
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $0C
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $0D
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $0E
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $0F
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $10
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $11
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $12
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $13
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $14
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $15
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $16
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $17
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $18
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $19
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $1A
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $1B
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $1C
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $1D
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $1E
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $1F
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $20
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $01
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $02
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $03
	.dl InvincibilityStars_State_01_Logic_01
.db $01, $04
	.dl InvincibilityStars_State_01_Logic_01
.db $FF, $00

InvincibilityStars_State_00_Logic_01:	;$AF14
	ld      a, (ix+$3F)
	inc     a
	ld      (ix+$02), a
	set     0, (ix+$04)
	ld      hl, gameMem+$D503
	set     7, (hl)
	jp      VF_Engine_MoveObjectToPlayer


InvincibilityStars_State_01_Logic_01:	;$AF27
	ld      a, (gameMem+$D532)
	cp      $02
	jr      nz, +_
	ld      hl, gameMem+$D503
	set     7, (hl)
	jp      VF_Engine_MoveObjectToPlayer

_:	ld      (ix+$00), $FF
	ret    
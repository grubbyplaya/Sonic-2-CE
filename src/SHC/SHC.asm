#define Port_VDPAddress $BF
#define Port_VDPData	$BE
#define Port_VDPStatus	$BF
#define Port_IoPort1	$DC
.assume adl=0
.org $8000

Bank32:
	call LABEL_80280
	di
	call LABEL_80325
LABEL_8003A:
	ld hl, $C000
	ld.lil de, SegaVRAM+$77A0
	ld b, $1B
LABEL_80049:
	ld a, (hl)
	ld.lil (de), a
	xor a
	ld (hl), a
	inc hl
	inc.lil de
	djnz LABEL_80049
	exx
LABEL_80066:
	ld hl, DATA_803B2
	ld de, $0020
	call LABEL_8028F
LABEL_8007E:
	exx
	ld hl, DATA_820D2
	ld de, $3800
	call LABEL_8028F
LABEL_80096:
	ld a, $04
	ld ($C012), a
	ld a, $FF
	ld ($C01A), a
LABEL_800A9:
	call LABEL_801C4
	call LABEL_800F2
	call LABEL_8013F
	ld a, ($C012)
	or a
	jr nz, LABEL_800E5
	ld b, a
	ld a, ($C011)
	cp b
	jr nz, LABEL_800E5
	jp LABEL_80348

LABEL_800E5:
	exx
	ld a, b
	exx
	and $20
	jr z, LABEL_800A9
	xor a
	ld ($C012), a
	jr LABEL_800A9

LABEL_800F2:
	ld de, DATA_80382
	xor a
	ld ($C019), a
	ld hl, ($C015)
	inc hl
	ld ($C015), hl
	ld a, l
	add a, a
	jr nc, LABEL_80129
	ld a, h
	cp $03
	jr c, LABEL_80114
	xor a
	ld ($C012), a
	jr LABEL_80131

LABEL_80114:
	ld a, ($C018)
	and $30
	sub $10
	jr nc, LABEL_8011E
	xor a
LABEL_8011E:
	ld ($C019), a
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	jr LABEL_8013E

LABEL_80129:
	ld a, h
	dec a
	and $03
	sub $02
	jr c, LABEL_8013E
LABEL_80131:
	ld de, DATA_803A2
	ld a, $20
	ld ($C019), a
LABEL_8013E:
	ret

LABEL_8013F:
	ld hl, ($C010)
	ld a, ($C012)
	sub h
	jr nz, LABEL_8015B
	ld a, ($C013)
	cp e
	jr nz, LABEL_80154
	ld a, ($C014)
	cp d
	jr z, LABEL_8015A
LABEL_80154:
	ld a, ($C011)
	ld b, a
	jr LABEL_80167

LABEL_8015A:
	ret

LABEL_8015B:
	sbc a, a
	ld b, a
	and $80
	or $40
	ld c, a
	add hl, bc
	ld ($C010), hl
	ld b, h
LABEL_80167:
	ld ($C013), de
	ld c, $10
	ld hl, $C000
LABEL_80170:
	push hl
	ld a, (de)
	and $30
	call LABEL_801B3
LABEL_80181:
	and $30
	ld l, a
	ld a, (de)
	and $0C
	call LABEL_801B3
LABEL_80194:
	and $0C
	ld h, a
	ld a, (de)
	and $03
	call LABEL_801B3
LABEL_801A7:
	and $03
	or h
	or l
	pop hl
	ld (hl), a
	inc de
	inc l
	dec c
	jr nz, LABEL_80170
	ret

LABEL_801B3:
	push bc
	ld c, a
	ld a, b
	or a
	jr z, LABEL_801C1
	xor a
LABEL_801BA:
	add a, c
	djnz LABEL_801BA
	rrca
	rrca
	pop bc
	ret

LABEL_801C1:
	xor a
	pop bc
	ret

LABEL_801C4:
	ld.lil hl, mpLcdRis
	ld.lil de, mpLcdIcr
	ld a, $08
_:	bit.lil 3, (hl) 
	jr z, -_
	ld.lil (de), a
	ld hl, ($C019)
	ld a, l
	cp h
	jr z, LABEL_80222
	ld ($C019), a
	ld hl, DATA_823E1
	rrca
	rrca
	rrca
	and $06
	ld c, a
	ld b, $00
	add hl, bc
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	ld de, $0414
	sbc hl, de
	ld de, DATA_80414
	add hl, de
	ld de, DATA_823E7
	ld a, (de)
	ld b, 0
LABEL_80201:
	ld c, a
	inc de
	ld a, (de)
	inc de
	push de
	ex de, hl
	ld h, (hl)
	ld l, a
	push bc
	ld.lil bc, SegaVRAM + $3800
	add.lil hl, bc
	ex.lil de, hl
	ld.lil bc, romStart
	add.lil hl, bc
	pop bc
	ldir.lil
	pop de
	inc de
	ld a, (de)
	or a
	jr nz, LABEL_80201
	call.lil DrawScreenMap
	jr LABEL_8022A

LABEL_80222:
	ld bc, $8002
LABEL_80225:
	djnz LABEL_80225
	dec c
	jr nz, LABEL_80225

LABEL_8022A:
	ld	b, $10
	ld.lil	de, CRAM
	exx
	ld.lil	de, $D2C000

_:	push	bc
	ld	a, (de)	
	ld	l, a
	ld	h, $00
	add	hl, hl
	ld.lil	bc, SMS_Palette+romStart
	add.lil	hl, bc
	push.lil hl
	exx
	pop.lil	hl
	ld	bc, $0002
	ldir.lil
	exx
	inc.lil	de
	pop	bc
	djnz	-_

	call LABEL_8024A
	jp LABEL_80258

LABEL_8024A:
	exx
	call _Port1_Input
	ld h, a
	ld a, b
	xor h
	ld b, h
	and h
	ld c, a
	exx
	ret

LABEL_80258:
	ld hl, ($C017)
	ld a, h
	or l
	jr nz, LABEL_80262
	ld hl, $365A
LABEL_80262:
	ld d, h
	ld e, l
	ld a, l
	rlca
	rlca
	ld b, a
	ld a, h
	ld h, b
	rlca
	rlca
	ld l, a
	add hl, de
	ld a, h
	ld h, l
	ld l, a
	ld ($C017), hl
	call.lil RenderScreenMap
	ret

; Data from 80275 to 8027F (11 bytes)
DATA_80275:
	.db $FF, $00, $00, $F0, $FB, $FF, $FF, $FF, $FF, $80, $16

LABEL_80280:
	xor a
	push af
	pop af
	ld a, i
	ret pe
	dec sp
	dec sp
	pop af
	sub $01
	sbc a, a
	and $01
	ret

LABEL_8028F:
	ld.lil bc, SegaVRAM
	ex de, hl
	add.lil hl, bc
	ex.lil de, hl
	ld a, $80
	jr LABEL_802A1

LABEL_8029E:
	push af
	ld a, (hl)
	ld.lil (de), a
	inc hl
	inc.lil de
	pop af
LABEL_802A1:
	add a, a
	jr nc, LABEL_8029E
	jr nz, LABEL_802AB
	ld a, (hl)
	inc hl
	adc a, a
	jr nc, LABEL_8029E
LABEL_802AB:
	add a, a
	jr nc, LABEL_802EF
	jr nz, LABEL_802B5
	ld a, (hl)
	inc hl
	adc a, a
	jr nc, LABEL_802EF
LABEL_802B5:
	ld b, $02
	add a, a
	jr nc, LABEL_802C3
	jr nz, LABEL_802C1
	ld a, (hl)
	inc hl
	adc a, a
	jr nc, LABEL_802C3
LABEL_802C1:
	inc b
	inc b
LABEL_802C3:
	add a, a
	jr nc, LABEL_802CE
	jr nz, LABEL_802CD
	ld a, (hl)
	inc hl
	adc a, a
	jr nc, LABEL_802CE
LABEL_802CD:
	inc b
LABEL_802CE:
	push hl
	ld l, (hl)
	ld h, $BF

	ex.lil de, hl
	push bc
	ld.lil bc, SegaVRAM
	or a
	sbc hl, bc
	pop bc
	set 6, h
	ex de, hl
	add hl, de
	res 6, d
	ex af, af'
LABEL_802D0:
	push bc
	ld.lil bc, SegaVRAM
	add.lil hl, bc
	pop bc
LABEL_802D4:
	push bc
	ld.lil a, (hl)
	inc.lil hl
	push de
	pop iy
	ld.lil bc, SegaVRAM
	add.lil iy, bc
	ld.lil (iy), a
	inc de
	pop bc
	djnz LABEL_802D4

	ex de, hl
	ld.lil bc, SegaVRAM
	add.lil hl, bc
	ex.lil de, hl

	pop hl
	inc hl
	ex af, af'
	jr LABEL_802A1

LABEL_802EF:
	ex af, af'
	ld a, (hl)
	inc hl
	push hl
	ld h, (hl)
	ld l, a
	ld a, h
	and $07
	jr nz, LABEL_80304
	ex (sp), hl
	inc hl
	ld a, (hl)
	ex (sp), hl
	or a
	jr nz, LABEL_80303
	pop hl
	ret

LABEL_80303:
	dec a
LABEL_80304:
	add a, $02
	ld b, a
	ld a, h
	or $07
	rrca
	rrca
	rrca
	and $BF
	ld h, a
	ex.lil de, hl
	push bc
	ld.lil bc, SegaVRAM
	sbc hl, bc
	pop bc
	set 6, h
	ex de, hl
	add hl, de
	res 6, d
	jr LABEL_802D0

LABEL_80325:
	call Engine_ClearVRAM
	ret

LABEL_80348:
	call LABEL_80325
	exx
	ld a, r
	ret po
	ei
	ret

; Data from 80382 to 8040C (139 bytes)
DATA_80382:
	.db $00, $10, $20, $34, $38, $3D, $3F, $3F, $3D, $38, $34, $20, $10, $00, $00, $00
	.db $00, $10, $20, $34, $38, $3D, $3F, $38, $34, $20, $10, $00, $00, $00, $00, $00
DATA_803A2:
	.db $00, $10, $20, $34, $38, $3D, $3F
	.fill 9, $00
DATA_803B2:
	.db $46, $00, $FF, $F8, $14, $05, $05, $18, $FC, $2A, $2A, $FC, $55, $40, $55, $E8
	.db $F8, $15, $57, $57, $01, $01, $BE, $07, $BF, $0E, $0F, $F0, $FF, $FC, $E4, $E4
	.db $D0, $FE, $BF, $37, $BF, $0F, $E8, $46, $E6, $FF, $0C, $F0, $7F, $FC, $E0, $93
	.db $E0, $AA, $AA, $E0, $FC, $FF, $77, $FF, $E8, $58, $FE, $3F, $FF, $C0, $BA, $E0
	.db $F8, $1B, $F7, $E0, $F8, $1B, $0F, $E3, $E0, $E0, $1F, $E0, $F2, $E0, $A0, $A0
	.db $E0, $FC, $03, $EA, $EA, $80, $80, $7F, $FF, $33, $FE

LABEL_8040D:
	ret po
	ld l, $F9
	add a, b
	ret m
	dec bc
	rst $38	; Engine_Interrupt
; Data from 80414 to 83FFF (15340 bytes)
DATA_80414:
	#import "SHC/SHCDATA.bin"

#define DATA_820D2  DATA_80414 + $1CBE
#define DATA_823E1  DATA_80414 + $1FCD
#define DATA_823E7  DATA_80414 + $1FD3
#define DATA_8262E  DATA_80414 + $221A

#include "s2.lab"
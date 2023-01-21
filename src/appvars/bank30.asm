#include "includes/ti84pce.inc"
#define Score	gameMem+$D29C		;score stored in 3-byte BCD
#define gameMem 	userMem+$9C00
#define LastLevel	$07
;routines to load a level's object layout
#include "object_layout_routines.asm"

#include "object_logic\bank30_logic.asm"

DATA_B30_9841:
#include "collision_data.asm"


#include "cycling_palette_data.asm"


DemoControlSequence_SEZ:
#import "demo\demo_control_sequence_sez.bin"

;bank 30 is separate from s2.asm, so a few includes and routines are here to fix some bugs.
.nolist
#include	"logic_jump_table.asm"
#include	"includes/memory_layout.asm"
#include	"includes/structures.asm"
#include	"includes/objects.asm"
#include	"includes/player_states.asm"
DATA_1E76:
.db $00, $01, $00

LABEL_1D05: ;BCD subtraction subroutine
	xor	a
	ld	de, gameMem+$D29E
	ld	hl, gameMem+$D2A1
	ld	a, (de)
	sub	(hl)
	ret	c
	jr	z, +_
	jr	+++_
_:	dec	hl
	dec	de
	ld	a, (de)
	sub	(hl)
	ret	c
	jr	z, +_
	jr	++_
_:	dec	hl
	dec	de
	ld	a, (de)
	sub	(hl)
	ret	c
	jr	nc, +_
_:	ld	hl, Score
	ld	de, gameMem+$D29F
	ld	bc, $0003
	ldir
	ld	a, $02
	ld	(gameMem+$D2B5), a
	ret

LABEL_1CC4:
	ld	hl, DATA_1E76
	jp	LABEL_1CD0

LABEL_1CD0:
	ld	a, (gameMem+$D292)
	or	a
	ret	nz
	xor	a
	ld	de, Score
	ld	a, (de)
	adc	a, (hl)
	daa
	ld	(de), a	;update first BCD byte
	inc	de
	inc	hl
	ld	a, (de)
	adc	a, (hl)
	daa
	ld	(de), a	;update second BCD byte
	inc	de
	inc	hl
	ld	a, (de)
	adc	a, (hl)
	daa
	ld	(de), a	;update third BCD byte
	
	jr	nc, +_		;score overflow. cap at 999,990
	ld	hl, gameMem+$D29F
	ld	(hl), $90
	inc	hl
	ld	(hl), $99
	inc	hl
	ld	(hl), $99
	ld	a, $02
	jr	++_
_:	ld	a, $01
_: 	ld	(gameMem+$D2B5), a
	call	LABEL_1D05
	jp	LABEL_1D34

#define  GT_NEXT_LEVEL_BIT         4

LABEL_1D34:
	ld	hl, gameMem+$D2B6
	ld	a, (hl)
	or	a
	ret	nz
	ld	a, (gameMem+$D29E)
	cp	$03
	ret	c
	ld	(hl), $01
	ld	hl, LifeCounter
	inc	(hl)
	ld	a, (GlobalTriggers)
	bit	GT_NEXT_LEVEL_BIT, a
	ret	nz
	jp	Engine_CapLifeCounterValue

Engine_CapLifeCounterValue:	; $25AC 
	ld	a, (gameMem+$D292)
	or	a
	ret	nz
	
	ld	a, (LifeCounter)
	cp	9
	jr	c, +_

	ld	a, 9
	
_:	; calculate the sprite number to display
	rlca
	and	$1E
	add	a, $10
	ld	(VDP_WorkingSAT_HPOS + $69), a
	ret
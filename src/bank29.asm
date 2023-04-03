#include	"includes/ti84pce.inc"
#define gameMem 	cmdPixelShadow-$C000

;2 extra bytes from the ghz control sequence (unused).
.db $08, $00

DemoControlSequence_GHZ:
#import "demo\demo_control_sequence_ghz.bin"

DemoControlSequence_SHZ:
#import "demo\demo_control_sequence_shz.bin"

Art_Rings_UGZ:
#import "art\rings\rings_ucmp_ugz.bin"

Art_Rings_SHZ1_3:
#import "art\rings\rings_ucmp_shz1_3.bin"

Art_Rings_SHZ2:
#import "art\rings\rings_ucmp_shz2.bin"

Art_Rings_ALZ:
#import "art\rings\rings_ucmp_alz.bin"

Art_Rings_GHZ:
#import "art\rings\rings_ucmp_ghz.bin"

Art_Rings_GMZ:
#import "art\rings\rings_ucmp_gmz.bin"

Art_Rings_SEZ:
#import "art\rings\rings_ucmp_sez.bin"

Art_Rings_CEZ:
#import "art\rings\rings_ucmp_cez.bin"

LABEL_B29_B400:				;push the last 16 sprites off of the screen
	ld      b, $10			;by setting the VPOS attribute
	ld      a, $E0
	ld      hl, gameMem+$DB30
_:	ld      (hl), a
	inc     hl
	djnz    -_
	ret     
LABEL_B29_B40C:
	ld      a, (gameMem+$D46D)
	or      a
	jp      nz, LABEL_B29_B422
	ld      hl, (gameMem+$D46F)
	dec     hl
	ld      (gameMem+$D46F), hl
	ld      a, h
	or      l
	ret     nz

	ld      a, $01
	ld      (gameMem+$D46D), a
	ret     

LABEL_B29_B422:
	dec     a
	jp      z, LABEL_B29_B433
	dec     a
	jp      z, LABEL_B29_B4AF
	dec     a
	jp      z, LABEL_B29_B510
	dec     a
	jp      z, LABEL_B29_B400
	ret     

LABEL_B29_B433:
	ld      b, $08
	ld      hl, gameMem+$DB30
	ld      a, $9A
_:	ld      (hl), a
	inc     hl
	djnz    -_
	ld      b, $08
	ld      a, $B0
_:	ld      (hl), a
	inc     hl
	djnz    -_
	ld      a, (gameMem+$D46E)
	ld      l, a
	ld      h, $00
	add     hl, hl
	add     hl, hl
	add     hl, hl
	add     hl, hl
	ld      de, EndSequence_Data_CreditsText
	add     hl, de
	ld      de, gameMem+$DBA0		;copy the 16-byte line of text to $DBA0
	ld      b, $10
_:	xor     a
	ld      (de), a
	inc     de
	ld      a, (hl)			;check for $FF byte
	inc     a
	jp      z, LABEL_B29_B4A9
	dec     a
	sub     $41				;convert from ASCII to char index
	add     a, a
	add     a, $12
	cp      $45
	jp      c, ++_
	ld      c, $46
	cp      $E8
	jp      z, +_
	ld      c, $48
	cp      $EA
	jp      z, +_
	ld      c, $4A
_:	ld      a, c
_:	ld      (de), a			;copy char to work RAM
	inc     de
	inc     hl
	djnz    ---_

	ld      hl, DATA_B29_B522
	ld      ix, DATA_B29_B542
	ld      de, gameMem+$D46F
	ld      b, $10
_:	ld      a, (hl)
	ld      (de), a
	inc     de
	inc     hl
	ld      a, (hl)
	ld      (de), a
	inc     de
	inc     hl
	ld      a, (ix+$00)
	ld      (de), a
	inc     ix
	inc     de
	djnz    -_
	ld      a, (gameMem+$D46E)
	inc     a
	ld      (gameMem+$D46E), a
	ld      a, $02
	ld      (gameMem+$D46D), a
	ret     

LABEL_B29_B4A9:
	ld      a, $04			;reset the counter
	ld      (gameMem+$D46D), a
	ret     

LABEL_B29_B4AF:
	ld      b, $10
	ld      c, $00
	ld      ix, gameMem+$D46F
	ld      iy, gameMem+$DBA0
_:	bit     7, (ix+$01)
	jp      z, +_
	ld      a, (ix+$02)
	ld      h, (iy+$00)
	sub     h
	jp      c, +_
	ld      a, (ix+$02)
	ld      (iy+$00), a
	xor     a
	jp      ++_
_:	call    LABEL_B29_B4F5
	xor     a
	dec     a
_:	or      c
	ld      c, a
	inc     ix
	inc     ix
	inc     ix
	inc     iy
	inc     iy
	djnz    ---_
	ld      a, c
	or      a
	ret     nz

	ld      a, $03
	ld      (gameMem+$D46D), a
	ld      hl, $00B4
	ld      (gameMem+$D46F), hl
	ret     

LABEL_B29_B4F5:
	ld      a, (ix+$01)
	ld      h, (iy+$00)
	add     a, h
	ld      (iy+$00), a
	ld      l, (ix+$00)
	ld      h, (ix+$01)
	ld      de, $FFE0
	add     hl, de
	ld      (ix+$01), h
	ld      (ix+$00), l
	ret     

LABEL_B29_B510:
	ld      hl, (gameMem+$D46F)
	dec     hl
	ld      a, h
	or      l
	jp	  z, LABEL_B29_B51C
	ld      (gameMem+$D46F), hl
	ret     

LABEL_B29_B51C:
	ld      a, $01
	ld      (gameMem+$D46D), a
	ret     


;movement data for the credits text?
DATA_B29_B522:
#import "unknown\bank29_B522.bin"

DATA_B29_B542:
#import "unknown\bank29_B542.bin"

EndSequence_Data_CreditsText:
#include "end_credits.asm"
	ld	hl, UndergroundZone
	call	Mov9ToOP1
	call	ChkFindSym
	jp	nc, DataFound
	ld	hl, DATA_2A34
.dw DATA_2A34	;UGZ
	ld	hl, SkyHighZone
	call	Mov9ToOP1
	call	ChkFindSym
	jp	nc, DataFound
	ld	hl, DATA_2AA4
.dw DATA_2AA4	;SHZ
	ld	hl, AquaLakeZone
	call	Mov9ToOP1
	call	ChkFindSym
	jp	nc, DataFound
	ld	hl, DATA_29C4
.dw DATA_29C4	;ALZ
	ld	hl, GreenHillsZone
	call	Mov9ToOP1
	call	ChkFindSym
	jp	nc, DataFound
	ld	hl, DATA_2904
.dw DATA_2904	;GHZ
	ld	hl, GimmickMtZone
	call	Mov9ToOP1
	call	ChkFindSym
	jp	nc, DataFound
	ld	hl, DATA_2814
.dw DATA_2B14	;GMZ
	ld	hl, ScrambledEggZone
	call	Mov9ToOP1
	call	ChkFindSym
	jp	nc, DataFound
	ld	hl, DATA_28F4
.dw DATA_2BF4	;SEZ
	ld	hl, CrystalEggZone
	call	Mov9ToOP1
	call	ChkFindSym
	jp	nc, DataFound
	ld	hl, DATA_2C64
.dw DATA_2C64	;CEZ

DATA_28FE:	;mappings for act logo
.dw DATA_2E04
.dw DATA_2E90
.dw DATA_2F1C


DATA_2974:
  #import "mappings/titlecard/titlecard_mappings_2974.bin"


DATA_299C:
  #import "mappings/titlecard/titlecard_mappings_299C.bin"


DATA_2D0C:	
  #import "mappings/titlecard/titlecard_mappings_2D0C.bin"


DATA_2D6C:
  #import "mappings/titlecard/titlecard_mappings_2D6C.bin"


DATA_2D98:
  #import "mappings/titlecard/titlecard_mappings_2D98.bin"


DATA_2DAC:
  #import "mappings/titlecard/titlecard_mappings_2DAC.bin"


DATA_2DC0:
  #import "mappings/titlecard/titlecard_mappings_2DC0.bin"


DATA_2DD4:
  #import "mappings/titlecard/titlecard_mappings_2DD4.bin"


DATA_2E04:
  #import "mappings/titlecard/titlecard_mappings_2E04.bin"


DATA_2E90:
  #import "mappings/titlecard/titlecard_mappings_2E90.bin"


DATA_2F1C:
  #import "mappings/titlecard/titlecard_mappings_2F1C.bin"

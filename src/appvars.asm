#define Bank28	pixelShadow+$4000
#define Bank30	pixelShadow+$8000
#define Bank31	pixelShadow+$C000

#define HeaderSize Bank05-Bank04

.ASSUME ADL=1
CheckForBank: 			;it's bankin' time
 	call	StoreRegisters
	jp.lil	+_ + romStart

_:	ld	hl, Engine_ResetInterruptFlag
	push.sis hl		;Copy the return address to the 16-bit stack

	;check for object logic banks
	ld	hl, Bank28
	cp	28
	jp	z, LoadBankFromRAM + romStart
	ld	hl, Bank30
	cp	30
	jp	z, LoadBankFromRAM + romStart
	ld	hl, Bank31
	cp	31
	jp	z, LoadBankFromRAM + romStart

	sub	$04		;banks 0-3 are the actual engine/SMPS
	ld	l, a
	ld	h, HeaderSize
	mlt	hl
	ld	de, Bank04+romStart
	add	hl, de

	call	Mov9ToOP1
 	call	ChkFindSym
	jp.lil	c, Engine_Exit + romStart
	call	PutBankinSlot2 + romStart
	ex	af, af'
CheckForBank_ToggleInterrupt:
	jp.sis RestoreRegisters

StoreRegisters:		;stores registers in RAM
	ld	(SegaSP), sp
	ld	sp, $DF12
	push	af
	push	bc
	push	de
	push	hl
	exx
	push	bc
	push	de
	push	hl
	push	ix
	push	iy
	ld	sp, (SegaSP)
	ret

RestoreRegisters:
	ld	(SegaSP), sp
	ld	sp, $DF00
	pop	iy
	pop	ix
	pop	hl
	pop	de
	pop	bc
	exx
	pop	hl
	pop	de
	pop	bc
	pop	af
	ld	sp, (SegaSP)
	ret

PutBankinSlot2:
	ex	de, hl			;point HL to appvar
	ld	de, BankSlot2+romStart	;point DE to bank slot	
	ld	bc, 8 + HeaderSize
	add	hl, bc			;offset HL into actual data
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	inc	hl
	ldir				;copy appvar to bank slot
	ret

LoadBankFromRAM:
	ld	de, $D28000
	ld	bc, $4000
	ldir
	jp	CheckForBank_ToggleInterrupt + romStart

#define BankAddressTable $D0E000

StoreBankPointers:	;for loading sprite data from ROM banks
	xor	a
_:	push	af
	ld	l, a
	ld	e, a
	ld	h, HeaderSize
	ld	d, 3
	mlt	hl
	mlt	de

	ld	bc, Bank04 + romStart
	add	hl, bc	;HL = ROM bank header
	ex	de, hl
	ld	bc, BankAddressTable
	add	hl, bc	
	ex	de, hl	;DE = bank address holder

	push	de
	call	Mov9ToOP1
 	call	ChkFindSym
	ex	de, hl
	pop	de
	jp	c, Engine_Exit + romStart

	ld	(StoreBankAddress + 1 + romStart), de
	ld	de, $FF8011	;offset HL into actual data
	add	hl, de
StoreBankAddress:
	ld	(0), hl
	pop	af
	inc	a
	cp	28
	jr	nz, -_

	ld iy, BankAddressTable + (24 * 3)
	ld hl, Bank28 - $8000
	ld (iy), hl
	ld hl, Bank30 - $8000
	ld (iy + 6), hl
	ld hl, Bank31 - $8000
	ld (iy + 9), hl
	ret.sis

GetDataPTR:	;locate ROM bank data in archive memory
	sub	$04
	push	de
	push	bc
	ld	e, a
	ld	d, 3
	mlt	de
	ex	de, hl
	ld	bc, BankAddressTable
	add	hl, bc
	ld	hl, (hl)
	pop	bc
	pop	de
	ret.sis

;Appvar Headers
Bank04:
	.db	AppvarObj, "S2B04", 0

Bank05:
	.db	AppVarObj, "S2B05", 0

Bank06:
	.db	AppVarObj, "S2B06", 0

Bank07:
	.db	AppVarObj, "S2B07", 0

Bank08:
	.db	AppVarObj, "S2B08", 0

Bank09:
	.db	AppVarObj, "S2B09", 0

Bank10:
	.db	AppVarObj, "S2B10", 0

Bank11:
	.db	AppVarObj, "S2B11", 0

Bank12:
	.db	AppVarObj, "S2B12", 0

Bank13:
	.db	AppVarObj, "S2B13", 0

Bank14:
	.db	AppVarObj, "S2B14", 0

Bank15:
	.db	AppVarObj, "S2B15", 0

Bank16:
	.db	AppVarObj, "S2B16", 0

Bank17:
	.db	AppVarObj, "S2B17", 0

Bank18:
	.db	AppVarObj, "S2B18", 0

Bank19:
	.db	AppVarObj, "S2B19", 0

Bank20:
	.db	AppVarObj, "S2B20", 0

Bank21:
	.db	AppVarObj, "S2B21", 0

Bank22:
	.db	AppVarObj, "S2B22", 0

Bank23:
	.db	AppVarObj, "S2B23", 0

Bank24:
	.db	AppVarObj, "S2B24", 0

Bank25:
	.db	AppVarObj, "S2B25", 0

Bank26:
	.db	AppVarObj, "S2B26", 0

Bank27:
	.db	AppVarObj, "S2B27", 0

Bank28Header:
	.db	AppVarObj, "S2B28", 0

Bank29:
	.db	AppvarObj, "S2B29", 0

Bank30Header:
	.db	AppvarObj, "S2B30", 0

Bank31Header:
	.db	AppvarObj, "S2B31", 0

SHCHeader:
	.db	AppvarObj, "S2B32", 0
.ASSUME ADL=0
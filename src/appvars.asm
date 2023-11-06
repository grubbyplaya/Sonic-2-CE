.ASSUME ADL=1
CheckForBank: 			;it's bankin' time
 	call.sis StoreRegisters
	sub	$04
	ld	l, a
	ld	h, $08
	mlt	hl
	ld	de, Bank04+romStart
	add	hl, de

	call	Mov9ToOP1
 	call	ChkFindSym
	jp	c, ExitGame
	call	PutBankinSlot2+romStart
	ex	af, af'
	call.lis RestoreRegisters
	ret

SegaSP:	;used to exit the game
	.dw	$0623

SaveSP:
	.dw	$1022

StoreRegisters:		;stores registers in RAM
	ld	(SaveSP), sp
	ld	sp, $E012
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
	ld	sp, (SaveSP)
	ret.lil

RestoreRegisters:
	ld	(SaveSP), sp
	ld	sp, $E000
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
	ex	af, af'
	pop	af
	ld	sp, (SaveSP)
	ret

PutBankinSlot2:
	ex	de, hl			;point HL to appvar
	ld	de, BankSlot2+romStart	;point DE to bank slot	
	ld	bc, 16
	add	hl, bc			;offset HL to actual data
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	inc	hl
	ldir				;copy appvar to bank slot
	ret

ExitGame:
	call.s	SaveGame
	;exit 8bpp mode
	ld	hl, lcdNormalMode
	ld	(mpLcdCtrl), hl
	ld	sp, (SegaSP)
	ret

LoadSave:
	ld	hl, SaveFile
	call	Mov9ToOP1	;check for a save file
	call	Arc_Unarc
	
	ex	de, hl
	ld	de, Score
	ldi
	ldi
	ldi
	ld	de, CurrentLevel
	ldi
	ldi
	ldi
	dec	hl
	ldi
	ldi
	ld	de, ContinueCounter
	ldi
	ld	de, EmeraldFlags
	ldi
	ld	a, (de)
	ld	($D292), a
	ld	hl, SaveFile
	call	Mov9ToOP1
	jp	Arc_Unarc

SaveGame:
	ld	hl, SaveFile
	call	Mov9ToOP1
	jp	Arc_Unarc
	ld	hl, Score
	ldi
	ldi
	ldi
	ld	hl, CurrentLevel
	ldi
	ldi
	inc	hl
	ldi
	ldi
	ld	hl, ContinueCounter
	ldi
	ld	hl, EmeraldFlags
	ldi
	ld	a, $01
	ld	(de), a
	jp	Arc_Unarc

;Appvar Headers


Bank04:
	.db	AppvarObj, "Bank04", 0

Bank05:
	.db	AppVarObj, "Bank05", 0

Bank06:
	.db	AppVarObj, "Bank06", 0

Bank07:
	.db	AppVarObj, "Bank07", 0

Bank08:
	.db	AppVarObj, "Bank08", 0

Bank09:
	.db	AppVarObj, "Bank09", 0

Bank10:
	.db	AppVarObj, "Bank10", 0

Bank11:
	.db	AppVarObj, "Bank11", 0

Bank12:
	.db	AppVarObj, "Bank12", 0

Bank13:
	.db	AppVarObj, "Bank13", 0

Bank14:
	.db	AppVarObj, "Bank14", 0

Bank15:
	.db	AppVarObj, "Bank15", 0

Bank16:
	.db	AppVarObj, "Bank16", 0

Bank17:
	.db	AppVarObj, "Bank17", 0

Bank18:
	.db	AppVarObj, "Bank18", 0

Bank19:
	.db	AppVarObj, "Bank19", 0

Bank20:
	.db	AppVarObj, "Bank20", 0

Bank21:
	.db	AppVarObj, "Bank21", 0

Bank22:
	.db	AppVarObj, "Bank22", 0

Bank23:
	.db	AppVarObj, "Bank23", 0

Bank24:
	.db	AppVarObj, "Bank24", 0

Bank25:
	.db	AppVarObj, "Bank25", 0

Bank26:
	.db	AppVarObj, "Bank26", 0

Bank27:
	.db	AppVarObj, "Bank27", 0

Bank28:
	.db	AppVarObj, "Bank28", 0

Bank29:
	.db	AppvarObj, "Bank29", 0

Bank30:
	.db	AppVarObj, "Bank30", 0

Bank31:
	.db	AppVarObj, "Bank31", 0

SaveFile:
	.db	AppvarObj, "S2Save", 0
.ASSUME ADL=0
CheckForBank: 			;it's bankin' time
 	call	StoreRegisters

	ld	a, (Frame2Page)
	sub	$04
	mlt	hl
	add	a, a
	add	a, a
	add	a, a
	ld	l, a
	ld	h, $00
	ld	de, Bank04
	add	hl, de

	call	_Mov9toOP1
 	call	_ChkFindSym
	call	c, ExitGame
	call	PutBankinSlot2
	call	RestoreRegisters
	ret

SegaSP:	;used to exit the game
	.dl	$062391

SaveSP:
	.dl	$102292

StoreRegisters:		;stores registers in RAM
	di
	ld	(SaveSP), sp
	ld	sp, gameMem+$DFF0
	ex	af, af'
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
	ret

PutBankinSlot1:	;unused, since Sonic 2 only swaps out ROM bank 2.
	ex	de, hl		;point hl to appvar
	ld	de, BankSlot1	;point de to bank slot	
	ld	bc, 17
	add	hl, bc		;offset hl to actual data
	push	hl
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	inc	hl
	ldir				;copy appvar to bank slot
	ret

PutBankinSlot2:
	ex	de, hl		;point hl to appvar
	ld	de, BankSlot2	;point de to bank slot	
	ld	bc, 17
	add	hl, bc		;offset hl to actual data

	push	hl
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	inc	hl
	ldir				;copy appvar to bank slot
	ret

ExitGame:
	ld	hl, SaveFile
	call	_Mov9toOP1
	call	_ChkFindSym
	call	SaveGame
	;exit 8bpp mode
	ld	a, lcdBpp16
	ld	(mpLcdCtrl), a
	ld	sp, (SegaSP)
	ret	

MakeSave:
	ld	hl, SaveFile
	call	_Mov9toOP1
	ld	hl, 10
	call	_CreateAppvar
	ret

LoadSave:
	ld	hl, SaveFile
	call	_Mov9toOP1
	call	_ChkFindSym	;check for a save file
	jp	c, MakeSave	;make one if it doesn't exist
	call	_Arc_Unarc
	
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
	ld	(gameMem+$D292), a
	ld	hl, SaveFile
	call	_Mov9toOP1
	call	_Arc_Unarc
	ret

SaveGame:
	ld	hl, SaveFile
	call	_Mov9toOP1
	call	_Arc_Unarc

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
	xor	a
	bit	1, a
	ld	(de), a
	ld	hl, SaveFile
	call	_Mov9toOP1
	call	_Arc_Unarc
	ret

;Appvar Headers

SaveFile:
	.db	AppvarObj, "S2SAVE", 0

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
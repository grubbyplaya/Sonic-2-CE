CheckForBank: 			;it's bankin' time
 	call	StoreRegisters
	call 	_Mov9toOP1
 	call 	_ChkFindSym
	call	DataFound
	call	PutBankinSlot2
	call	RestoreRegisters
	ret

DataFound:
	ld de, $42616E	;Store "Ban" in DE
	call	_ChkInRam	;check in RAM
	jr	z, +_		;jump if exists
	call	_Arc_Unarc
	call	_ChkInRam
_:	ret

SegaSP:	;used to exit the game
	.dl	$062391

SaveSP:
	.dl	$221022

SaveSP2:	;exists to optimize VDP_UpdateSAT_Descending in vdp.asm
	.dl	$112492

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
	ret

;PutBankinSlot1:	;unused, since Sonic 2 only uses one ROM bank.
	;ex	de, hl		;point hl to appvar
	;ld	de, BankSlot1	;point de to bank slot	
	;ld	bc, 17
	;add	hl, bc
	;push	hl
	;pop	ix
	;ld	b, (ix+1)
	;ld	c, (ix)
	;inc	hl
	;inc	hl
	;ldir				;copy appvar to bank slot
	;call	_Arc_Unarc		;archive appvar
	;ret

PutBankinSlot2:
	ex	de, hl		;point hl to appvar
	ld	de, BankSlot2	;point de to bank slot	
	ld	bc, 17
	add	hl, bc
	push	hl
	pop	ix
	ld	b, (ix+1)
	ld	c, (ix)
	inc	hl
	inc	hl
	ldir				;copy appvar to bank slot
	call	_Arc_Unarc		;archive appvar
	ret

ExitGame:
	ld	hl, SaveFile
	call	_Mov9toOP1
	call _ChkFindSym
	call c, MakeSave
	call nc, LoadSave
	ld	sp, (SegaSP)
	ret	

MakeSave:
	ld	hl, SaveFile
	call _Mov9toOP1
	ld	hl, 9
	call _CreateAppvar
	ld	hl, SaveFile
	call _Mov9toOP1
	call _Arc_Unarc
	ret

LoadSave:
	ld  hl, SaveFile
	call _Mov9toOP1
	call _Arc_Unarc
	
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
	ld	hl, SaveFile
	call	_Mov9toOP1
	call _Arc_Unarc
	ret

SaveGame:
	ld	hl, SaveFile
	call _Mov9toOP1
	call _Arc_Unarc

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
	ld	hl, SaveFile
	call _Mov9toOP1
	call _Arc_Unarc
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


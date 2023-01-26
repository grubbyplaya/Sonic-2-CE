CheckForBank: 			;it's bankin' time
 	call	StoreRegisters
	call 	_Mov9toOP1
 	call 	_ChkFindSym
	call	DataFound
	call	PutBankinSlot2
	call	RestoreRegisters
	ret

DataFound:
	ld	a, b	;check if archived
	or	a	;is it?
	jr	z, +_	;jump if exists
	call	_Arc_Unarc
	jr	CheckForBank
_:	ret

RestoreRegisters:
	ld	a, (PixelShadow+1)
	ld	b, a
	ld	a, (PixelShadow+2)
	ld	c, a
	ld	a, (PixelShadow+3)
	ld	d, a
	ld	a, (PixelShadow+4)
	ld	e, a
	ld	a, (PixelShadow+5)
	ld	h, a
	ld	a, (PixelShadow+6)
	ld	l, a
	ld	a, (PixelShadow)
	ret

StoreRegisters:		;stores register values in SafeRAM
	ld	(PixelShadow), a
	ld	a, b
	ld	(PixelShadow+1), a
	ld	a, c
	ld	(PixelShadow+2), a
	ld	a, d
	ld	(PixelShadow+3), a
	ld	a, e
	ld	(PixelShadow+4), a
	ld	a, h
	ld	(PixelShadow+5), a
	ld	a, l
	ld	(PixelShadow+6), a
	ret

PutBankinSlot1:
	ex	de, hl		;point hl to appvar
	ld	de, BankSlot1	;point de to bank slot	
	ld	a, (BankSlot2-5)	;point bc to size word
	ld	b, a			
	ld	a, (BankSlot2-6)
	ld	c, a
	ldir				;copy appvar to bank slot
	call	_Arc_Unarc		;archive appvar
	ret

PutBankinSlot2:
	ex	de, hl		;point hl to appvar
	ld	de, BankSlot2	;point de to bank slot		
	ld	a, (BankSlot2-5)
	ld	b, a			;point bc to size word
	ld	a, (BankSlot2-6)
	ld	c, a
	ldir				;copy appvar to bank slot
	call	_Arc_Unarc		;archive appvar
	ret

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
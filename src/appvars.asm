DataFound:
	ld	a, b	;check if archived
	or	a	;is it?
	jr	z, done	;jump if exists
	call	Arc_Unarc
	jr	Relook
	ret
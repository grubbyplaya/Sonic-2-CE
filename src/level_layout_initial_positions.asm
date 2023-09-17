;/****************************************************************
; *	Starting positions for screen & Sonic for each zone/act.	*
; ****************************************************************/

;-------------------------------
;    pointers for each zone
;-------------------------------
LevelLayout_Data_InitPos:		;$5401
.dl LevelLayout_Data_InitPos_UGZ
.dl LevelLayout_Data_InitPos_SHZ
.dl LevelLayout_Data_InitPos_ALZ
.dl LevelLayout_Data_InitPos_GHZ
.dl LevelLayout_Data_InitPos_GMZ
.dl LevelLayout_Data_InitPos_SEZ
.dl LevelLayout_Data_InitPos_CEZ
.dl DATA_543F 
.dl DATA_5445 
.dl DATA_544B


;-------------------------------
;    pointers for each act
;-------------------------------
LevelLayout_Data_InitPos_UGZ:	;$5415
.dl LevelLayout_Data_InitPos_UGZ1
.dl LevelLayout_Data_InitPos_UGZ2
.dl LevelLayout_Data_InitPos_UGZ3

LevelLayout_Data_InitPos_SHZ:	;$541B
.dl LevelLayout_Data_InitPos_SHZ1
.dl LevelLayout_Data_InitPos_SHZ2
.dl LevelLayout_Data_InitPos_SHZ3

LevelLayout_Data_InitPos_ALZ:	;$5421
.dl LevelLayout_Data_InitPos_ALZ1
.dl LevelLayout_Data_InitPos_ALZ2
.dl LevelLayout_Data_InitPos_ALZ3

LevelLayout_Data_InitPos_GHZ:	;$5427
.dl LevelLayout_Data_InitPos_GHZ1
.dl LevelLayout_Data_InitPos_GHZ2
.dl LevelLayout_Data_InitPos_GHZ3

LevelLayout_Data_InitPos_GMZ:	;$542D
.dl LevelLayout_Data_InitPos_GMZ1
.dl LevelLayout_Data_InitPos_GMZ2
.dl LevelLayout_Data_InitPos_GMZ3

LevelLayout_Data_InitPos_SEZ:	;$5433
.dl LevelLayout_Data_InitPos_SEZ1
.dl LevelLayout_Data_InitPos_SEZ2
.dl LevelLayout_Data_InitPos_SEZ3

LevelLayout_Data_InitPos_CEZ:	;$5439
.dl LevelLayout_Data_InitPos_CEZ1
.dl LevelLayout_Data_InitPos_CEZ2
.dl LevelLayout_Data_InitPos_CEZ3

DATA_543F:
.dl DATA_54F9
.dl DATA_54F9
.dl DATA_54F9

DATA_5445:
.dl DATA_5501
.dl DATA_5509
.dl DATA_5511

DATA_544B:
.dl DATA_5519
.dl DATA_5521
.dl DATA_5529



;-------------------------------------
;         The position data
;--------------------------------------
;		,-- Initial cam horiz. offset
;       |       ,- Intial cam vert. offset
;		|		|			,- Initial sprite horiz offset
;		|		|			|		 ,- Initial sprite vert. offset
;  |--------|---------|---------|---------|
;   $00, $00, $30, $00, $88, $00, $A8, $00

LevelLayout_Data_InitPos_UGZ1:	;$5451
.db $00, $00, $30, $00, $88, $00, $A8, $00
LevelLayout_Data_InitPos_UGZ2:	;$5459
.db $00, $00, $70, $00, $84, $00, $08, $01
LevelLayout_Data_InitPos_UGZ3:	;$561
.db $00, $00, $10, $00, $84, $00, $88, $00

LevelLayout_Data_InitPos_SHZ1:	;$5469
.db $00, $00, $DE, $03, $80, $00, $4E, $04
LevelLayout_Data_InitPos_SHZ2:
.db $00, $00, $75, $00, $72, $00, $EE, $00
LevelLayout_Data_InitPos_SHZ3:
.db $00, $00, $20, $00, $80, $00, $A8, $00

LevelLayout_Data_InitPos_ALZ1:	;$5481
.db $00, $00, $E0, $00, $38, $00, $68, $01
LevelLayout_Data_InitPos_ALZ2:	;$5489
.db $00, $00, $18, $00, $88, $00, $A8, $00
LevelLayout_Data_InitPos_ALZ3:	;$5491
.db $00, $00, $30, $00, $48, $00, $A8, $00

LevelLayout_Data_InitPos_GHZ1:	;$5499
.db $00, $00, $80, $00, $70, $00, $08, $01
LevelLayout_Data_InitPos_GHZ2:	;$54A1
.db $00, $00, $E0, $00, $60, $00, $68, $01
LevelLayout_Data_InitPos_GHZ3:	;$54A9
.db $20, $00, $D8, $01, $A0, $00, $68, $02

LevelLayout_Data_InitPos_GMZ1:	;$54B1
.db $00, $00, $B0, $02, $50, $00, $28, $03
LevelLayout_Data_InitPos_GMZ2:	;$54B9
.db $00, $00, $78, $02, $90, $00, $08, $03
LevelLayout_Data_InitPos_GMZ3:	;$54C1
.db $00, $00, $08, $00, $90, $00, $58, $00

LevelLayout_Data_InitPos_SEZ1:	;$54C9
.db $00, $00, $E0, $0A, $90, $00, $68, $0B
LevelLayout_Data_InitPos_SEZ2:	;$54D1
.db $A8, $00, $1E, $02, $24, $01, $AE, $02
LevelLayout_Data_InitPos_SEZ3:	;$54D9
.db $00, $00, $B8, $0D, $78, $00, $48, $0E

LevelLayout_Data_InitPos_CEZ1:	;$54E1
.db $00, $00, $38, $00, $88, $00, $C8, $00
LevelLayout_Data_InitPos_CEZ2:	;$54E9
.db $70, $00, $9E, $07, $F4, $00, $2E, $08
LevelLayout_Data_InitPos_CEZ3:	;$54F1
.db $00, $00, $38, $00, $88, $00, $C8, $00

DATA_54F9:
.db $00, $00, $00, $01, $B0, $00, $70, $01

DATA_5501:
.db $80, $00, $00, $00, $80, $00, $80, $00
DATA_5509:
.db $80, $00, $00, $00, $80, $00, $80, $00
DATA_5511:
.db $80, $00, $00, $00, $80, $00, $80, $00

DATA_5519:
.db $00, $00, $2C, $00, $70, $00, $8C, $00
DATA_5521:
.db $00, $00, $2C, $00, $80, $00, $8C, $00
DATA_5529:
.db $00, $00, $2C, $00, $80, $00, $8C, $00

LevelHeaders:		;$55E5
 .dl LevelHeaders_UGZ
 .dl LevelHeaders_SHZ
 .dl LevelHeaders_ALZ
 .dl LevelHeaders_GHZ
 .dl LevelHeaders_GMZ
 .dl LevelHeaders_SEZ
 .dl LevelHeaders_CEZ
 .dl LevelHeaders_UNK1
 .dl LevelHeaders_UNK2
 .dl LevelHeaders_Intro_Title

LevelHeaders_UGZ:
 .dl LevelHeader_UGZ1
 .dl LevelHeader_UGZ2
 .dl LevelHeader_UGZ3

LevelHeaders_SHZ:
 .dl LevelHeader_SHZ1
 .dl LevelHeader_SHZ2
 .dl LevelHeader_SHZ3

LevelHeaders_ALZ:
 .dl LevelHeader_ALZ1
 .dl LevelHeader_ALZ2
 .dl LevelHeader_ALZ3

LevelHeaders_GHZ:
 .dl LevelHeader_GHZ1
 .dl LevelHeader_GHZ2
 .dl LevelHeader_GHZ3

LevelHeaders_GMZ:
 .dl LevelHeader_GMZ1
 .dl LevelHeader_GMZ2
 .dl LevelHeader_GMZ3

LevelHeaders_SEZ:
 .dl LevelHeader_SEZ1
 .dl LevelHeader_SEZ2
 .dl LevelHeader_SEZ3

LevelHeaders_CEZ:
 .dl LevelHeader_CEZ1
 .dl LevelHeader_CEZ2
 .dl LevelHeader_CEZ3

LevelHeaders_UNK1:
 .dl LevelHeader_5803
 .dl LevelHeader_5819
 .dl LevelHeader_5803

LevelHeaders_UNK2:
 .dl LevelHeader_SEZ1
 .dl LevelHeader_SEZ2
 .dl LevelHeader_SEZ3

LevelHeaders_Intro_Title:
 .dl LevelHeader_Intro
 .dl LevelHeader_Title
 .dl LevelHeader_Title


;LevelHeader_UGZ1:
;.db Bank15				;bank number for 32x32 mappings
;.dw Mappings32_UGZ		;pointer to 32x32 mappings
;.db :Layout_UGZ1		;bank number for level layout
;.dw Layout_UGZ1			;level layout pointer
;.dw $00A8				;level width in blocks
;.dw $FF58				;2's comp level width in blocks
;.dw $0498				;vertical offset into layout - i.e. the row
					;that appears at the bottom of the screen when
						;the player starts the level (7 * level width).
;.dw $0008				;minimum camera x pos
;.dw $0008				;minimum camera y pos
;.dw $1400				;max camera x pos
;.dw $0210				;max camera ypos
;.dl MultTable_168		;pointer to block row offsets (must point to 
						;table of multiples of level width)


LevelHeader_GHZ1:
.db Bank12
.dw Mappings32_GHZ
.db Bank13
.dw Layout_GHZ1
.dw $0100
.dw $FF00
.dw $0700
.dw $0008
.dw $0008
.dw $1F00
.dw $0110
.dl MultTable_256

LevelHeader_GHZ2:
.db Bank12
.dw Mappings32_GHZ
.db Bank13
.dw Layout_GHZ2
.dw $0100
.dw $FF00
.dw $0700
.dw $0008
.dw $0008
.dw $1F00
.dw $0110
.dl MultTable_256

LevelHeader_GHZ3:
.db Bank12
.dw Mappings32_GHZ
.db Bank13
.dw Layout_GHZ3
.dw $00A8
.dw $FF58
.dw $0498
.dw $0008
.dw $0008
.dw $1400
.dw $0210
.dl MultTable_168

LevelHeader_SHZ1:
.db Bank11
.dw Mappings32_SHZ1_3
.db Bank13
.dw Layout_SHZ1
.dw $0060
.dw $FFA0
.dw $02A0
.dw $0008
.dw $0008
.dw $0B00
.dw $0410
.dl MultTable_96

LevelHeader_SHZ2:
.db Bank11
.dw Mappings32_SHZ2
.db Bank13
.dw Layout_SHZ2
.dw $0080
.dw $FF80
.dw $0380
.dw $0008
.dw $0008
.dw $0F00
.dw $0310
.dl MultTable_128

LevelHeader_SHZ3:
.db Bank11
.dw Mappings32_SHZ1_3
.db Bank12
.dw Layout_SHZ3
.dw $0060
.dw $FFA0
.dw $02A0
.dw $0008
.dw $0008
.dw $0B00
.dw $0210
.dl MultTable_96


LevelHeader_ALZ1:
.db Bank12
.dw Mappings32_ALZ
.db Bank14
.dw Layout_ALZ1
.dw $0080
.dw $FF80
.dw $0380
.dw $0008
.dw $0008
.dw $0F00
.dw $0310
.dl MultTable_128

LevelHeader_ALZ2:
.db Bank15
.dw Mappings32_ALZ2
.db Bank14
.dw Layout_ALZ2
.dw $0048
.dw $FFB8
.dw $01F8
.dw $0008
.dw $0008
.dw $0800
.dw $0610
.dl MultTable_72

LevelHeader_ALZ3:
.db Bank12
.dw Mappings32_ALZ
.db Bank14
.dw Layout_ALZ3
.dw $0080
.dw $FF80
.dw $0380
.dw $0008
.dw $0008
.dw $0F00
.dw $0310
.dl MultTable_128


LevelHeader_UGZ1:
.db Bank15
.dw Mappings32_UGZ
.db Bank14
.dw Layout_UGZ1
.dw $00A8
.dw $FF58
.dw $0498
.dw $0008
.dw $0008
.dw $1400
.dw $0210
.dl MultTable_168


LevelHeader_UGZ2:
.db Bank15
.dw Mappings32_UGZ
.db Bank23
.dw Layout_UGZ2
.dw $00A8
.dw $FF58
.dw $0498
.dw $0008
.dw $0008
.dw $1400
.dw $0210
.dl MultTable_168

LevelHeader_UGZ3:
.db Bank15
.dw Mappings32_UGZ
.db Bank24
.dw Layout_UGZ3
.dw $0080
.dw $FF80
.dw $0380
.dw $0008
.dw $0008
.dw $0F00
.dw $0310
.dl MultTable_128

LevelHeader_GMZ1:
.db Bank22
.dw Mappings32_GMZ
.db Bank19
.dw Layout_GMZ1
.dw $0060
.dw $FFA0
.dw $02A0
.dw $0008
.dw $0008
.dw $0B00
.dw $0410
.dl MultTable_96

LevelHeader_GMZ2:
.db Bank22
.dw Mappings32_GMZ
.db Bank19
.dw Layout_GMZ2
.dw $0080
.dw $FF80
.dw $0380
.dw $0008
.dw $0008
.dw $0F00
.dw $0310
.dl MultTable_128

LevelHeader_GMZ3:
.db Bank22
.dw Mappings32_GMZ
.db Bank12
.dw Layout_GMZ3
.dw $0028
.dw $FFD8
.dw $0118
.dw $0008
.dw $0008
.dw $0400
.dw $0510
.dl MultTable_40


LevelHeader_SEZ1:
.db Bank22
.dw Mappings32_SEZ1_3
.db Bank19
.dw Layout_SEZ1
.dw $0028
.dw $FFD8
.dw $0118
.dw $0008
.dw $0008
.dw $0400
.dw $0B10
.dl MultTable_40

LevelHeader_SEZ2:
.db Bank23
.dw Mappings32_SEZ2
.db Bank19
.dw Layout_SEZ2
.dw $0080
.dw $FF80
.dw $0380
.dw $0008
.dw $0008
.dw $0F00
.dw $0310
.dl MultTable_128

LevelHeader_SEZ3:
.db Bank22
.dw Mappings32_SEZ1_3
.db Bank27
.dw Layout_SEZ3
.dw $0018
.dw $FFE8
.dw $00A8
.dw $0008
.dw $0008
.dw $0200
.dw $0E10
.dl MultTable_24

LevelHeader_CEZ1:
.db Bank24
.dw Mappings32_CEZ1_2
.db Bank21
.dw Layout_CEZ1
.dw $00A8
.dw $FF58
.dw $0498
.dw $0008
.dw $0008
.dw $1400
.dw $0210
.dl MultTable_168

LevelHeader_CEZ2:
.db Bank24
.dw Mappings32_CEZ1_2
.db Bank21
.dw Layout_CEZ2
.dw $0038
.dw $FFC8
.dw $0188
.dw $0008
.dw $0008
.dw $0600
.dw $0810
.dl MultTable_56

LevelHeader_CEZ3:
.db Bank23
.dw Mappings32_CEZ3
.db Bank21
.dw Layout_CEZ3
.dw $0028
.dw $FFD8
.dw $0118
.dw $0008
.dw $0008
.dw $0400
.dw $0110
.dl MultTable_40

LevelHeader_5803:
.db Bank22
.dw Mappings32_Ending
.db Bank27
.dw Layout_Bad_Ending
.dw $0020
.dw $FFE0
.dw $00E0
.dw $0008
.dw $0008
.dw $0300
.dw $0110
.dl MultTable_32

LevelHeader_5819:
.db Bank22
.dw Mappings32_Ending
.db Bank27
.dw Layout_Good_Ending
.dw $0020
.dw $FFE0
.dw $00E0
.dw $0008
.dw $0008
.dw $0300
.dw $0110
.dl MultTable_32

LevelHeader_Intro:
.db Bank08
.dw Mappings32_Intro
.db Bank08
.dw Layout_Intro
.dw $0010
.dw $FFF0
.dw $0070
.dw $0008
.dw $0008
.dw $0100
.dw $0110
.dl MultTable_16

LevelHeader_Title:
.db Bank08
.dw Mappings32_Title
.db Bank08
.dw Layout_Title
.dw $0010
.dw $FFF0
.dw $0070
.dw $0008
.dw $0008
.dw $0100
.dw $0110
.dl MultTable_16
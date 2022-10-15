LevelHeaders:		;$55E5
.dl	LevelHeaders_UGZ
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
;.db Mappings32_UGZ	;bank number for 32x32 mappings
;.dl Mappings32_UGZ		;pointer to 32x32 mappings
;.db Layout_UGZ1		;bank number for level layout
;.dl Layout_UGZ1		;level layout pointer
;.dl $00A8				;level width in blocks
;.dl $FF58				;2's comp level width in blocks
;.dl $0498				;vertical offset into layout - i.e. the row
						;that appears at the bottom of the screen when
						;the player starts the level (7 * level width).
;.dl $0008				;minimum camera x pos
;.dl $0008				;minimum camera y pos
;.dl $1400				;max camera x pos
;.dl $0210				;max camera ypos
;.dl MultTable_168		;pointer to block row offsets (must point to 
						;table of multiples of level width)


LevelHeader_GHZ1:
.db Mappings32_GHZ
.dl Mappings32_GHZ
.db Layout_GHZ1
.dl Layout_GHZ1
.dl $0100
.dl $FF00
.dl $0700
.dl $0008
.dl $0008
.dl $1F00
.dl $0110
.dl MultTable_256

LevelHeader_GHZ2:
.db Mappings32_GHZ
.dl Mappings32_GHZ
.db Layout_GHZ2
.dl Layout_GHZ2
.dl $0100
.dl $FF00
.dl $0700
.dl $0008
.dl $0008
.dl $1F00
.dl $0110
.dl MultTable_256

LevelHeader_GHZ3:
.db Mappings32_GHZ
.dl Mappings32_GHZ
.db Layout_GHZ3
.dl Layout_GHZ3
.dl $00A8
.dl $FF58
.dl $0498
.dl $0008
.dl $0008
.dl $1400
.dl $0210
.dl MultTable_168

LevelHeader_SHZ1:
.db Mappings32_SHZ1_3
.dl Mappings32_SHZ1_3
.db Layout_SHZ1
.dl Layout_SHZ1
.dl $0060
.dl $FFA0
.dl $02A0
.dl $0008
.dl $0008
.dl $0B00
.dl $0410
.dl MultTable_96

LevelHeader_SHZ2:
.db Mappings32_SHZ2
.dl Mappings32_SHZ2
.db Layout_SHZ2
.dl Layout_SHZ2
.dl $0080
.dl $FF80
.dl $0380
.dl $0008
.dl $0008
.dl $0F00
.dl $0310
.dl MultTable_128

LevelHeader_SHZ3:
.db Mappings32_SHZ1_3
.dl Mappings32_SHZ1_3
.db Layout_SHZ3
.dl Layout_SHZ3
.dl $0060
.dl $FFA0
.dl $02A0
.dl $0008
.dl $0008
.dl $0B00
.dl $0210
.dl MultTable_96


LevelHeader_ALZ1:
.db Mappings32_ALZ
.dl Mappings32_ALZ
.db Layout_ALZ1
.dl Layout_ALZ1
.dl $0080
.dl $FF80
.dl $0380
.dl $0008
.dl $0008
.dl $0F00
.dl $0310
.dl MultTable_128

LevelHeader_ALZ2:
.db Mappings32_ALZ2
.dl Mappings32_ALZ2
.db Layout_ALZ2
.dl Layout_ALZ2
.dl $0048
.dl $FFB8
.dl $01F8
.dl $0008
.dl $0008
.dl $0800
.dl $0610
.dl MultTable_72

LevelHeader_ALZ3:
.db Mappings32_ALZ
.dl Mappings32_ALZ
.db Layout_ALZ3
.dl Layout_ALZ3
.dl $0080
.dl $FF80
.dl $0380
.dl $0008
.dl $0008
.dl $0F00
.dl $0310
.dl MultTable_128


LevelHeader_UGZ1:
.db Mappings32_UGZ		;bank number for 32x32 mappings
.dl Mappings32_UGZ		;pointer to 32x32 mappings
.db Layout_UGZ1		;bank number for level layout
.dl Layout_UGZ1			;level layout pointer
.dl $00A8				;level width in blocks?
.dl $FF58				;2's comp level width in blocks
.dl $0498				;vertical offset into layout
.dl $0008				;minimum camera x pos
.dl $0008				;minimum camera y pos
.dl $1400				;max camera x pos
.dl $0210				;max camera ypos
.dl MultTable_168			;pointer to block row offsets


LevelHeader_UGZ2:
.db Mappings32_UGZ
.dl Mappings32_UGZ
.db Layout_UGZ2
.dl Layout_UGZ2
.dl $00A8
.dl $FF58
.dl $0498
.dl $0008
.dl $0008
.dl $1400
.dl $0210
.dl MultTable_168

LevelHeader_UGZ3:
.db Mappings32_UGZ
.dl Mappings32_UGZ
.db Layout_UGZ3
.dl Layout_UGZ3
.dl $0080
.dl $FF80
.dl $0380
.dl $0008
.dl $0008
.dl $0F00
.dl $0310
.dl	MultTable_128

LevelHeader_GMZ1:
.db Mappings32_GMZ
.dl Mappings32_GMZ
.db Layout_GMZ1
.dl Layout_GMZ1
.dl $0060
.dl $FFA0
.dl $02A0
.dl $0008
.dl $0008
.dl $0B00
.dl $0410
.dl MultTable_96

LevelHeader_GMZ2:
.db Mappings32_GMZ
.dl Mappings32_GMZ
.db Layout_GMZ2
.dl Layout_GMZ2
.dl $0080
.dl $FF80
.dl $0380
.dl $0008
.dl $0008
.dl $0F00
.dl $0310
.dl MultTable_128

LevelHeader_GMZ3:
.db Mappings32_GMZ
.dl Mappings32_GMZ
.db Layout_GMZ3
.dl Layout_GMZ3
.dl $0028
.dl $FFD8
.dl $0118
.dl $0008
.dl $0008
.dl $0400
.dl $0510
.dl MultTable_40


LevelHeader_SEZ1:
.db Mappings32_SEZ1_3
.dl Mappings32_SEZ1_3
.db Layout_SEZ1
.dl Layout_SEZ1
.dl $0028
.dl $FFD8
.dl $0118
.dl $0008
.dl $0008
.dl $0400
.dl $0B10
.dl MultTable_40

LevelHeader_SEZ2:
.db Mappings32_SEZ2
.dl Mappings32_SEZ2
.db Layout_SEZ2
.dl Layout_SEZ2
.dl $0080
.dl $FF80
.dl $0380
.dl $0008
.dl $0008
.dl $0F00
.dl $0310
.dl MultTable_128

LevelHeader_SEZ3:
.db Mappings32_SEZ1_3
.dl Mappings32_SEZ1_3
.db Layout_SEZ3
.dl Layout_SEZ3
.dl $0018
.dl $FFE8
.dl $00A8
.dl $0008
.dl $0008
.dl $0200
.dl $0E10
.dl MultTable_24

LevelHeader_CEZ1:
.db Mappings32_CEZ1_2
.dl Mappings32_CEZ1_2
.db Layout_CEZ1
.dl Layout_CEZ1
.dl $00A8
.dl $FF58
.dl $0498
.dl $0008
.dl $0008
.dl $1400
.dl $0210
.dl MultTable_168

LevelHeader_CEZ2:
.db Mappings32_CEZ1_2
.dl Mappings32_CEZ1_2
.db Layout_CEZ2
.dl Layout_CEZ2
.dl $0038
.dl $FFC8
.dl $0188
.dl $0008
.dl $0008
.dl $0600
.dl $0810
.dl MultTable_56

LevelHeader_CEZ3:
.db Mappings32_CEZ3
.dl Mappings32_CEZ3
.db Layout_CEZ3
.dl Layout_CEZ3
.dl $0028
.dl $FFD8
.dl $0118
.dl $0008
.dl $0008
.dl $0400
.dl $0110
.dl MultTable_40

LevelHeader_5803:
.db Mappings32_Ending
.dl Mappings32_Ending
.db Layout_Bad_Ending
.dl Layout_Bad_Ending
.dl $0020
.dl $FFE0
.dl $00E0
.dl $0008
.dl $0008
.dl $0300
.dl $0110
.dl MultTable_32

LevelHeader_5819:
.db Mappings32_Ending
.dl Mappings32_Ending
.db Layout_Good_Ending
.dl Layout_Good_Ending
.dl $0020
.dl $FFE0
.dl $00E0
.dl $0008
.dl $0008
.dl $0300
.dl $0110
.dl MultTable_32

LevelHeader_Intro:
.db Mappings32_Intro
.dl Mappings32_Intro
.db Layout_Intro
.dl Layout_Intro
.dl $0010
.dl $FFF0
.dl $0070
.dl $0008
.dl $0008
.dl $0100
.dl $0110
.dl MultTable_16

LevelHeader_Title:
.db Mappings32_Title
.dl Mappings32_Title
.db Layout_Title
.dl Layout_Title
.dl $0010
.dl $FFF0
.dl $0070
.dl $0008
.dl $0008
.dl $0100
.dl $0110
.dl MultTable_16

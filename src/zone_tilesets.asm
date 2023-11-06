.ASSUME ADL=0
;Tileset header chains for each zone/act
;Under Ground Zone
.db 09				;Act 1
	.dw $2100
	.dw Art_UGZ_Level_Tiles
	.dw Tileset_UGZ
.db 09				;Act 2
	.dw $2100
	.dw Art_UGZ_Level_Tiles
	.dw Tileset_UGZ
.db 09				;Act 3
	.dw $2100
	.dw Art_UGZ_Level_Tiles
	.dw Tileset_UGZ

;Sky High Zone
.db 10
	.dw $2000
	.dw Art_SHZ_Level_Tiles
	.dw Tileset_SHZ
.db 23
	.dw $2000
	.dw Art_SHZ2_Level_Tiles
	.dw Tileset_SHZ
.db 10
	.dw $2000
	.dw Art_SHZ_Level_Tiles
	.dw Tileset_SHZ

;Aqua Lake Zone
.db 21
	.dw $20C0
	.dw Art_ALZ_Level_Tiles
	.dw Tileset_ALZ 
.db 21
	.dw $20C0
	.dw Art_ALZ2_Level_Tiles
	.dw Tileset_ALZ 
.db 21
	.dw $20C0
	.dw Art_ALZ_Level_Tiles
	.dw Tileset_ALZ 

;Green Hills Zone
.db 10
	.dw $2000
	.dw Art_GHZ_Level_Tiles
	.dw Tileset_GHZ 
.db 10
	.dw $2000
	.dw Art_GHZ_Level_Tiles
	.dw Tileset_GHZ
.db 10
	.dw $2000
	.dw Art_GHZ_Level_Tiles
	.dw Tileset_GHZ

.db 10
	.dw $2000
	.dw Art_GMZ_Level_Tiles
	.dw Tileset_GMZ
.db 10
	.dw $2000
	.dw Art_GMZ_Level_Tiles
	.dw Tileset_GMZ
.db 10
	.dw $2000
	.dw Art_GMZ_Level_Tiles
	.dw Tileset_GMZ

.db 20
	.dw $2000
	.dw Art_SEZ_Level_Tiles
	.dw Tileset_SEZ
.db 20
	.dw $2000
	.dw Art_SEZ2_Level_Tiles
	.dw Tileset_SEZ
.db 20
	.dw $2000
	.dw Art_SEZ_Level_Tiles
	.dw Tileset_SEZ

.db 21
	.dw $2000
	.dw Art_CEZ_Level_Tiles
	.dw Tileset_CEZ
.db 21
	.dw $2000
	.dw Art_CEZ_Level_Tiles
	.dw Tileset_CEZ
.db 21
	.dw $2000
	.dw Art_CEZ3_Level_Tiles
	.dw Tileset_CEZ3 

.db 27
	.dw $2000
	.dw Art_Ending_Tiles
	.dw Tileset_UNK1
.db 27
	.dw $2000
	.dw Art_Ending_Tiles
	.dw Tileset_UNK1
.db 27
	.dw $2000
	.dw Art_Ending_Tiles
	.dw Tileset_UNK1

.db 08
	.dw $2000
	.dw Art_Intro_Sequence
	.dw Tileset_Intro
.db 08
	.dw $2000
	.dw Art_Beta_Title
	.dw Tileset_Intro
.db 08
	.dw $2000
	.dw Art_Beta_Title
	.dw Tileset_Intro
.db 08
	.dw $2000
	.dw Art_Intro_Sequence
	.dw Tileset_Intro
.db 08
	.dw $2000
	.dw Art_Beta_Title
	.dw Tileset_Intro
.db 08
	.dw $2000
	.dw Art_Beta_Title
	.dw Tileset_Intro

Tileset_UGZ:
.db 07
	.dw $0200
	.dw Art_Icons_Numbers 
.db 07
	.dw $09C0
	.dw Art_Monitors_Generic 
.db 07
	.dw $07C0
	.dw Art_Rings
.db 07
	.dw $0D40
	.dw Art_Minecart
.db 26
	.dw $0C00
	.dw Art_Block_Fragment
.db 16
	.dw $1240
	.dw Art_UGZ_Fireball
.db 16
	.dw $1300
	.dw Art_Badnik_Motobug

.db 16 + $80	;mirror tiles
	.dw $1500
	.dw Art_Badnik_Motobug 
.db 09
	.dw $0C40
	.dw Art_UGZ_Unknown 
.db 09
	.dw $10C0
	.dw Art_UGZ_Spikes 
.db 09 + $80	;mirror tiles
	.dw $1700
	.dw Art_Badnik_Newtron
.db 09
	.dw $1A80
	.dw Art_Badnik_Crab
.db 09
	.dw $1F40
	.dw Art_UGZ_Spikes 
.db $FF

Tileset_SHZ:
.db 07
	.dw $0200
	.dw Art_Icons_Numbers 
.db 07
	.dw $09C0
	.dw Art_Monitors_Generic 
.db 07
	.dw $07C0
	.dw Art_Rings
.db 07
	.dw $0C40
	.dw Art_SHZ_Log
.db 07
	.dw $0CC0
	.dw Art_SHZ_Moving_Platform
.db 07
	.dw $1940
	.dw Art_SHZ_Glider 
.db 26
	.dw $0DC0
	.dw Art_SHZ_Rock 
.db 26
	.dw $0C00
	.dw Art_Block_Fragment
.db 04
	.dw $0F40
	.dw Art_Badnik_Turtle
.db 04 + $80
	.dw $1240
	.dw Art_Badnik_Turtle
.db 09
	.dw $1540
	.dw Art_SHZ_Yellow_Bird 
.db 09 + $80
	.dw $15C0
	.dw Art_Badnik_Newtron
.db 04
	.dw $1EC0
	.dw Art_SHZ_Leaves 
.db $FF

Tileset_ALZ:
.db 07
	.dw $0200
	.dw Art_Icons_Numbers 
.db 07
	.dw $09C0
	.dw Art_Monitors_Generic
.db 07
	.dw $07C0
	.dw Art_Rings
.db 26
	.dw $0C00
	.dw Art_Block_Fragment
.db 16
	.dw $0E40
	.dw Art_Badnik_Lobster
.db 16 + $80
	.dw $1140
	.dw Art_Badnik_Lobster
.db 09
	.dw $0C40
	.dw Art_ALZ_Spike
.db 09
	.dw $1440
	.dw Art_Badnik_Crab
.db 09
	.dw $1900
	.dw Art_ALZ_Unknown2
.db 09
	.dw $1980
	.dw Art_ALZ_Unknown
.db 09
	.dw $1C40
	.dw Art_ALZ_Big_Bubble 
.db 04
	.dw $1A00
	.dw Art_ALZ_Bubble
.db $FF

Tileset_GHZ:
.db 07
	.dw $0200
	.dw Art_Icons_Numbers 
.db 07
	.dw $09C0
	.dw Art_Monitors_Generic
.db 07
	.dw $07C0
	.dw Art_Rings
.db 07
	.dw $0C40
	.dw Art_GHZ_Moving_Platform
.db 26
	.dw $0C00
	.dw Art_Block_Fragment
.db 16
	.dw $0D40
	.dw Art_Badnik_Motobug
.db 16 + $80
	.dw $0F40
	.dw Art_Badnik_Motobug
.db 09 + $80
	.dw $1140
	.dw Art_Badnik_Newtron 
.db 09
	.dw $14C0
	.dw Art_Badnik_Crab
.db $FF

Tileset_GMZ:
.db 07
	.dw $0200
	.dw Art_Icons_Numbers 
.db 07
	.dw $09C0
	.dw Art_Monitors_Generic
.db 07
	.dw $07C0
	.dw Art_Rings
.db 07
	.dw $0D40
	.dw Art_Minecart
.db 26
	.dw $0C00
	.dw Art_Block_Fragment
.db 16
	.dw $10C0
	.dw Art_Badnik_Burrobot
.db 16 + $80
	.dw $1440
	.dw Art_Badnik_Burrobot
.db 04
	.dw $17C0
	.dw Art_Badnik_Pig
.db 09
	.dw $0C40
	.dw Art_GMZ_Moving_Platform
.db 09
	.dw $1AC0
	.dw Art_Badnik_Bomb
.db 09 + $80
	.dw $1CC0
	.dw Art_Badnik_Bomb
.db 09
	.dw $1EC0
	.dw Art_GMZ_Spikes
.db $FF

Tileset_SEZ:
.db 07
	.dw $0200
	.dw Art_Icons_Numbers 
.db 07
	.dw $09C0
	.dw Art_Monitors_Generic
.db 07
	.dw $07C0
	.dw Art_Rings
.db 26
	.dw $0C00
	.dw Art_Block_Fragment
.db 18
	.dw $0D40
	.dw Art_SEZ_Block
.db 04
	.dw $0DC0
	.dw Art_Badnik_Turtle
.db 04 + $80
	.dw $10C0
	.dw Art_Badnik_Turtle
.db 09
	.dw $0C40
	.dw Art_SEZ_Moving_Platform
.db 09
	.dw $13C0
	.dw Art_Badnik_Bomb
.db 09 + $80
	.dw $15C0
	.dw Art_Badnik_Bomb
.db 09
	.dw $17C0
	.dw Art_Badnik_Crab
.db $FF

Tileset_CEZ:
.db 07
	.dw $0200
	.dw Art_Icons_Numbers 
.db 07
	.dw $09C0
	.dw Art_Monitors_Generic 
.db 07
	.dw $07C0
	.dw Art_Rings
.db 26
	.dw $0C00
	.dw Art_Block_Fragment
.db 18
	.dw $0C40
	.dw Art_CEZ_Moving_Platform
.db 18
	.dw $0D40
	.dw Art_CEZ_Rock
.db 06
	.dw $0E40
	.dw Art_CEZ_Wheel
.db 06
	.dw $1140
	.dw Art_CEZ_Block
.db 16
	.dw $1340
	.dw Art_Badnik_Fish
.db 16 + $80
	.dw $1400
	.dw Art_Badnik_Fish
.db 09
	.dw $14C0
	.dw Art_Badnik_Crab
.db 04
	.dw $1980
	.dw Art_Badnik_Turtle
.db $FF

Tileset_CEZ3:
.db 07
	.dw $0200
	.dw Art_Icons_Numbers
.db 24
	.dw $0C40
	.dw Art_CEZ_Boss
.db 24
	.dw $1F80
	.dw Art_CEZ3_Cloud
.db $FF 

Tileset_UNK1:
.db 10
	.dw $0200
	.dw Art_Ending_Text
.db 20
	.dw $0940
	.dw Art_End
.db 20 + $80
	.dw $0C80
	.dw Art_Tails_Running
.db 20 + $80
	.dw $1700
	.dw Art_Tails_Skid
.db 20 + $80
	.dw $18C0
	.dw Art_Tails_LookingUp
.db $FF 

Tileset_Intro:
.db 07
	.dw $0200
	.dw Art_Icons_Numbers
.db 07
	.dw $09C0
	.dw Art_Monitors_Generic
.db 07
	.dw $07C0
	.dw Art_Rings
.db 26
	.dw $0C00
	.dw Art_Block_Fragment
.db $FF
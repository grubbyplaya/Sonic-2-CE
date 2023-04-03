;Tileset header chains for each zone/act
;Under Ground Zone
.dl Bank09	;act1
	.dw $2100
	.dl Art_UGZ_Level_Tiles
	.dl Tileset_UGZ
.dl Bank09	;act2
	.dw $2100
	.dl Art_UGZ_Level_Tiles
	.dl Tileset_UGZ
.dl Bank09	;act3
	.dw $2100
	.dl Art_UGZ_Level_Tiles
	.dl Tileset_UGZ

;Sky High Zone
.dl Bank10
	.dw $2000
	.dl Art_SHZ_Level_Tiles
	.dl Tileset_SHZ
.dl Bank23
	.dw $2000
	.dl Art_SHZ2_Level_Tiles
	.dl Tileset_SHZ
.dl Bank10
	.dw $2000
	.dl Art_SHZ_Level_Tiles
	.dl Tileset_SHZ

;Aqua Lake Zone
.dl Bank21
	.dw $20C0
	.dl Art_ALZ_Level_Tiles
	.dl Tileset_ALZ 
.dl Bank21
	.dw $20C0
	.dl Art_ALZ2_Level_Tiles
	.dl Tileset_ALZ 
.dl Bank21
	.dw $20C0
	.dl Art_ALZ_Level_Tiles
	.dl Tileset_ALZ 

;Green Hills Zone
.dl Bank10
	.dw $2000
	.dl Art_GHZ_Level_Tiles
	.dl Tileset_GHZ 
.dl Bank10
	.dw $2000
	.dl Art_GHZ_Level_Tiles
	.dl Tileset_GHZ
.dl Bank10
	.dw $2000
	.dl Art_GHZ_Level_Tiles
	.dl Tileset_GHZ

.dl Bank10
	.dw $2000
	.dl Art_GMZ_Level_Tiles
	.dl Tileset_GMZ
.dl Bank10
	.dw $2000
	.dl Art_GMZ_Level_Tiles
	.dl Tileset_GMZ
.dl Bank10
	.dw $2000
	.dl Art_GMZ_Level_Tiles
	.dl Tileset_GMZ

.dl Bank20
	.dw $2000
	.dl Art_SEZ_Level_Tiles
	.dl Tileset_SEZ
.dl Bank20
	.dw $2000
	.dl Art_SEZ2_Level_Tiles
	.dl Tileset_SEZ
.dl Bank20
	.dw $2000
	.dl Art_SEZ_Level_Tiles
	.dl Tileset_SEZ

.dl Bank21
	.dw $2000
	.dl Art_CEZ_Level_Tiles
	.dl Tileset_CEZ
.dl Bank21
	.dw $2000
	.dl Art_CEZ_Level_Tiles
	.dl Tileset_CEZ
.dl Bank21
	.dw $2000
	.dl Art_CEZ3_Level_Tiles
	.dl Tileset_CEZ3 

.dl Bank27
	.dw $2000
	.dl Art_Ending_Tiles
	.dl Tileset_UNK1
.dl Bank27
	.dw $2000
	.dl Art_Ending_Tiles
	.dl Tileset_UNK1
.dl Bank27
	.dw $2000
	.dl Art_Ending_Tiles
	.dl Tileset_UNK1

.dl Bank08
	.dw $2000
	.dl Art_Intro_Sequence
	.dl Tileset_Intro
.dl Bank08
	.dw $2000
	.dl Art_Beta_Title
	.dl Tileset_Intro
.dl Bank08
	.dw $2000
	.dl Art_Beta_Title
	.dl Tileset_Intro
.dl Bank08
	.dw $2000
	.dl Art_Intro_Sequence
	.dl Tileset_Intro
.dl Bank08
	.dw $2000
	.dl Art_Beta_Title
	.dl Tileset_Intro
.dl Bank08
	.dw $2000
	.dl Art_Beta_Title
	.dl Tileset_Intro

Tileset_UGZ:
.dl Bank07
	.dw $0200
	.dl Art_Icons_Numbers 
.dl Bank07
	.dw $09C0
	.dl Art_Monitors_Generic 
.dl Bank07
	.dw $07C0
	.dl Art_Rings
.dl Bank26
	.dw $0C00
	.dl Art_Block_Fragment
.dl Bank09
	.dw $0C40
	.dl Art_UGZ_Unknown 
.dl Bank07
	.dw $0D40
	.dl Art_Minecart
.dl Bank09
	.dw $10C0
	.dl Art_UGZ_Spikes 
.dl Bank16
	.dw $1240
	.dl Art_UGZ_Fireball
.dl Bank16
	.dw $1300
	.dl Art_Badnik_Motobug
.dl Bank16 + $80	;mirror tiles
	.dw $1500
	.dl Art_Badnik_Motobug 
.dl Bank09 + $80	;mirror tiles
	.dw $1700
	.dl Art_Badnik_Newtron
.dl Bank09
	.dw $1A80
	.dl Art_Badnik_Crab
.dl Bank09
	.dw $1F40
	.dl Art_UGZ_Spikes 
.db $FF

Tileset_SHZ:
.dl Bank07
	.dw $0200
	.dl Art_Icons_Numbers 
.dl Bank07
	.dw $09C0
	.dl Art_Monitors_Generic 
.dl Bank07
	.dw $07C0
	.dl Art_Rings
.dl Bank26
	.dw $0C00
	.dl Art_Block_Fragment
.dl Bank07
	.dw $0C40
	.dl Art_SHZ_Log
.dl Bank07
	.dw $0CC0
	.dl Art_SHZ_Moving_Platform
.dl Bank26
	.dw $0DC0
	.dl Art_SHZ_Rock 
.dl Bank04
	.dw $0F40
	.dl Art_Badnik_Turtle
.dl Bank04 + $80
	.dw $1240
	.dl Art_Badnik_Turtle
.dl Bank09
	.dw $1540
	.dl Art_SHZ_Yellow_Bird 
.dl Bank09 + $80
	.dw $15C0
	.dl Art_Badnik_Newtron
.dl Bank07
	.dw $1940
	.dl Art_SHZ_Glider 
.dl Bank04
	.dw $1EC0
	.dl Art_SHZ_Leaves 
.db $FF

Tileset_ALZ:
.dl Bank07
	.dw $0200
	.dl Art_Icons_Numbers 
.dl Bank07
	.dw $09C0
	.dl Art_Monitors_Generic
.dl Bank07
	.dw $07C0
	.dl Art_Rings
.dl Bank26
	.dw $0C00
	.dl Art_Block_Fragment
.dl Bank09
	.dw $0C40
	.dl Art_ALZ_Spike
.dl Bank16
	.dw $0E40
	.dl Art_Badnik_Lobster
.dl Bank16 + $80
	.dw $1140
	.dl Art_Badnik_Lobster
.dl Bank09
	.dw $1440
	.dl Art_Badnik_Crab
.dl Bank09
	.dw $1900
	.dl Art_ALZ_Unknown2
.dl Bank09
	.dw $1980
	.dl Art_ALZ_Unknown
.dl Bank04
	.dw $1A00
	.dl Art_ALZ_Bubble
.dl Bank09
	.dw $1C40
	.dl Art_ALZ_Big_Bubble 
.db $FF

Tileset_GHZ:
.dl Bank07
	.dw $0200
	.dl Art_Icons_Numbers 
.dl Bank07
	.dw $09C0
	.dl Art_Monitors_Generic
.dl Bank07
	.dw $07C0
	.dl Art_Rings
.dl Bank26
	.dw $0C00
	.dl Art_Block_Fragment
.dl Bank07
	.dw $0C40
	.dl Art_GHZ_Moving_Platform
.dl Bank16
	.dw $0D40
	.dl Art_Badnik_Motobug
.dl Bank16 + $80
	.dw $0F40
	.dl Art_Badnik_Motobug
.dl Bank09 + $80
	.dw $1140
	.dl Art_Badnik_Newtron 
.dl Bank09
	.dw $14C0
	.dl Art_Badnik_Crab
.db $FF

Tileset_GMZ:
.dl Bank07
	.dw $0200
	.dl Art_Icons_Numbers 
.dl Bank07
	.dw $09C0
	.dl Art_Monitors_Generic
.dl Bank07
	.dw $07C0
	.dl Art_Rings
.dl Bank26
	.dw $0C00
	.dl Art_Block_Fragment
.dl Bank09
	.dw $0C40
	.dl Art_GMZ_Moving_Platform
.dl Bank07
	.dw $0D40
	.dl Art_Minecart
.dl Bank16
	.dw $10C0
	.dl Art_Badnik_Burrobot
.dl Bank16 + $80
	.dw $1440
	.dl Art_Badnik_Burrobot
.dl Bank04
	.dw $17C0
	.dl Art_Badnik_Pig
.dl Bank09
	.dw $1AC0
	.dl Art_Badnik_Bomb
.dl Bank09 + $80
	.dw $1CC0
	.dl Art_Badnik_Bomb
.dl Bank09
	.dw $1EC0
	.dl Art_GMZ_Spikes
.db $FF

Tileset_SEZ:
.dl Bank07
	.dw $0200
	.dl Art_Icons_Numbers 
.dl Bank07
	.dw $09C0
	.dl Art_Monitors_Generic
.dl Bank07
	.dw $07C0
	.dl Art_Rings
.dl Bank26
	.dw $0C00
	.dl Art_Block_Fragment
.dl Bank09
	.dw $0C40
	.dl Art_SEZ_Moving_Platform
.dl Bank18
	.dw $0D40
	.dl Art_SEZ_Block
.dl Bank04
	.dw $0DC0
	.dl Art_Badnik_Turtle
.dl Bank04 + $80
	.dw $10C0
	.dl Art_Badnik_Turtle
.dl Bank09
	.dw $13C0
	.dl Art_Badnik_Bomb
.dl Bank09 + $80
	.dw $15C0
	.dl Art_Badnik_Bomb
.dl Bank09
	.dw $17C0
	.dl Art_Badnik_Crab
.db $FF

Tileset_CEZ:
.dl Bank07
	.dw $0200
	.dl Art_Icons_Numbers 
.dl Bank07
	.dw $09C0
	.dl Art_Monitors_Generic 
.dl Bank07
	.dw $07C0
	.dl Art_Rings
.dl Bank26
	.dw $0C00
	.dl Art_Block_Fragment
.dl Bank18
	.dw $0C40
	.dl Art_CEZ_Moving_Platform
.dl Bank18
	.dw $0D40
	.dl Art_CEZ_Rock
.dl Bank06
	.dw $0E40
	.dl Art_CEZ_Wheel
.dl Bank06
	.dw $1140
	.dl Art_CEZ_Block
.dl Bank16
	.dw $1340
	.dl Art_Badnik_Fish
.dl Bank16 + $80
	.dw $1400
	.dl Art_Badnik_Fish
.dl Bank09
	.dw $14C0
	.dl Art_Badnik_Crab
.dl Bank04
	.dw $1980
	.dl Art_Badnik_Turtle
.db $FF

Tileset_CEZ3:
.dl Bank07
	.dw $0200
	.dl Art_Icons_Numbers
.dl Bank24
	.dw $0C40
	.dl Art_CEZ_Boss
.dl Bank24
	.dw $1F80
	.dl Art_CEZ3_Cloud
.db $FF 

Tileset_UNK1:
.dl Bank10
	.dw $0200
	.dl Art_Ending_Text
.dl Bank20
	.dw $0940
	.dl Art_End
.dl Bank20 + $80
	.dw $0C80
	.dl Art_Tails_Running
.dl Bank20 + $80
	.dw $1700
	.dl Art_Tails_Skid
.dl Bank20 + $80
	.dw $18C0
	.dl Art_Tails_LookingUp
.db $FF 

Tileset_Intro:
.dl Bank07
	.dw $0200
	.dl Art_Icons_Numbers
.dl Bank07
	.dw $09C0
	.dl Art_Monitors_Generic
.dl Bank07
	.dw $07C0
	.dl Art_Rings
.dl Bank26
	.dw $0C00
	.dl Art_Block_Fragment
.db $FF
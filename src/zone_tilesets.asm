;Tileset header chains for each zone/act
;Under Ground Zone
.db Bank09	;act1
	.dw $2100
	.dw Art_UGZ_Level_Tiles
	.dl Tileset_UGZ
.db Bank09	;act2
	.dw $2100
	.dw Art_UGZ_Level_Tiles
	.dl Tileset_UGZ
.db Bank09	;act3
	.dw $2100
	.dw Art_UGZ_Level_Tiles
	.dl Tileset_UGZ

;Sky High Zone
.db Bank10
	.dw $2000
	.dw Art_SHZ_Level_Tiles
	.dl Tileset_SHZ
.db Bank23
	.dw $2000
	.dw Art_SHZ2_Level_Tiles
	.dl Tileset_SHZ
.db Bank10
	.dw $2000
	.dw Art_SHZ_Level_Tiles
	.dl Tileset_SHZ

;Aqua Lake Zone
.db Bank21
	.dw $20C0
	.dw Art_ALZ_Level_Tiles
	.dl Tileset_ALZ 
.db Bank21
	.dw $20C0
	.dw Art_ALZ2_Level_Tiles
	.dl Tileset_ALZ 
.db Bank21
	.dw $20C0
	.dw Art_ALZ_Level_Tiles
	.dl Tileset_ALZ 

;Green Hills Zone
.db Bank10
	.dw $2000
	.dw Art_GHZ_Level_Tiles
	.dl Tileset_GHZ 
.db Bank10
	.dw $2000
	.dw Art_GHZ_Level_Tiles
	.dl Tileset_GHZ
.db Bank10
	.dw $2000
	.dw Art_GHZ_Level_Tiles
	.dl Tileset_GHZ

.db Bank10
	.dw $2000
	.dw Art_GMZ_Level_Tiles
	.dl Tileset_GMZ
.db Bank10
	.dw $2000
	.dw Art_GMZ_Level_Tiles
	.dl Tileset_GMZ
.db Bank10
	.dw $2000
	.dw Art_GMZ_Level_Tiles
	.dl Tileset_GMZ

.db Bank20
	.dw $2000
	.dw Art_SEZ_Level_Tiles
	.dl Tileset_SEZ
.db Bank20
	.dw $2000
	.dw Art_SEZ2_Level_Tiles
	.dl Tileset_SEZ
.db Bank20
	.dw $2000
	.dw Art_SEZ_Level_Tiles
	.dl Tileset_SEZ

.db Bank21
	.dw $2000
	.dw Art_CEZ_Level_Tiles
	.dl Tileset_CEZ
.db Bank21
	.dw $2000
	.dw Art_CEZ_Level_Tiles
	.dl Tileset_CEZ
.db Bank21
	.dw $2000
	.dw Art_CEZ3_Level_Tiles
	.dl Tileset_CEZ3 

.db Bank27
	.dw $2000
	.dw Art_Ending_Tiles
	.dl Tileset_UNK1
.db Bank27
	.dw $2000
	.dw Art_Ending_Tiles
	.dl Tileset_UNK1
.db Bank27
	.dw $2000
	.dw Art_Ending_Tiles
	.dl Tileset_UNK1

.db Bank08
	.dw $2000
	.dw Art_Intro_Sequence
	.dl Tileset_Intro
.db Bank08
	.dw $2000
	.dw Art_Beta_Title
	.dl Tileset_Intro
.db Bank08
	.dw $2000
	.dw Art_Beta_Title
	.dl Tileset_Intro
.db Bank08
	.dw $2000
	.dw Art_Intro_Sequence
	.dl Tileset_Intro
.db Bank08
	.dw $2000
	.dw Art_Beta_Title
	.dl Tileset_Intro
.db Bank08
	.dw $2000
	.dw Art_Beta_Title
	.dl Tileset_Intro

Tileset_UGZ:
.db Bank07
	.dw $0200
	.dw Art_Icons_Numbers 
.db Bank07
	.dw $09C0
	.dw Art_Monitors_Generic 
.db Bank07
	.dw $07C0
	.dw Art_Rings
.db Bank26
	.dw $0C00
	.dw Art_Block_Fragment
.db Bank09
	.dw $0C40
	.dw Art_UGZ_Unknown 
.db Bank07
	.dw $0D40
	.dw Art_Minecart
.db Bank09
	.dw $10C0
	.dw Art_UGZ_Spikes 
.db Bank16
	.dw $1240
	.dw Art_UGZ_Fireball
.db Bank16
	.dw $1300
	.dw Art_Badnik_Motobug
.db Bank16 + $80	;mirror tiles
	.dw $1500
	.dw Art_Badnik_Motobug 
.db Bank09 + $80	;mirror tiles
	.dw $1700
	.dw Art_Badnik_Newtron
.db Bank09
	.dw $1A80
	.dw Art_Badnik_Crab
.db Bank09
	.dw $1F40
	.dw Art_UGZ_Spikes 
.db $FF

Tileset_SHZ:
.db Bank07
	.dw $0200
	.dw Art_Icons_Numbers 
.db Bank07
	.dw $09C0
	.dw Art_Monitors_Generic 
.db Bank07
	.dw $07C0
	.dw Art_Rings
.db Bank26
	.dw $0C00
	.dw Art_Block_Fragment
.db Bank07
	.dw $0C40
	.dw Art_SHZ_Log
.db Bank07
	.dw $0CC0
	.dw Art_SHZ_Moving_Platform
.db Bank26
	.dw $0DC0
	.dw Art_SHZ_Rock 
.db Bank04
	.dw $0F40
	.dw Art_Badnik_Turtle
.db Bank04 + $80
	.dw $1240
	.dw Art_Badnik_Turtle
.db Bank09
	.dw $1540
	.dw Art_SHZ_Yellow_Bird 
.db Bank09 + $80
	.dw $15C0
	.dw Art_Badnik_Newtron
.db Bank07
	.dw $1940
	.dw Art_SHZ_Glider 
.db Bank04
	.dw $1EC0
	.dw Art_SHZ_Leaves 
.db $FF

Tileset_ALZ:
.db Bank07
	.dw $0200
	.dw Art_Icons_Numbers 
.db Bank07
	.dw $09C0
	.dw Art_Monitors_Generic
.db Bank07
	.dw $07C0
	.dw Art_Rings
.db Bank26
	.dw $0C00
	.dw Art_Block_Fragment
.db Bank09
	.dw $0C40
	.dw Art_ALZ_Spike
.db Bank16
	.dw $0E40
	.dw Art_Badnik_Lobster
.db Bank16 + $80
	.dw $1140
	.dw Art_Badnik_Lobster
.db Bank09
	.dw $1440
	.dw Art_Badnik_Crab
.db Bank09
	.dw $1900
	.dw Art_ALZ_Unknown2
.db Bank09
	.dw $1980
	.dw Art_ALZ_Unknown
.db Bank04
	.dw $1A00
	.dw Art_ALZ_Bubble
.db Bank09
	.dw $1C40
	.dw Art_ALZ_Big_Bubble 
.db $FF

Tileset_GHZ:
.db Bank07
	.dw $0200
	.dw Art_Icons_Numbers 
.db Bank07
	.dw $09C0
	.dw Art_Monitors_Generic
.db Bank07
	.dw $07C0
	.dw Art_Rings
.db Bank26
	.dw $0C00
	.dw Art_Block_Fragment
.db Bank07
	.dw $0C40
	.dw Art_GHZ_Moving_Platform
.db Bank16
	.dw $0D40
	.dw Art_Badnik_Motobug
.db Bank16 + $80
	.dw $0F40
	.dw Art_Badnik_Motobug
.db Bank09 + $80
	.dw $1140
	.dw Art_Badnik_Newtron 
.db Bank09
	.dw $14C0
	.dw Art_Badnik_Crab
.db $FF

Tileset_GMZ:
.db Bank07
	.dw $0200
	.dw Art_Icons_Numbers 
.db Bank07
	.dw $09C0
	.dw Art_Monitors_Generic
.db Bank07
	.dw $07C0
	.dw Art_Rings
.db Bank26
	.dw $0C00
	.dw Art_Block_Fragment
.db Bank09
	.dw $0C40
	.dw Art_GMZ_Moving_Platform
.db Bank07
	.dw $0D40
	.dw Art_Minecart
.db Bank16
	.dw $10C0
	.dw Art_Badnik_Burrobot
.db Bank16 + $80
	.dw $1440
	.dw Art_Badnik_Burrobot
.db Bank04
	.dw $17C0
	.dw Art_Badnik_Pig
.db Bank09
	.dw $1AC0
	.dw Art_Badnik_Bomb
.db Bank09 + $80
	.dw $1CC0
	.dw Art_Badnik_Bomb
.db Bank09
	.dw $1EC0
	.dw Art_GMZ_Spikes
.db $FF

Tileset_SEZ:
.db Bank07
	.dw $0200
	.dw Art_Icons_Numbers 
.db Bank07
	.dw $09C0
	.dw Art_Monitors_Generic
.db Bank07
	.dw $07C0
	.dw Art_Rings
.db Bank26
	.dw $0C00
	.dw Art_Block_Fragment
.db Bank09
	.dw $0C40
	.dw Art_SEZ_Moving_Platform
.db Bank18
	.dw $0D40
	.dw Art_SEZ_Block
.db Bank04
	.dw $0DC0
	.dw Art_Badnik_Turtle
.db Bank04 + $80
	.dw $10C0
	.dw Art_Badnik_Turtle
.db Bank09
	.dw $13C0
	.dw Art_Badnik_Bomb
.db Bank09 + $80
	.dw $15C0
	.dw Art_Badnik_Bomb
.db Bank09
	.dw $17C0
	.dw Art_Badnik_Crab
.db $FF

Tileset_CEZ:
.db Bank07
	.dw $0200
	.dw Art_Icons_Numbers 
.db Bank07
	.dw $09C0
	.dw Art_Monitors_Generic 
.db Bank07
	.dw $07C0
	.dw Art_Rings
.db Bank26
	.dw $0C00
	.dw Art_Block_Fragment
.db Bank18
	.dw $0C40
	.dw Art_CEZ_Moving_Platform
.db Bank18
	.dw $0D40
	.dw Art_CEZ_Rock
.db Bank06
	.dw $0E40
	.dw Art_CEZ_Wheel
.db Bank06
	.dw $1140
	.dw Art_CEZ_Block
.db Bank16
	.dw $1340
	.dw Art_Badnik_Fish
.db Bank16 + $80
	.dw $1400
	.dw Art_Badnik_Fish
.db Bank09
	.dw $14C0
	.dw Art_Badnik_Crab
.db Bank04
	.dw $1980
	.dw Art_Badnik_Turtle
.db $FF

Tileset_CEZ3:
.db Bank07
	.dw $0200
	.dw Art_Icons_Numbers
.db Bank24
	.dw $0C40
	.dw Art_CEZ_Boss
.db Bank24
	.dw $1F80
	.dw Art_CEZ3_Cloud
.db $FF 

Tileset_UNK1:
.db Bank10
	.dw $0200
	.dw Art_Ending_Text
.db Bank20
	.dw $0940
	.dw Art_End
.db Bank20 + $80
	.dw $0C80
	.dw Art_Tails_Running
.db Bank20 + $80
	.dw $1700
	.dw Art_Tails_Skid
.db Bank20 + $80
	.dw $18C0
	.dw Art_Tails_LookingUp
.db $FF 

Tileset_Intro:
.db Bank07
	.dw $0200
	.dw Art_Icons_Numbers
.db Bank07
	.dw $09C0
	.dw Art_Monitors_Generic
.db Bank07
	.dw $07C0
	.dw Art_Rings
.db Bank26
	.dw $0C00
	.dw Art_Block_Fragment
.db $FF
;Tileset header chains for each zone/act
;Under Ground Zone
.db Art_UGZ_Level_Tiles	;act1
	.dl $2100
	.dl Art_UGZ_Level_Tiles
	.dl Tileset_UGZ
.db Art_UGZ_Level_Tiles	;act2
	.dl $2100
	.dl Art_UGZ_Level_Tiles
	.dl Tileset_UGZ
.db Art_UGZ_Level_Tiles	;act3
	.dl $2100
	.dl Art_UGZ_Level_Tiles
	.dl Tileset_UGZ

;Sky High Zone
.db Art_SHZ_Level_Tiles
	.dl $2000
	.dl Art_SHZ_Level_Tiles
	.dl Tileset_SHZ
.db Art_SHZ2_Level_Tiles
	.dl $2000
	.dl Art_SHZ2_Level_Tiles
	.dl Tileset_SHZ
.db Art_SHZ_Level_Tiles
	.dl $2000
	.dl Art_SHZ_Level_Tiles
	.dl Tileset_SHZ

;Aqua Lake Zone
.db Art_ALZ_Level_Tiles
	.dl $20C0
	.dl Art_ALZ_Level_Tiles
	.dl Tileset_ALZ 
.db Art_ALZ_Level_Tiles
	.dl $20C0
	.dl Art_ALZ2_Level_Tiles
	.dl Tileset_ALZ 
.db Art_ALZ_Level_Tiles
	.dl $20C0
	.dl Art_ALZ_Level_Tiles
	.dl Tileset_ALZ 

;Green Hills Zone
.db Art_GHZ_Level_Tiles
	.dl $2000
	.dl Art_GHZ_Level_Tiles
	.dl Tileset_GHZ 
.db Art_GHZ_Level_Tiles
	.dl $2000
	.dl Art_GHZ_Level_Tiles
	.dl Tileset_GHZ
.db Art_GHZ_Level_Tiles
	.dl $2000
	.dl Art_GHZ_Level_Tiles
	.dl Tileset_GHZ

.db Art_GMZ_Level_Tiles
	.dl $2000
	.dl Art_GMZ_Level_Tiles
	.dl Tileset_GMZ
.db Art_GMZ_Level_Tiles
	.dl $2000
	.dl Art_GMZ_Level_Tiles
	.dl Tileset_GMZ
.db Art_GMZ_Level_Tiles
	.dl $2000
	.dl Art_GMZ_Level_Tiles
	.dl Tileset_GMZ

.db Art_SEZ_Level_Tiles
	.dl $2000
	.dl Art_SEZ_Level_Tiles
	.dl Tileset_SEZ
.db Art_SEZ_Level_Tiles
	.dl $2000
	.dl Art_SEZ2_Level_Tiles
	.dl Tileset_SEZ
.db Art_SEZ_Level_Tiles
	.dl $2000
	.dl Art_SEZ_Level_Tiles
	.dl Tileset_SEZ

.db Art_CEZ_Level_Tiles
	.dl $2000
	.dl Art_CEZ_Level_Tiles
	.dl Tileset_CEZ
.db Art_CEZ_Level_Tiles
	.dl $2000
	.dl Art_CEZ_Level_Tiles
	.dl Tileset_CEZ
.db Art_CEZ3_Level_Tiles
	.dl $2000
	.dl Art_CEZ3_Level_Tiles
	.dl Tileset_CEZ3 

.db Art_Ending_Tiles
	.dl $2000
	.dl Art_Ending_Tiles
	.dl Tileset_UNK1
.db Art_Ending_Tiles
	.dl $2000
	.dl Art_Ending_Tiles
	.dl Tileset_UNK1
.db Art_Ending_Tiles
	.dl $2000
	.dl Art_Ending_Tiles
	.dl Tileset_UNK1



.db Art_Intro_Sequence
	.dl $2000
	.dl Art_Intro_Sequence
	.dl Tileset_Intro
.db Art_Beta_Title
	.dl $2000
	.dl Art_Beta_Title
	.dl Tileset_Intro
.db Art_Beta_Title
	.dl $2000
	.dl Art_Beta_Title
	.dl Tileset_Intro
.db Art_Intro_Sequence
	.dl $2000
	.dl Art_Intro_Sequence
	.dl Tileset_Intro
.db Art_Beta_Title
	.dl $2000
	.dl Art_Beta_Title
	.dl Tileset_Intro
.db Art_Beta_Title
	.dl $2000
	.dl Art_Beta_Title
	.dl Tileset_Intro

Tileset_UGZ:
.db Art_Icons_Numbers
	.dl $0200
	.dl Art_Icons_Numbers 
.db Art_Monitors_Generic
	.dl $09C0
	.dl Art_Monitors_Generic 
.db Art_Rings
	.dl $07C0
	.dl Art_Rings
.db Art_Block_Fragment
	.dl $0C00
	.dl Art_Block_Fragment
.db Art_UGZ_Unknown
	.dl $0C40
	.dl Art_UGZ_Unknown 
.db Art_Minecart
	.dl $0D40
	.dl Art_Minecart
.db Art_UGZ_Spikes
	.dl $10C0
	.dl Art_UGZ_Spikes 
.db Art_UGZ_Fireball
	.dl $1240
	.dl Art_UGZ_Fireball
.db Art_Badnik_Motobug
	.dl $1300
	.dl Art_Badnik_Motobug
.db Art_Badnik_Motobug + $80	;mirror tiles
	.dl $1500
	.dl Art_Badnik_Motobug 
.db Art_Badnik_Newtron + $80	;mirror tiles
	.dl $1700
	.dl Art_Badnik_Newtron
.db Art_Badnik_Crab
	.dl $1A80
	.dl Art_Badnik_Crab
.db Art_UGZ_Spikes
	.dl $1F40
	.dl Art_UGZ_Spikes 
.db $FF

Tileset_SHZ:
.db Art_Icons_Numbers
	.dl $0200
	.dl Art_Icons_Numbers 
.db Art_Monitors_Generic
	.dl $09C0
	.dl Art_Monitors_Generic 
.db Art_Rings
	.dl $07C0
	.dl Art_Rings
.db Art_Block_Fragment
	.dl $0C00
	.dl Art_Block_Fragment
.db Art_SHZ_Log
	.dl $0C40
	.dl Art_SHZ_Log
.db Art_SHZ_Moving_Platform
	.dl $0CC0
	.dl Art_SHZ_Moving_Platform
.db Art_SHZ_Rock
	.dl $0DC0
	.dl Art_SHZ_Rock 
.db Art_Badnik_Turtle
	.dl $0F40
	.dl Art_Badnik_Turtle
.db Art_Badnik_Turtle + $80
	.dl $1240
	.dl Art_Badnik_Turtle
.db Art_SHZ_Yellow_Bird
	.dl $1540
	.dl Art_SHZ_Yellow_Bird 
.db Art_Badnik_Newtron + $80
	.dl $15C0
	.dl Art_Badnik_Newtron
.db Art_SHZ_Glider
	.dl $1940
	.dl Art_SHZ_Glider 
.db Art_SHZ_Leaves
	.dl $1EC0
	.dl Art_SHZ_Leaves 
.db $FF

Tileset_ALZ:
.db Art_Icons_Numbers
	.dl $0200
	.dl Art_Icons_Numbers 
.db Art_Monitors_Generic
	.dl $09C0
	.dl Art_Monitors_Generic
.db Art_Rings
	.dl $07C0
	.dl Art_Rings
.db Art_Block_Fragment
	.dl $0C00
	.dl Art_Block_Fragment
.db Art_ALZ_Spike
	.dl $0C40
	.dl Art_ALZ_Spike
.db Art_Badnik_Lobster
	.dl $0E40
	.dl Art_Badnik_Lobster
.db Art_Badnik_Lobster + $80
	.dl $1140
	.dl Art_Badnik_Lobster
.db Art_Badnik_Crab
	.dl $1440
	.dl Art_Badnik_Crab
.db Art_ALZ_Unknown2
	.dl $1900
	.dl Art_ALZ_Unknown2
.db Art_ALZ_Unknown
	.dl $1980
	.dl Art_ALZ_Unknown
.db Art_ALZ_Bubble
	.dl $1A00
	.dl Art_ALZ_Bubble
.db Art_ALZ_Big_Bubble
	.dl $1C40
	.dl Art_ALZ_Big_Bubble 
.db $FF

Tileset_GHZ:
.db Art_Icons_Numbers
	.dl $0200
	.dl Art_Icons_Numbers 
.db Art_Monitors_Generic
	.dl $09C0
	.dl Art_Monitors_Generic
.db Art_Rings
	.dl $07C0
	.dl Art_Rings
.db Art_Block_Fragment
	.dl $0C00
	.dl Art_Block_Fragment
.db Art_GHZ_Moving_Platform
	.dl $0C40
	.dl Art_GHZ_Moving_Platform
.db Art_Badnik_Motobug
	.dl $0D40
	.dl Art_Badnik_Motobug
.db Art_Badnik_Motobug + $80
	.dl $0F40
	.dl Art_Badnik_Motobug
.db Art_Badnik_Newtron + $80
	.dl $1140
	.dl Art_Badnik_Newtron 
.db Art_Badnik_Crab
	.dl $14C0
	.dl Art_Badnik_Crab
.db $FF

Tileset_GMZ:
.db Art_Icons_Numbers
	.dl $0200
	.dl Art_Icons_Numbers 
.db Art_Monitors_Generic
	.dl $09C0
	.dl Art_Monitors_Generic
.db Art_Rings
	.dl $07C0
	.dl Art_Rings
.db Art_Block_Fragment
	.dl $0C00
	.dl Art_Block_Fragment
.db Art_GMZ_Moving_Platform
	.dl $0C40
	.dl Art_GMZ_Moving_Platform
.db Art_Minecart
	.dl $0D40
	.dl Art_Minecart
.db Art_Badnik_Burrobot
	.dl $10C0
	.dl Art_Badnik_Burrobot
.db Art_Badnik_Burrobot + $80
	.dl $1440
	.dl Art_Badnik_Burrobot
.db Art_Badnik_Pig
	.dl $17C0
	.dl Art_Badnik_Pig
.db Art_Badnik_Bomb
	.dl $1AC0
	.dl Art_Badnik_Bomb
.db Art_Badnik_Bomb + $80
	.dl $1CC0
	.dl Art_Badnik_Bomb
.db Art_GMZ_Spikes
	.dl $1EC0
	.dl Art_GMZ_Spikes
.db $FF

Tileset_SEZ:
.db Art_Icons_Numbers
	.dl $0200
	.dl Art_Icons_Numbers 
.db Art_Monitors_Generic
	.dl $09C0
	.dl Art_Monitors_Generic
.db Art_Rings
	.dl $07C0
	.dl Art_Rings
.db Art_Block_Fragment
	.dl $0C00
	.dl Art_Block_Fragment
.db Art_SEZ_Moving_Platform
	.dl $0C40
	.dl Art_SEZ_Moving_Platform
.db Art_SEZ_Block
	.dl $0D40
	.dl Art_SEZ_Block
.db Art_Badnik_Turtle
	.dl $0DC0
	.dl Art_Badnik_Turtle
.db Art_Badnik_Turtle + $80
	.dl $10C0
	.dl Art_Badnik_Turtle
.db Art_Badnik_Bomb
	.dl $13C0
	.dl Art_Badnik_Bomb
.db Art_Badnik_Bomb + $80
	.dl $15C0
	.dl Art_Badnik_Bomb
.db Art_Badnik_Crab
	.dl $17C0
	.dl Art_Badnik_Crab
.db $FF

Tileset_CEZ:
.db Art_Icons_Numbers
	.dl $0200
	.dl Art_Icons_Numbers 
.db Art_Monitors_Generic
	.dl $09C0
	.dl Art_Monitors_Generic 
.db Art_Rings
	.dl $07C0
	.dl Art_Rings
.db Art_Block_Fragment
	.dl $0C00
	.dl Art_Block_Fragment
.db Art_CEZ_Moving_Platform
	.dl $0C40
	.dl Art_CEZ_Moving_Platform
.db Art_CEZ_Rock
	.dl $0D40
	.dl Art_CEZ_Rock
.db Art_CEZ_Wheel
	.dl $0E40
	.dl Art_CEZ_Wheel
.db Art_CEZ_Block
	.dl $1140
	.dl Art_CEZ_Block
.db Art_Badnik_Fish
	.dl $1340
	.dl Art_Badnik_Fish
.db Art_Badnik_Fish + $80
	.dl $1400
	.dl Art_Badnik_Fish
.db Art_Badnik_Crab
	.dl $14C0
	.dl Art_Badnik_Crab
.db Art_Badnik_Turtle
	.dl $1980
	.dl Art_Badnik_Turtle
.db $FF

Tileset_CEZ3:
.db Art_Icons_Numbers
	.dl $0200
	.dl Art_Icons_Numbers
.db Art_CEZ_Boss
	.dl $0C40
	.dl Art_CEZ_Boss
.db Art_CEZ3_Cloud
	.dl $1F80
	.dl Art_CEZ3_Cloud
.db $FF 

Tileset_UNK1:
.db Art_Ending_Text
	.dl $0200
	.dl Art_Ending_Text
.db Art_End
	.dl $0940
	.dl Art_End
.db Art_Tails_Running + $80
	.dl $0C80
	.dl Art_Tails_Running
.db Art_Tails_Skid + $80
	.dl $1700
	.dl Art_Tails_Skid
.db Art_Tails_LookingUp + $80
	.dl $18C0
	.dl Art_Tails_LookingUp
.db $FF 

Tileset_Intro:
.db Art_Icons_Numbers
	.dl $0200
	.dl Art_Icons_Numbers
.db Art_Monitors_Generic
	.dl $09C0
	.dl Art_Monitors_Generic
.db Art_Rings
	.dl $07C0
	.dl Art_Rings
.db Art_Block_Fragment
	.dl $0C00
	.dl Art_Block_Fragment
.db $FF

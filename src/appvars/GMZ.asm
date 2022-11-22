Art_GMZ_Level_Tiles:		;$A2AC
#import "art\level\gmz\art_gmz_level_tiles.bin"

Art_GMZ_Moving_Platform:	;B24F
#import "art\level\gmz\art_gmz_moving_platform.bin"

Art_GMZ_Spikes:			;BCB1
#import "art\level\gmz\art_gmz_spikes.bin"

Art_Minecart:
#import "art/misc/art_minecart.bin"

Art_Badnik_Pig:			
#import "art/badniks/art_badnik_pig.bin"

Art_Badnik_Burrobot:	;$B9A0
#import "art\badniks\art_badnik_gmz_burrobot.bin"

Art_GMZ_Boss:
#import "art\boss\art_ucmp_gmz_boss.bin"

Art_ChaosEmerald_Red:		;$BB60
#import "art\items\art_ucmp_red_emerald.bin"

Layout_GMZ1:
#import "layout\gmz\layout_gmz1_2.2.bin"

Layout_GMZ2:
#import "layout\gmz\layout_gmz2.bin"

Layout_GMZ3:
#import "layout\gmz\layout_gmz3.bin"

Mappings32_GMZ:
#import "mappings/gmz/mappings32_gmz.bin"
#include "mappings/gmz/mappings32_gmz.asm"

Palette_GMZ_Sonic:
#import "palettes\palette_gmz_sonic.bin"

Palette_GMZ:
#import "palettes\palette_gmz.bin"

GMZ_Title_Pic_Art:
#import "art\titlecard\gmz_title_card_pic.bin"

GMZ_Title_Pic_Mappings:
#import "mappings\titlecard\gmz_title_card_pic_mappings.bin"

Palette_TitleCard_GMZ:
#import "palettes\palette_titlecard_gmz.bin"
Data_ObjectLayout_GMZ:    ;$8161
.dl Data_ObjectLayout_GMZ1 
.dl Data_ObjectLayout_GMZ2 
.dl Data_ObjectLayout_GMZ3 

Data_ObjectLayout_GMZ1:    ;$8983
#import "layout/gmz/object_layout_gmz1.bin"
Data_ObjectLayout_GMZ2:    ;$8A4A
#import "layout/gmz/object_layout_gmz2.bin"
Data_ObjectLayout_GMZ3:    ;$8AFF
#import "layout/gmz/object_layout_gmz3.bin"
AppVarObj	.equ $15	;application variable

UndergroundZone: 
.db	AppVarObj, "UGZ", 0 

Art_UGZ_Level_Tiles:
#import "art\level\ugz\art_ugz_level_tiles.bin"

Art_UGZ_Spikes:
#import "art\level\ugz\art_ugz_spikes.bin"

Art_Boss_UGZ:
#import "art\boss\art_ucmp_ugz_boss.bin"

Art_UGZ_Fireball:
#import "art\level\ugz\art_ugz_fireball.bin"

Art_Minecart:
#import "art/misc/art_minecart.bin"

Art_ChaosEmerald_Blue:
#import "art\items\art_ucmp_blue_emerald.bin"

Art_UGZ_Unknown:
#import "art\level\ugz\art_ugz_unknown.bin"

Layout_UGZ1:
#import "layout\ugz\layout_ugz1.bin"

Layout_UGZ2:
#import "layout\ugz\layout_ugz2.bin"

Layout_UGZ3:
#import "layout\ugz\layout_ugz3.bin"

Mappings32_UGZ:
#import "mappings\ugz\mappings32_ugz.bin"
#include "mappings\ugz\mappings32_ugz.asm"

Palette_UGZ:
#import "palettes\palette_ugz.bin"

Palette_UGZ_Sonic:
#import "palettes\palette_ugz_sonic.bin"

UGZ_Title_Pic_Art:
#import "art\titlecard\ugz_title_card_pic.bin"

DATA_2A34:	;mappings for "UNDER GROUND"
#import "mappings/titlecard/titlecard_mappings_2A34.bin"

UGZ_Title_Pic_Mappings:
#import "mappings\titlecard\ugz_title_card_pic_mappings.bin"

Palette_TitleCard_GHZ:
#import "palettes\palette_titlecard_ghz.bin"

Data_ObjectLayout_UGZ:
.dl Data_ObjectLayout_UGZ1
.dl Data_ObjectLayout_UGZ2 
.dl Data_ObjectLayout_UGZ3 

Data_ObjectLayout_UGZ1:    ;$8173
#import "layout/ugz/object_layout_ugz1.bin"
Data_ObjectLayout_UGZ2:    ;$82C1
#import "layout/ugz/object_layout_ugz2.bin"
Data_ObjectLayout_UGZ3:    ;$840F
#import "layout/ugz/object_layout_ugz3.bin"
AppVarObj	.equ $15	;application variable

SkyHighZone: 
.db	AppVarObj, "SHZ", 0 

Layout_SHZ1:
#import "layout\shz\layout_shz1_2.2.bin"

Layout_SHZ2:
#import "layout\shz\layout_shz2_2.2.bin"

Layout_SHZ3:
#import "layout\shz\layout_shz3.bin"

Mappings32_SHZ1_3:
#import "mappings\shz\mappings32_shz1_3.bin"
#include "mappings\shz\mappings32_shz1_3.asm"

Mappings32_SHZ2:
#import "mappings\shz\mappings32_shz2.bin"
#include "mappings\shz\mappings32_shz2.asm"

Art_SHZ_Level_Tiles:		;$8000
#import "art\level\shz\art_shz_level_tiles.bin"

Art_SHZ2_Level_Tiles:
#import "art\level\shz\art_shz2_level_tiles.bin"

Art_SHZ_Yellow_Bird:		;B0DD
#import "art\level\shz\art_shz_yellow_bird.bin"

Art_SHZ_Log:
#import "art/level/shz/art_shz_log.bin"

Art_SHZ_Rock:
#import "art\level\shz\art_shz_rock.bin"

Art_SHZ_Leaves:		;BC50
#import "art\level\shz\art_shz_leaves.bin"

Art_SHZ_Moving_Platform:
#import "art/level/shz/art_shz_moving_platform.bin"

Art_ChaosEmerald_Yellow:		;$BBE0
#import "art\items\art_ucmp_yellow_emerald.bin"

Art_SHZ_Boss:
#import "art\boss\art_ucmp_shz_boss.bin"

Palette_SHZ1_3_Sonic:
#import "palettes\palette_shz1_3_sonic.bin"

Palette_SHZ2_Sonic:
#import "palettes\palette_shz2_sonic.bin"

Palette_SHZ1_3:
#import "palettes\palette_shz1_3.bin"

Palette_SHZ2:
#import "palettes\palette_shz2.bin"

DemoControlSequence_SHZ:
#import "demo\demo_control_sequence_shz.bin"

SHZ_Title_Pic_Art:
#import "art\titlecard\shz_title_card_pic.bin"

DATA_2AA4:	;mappings for "SKY HIGH"
  #import "mappings/titlecard/titlecard_mappings_2AA4.bin"

SHZ_Title_Pic_Mappings:
#import "mappings\titlecard\shz_title_card_pic_mappings.bin"

Palette_TitleCard_SHZ:
#import "palettes\palette_titlecard_shz.bin"

Data_ObjectLayout_SHZ:    ;$814F
.dl Data_ObjectLayout_SHZ1
.dl Data_ObjectLayout_SHZ2
.dl Data_ObjectLayout_SHZ3

Data_ObjectLayout_SHZ1:    ;$848E
#import "layout/shz/object_layout_shz1.bin"
Data_ObjectLayout_SHZ2:    ;$84E9
#import "layout/shz/object_layout_shz2.bin"
Data_ObjectLayout_SHZ3:    ;$8568
#import "layout/shz/object_layout_shz3.bin"
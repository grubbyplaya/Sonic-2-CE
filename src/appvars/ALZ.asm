Layout_ALZ1:
#import "layout\alz\layout_alz1.bin"

Layout_ALZ2:
#import "layout\alz\layout_alz2.bin"

Layout_ALZ3:
#import "layout\alz\layout_alz3.bin"

Mappings32_ALZ:
#import "mappings\alz\mappings32_alz.bin"
#include "mappings\alz\mappings32_alz.asm"

Mappings32_ALZ2:
#import "mappings\alz\mappings32_alz2.bin"
#include "mappings\alz\mappings32_alz2.asm"

Art_ALZ_Level_Tiles:		;$8000
#import "art\level\alz\art_alz_level_tiles.bin"

Art_ALZ2_Level_Tiles:		;$9050
#import "art\level\alz\art_alz2_level_tiles.bin"

Art_ALZ_Spike:				;B15D
#import "art\level\alz\art_alz_spike.bin"

Art_ALZ_Unknown:			;BB91
#import "art\level\alz\art_alz_unknown.bin"

Art_ALZ_Unknown2:			;BBE1
#import "art\level\alz\art_alz_unknown2.bin"

Art_ALZ_Bubble:			;B800
#import "art/level/alz/art_alz_bubble.bin"

Art_ALZ_Big_Bubble:			;BD51
#import "art\level\alz\art_alz_big_bubble.bin"

Art_ChaosEmerald_Pink:		;$BAE0
#import "art\items\art_ucmp_pink_emerald.bin"

Art_ALZ_Boss:
#import "art\boss\art_ucmp_alz_boss.bin"

Palette_ALZ1_3_Sonic:
#import "palettes\palette_alz1_3_sonic.bin"

Palette_ALZ2_Sonic:
#import "palettes\palette_alz2_sonic.bin"

Palette_ALZ1_3:
#import "palettes\palette_alz1_3.bin"

Palette_ALZ2:
#import "palettes\palette_alz2.bin"

DemoControlSequence_ALZ:		;$B072
#import "demo\demo_control_sequence_alz.bin"

ALZ_Title_Pic_Art:
#import "art\titlecard\alz_title_card_pic.bin"

ALZ_Title_Pic_Mappings:
#import "mappings\titlecard\alz_title_card_pic_mappings.bin"

Palette_TitleCard_ALZ:
#import "palettes\palette_titlecard_alz.bin"

Data_ObjectLayout_ALZ:    ;$8155
.dl Data_ObjectLayout_ALZ1 
.dl Data_ObjectLayout_ALZ2 
.dl Data_ObjectLayout_ALZ3 

Data_ObjectLayout_ALZ1:    ;$8584
#import "layout/alz/object_layout_alz1.bin"
Data_ObjectLayout_ALZ2:    ;$8666
#import "layout/alz/object_layout_alz2.bin"
Data_ObjectLayout_ALZ3:    ;$87BD
#import "layout/alz/object_layout_alz3.bin"
Layout_CEZ1:
#import "layout\cez\layout_cez1.bin"

Layout_CEZ2:
#import "layout\cez\layout_cez2.bin"

Art_CEZ_Level_Tiles:		;$A116
#import "art\level\cez\art_cez_level_tiles.bin"

Art_CEZ_Moving_Platform:		;BC80
#import "art\level\cez\art_cez_moving_platform.bin"

Art_CEZ_Wheel:		;BC00
#import "art\level\cez\art_cez_wheel.bin"

Art_CEZ_Block:		;BE60
#import "art\level\cez\art_cez_block.bin"

Art_CEZ_Rock:					;BD48
#import "art\level\cez\art_cez_rock.bin"

Art_Badnik_Fish:		;$BE28
#import "art\badniks\art_badnik_fish.bin"

Mappings32_CEZ1_2:
#import "mappings\cez\mappings32_cez1_2.bin"
#include "mappings\cez\mappings32_cez1_2.asm"

Palette_CEZ1_2_Sonic:
#import "palettes\palette_cez1_2_sonic.bin"

Palette_CEZ1_2:
#import "palettes\palette_cez1_2.bin"

CEZ_Title_Pic_Art:
#import "art\titlecard\cez_title_card_pic.bin"

CEZ_Title_Pic_Mappings:
#import "mappings\titlecard\cez_title_card_pic_mappings.bin"

Palette_TitleCard_CEZ:
#import "palettes\palette_titlecard_cez.bin"

Data_ObjectLayout_CEZ:    ;$816D
.dl Data_ObjectLayout_CEZ1 
.dl Data_ObjectLayout_CEZ2 
.dl Data_ObjectLayout_CEZ3

Data_ObjectLayout_CEZ1:    ;$8C8F
#import "layout/cez/object_layout_cez1.bin"
Data_ObjectLayout_CEZ2:    ;$8D20
#import "layout/cez/object_layout_cez2.bin"

;Act 3 data

Art_CEZ3_Level_Tiles:		;AE7E
#import "art\level\cez\art_cez3_level_tiles.bin"

Art_CEZ3_Cloud:
#import "art\level\cez\art_cez3_cloud.bin"

Art_CEZ_Boss:
#import "art\boss\art_cez_boss_eggman.bin"

Mappings32_CEZ3:
#import "mappings\cez\mappings32_cez3.bin"
#include "mappings\cez\mappings32_cez3.asm"

Layout_CEZ3:
#import "layout\cez\layout_cez3.bin"

Data_ObjectLayout_CEZ3: ;$8D8D
#import "layout/cez/object_layout_cez3.bin"

Palette_CEZ3_Sonic:
#import "palettes\palette_cez3_sonic.bin"

Palette_CEZ3:
#import "palettes\palette_cez3.bin"

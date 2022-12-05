AppVarObj	.equ $15	;application variable

GreenHillsZone: 
.db	AppVarObj, "GHZ", 0 

#define	Object_Crab				$23
#define	Object_Motobug              	$34   ;motobug badnik
#define	Object_Newtron			$35	;newtron badnik
#define	Object_Monitor			$10
#define	Object_Signpost			$18

Mappings32_GHZ:
#import "mappings\ghz\mappings32_ghz.bin"
#include "mappings\ghz\mappings32_ghz.asm"

Layout_GHZ1:
#import "layout\ghz\layout_ghz1.bin"

Layout_GHZ2:
#import "layout\ghz\layout_ghz2.bin"

Layout_GHZ3:
#import "layout\ghz\layout_ghz3.bin"

Art_GHZ_Level_Tiles:		;$91DC
#import "art\level\ghz\art_ghz_level_tiles.bin"

Art_GHZ_Moving_Platform:
#import "art/level/ghz/art_ghz_moving_platform.bin"

Art_ChaosEmerald_Grey:		;$B960
#import "art\items\art_ucmp_grey_emerald.bin"

Art_GHZ_Boss:
#import "art\boss\art_ucmp_ghz_boss.bin"

Palette_GHZ_Sonic:
#import "palettes\palette_ghz_sonic.bin"

Palette_GHZ:
#import "palettes\palette_ghz.bin"

DemoControlSequence_GHZ:
#import "demo\demo_control_sequence_ghz.bin"

GHZ_Title_Pic_Art:
#import "art\titlecard\ghz_title_card_pic.bin"

GHZ_Title_Pic_Mappings:
#import "mappings\titlecard\ghz_title_card_pic_mappings.bin"

DATA_2904:	;mappings for "GREEN HILLS"
#import "mappings/titlecard/titlecard_mappings_2904.bin"

Data_ObjectLayout_GHZ:    ;$815B
.dl Data_ObjectLayout_GHZ1 
.dl Data_ObjectLayout_GHZ2 
.dl Data_ObjectLayout_GHZ3 

Data_ObjectLayout_GHZ1:    ;$87F4
;#import "layout/ghz/object_layout_ghz1.bin"
#include "layout/ghz/object_layout_ghz1.asm"
Data_ObjectLayout_GHZ2:    ;$88C4
#import "layout/ghz/object_layout_ghz2.bin"
Data_ObjectLayout_GHZ3:    ;$8970
#import "layout/ghz/object_layout_ghz3.bin"
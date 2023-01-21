#include	"includes/ti84pce.inc"

Bank23:
	.db	AppVarObj, "Bank23", 0

Mappings32_SEZ2:
;#import "mappings\sez\mappings32_sez2.bin"
#include "mappings\sez\mappings32_sez2.asm"

Mappings32_CEZ3:
;#import "mappings\cez\mappings32_cez3.bin"
#include "mappings\cez\mappings32_cez3.asm"

Art_SHZ2_Level_Tiles:
#import "art\level\shz\art_shz2_level_tiles.bin"

.db $00, $00

Layout_UGZ2:
#import "layout\ugz\layout_ugz2.bin"
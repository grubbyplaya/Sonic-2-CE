AppVarObj	.equ $15	;application variable

Ending: 
.db	AppVarObj, "END", 0 

;credits
Layout_Good_Ending:
#import "layout/ending/layout_good_ending.bin"

Layout_Bad_Ending:
#import "layout/ending/layout_bad_ending.bin"

Mappings32_Ending:
#import "mappings/ending/mappings32_ending.bin"
#include "mappings/ending/mappings32_ending.asm"

Art_Ending_Tiles:
#import "art/ending/art_ending_tiles.bin"

Art_Ending_Text:			;$B2E2
#import "art/fonts/art_ending_text.bin"

Art_End:					;$AE42
#import "art\ending\art_end.bin"

Art_Tails_Running:			;$B002
#import "art\tails\art_tails_running.bin"

Art_Tails_Skid:				;$B740
#import "art\tails\art_tails_skid.bin"

Palette_Ending_Sequence:
#import "palettes\palette_ending_1.bin"
#import "palettes\palette_ending_2.bin"
#import "palettes\palette_ending_3.bin"
#import "palettes\palette_ending_4.bin"
#import "palettes\palette_ending_5.bin"
#import "palettes\palette_ending_6.bin"
#import "palettes\palette_ending_7.bin"
#import "palettes\palette_ending_8.bin"

Palette_Ending_Sonic:
#import "palettes\palette_ending_sonic.bin"

DATA_B29_B522:
#import "unknown/bank29_B522.bin"

DATA_B29_B542:
#import "unknown/bank29_B542.bin"

;game over
Continue:
.db	AppVarObj, "CONT", 0 

;tile data for the "GAME OVER" text
GameOverScreen_Data_GameOverTiles:		;3380
#import "art\continue_gameover\gameover_screen_tiles.bin"

;tile data for the "CONTINUE" text
ContinueScreen_Data_ContinueTiles:		;3570
#import "art\continue_gameover\continue_tiles.bin"

ContinueScreen_Data_NumberTiles:		;375A
#import "art\continue_gameover\continue_screen_tiles_2.bin"

GameOverScreen_Data_TextMappings:		;3B7E
#import "mappings\continue_gameover\gameover_screen_text_mappings.bin"

ContinueScreen_Data_TextMappings:		;3BC6
#import "mappings\continue_gameover\continue_screen_text_mappings.bin"

ContinueScreen_Data_NumberMappings:		;3C0D
#import "mappings\continue_gameover\continue_screen_number_mappings.bin"
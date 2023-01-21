#include	"includes/ti84pce.inc"

Bank15:
	.db	AppVarObj, "Bank15", 0

Mappings32_ALZ2:
;#import "mappings\alz\mappings32_alz2.bin"
#include "mappings\alz\mappings32_alz2.asm"

Mappings32_UGZ:
;#import "mappings\ugz\mappings32_ugz.bin"
#include "mappings\ugz\mappings32_ugz.asm"


;tile data for the "GAME OVER" text
GameOverScreen_Data_GameOverTiles:		;3380
#import "art\continue_gameover\gameover_screen_tiles.bin"

;tile data for the "CONTINUE" text
ContinueScreen_Data_ContinueTiles:		;3570
#import "art\continue_gameover\continue_tiles.bin"

;just padding?
.db $00, $00

ContinueScreen_Data_NumberTiles:		;375A
#import "art\continue_gameover\continue_screen_tiles_2.bin"

GameOverScreen_Data_TextMappings:		;3B7E
#import "mappings\continue_gameover\gameover_screen_text_mappings.bin"

ContinueScreen_Data_TextMappings:		;3BC6
#import "mappings\continue_gameover\continue_screen_text_mappings.bin"

ContinueScreen_Data_NumberMappings:		;3C0D
#import "mappings\continue_gameover\continue_screen_number_mappings.bin"
AppVarObj	.equ $15	;application variable

INTRO: 
.db	AppVarObj, "INTRO", 0 

Art_Title_Screen:
#import "art\intro_title\art_title_screen.bin"

Art_Intro_Sequence:		;$8000
#import "art\intro_title\art_intro_sequence.bin"

Art_Beta_Title:			;$86A0
#import "art\intro_title\art_beta_title.bin"

Art_Mini_Sonic:			;$9B32
#import "art\intro_title\art_ucmp_mini_sonic.bin"

Art_Intro_Scenery:		;$A832
#import "art\intro_title\art_intro_background.bin"

Art_Intro_Tails:
#import "art\intro_title\art_intro_tails.bin"

Art_Intro_Tails_Eggman:
#import "art\intro_title\art_intro_tails_eggman.bin"

Art_Block_Fragment:
#import "art\misc\art_block_fragment.bin"

Art_Title_Sonic_Hand:	;$A9A2
#import "art\intro_title\art_title_sonic_hand.bin"

Art_Title_Tails_Face:	;$AC32
#import "art\intro_title\art_title_tails_face.bin"

Art_Tails_LookingUp:		;$B850
#import "art\tails\art_tails_look_up.bin"

Layout_Intro:			;$9A32
#import "layout\intro_title\layout_intro.bin"

Layout_Title:			;$9AB2
#import "layout\intro_title\layout_title.bin"

Mappings_Title:			;$ADA2
#import "mappings\intro_title\mappings_title.bin"

Mappings32_Intro:		;$93B0
#import "mappings\intro_title\mappings32_intro.bin"

Mappings32_Title:		;$96E0
#import "mappings\intro_title\mappings32_title.bin"

Art_LevelSelect_Font:
#import "art\fonts\art_level_select_font.bin"

;titlecard

Art_TitleCard_Text_Tiles:
#import "art\titlecard\art_titlecard_text.bin"

Art_TitleCard_Unknown:
#import "art\titlecard\art_titlecard_unknown.bin"

Art_TitleCard_Unknown2:
#import "art\titlecard\art_titlecard_unknown2.bin"

Art_Scrolling_Text_Background:
#import "art/misc/art_misc_scrolling_text_background.bin"

Palette_TitleCards:
#import "palettes\palette_title_cards.bin"
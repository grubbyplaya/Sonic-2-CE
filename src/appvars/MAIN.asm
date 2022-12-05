AppVarObj	.equ 15h	;application variable

S2MAIN: 
.db	AppVarObj, "S2MAIN", 0 

Art_Sonic:				
#import "art/sonic/art_ucmp_sonic.bin"

Art_Sonic_Gliding:
#import "art/sonic/art_ucmp_sonic_gliding.bin"

Art_Sonic_Minecart:
#import "art/sonic/art_ucmp_sonic_minecart.bin"

Art_Sonic_Mirrored:		;$8000
#import "art/sonic/art_ucmp_sonic_mirrored.bin"

Art_Sonic_Gliding_Mirrored:
#import "art/sonic/art_ucmp_sonic_gliding_mirrored.bin"

Art_Sonic_Minecart_Mirrored:
#import "art/sonic/art_ucmp_sonic_minecart_mirrored.bin"

Art_Icons_Numbers:
#import "art/level/icons_numbers.bin" 

Art_Monitors_Generic:
#import "art/items/art_monitor_generic.bin"

Art_Monitors:
Art_Monitor_0:
#import "art/items/art_monitor_0.bin"

Art_Monitor_1:
#import "art/items/art_monitor_1.bin"

Art_Monitor_2:
#import "art/items/art_monitor_2.bin"

Art_Monitor_3:
#import "art/items/art_monitor_3.bin"

Art_Monitor_4:
#import "art/items/art_monitor_4.bin"

Art_Monitor_5:
#import "art/items/art_monitor_5.bin"

Art_Monitor_6:
#import "art/items/art_monitor_6.bin"

Art_Monitor_7:
#import "art/items/art_monitor_7.bin"

Art_Monitor_8:
#import "art/items/art_monitor_8.bin"

Art_Rings:
#import "art/rings/art_rings.bin"

Art_SHZ_Glider:
#import "art/level/shz/art_shz_glider.bin"

Art_Badnik_Turtle:		
#import "art/badniks/art_badnik_turtle.bin"

Art_Badnik_Newtron:		;B3E9
#import "art/badniks/art_badnik_newtron.bin"

Art_Badnik_Bomb:			;B655
#import "art/badniks/art_badnik_bomb.bin"

Art_Badnik_Crab:			;B871
#import "art/badniks/art_badnik_crab.bin"

Art_Badnik_Motobug:		;$BC82
#import "art/badniks/art_badnik_motobug.bin"

Art_Signpost:
#import "art/misc/art_ucmp_signpost.bin"
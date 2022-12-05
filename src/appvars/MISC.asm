AppVarObj	.equ $15	;application variable

Misc: 
.db	AppVarObj, "MISC", 0 

;miscellaneous data from the original game compiled into an appvar to reduce space.

Art_Sonic_Loop_Mirrored:
#import "art/sonic/art_ucmp_sonic_loop_mirrored.bin"

Art_Sonic_Loop:
#import "art/sonic/art_ucmp_sonic_loop.bin"

Art_Tails:
#import "art/tails/art_ucmp_tails.bin"

Art_Unused_Numbers:		;BBD0
#import "art/fonts/art_numbers.bin"

Art_Prison_Capsule:
#import "art/misc/art_ucmp_prison_capsule.bin"

Art_Animals:
#import "art/misc/art_ucmp_animals.bin"

LoopMotionData:		;$840F
#import "misc/data_loop_motion.bin"

Art_WavyLines:			;$B680
#import "art/misc/art_wavy_lines.bin"

Palette_811F:
#import "palettes/palette_811F.bin"

Palette_812F:
#import "palettes/palette_812F.bin"

Palette_813F:
#import "palettes/palette_813F.bin"

Palette_82DF:
#import "palettes/palette_82DF.bin"

Palette_835F:
#import "palettes/palette_835F.bin"

Palette_837F:
#import "palettes/palette_837F.bin"
;temporary file, will merge into s2.asm once ported over
Bank29:
#include "bank29.asm"

;routines to load a level's object layout
#include "object_layout_routines.asm"

#include "object_logic\bank30_logic.asm"

DemoControlSequence_SEZ:
#import "demo\demo_control_sequence_sez.bin"

#include "object_animations.asm"

#include "object_logic\bank31_logic.asm"
;$BCCB
#include "player_sprite_defs.asm"
.ORG $8000

;routines to load a level's object layout
#include "object_layout_routines.asm"

#include "object_logic\bank30_logic.asm"

DATA_B30_9841:
#include "collision_data.asm"

DemoControlSequence_SEZ:
#import "demo\demo_control_sequence_sez.bin"

#if Listing=0
#include "s2.lab"
#endif
#undef Listing
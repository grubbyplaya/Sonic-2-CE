.ORG $8000

;routines to load a level's object layout
#include "src/object_layout_routines.asm"

#include "src/object_logic/bank30_logic.asm"

DemoControlSequence_SEZ:
#import "src/demo/demo_control_sequence_sez.bin"

#if Listing=0
#include "bin/sonic2.lab"
#endif
#undef Listing
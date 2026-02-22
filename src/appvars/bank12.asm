.ORG $8000

Mappings32_GHZ:
;#import "src/mappings/ghz/mappings32_ghz.bin"
#include "src/mappings/ghz/mappings32_ghz.asm"

Mappings32_ALZ:
;#import "src/mappings/alz/mappings32_alz.bin"
#include "src/mappings/alz/mappings32_alz.asm"

Layout_SHZ3:
#import "src/layout/shz/layout_shz3.bin"

Layout_GMZ3:
#if Version = 2
#import "src/layout/gmz/layout_gmz3.bin"
#else
#import "src/layout/gmz/layout_gmz3_og.bin"
#endif
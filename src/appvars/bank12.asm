#include	"includes/ti84pce.inc"
#define	Version = 2
Bank12:
	.db	AppVarObj, "Bank12", 0

Mappings32_GHZ:
;#import "mappings\ghz\mappings32_ghz.bin"
#include "mappings\ghz\mappings32_ghz.asm"

Mappings32_ALZ:
;#import "mappings\alz\mappings32_alz.bin"
#include "mappings\alz\mappings32_alz.asm"

Layout_SHZ3:
#ifdef Version=2
#import "layout\shz\layout_shz3.bin"
#else
#import "layout\shz\layout_shz3_og.bin"
#endif

Layout_GMZ3:
#ifdef Version=2
#import "layout\gmz\layout_gmz3.bin"
#else
#import "layout\gmz\layout_gmz3_og.bin"
#endif
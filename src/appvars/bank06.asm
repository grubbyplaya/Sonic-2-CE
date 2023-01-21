#include	"includes/ti84pce.inc"

Bank06:
	.db	AppVarObj, "Bank06", 0

Art_Sonic_Loop:
#import "art\sonic\art_ucmp_sonic_loop.bin"

Art_CEZ_Wheel:		;BC00
#import "art\level\cez\art_cez_wheel.bin"

Art_CEZ_Block:		;BE60
#import "art\level\cez\art_cez_block.bin"
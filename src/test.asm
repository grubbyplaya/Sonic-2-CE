;tile drawing test
#include "includes\ti84pce.inc"

	.assume ADL=1
	.org userMem-2
	.db tExtTok,tAsm84CeCmp

#define	CRAM	$E30200
#define TileStorage	pixelShadow

_START:
	ld	a, lcdBpp8
	ld	(mpLcdCtrl), a
	ld	iy, VRAM
	ld	hl, Art
	ld	a, (hl)
	ld	b, $20	
_:	call	ConvertTileTo8bpp
	djnz -_
	ret

ConvertTileTo8bpp:
	ld	(plotSScreen-1), a
	res	4, a
	res	5, a
	res	6, a
	res	7, a
	ld	ixl, a
	ld	de, CRAM
	add	ix, de
	ld	a, (ix)
	ld	(iy), a
	inc	iy
	ld	a, (plotSScreen-1)
	res	0, a
	res	1, a
	res	2, a
	res	3, a
	rlca
	rlca
	rlca
	rlca
	ld	ixl, a
	ld	de, CRAM
	add	ix, de
	ld	a, (ix)
	ld	(iy), a
	inc	iy
	ret

Art:
#import "art\items\art_ucmp_blue_emerald.bin"
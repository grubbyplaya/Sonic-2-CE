
#define appVarObj		$15
#define lcdBpp8			$27
#define lcdHeight		240
#define lcdWidth		320
#define lcdNormalMode		$92D
#define	CpHLDE			$02013C
#define Mov9ToOP1		$020320
#define ChkFindSym		$02050C
#define Arc_Unarc		$021448
#define ramStart		$D00000
#define cmdPixelShadow		$D07396
#define plotSScreen		$D09466
#define saveSScreen		$D0EA1F
#define pixelShadow		$D031F6
#define VRAM 			$D40000
#define VRAMEnd			VRAM+((320*240)*2)
#define mpLcdCtrl		$E30018
#define mpLcdImsc		$E3001C
#define mpLcdRis		$E30020
#define mpLcdIcr		$E30028
#define mpLcdPalette		$E30200
#define romStart		$D20000	;game ROM, not TI ROM


kbdG1		= $F50012
;----------------------------
kbdGraph	= 00000001b
kbdTrace	= 00000010b
kbdZoom		= 00000100b
kbdWindow	= 00001000b
kbdY 		= 00010000b
kbd2nd		= 00100000b
kbdMode		= 01000000b
kbdDel		= 10000000b

kbitGraph	= 00
kbitTrace	= 01
kbitZoom	= 02
kbitWindow	= 03
kbitY		= 04
kbit2nd		= 05
kbitMode	= 06
kbitDel		= 07

kbdG2		= $F50014
;----------------------------
kbdStore	= 00000010b
kbdLn		= 00000100b
kbdLog		= 00001000b
kbdSquare	= 00010000b
kbdRecip	= 00100000b
kbdMat		= 01000000b
kbdAlpha	= 10000000b

kbitStore	= 01
kbitLn		= 02
kbitLog		= 03
kbitSquare	= 04
kbitRecip	= 05
kbitMath	= 06
kbitAlpha	= 07

kbdG3		= $F50016
;----------------------------
kbd0		= 00000001b
kbd1		= 00000010b
kbd4		= 00000100b
kbd7		= 00001000b
kbdComma	= 00010000b
kbdSin		= 00100000b
kbdApps		= 01000000b
kbdGrapVar	= 10000000b

kbit0		= 00
kbit1		= 01
kbit4		= 02
kbit7		= 03
kbitComma	= 04
kbitSin		= 05
kbitApps	= 06
kbitGraphVar	= 07

kbdG4		= $F50018
;----------------------------
kbdDecPnt	= 00000001b
kbd2		= 00000010b
kbd5		= 00000100b
kbd8		= 00001000b
kbdLParen	= 00010000b
kbdCos		= 00100000b
kbdPgrm		= 01000000b
kbdStat		= 10000000b

kbitDecPnt	= 00
kbit2		= 01
kbit5		= 02
kbit8		= 03
kbitLParen	= 04
kbitCos		= 05
kbitPgrm	= 06
kbitStat	= 07

kbdG5		= $F5001A
;----------------------------
kbdCs		= 00000001b
kbd3		= 00000010b
kbd6		= 00000100b
kbd9		= 00001000b
kbdRParen	= 00010000b
kbdTan		= 00100000b
kbdVars		= 01000000b

kbitCs		= 00
kbit3		= 01
kbit6		= 02
kbit9		= 03
kbitRParen	= 04
kbitTan		= 05
kbitVars	= 06

kbdG6		= $F5001C
;----------------------------
kbdEnter	= 00000001b
kbdAdd		= 00000010b
kbdSub		= 00000100b
kbdMul		= 00001000b
kbdDiv		= 00010000b
kbdPower	= 00100000b
kbdClear	= 01000000b

kbitEnter	= 00
kbitAdd		= 01
kbitSub		= 02
kbitMul		= 03
kbitDiv		= 04
kbitPower	= 05
kbitClear	= 06

kbdG7		= $F5001E
;----------------------------
kbdDown		= 00000001b
kbdLeft		= 00000010b
kbdRight	= 00000100b
kbdUp		= 00001000b

kbitDown	= 00
kbitLeft	= 01
kbitRight	= 02
kbitUp		= 03
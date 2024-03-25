#define	PlayerState_Standing		$01
#define	PlayerState_Idle		$02	;idle animation
#define	PlayerState_LookUp		$03
#define	PlayerState_Crouch		$04
#define	PlayerState_Walking		$05
#define	PlayerState_Running		$06
#define	PlayerState_SkiddingRight	$07
#define	PlayerState_SkiddingLeft	$08
#define	PlayerState_Rolling		$09
#define	PlayerState_Jumping		$0A
#define	PlayerState_VerticalSpring	$0B	;set after collision with vertical spring
#define	PlayerState_OnLoop		$0C	;sprite rotated 45 degrees CCW.

#define	PlayerState_Falling		$0E

#define	PlayerState_16			$10 	;used in intro sequence; see $0F41.

#define	PlayerState_HangGlider		$13	;set after touching hang glider
#define	PlayerState_HangGliderBack	$14	;set when pressing left with hang glider
#define	PlayerState_HangGliderFwd	$15	;set when pressing right with hang glider
#define	PlayerState_EnterMineCart	$16
#define	PlayerState_InMineCart		$17
#define	PlayerState_Balance		$19
#define	PlayerState_ALZSlope		$1A	;set on ALZ slippery slope
#define	PlayerState_JumpFromRamp	$1B	;e.g. in UGZ-3 before boss & when exiting SEZ/ALZ tube
#define	PlayerState_DiagonalSpring	$1C	;set after collision with diagonal spring
#define	PlayerState_FallFromLoop	$1D	;set if a player falls from loop (not moving fast enough).
#define	PlayerState_Hurt		$1E
#define	PlayerState_LostLife		$1F
#define	PlayerState_EndOfLevel		$20	;Set at end of level. CPU controlled movement off of screen.
#define	PlayerState_InPipe		$21	;Set in ALZ/SEZ on entering a pipe.

#define	PlayerState_UGZ_Boss		$23	;Set when caught by robotnik in UGZ-3
#define	PlayerState_ALZ_Bubble		$24	;Set on collision with ALZ big bubble

#define	PlayerState_SHZ3_Boss_Fall	$26	;Set by SHZ boss during state $06

#define	PlayerState_Drowning		$28

#define	PlayerState_EndSeq_Init    	$2A	;Set by routine at $6F3 on starting the end sequence.
#define	PlayerState_EndSequence		$2B

#define	PlayerState_ContinueScreen	$2F 

#define PlayerState_SpinDash		$34

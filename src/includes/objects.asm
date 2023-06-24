; =============================================================================
;  Object Definitions
; -----------------------------------------------------------------------------
;  
; -----------------------------------------------------------------------------

#define	Object_Sonic			$01
#define	Object_RingSparkle		$02
#define	Object_SpeedShoesStar		$03
#define	Object_BlockFragment		$04
#define	Object_InvincibilityStar	$05
#define	SpecObj_HideTimerRings		$06	;special object. spawned by prison capsule after boss to hide ring counter & timer.
#define	Object_BlockFragment2		$07
#define	Object_DroppedRing		$08
#define	Object_AirCountdown		$09	;air timer countdown
#define	Object_ALZ_Bubble		$0A	;ALZ big bubble
#define	Object_WaterSplash		$0B	;ALZ water splash

;#define Object_Fireball?		$0D	; same logic as $0E
#define	Object_UGZFireball		$0E
#define	Object_Explosion		$0F
#define	Object_Monitor			$10
#define	Object_ChaosEmerald1		$11
#define	Object_ChaosEmerald2	  	$12
#define	Object_ChaosEmerald3	   	$13
#define	Object_ChaosEmerald4	   	$14
#define	Object_Signpost2		$15	; same logic as signpost, different anims
#define	Object_Signpost3		$16	; same logic as signpost, different anims
#define	Object_Signpost4		$17	; same logic as signpost, different anims
#define	Object_Signpost			$18

#define	Object_IntroClouds		$1D	; intro sequence clouds
#define	Object_IntroTree		$1E	; intro sequence tree
#define	Object_Invalid			$1F	; invalid object (logic pointer points into data)

;********************************************
;*		Objects $20 - $3F: Badniks			*
;********************************************
#define	Object_Crab			$23
#define	Object_CrabProjectile		$24

#define	Object_Glider			$27

#define	Object_MineCart			$29

#define	Object_Motobug			$34	;motobug badnik
#define	Object_Newtron			$35	;newtron badnik
#define	Object_SHZ3_SmallBird1		$36	;used during the SHZ boss along with $46 - spawned by $48

#define	Object_Newtron_Fireball		$3C	;fireballs created by object $35

;********************************************
;*		Objects $40 -$??: Bosses			*
;********************************************
#define	Object_PrisonCapsule		$40
#define	Object_PrisonAnimals		$41

#define	Object_SHZ3_SmallBird2		$46	;used alongside $36 - spawned by $47
#define	Object_SHZ3_EggCapsule		$47
#define	Object_SHZ3_Boss		$48
#define	Object_SHZ3_Boss_Fireball	$49
#define	Object_ALZ3_Boss		$4A
#define	Object_UGZ_Robotnik		$4B
#define	Object_UGZ_CannonBall		$4C
#define	Object_UGZ_Pincers		$4D

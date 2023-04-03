;================================================================
; 	Pointers to tile art for each frame of player object's 
;	animations.
;	Used by routine at $10BF to load player tile art into VRAM.
;================================================================

;================================================================
;	Porting Guide: ;.dstruct values become defines
;	using the SpriteDef structure from structures.asm.
;================================================================

Data_PlayerSprites:

Sonic_Walking:		;6 frames
	#define Sonic_Walking_1.BankNum			Bank04
	#define Sonic_Walking_1.SourceAddress		BankSlot2+$00
	#define Sonic_Walking_1.LineCount			$06
;.dstruct Sonic_Walking_1 instanceof SpriteDef DATA $04, $8000, $06 
	#define Sonic_Walking_2.BankNum			Bank04
	#define Sonic_Walking_2.SourceAddress		BankSlot2+$0180
	#define Sonic_Walking_2.LineCount			$06
;.dstruct Sonic_Walking_2 instanceof SpriteDef DATA $04, $8180, $06 
	#define Sonic_Walking_3.BankNum			Bank04
	#define Sonic_Walking_3.SourceAddress		BankSlot2+$0300
	#define Sonic_Walking_3.LineCount			$06
;.dstruct Sonic_Walking_3 instanceof SpriteDef DATA $04, $8300, $06 
	#define Sonic_Walking_4.BankNum			Bank04
	#define Sonic_Walking_4.SourceAddress		BankSlot2+$0480
	#define Sonic_Walking_4.LineCount			$06
;.dstruct Sonic_Walking_4 instanceof SpriteDef DATA $04, $8480, $06 
	#define Sonic_Walking_5.BankNum			Bank04
	#define Sonic_Walking_5.SourceAddress		BankSlot2+$0600
	#define Sonic_Walking_5.LineCount			$06
;.dstruct Sonic_Walking_5 instanceof SpriteDef DATA $04, $8600, $06
	#define Sonic_Walking_6.BankNum			Bank04
	#define Sonic_Walking_6.SourceAddress		BankSlot2+$0780
	#define Sonic_Walking_6.LineCount			$06
;.dstruct Sonic_Walking_6 instanceof SpriteDef DATA $04, $8780, $06 

Sonic_Idle:			;3 frames
	#define Sonic_Idle_1.BankNum			Bank04
	#define Sonic_Idle_1.SourceAddress		BankSlot2+$0900
	#define Sonic_Idle_1.LineCount			$06
;.dstruct Sonic_Idle_1 instanceof SpriteDef DATA $04, $8900, $06		;$07
	#define Sonic_Idle_2.BankNum			Bank04
	#define Sonic_Idle_2.SourceAddress		BankSlot2+$2F80
	#define Sonic_Idle_2.LineCount			$06
;.dstruct Sonic_Idle_2 instanceof SpriteDef DATA $04, $AF80, $06		;$08 
	#define Sonic_Idle_3.BankNum			Bank04
	#define Sonic_Idle_3.SourceAddress		BankSlot2+$3100
	#define Sonic_Idle_3.LineCount			$06
;.dstruct Sonic_Idle_3 instanceof SpriteDef DATA $04, $B100, $06		;$09

Sonic_Standing:		;1 frame
	#define Sonic_Standing_1.BankNum			Bank04
	#define Sonic_Standing_1.SourceAddress		BankSlot2+$0D80
	#define Sonic_Standing_1.LineCount		$06
;.dstruct Sonic_Standing_1 instanceof SpriteDef DATA $04, $8D80, $06	;$0A

Sonic_LookUp:		;1 frame
	#define Sonic_LookUp_1.BankNum			Bank04
	#define Sonic_LookUp_1.SourceAddress		BankSlot2+$0F00
	#define Sonic_LookUp_1.LineCount			$06
;.dstruct Sonic_LookUp_1 instanceof SpriteDef DATA $04, $8F00, $06		;$0B

Sonic_Running:		;4 frames
	#define Sonic_Running_1.BankNum			Bank04
	#define Sonic_Running_1.SourceAddress		BankSlot2+$1080
	#define Sonic_Running_1.LineCount			$06
;.dstruct Sonic_Running_1 instanceof SpriteDef DATA $04, $9080, $06	;$0C
	#define Sonic_Running_2.BankNum			Bank04
	#define Sonic_Running_2.SourceAddress		BankSlot2+$1200
	#define Sonic_Running_2.LineCount			$06
;.dstruct Sonic_Running_2 instanceof SpriteDef DATA $04, $9200, $06	;$0D 
	#define Sonic_Running_3.BankNum			Bank04
	#define Sonic_Running_3.SourceAddress		BankSlot2+$1380
	#define Sonic_Running_3.LineCount			$06
;.dstruct Sonic_Running_3 instanceof SpriteDef DATA $04, $9380, $06	;$0E 
	#define Sonic_Running_4.BankNum			Bank04
	#define Sonic_Running_4.SourceAddress		BankSlot2+$1500
	#define Sonic_Running_4.LineCount			$06
;.dstruct Sonic_Running_4 instanceof SpriteDef DATA $04, $9500, $06	;$0F 

Sonic_LookDown:		;1 frame
	#define Sonic_LookDown_1.BankNum			Bank04
	#define Sonic_LookDown_1.SourceAddress		BankSlot2+$1680
	#define Sonic_LookDown_1.LineCount		$06
;.dstruct Sonic_LookDown_1 instanceof SpriteDef DATA $04, $9680, $06	;$10

Sonic_Roll:			;5 frames
	#define Sonic_Roll_1.BankNum			Bank04
	#define Sonic_Roll_1.SourceAddress		BankSlot2+$1800
	#define Sonic_Roll_1.LineCount			$06
;.dstruct Sonic_Roll_1 instanceof SpriteDef DATA $04, $9800, $06			;$11
	#define Sonic_Roll_2.BankNum			Bank04
	#define Sonic_Roll_2.SourceAddress		BankSlot2+$1980
	#define Sonic_Roll_2.LineCount			$06
;.dstruct Sonic_Roll_2 instanceof SpriteDef DATA $04, $9980, $06			;$12
	#define Sonic_Roll_3.BankNum			Bank04
	#define Sonic_Roll_3.SourceAddress		BankSlot2+$1B00
	#define Sonic_Roll_3.LineCount			$06
;.dstruct Sonic_Roll_3 instanceof SpriteDef DATA $04, $9B00, $06			;$13 
	#define Sonic_Roll_4.BankNum			Bank04
	#define Sonic_Roll_4.SourceAddress		BankSlot2+$1C80
	#define Sonic_Roll_4.LineCount			$06
;.dstruct Sonic_Roll_4 instanceof SpriteDef DATA $04, $9C80, $06			;$14 
	#define Sonic_Roll_5.BankNum			Bank04
	#define Sonic_Roll_5.SourceAddress		BankSlot2+$1E00
	#define Sonic_Roll_5.LineCount			$06
;.dstruct Sonic_Roll_5 instanceof SpriteDef DATA $04, $9E00, $06			;$15 

Sonic_Skid:			;2 frames
	#define Sonic_Skid_Left_1.BankNum			Bank16
	#define Sonic_Skid_Left_1.SourceAddress	$9F80
	#define Sonic_Skid_Left_1.LineCount		$06
;.dstruct Sonic_Skid_Left_1 instanceof SpriteDef DATA $10, $9F80, $06	;$16
	#define Sonic_Skid_Left_2.BankNum			Bank16
	#define Sonic_Skid_Left_2.SourceAddress	$A100
	#define Sonic_Skid_Left_2.LineCount		$06
;.dstruct Sonic_Skid_Left_2 instanceof SpriteDef DATA $10, $A100, $06	;$17 

Sonic_Drowning:		;2 frames
	#define Sonic_Drowning_1.BankNum			Bank04
	#define Sonic_Drowning_1.SourceAddress		$A280
	#define Sonic_Drowning_1.LineCount		$06
;.dstruct Sonic_Drowning_1 instanceof SpriteDef DATA $04, $A280, $06		;$18
	#define Sonic_Drowning_2.BankNum			Bank04
	#define Sonic_Drowning_2.SourceAddress		$A400
	#define Sonic_Drowning_2.LineCount		$06
;.dstruct Sonic_Drowning_2 instanceof SpriteDef DATA $04, $A400, $06		;$19
 
Sonic_Leap:			;1 frame
	#define Sonic_Leap_1.BankNum			Bank04
	#define Sonic_Leap_1.SourceAddress		$A580
	#define Sonic_Leap_1.LineCount			$06
;.dstruct Sonic_Leap_1 instanceof SpriteDef DATA $04, $A580, $06			;$1A 

Sonic_Hurt:			;2 frames
	#define Sonic_Hurt_1.BankNum			Bank04
	#define Sonic_Hurt_1.SourceAddress		$A700
	#define Sonic_Hurt_1.LineCount			$06
;.dstruct Sonic_Hurt_1 instanceof SpriteDef DATA $04, $A700, $06			;$1B
	#define Sonic_Hurt_2.BankNum			Bank04
	#define Sonic_Hurt_2.SourceAddress		$A880
	#define Sonic_Hurt_2.LineCount			$06
;.dstruct Sonic_Hurt_2 instanceof SpriteDef DATA $04, $A880, $06			;$1C

Sonic_Spring		;1 frame
	#define Sonic_Spring_1.BankNum			Bank04
	#define Sonic_Spring_1.SourceAddress		$AA00
	#define Sonic_Spring_1.LineCount			$06
;.dstruct Sonic_Spring_1 instanceof SpriteDef DATA $04, $AA00, $06		;$1D

;loop anims
	#define SPR19.BankNum			Bank06
	#define SPR19.SourceAddress		$8000
	#define SPR19.LineCount		$08
;.dstruct SPR19 instanceof SpriteDef DATA $06, $8000, $08 		;$1D
	#define SPR20.BankNum			Bank06
	#define SPR20.SourceAddress		$8200
	#define SPR20.LineCount		$08
;.dstruct SPR20 instanceof SpriteDef DATA $06, $8200, $08 		;$1E
	#define SPR21.BankNum			Bank06
	#define SPR21.SourceAddress		$8400
	#define SPR21.LineCount		$08
;.dstruct SPR21 instanceof SpriteDef DATA $06, $8400, $08 		;$1F
	#define SPR22.BankNum			Bank06
	#define SPR22.SourceAddress		$8600
	#define SPR22.LineCount		$08
;.dstruct SPR22 instanceof SpriteDef DATA $06, $8600, $08 		;$20
	#define SPR23.BankNum			Bank06
	#define SPR23.SourceAddress		$8800
	#define SPR23.LineCount		$08
;.dstruct SPR23 instanceof SpriteDef DATA $06, $8800, $08 		;$21
	#define SPR24.BankNum			Bank06
	#define SPR24.SourceAddress		$8A00
	#define SPR24.LineCount		$08
;.dstruct SPR24 instanceof SpriteDef DATA $06, $8A00, $08 		;$22
	#define SPR25.BankNum			Bank06
	#define SPR25.SourceAddress		$8C00
	#define SPR25.LineCount		$08
;.dstruct SPR25 instanceof SpriteDef DATA $06, $8C00, $08 		;$23
	#define SPR26.BankNum			Bank06
	#define SPR26.SourceAddress		$8E00
	#define SPR26.LineCount		$08
;.dstruct SPR26 instanceof SpriteDef DATA $06, $8E00, $08 		;$24
	#define SPR27.BankNum			Bank06
	#define SPR27.SourceAddress		$9000
	#define SPR27.LineCount		$08
;.dstruct SPR27 instanceof SpriteDef DATA $06, $9000, $08 		;$25
	#define SPR28.BankNum			Bank06
	#define SPR28.SourceAddress		$9200
	#define SPR28.LineCount		$08
;.dstruct SPR28 instanceof SpriteDef DATA $06, $9200, $08 		;$26
	#define SPR29.BankNum			Bank06
	#define SPR29.SourceAddress		$9400
	#define SPR29.LineCount		$08
;.dstruct SPR29 instanceof SpriteDef DATA $06, $9400, $08 		;$27
	#define SPR30.BankNum			Bank06
	#define SPR30.SourceAddress		$9600
	#define SPR30.LineCount		$08
;.dstruct SPR30 instanceof SpriteDef DATA $06, $9600, $08 		;$28
	#define SPR31.BankNum			Bank06
	#define SPR31.SourceAddress		$9800
	#define SPR31.LineCount		$08
;.dstruct SPR31 instanceof SpriteDef DATA $06, $9800, $08 		;$29
	#define SPR32.BankNum			Bank06
	#define SPR32.SourceAddress		$9A00
	#define SPR32.LineCount		$08
;.dstruct SPR32 instanceof SpriteDef DATA $06, $9A00, $08 		;$2A
	#define SPR33.BankNum			Bank06
	#define SPR33.SourceAddress		$9C00
	#define SPR33.LineCount		$08
;.dstruct SPR33 instanceof SpriteDef DATA $06, $9C00, $08 		;$2B
	#define SPR34.BankNum			Bank06
	#define SPR34.SourceAddress		$9E00
	#define SPR34.LineCount		$08
;.dstruct SPR34 instanceof SpriteDef DATA $06, $9E00, $08 		;$2C
	#define SPR35.BankNum			Bank06
	#define SPR35.SourceAddress		$A000
	#define SPR35.LineCount		$08
;.dstruct SPR35 instanceof SpriteDef DATA $06, $A000, $08 		;$2D
	#define SPR36.BankNum			Bank06
	#define SPR36.SourceAddress		$A200
	#define SPR36.LineCount		$08
;.dstruct SPR36 instanceof SpriteDef DATA $06, $A200, $08 		;$2E
	#define SPR37.BankNum			Bank06
	#define SPR37.SourceAddress		$A400
	#define SPR37.LineCount		$08
;.dstruct SPR37 instanceof SpriteDef DATA $06, $A400, $08 		;$2F
	#define SPR38.BankNum			Bank06
	#define SPR38.SourceAddress		$A600
	#define SPR38.LineCount		$08
;.dstruct SPR38 instanceof SpriteDef DATA $06, $A600, $08 		;$30
	#define SPR39.BankNum			Bank06
	#define SPR39.SourceAddress		$A800
	#define SPR39.LineCount		$08
;.dstruct SPR39 instanceof SpriteDef DATA $06, $A800, $08 		;$31
	#define SPR40.BankNum			Bank06
	#define SPR40.SourceAddress		$AA00
	#define SPR40.LineCount		$08
;.dstruct SPR40 instanceof SpriteDef DATA $06, $AA00, $08 		;$32
	#define SPR41.BankNum			Bank06
	#define SPR41.SourceAddress		$AC00
	#define SPR41.LineCount		$08
;.dstruct SPR41 instanceof SpriteDef DATA $06, $AC00, $08 		;$33
	#define SPR42.BankNum			Bank06
	#define SPR42.SourceAddress		$AE00
	#define SPR42.LineCount		$08
;.dstruct SPR42 instanceof SpriteDef DATA $06, $AE00, $08 		;$34
	#define SPR43.BankNum			Bank06
	#define SPR43.SourceAddress		$B000
	#define SPR43.LineCount		$08
;.dstruct SPR43 instanceof SpriteDef DATA $06, $B000, $08 		;$35
	#define SPR44.BankNum			Bank06
	#define SPR44.SourceAddress		$B200
	#define SPR44.LineCount		$08
;.dstruct SPR44 instanceof SpriteDef DATA $06, $B200, $08 		;$36
	#define SPR45.BankNum			Bank06
	#define SPR45.SourceAddress		$B400
	#define SPR45.LineCount		$08
;.dstruct SPR45 instanceof SpriteDef DATA $06, $B400, $08 		;$37
	#define SPR46.BankNum			Bank06
	#define SPR46.SourceAddress		$B600
	#define SPR46.LineCount		$08
;.dstruct SPR46 instanceof SpriteDef DATA $06, $B600, $08 		;$38
	#define SPR47.BankNum			Bank06
	#define SPR47.SourceAddress		$B800
	#define SPR47.LineCount		$08
;.dstruct SPR47 instanceof SpriteDef DATA $06, $B800, $08 		;$39
	#define SPR48.BankNum			Bank06
	#define SPR48.SourceAddress		$BA00
	#define SPR48.LineCount		$08
;.dstruct SPR48 instanceof SpriteDef DATA $06, $BA00, $08		;$3A

;glider
	#define SPR49.BankNum			Bank05
	#define SPR49.SourceAddress		$8000
	#define SPR49.LineCount		$08
;.dstruct SPR49 instanceof SpriteDef DATA $05, $8000, $08 		;$3B
	#define SPR50.BankNum			Bank05
	#define SPR50.SourceAddress		$8200
	#define SPR50.LineCount		$08
;.dstruct SPR50 instanceof SpriteDef DATA $05, $8200, $08 		;$3C
	#define SPR51.BankNum			Bank05
	#define SPR51.SourceAddress		$8400
	#define SPR51.LineCount		$08
;.dstruct SPR51 instanceof SpriteDef DATA $05, $8400, $08 		;$3D
	#define SPR52.BankNum			Bank05
	#define SPR52.SourceAddress		$8600
	#define SPR52.LineCount		$08
;.dstruct SPR52 instanceof SpriteDef DATA $05, $8600, $08 		;$3E
	#define SPR53.BankNum			Bank05
	#define SPR53.SourceAddress		$8800
	#define SPR53.LineCount		$08
;.dstruct SPR53 instanceof SpriteDef DATA $05, $8800, $08 		;$3F
	#define SPR54.BankNum			Bank05
	#define SPR54.SourceAddress		$8A00
	#define SPR54.LineCount		$08
;.dstruct SPR54 instanceof SpriteDef DATA $05, $8A00, $08 		;$40
	#define SPR55.BankNum			Bank05
	#define SPR55.SourceAddress		$8C00
	#define SPR55.LineCount		$08
;.dstruct SPR55 instanceof SpriteDef DATA $05, $8C00, $08 		;$41
	#define SPR56.BankNum			Bank05
	#define SPR56.SourceAddress		$8E00
	#define SPR56.LineCount		$08
;.dstruct SPR56 instanceof SpriteDef DATA $05, $8E00, $08 		;$42
	#define SPR57.BankNum			Bank05
	#define SPR57.SourceAddress		$9000
	#define SPR57.LineCount		$08
;.dstruct SPR57 instanceof SpriteDef DATA $05, $9000, $08 		;$43
	#define SPR58.BankNum			Bank05
	#define SPR58.SourceAddress		$9200
	#define SPR58.LineCount		$08
;.dstruct SPR58 instanceof SpriteDef DATA $05, $9200, $08 		;$44
	#define SPR59.BankNum			Bank05
	#define SPR59.SourceAddress		$9400
	#define SPR59.LineCount		$08
;.dstruct SPR59 instanceof SpriteDef DATA $05, $9400, $08 		;$45
	#define SPR60.BankNum			Bank05
	#define SPR60.SourceAddress		$9600
	#define SPR60.LineCount		$08
;.dstruct SPR60 instanceof SpriteDef DATA $05, $9600, $08 		;$46
	#define SPR61.BankNum			Bank05
	#define SPR61.SourceAddress		$9800
	#define SPR61.LineCount		$08
;.dstruct SPR61 instanceof SpriteDef DATA $05, $9800, $08 		;$47
	#define SPR62.BankNum			Bank05
	#define SPR62.SourceAddress		$9A00
	#define SPR62.LineCount		$08
;.dstruct SPR62 instanceof SpriteDef DATA $05, $9A00, $08 		;$48
	#define SPR63.BankNum			Bank05
	#define SPR63.SourceAddress		$9C00
	#define SPR63.LineCount		$08
;.dstruct SPR63 instanceof SpriteDef DATA $05, $9C00, $08 		;$49

;mini sonic (from intro)
	#define SPR64.BankNum			Bank08
	#define SPR64.SourceAddress		$9B32
	#define SPR64.LineCount		$04
;.dstruct SPR64 instanceof SpriteDef DATA $08, $9B32, $04 		;$4A
	#define SPR65.BankNum			Bank08
	#define SPR65.SourceAddress		$9C32
	#define SPR65.LineCount		$04
;.dstruct SPR65 instanceof SpriteDef DATA $08, $9C32, $04 		;$4B
	#define SPR66.BankNum			Bank08
	#define SPR66.SourceAddress		$9D32
	#define SPR66.LineCount		$04
;.dstruct SPR66 instanceof SpriteDef DATA $08, $9D32, $04 		;$4C
	#define SPR67.BankNum			Bank08
	#define SPR67.SourceAddress		$9E32
	#define SPR68.LineCount		$04
;.dstruct SPR67 instanceof SpriteDef DATA $08, $9E32, $04 		;$4D
	#define SPR68.BankNum			Bank08
	#define SPR68.SourceAddress		$9F32
	#define SPR68.LineCount		$04
;.dstruct SPR68 instanceof SpriteDef DATA $08, $9F32, $04 		;$4E
	#define SPR69.BankNum			Bank08
	#define SPR69.SourceAddress		$A032
	#define SPR69.LineCount		$04
;.dstruct SPR69 instanceof SpriteDef DATA $08, $A032, $04 		;$4F
	#define SPR70.BankNum			Bank08
	#define SPR70.SourceAddress		$A132
	#define SPR70.LineCount		$04
;.dstruct SPR70 instanceof SpriteDef DATA $08, $A132, $04 		;$50
	#define SPR71.BankNum			Bank08
	#define SPR71.SourceAddress		$A232
	#define SPR71.LineCount		$04
;.dstruct SPR71 instanceof SpriteDef DATA $08, $A232, $04 		;$51
	#define SPR72.BankNum			Bank08
	#define SPR72.SourceAddress		$A332
	#define SPR72.LineCount		$04
;.dstruct SPR72 instanceof SpriteDef DATA $08, $A332, $04 		;$52
	#define SPR73.BankNum			Bank08
	#define SPR73.SourceAddress		$A432
	#define SPR73.LineCount		$04
;.dstruct SPR73 instanceof SpriteDef DATA $08, $A432, $04 		;$53
	#define SPR74.BankNum			Bank08
	#define SPR74.SourceAddress		$A532
	#define SPR74.LineCount		$04
;.dstruct SPR74 instanceof SpriteDef DATA $08, $A532, $04 		;$54
	#define SPR75.BankNum			Bank08
	#define SPR75.SourceAddress		$A632
	#define SPR75.LineCount		$04
;.dstruct SPR75 instanceof SpriteDef DATA $08, $A632, $04 		;$55
	#define SPR76.BankNum			Bank08
	#define SPR76.SourceAddress		$A732
	#define SPR76.LineCount		$04
;.dstruct SPR76 instanceof SpriteDef DATA $08, $A732, $04 		;$56

;minecart
	#define SPR77.BankNum			Bank05
	#define SPR77.SourceAddress		$9E00
	#define SPR77.LineCount		$03
;.dstruct SPR77 instanceof SpriteDef DATA $05, $9E00, $03 		;$57
	#define SPR78.BankNum			Bank05
	#define SPR78.SourceAddress		$9EC0
	#define SPR78.LineCount		$03
;.dstruct SPR78 instanceof SpriteDef DATA $05, $9EC0, $03 		;$58
 	#define SPR79.BankNum			Bank05
	#define SPR79.SourceAddress		$9EC0
	#define SPR79.LineCount		$03
;.dstruct SPR79 instanceof SpriteDef DATA $05, $9F80, $03 		;$59
 	#define SPR80.BankNum			Bank05
	#define SPR80.SourceAddress		$A040
	#define SPR80.LineCount		$03
;.dstruct SPR80 instanceof SpriteDef DATA $05, $A040, $03 		;$5A
 	#define SPR81.BankNum			Bank05
	#define SPR81.SourceAddress		$A100
	#define SPR81.LineCount		$03
;.dstruct SPR81 instanceof SpriteDef DATA $05, $A100, $03 		;$5B
 	#define SPR82.BankNum			Bank05
	#define SPR82.SourceAddress		$A1C0
	#define SPR82.LineCount		$03
;.dstruct SPR82 instanceof SpriteDef DATA $05, $A1C0, $03 		;$5C
 	#define SPR83.BankNum			Bank05
	#define SPR83.SourceAddress		$A280
	#define SPR83.LineCount		$03
;.dstruct SPR83 instanceof SpriteDef DATA $05, $A280, $03 		;$5D
 	#define SPR84.BankNum			Bank04
	#define SPR84.SourceAddress		$AB80
	#define SPR84.LineCount		$08
;.dstruct SPR84 instanceof SpriteDef DATA $04, $AB80, $08 		;$5E
	#define SPR85.BankNum			Bank04
	#define SPR85.SourceAddress		$AD80
	#define SPR85.LineCount		$08
;.dstruct SPR85 instanceof SpriteDef DATA $04, $AD80, $08 		;$5F
	#define SPR86.BankNum			Bank04
	#define SPR86.SourceAddress		$B280
	#define SPR86.LineCount		$08
;.dstruct SPR86 instanceof SpriteDef DATA $04, $B280, $08 		;$60
	#define SPR87.BankNum			Bank04
	#define SPR87.SourceAddress		$B480
	#define SPR87.LineCount		$08
;.dstruct SPR87 instanceof SpriteDef DATA $04, $B480, $08 		;$61
	#define SPR88.BankNum			Bank04
	#define SPR88.SourceAddress		$B680
	#define SPR88.LineCount		$06
;.dstruct SPR88 instanceof SpriteDef DATA $04, $B680, $06 		;$62



Data_PlayerSprites_Mirrored:
	#define SPR89.BankNum			Bank10
	#define SPR89.SourceAddress		$8000
	#define SPR89.LineCount		$06
;.dstruct SPR89 instanceof SpriteDef DATA $10, $8000, $06 		;$63
	#define SPR90.BankNum			Bank10
	#define SPR90.SourceAddress		$8180
	#define SPR90.LineCount		$06
;.dstruct SPR90 instanceof SpriteDef DATA $10, $8180, $06 		;$64
	#define SPR91.BankNum			Bank10
	#define SPR91.SourceAddress		$8300
	#define SPR91.LineCount		$06
;.dstruct SPR91 instanceof SpriteDef DATA $10, $8300, $06 		;$65
	#define SPR92.BankNum			Bank10
	#define SPR92.SourceAddress		$8480
	#define SPR92.LineCount		$06
;.dstruct SPR92 instanceof SpriteDef DATA $10, $8480, $06 		;$66
	#define SPR93.BankNum			Bank10
	#define SPR93.SourceAddress		$8600
	#define SPR93.LineCount		$06
;.dstruct SPR93 instanceof SpriteDef DATA $10, $8600, $06 
	#define SPR94.BankNum			Bank10
	#define SPR94.SourceAddress		$8780
	#define SPR94.LineCount		$06
;.dstruct SPR94 instanceof SpriteDef DATA $10, $8780, $06 
	#define SPR95.BankNum			Bank10
	#define SPR95.SourceAddress		$8900
	#define SPR95.LineCount		$06
;.dstruct SPR95 instanceof SpriteDef DATA $10, $8900, $06 
	#define SPR96.BankNum			Bank10
	#define SPR96.SourceAddress		$AF80
	#define SPR96.LineCount		$06
;.dstruct SPR96 instanceof SpriteDef DATA $10, $AF80, $06 
	#define SPR97.BankNum			Bank10
	#define SPR97.SourceAddress		$B100
	#define SPR97.LineCount		$06
;.dstruct SPR97 instanceof SpriteDef DATA $10, $B100, $06 
	#define SPR98.BankNum			Bank10
	#define SPR98.SourceAddress		$8D80
	#define SPR98.LineCount		$06
;.dstruct SPR98 instanceof SpriteDef DATA $10, $8D80, $06 
	#define SPR99.BankNum			Bank10
	#define SPR99.SourceAddress		$8F00
	#define SPR99.LineCount		$06
;.dstruct SPR99 instanceof SpriteDef DATA $10, $8F00, $06 
	#define SPR100.BankNum			Bank10
	#define SPR100.SourceAddress	$9080
	#define SPR100.LineCount		$06
;.dstruct SPR100 instanceof SpriteDef DATA $10, $9080, $06 
	#define SPR101.BankNum			Bank10
	#define SPR101.SourceAddress	$9200
	#define SPR101.LineCount		$06
;.dstruct SPR101 instanceof SpriteDef DATA $10, $9200, $06 
	#define SPR102.BankNum			Bank10
	#define SPR102.SourceAddress	$9380
	#define SPR102.LineCount		$06
;.dstruct SPR102 instanceof SpriteDef DATA $10, $9380, $06 
	#define SPR103.BankNum			Bank10
	#define SPR103.SourceAddress	$9500
	#define SPR103.LineCount		$06
;.dstruct SPR103 instanceof SpriteDef DATA $10, $9500, $06 
	#define SPR104.BankNum			Bank10
	#define SPR104.SourceAddress	$9680
	#define SPR104.LineCount		$06
;.dstruct SPR104 instanceof SpriteDef DATA $10, $9680, $06 
	#define SPR105.BankNum			Bank10
	#define SPR105.SourceAddress	$9800
	#define SPR105.LineCount		$06
;.dstruct SPR105 instanceof SpriteDef DATA $10, $9800, $06 
	#define SPR106.BankNum			Bank10
	#define SPR106.SourceAddress	$9980
	#define SPR106.LineCount		$06
;.dstruct SPR106 instanceof SpriteDef DATA $10, $9980, $06 
	#define SPR107.BankNum			Bank10
	#define SPR107.SourceAddress	$9B00
	#define SPR107.LineCount		$06
;.dstruct SPR107 instanceof SpriteDef DATA $10, $9B00, $06 
	#define SPR108.BankNum			Bank10
	#define SPR108.SourceAddress	$9C80
	#define SPR108.LineCount		$06
;.dstruct SPR108 instanceof SpriteDef DATA $10, $9C80, $06 
	#define SPR109.BankNum			Bank10
	#define SPR109.SourceAddress	$9E00
	#define SPR109.LineCount		$06
;.dstruct SPR109 instanceof SpriteDef DATA $10, $9E00, $06 
	#define SPR110.BankNum			Bank10
	#define SPR110.SourceAddress	$9F80
	#define SPR110.LineCount		$06
;.dstruct SPR110 instanceof SpriteDef DATA $04, $9F80, $06 
	#define SPR111.BankNum			Bank04
	#define SPR111.SourceAddress	$A100
	#define SPR111.LineCount		$06
;.dstruct SPR111 instanceof SpriteDef DATA $04, $A100, $06 
	#define SPR112.BankNum			Bank04
	#define SPR112.SourceAddress	$A280
	#define SPR112.LineCount		$06
;.dstruct SPR112 instanceof SpriteDef DATA $10, $A280, $06 
	#define SPR113.BankNum			Bank04
	#define SPR113.SourceAddress	$A400
	#define SPR113.LineCount		$06
;.dstruct SPR113 instanceof SpriteDef DATA $10, $A400, $06
	#define SPR114.BankNum			Bank04
	#define SPR114.SourceAddress	$A580
	#define SPR114.LineCount		$06 
;.dstruct SPR114 instanceof SpriteDef DATA $10, $A580, $06 
	#define SPR115.BankNum			Bank04
	#define SPR115.SourceAddress	$A700
	#define SPR115.LineCount		$06
;.dstruct SPR115 instanceof SpriteDef DATA $10, $A700, $06 
	#define SPR116.BankNum			Bank04
	#define SPR116.SourceAddress	$A880
	#define SPR116.LineCount		$06
;.dstruct SPR116 instanceof SpriteDef DATA $10, $A880, $06 
	#define SPR117.BankNum			Bank04
	#define SPR117.SourceAddress	$AA00
	#define SPR117.LineCount		$06
;.dstruct SPR117 instanceof SpriteDef DATA $10, $AA00, $06 
	#define SPR118.BankNum			Bank12
	#define SPR118.SourceAddress	$BA00
	#define SPR118.LineCount		$08
;.dstruct SPR118 instanceof SpriteDef DATA $12, $BA00, $08 
	#define SPR119.BankNum			Bank12
	#define SPR119.SourceAddress	$B800
	#define SPR119.LineCount		$08
;.dstruct SPR119 instanceof SpriteDef DATA $12, $B800, $08 
	#define SPR120.BankNum			Bank12
	#define SPR120.SourceAddress	$B600
	#define SPR120.LineCount		$08
;.dstruct SPR120 instanceof SpriteDef DATA $12, $B600, $08 
	#define SPR121.BankNum			Bank12
	#define SPR121.SourceAddress	$B400
	#define SPR121.LineCount		$08
;.dstruct SPR121 instanceof SpriteDef DATA $12, $B400, $08 
	#define SPR123.BankNum			Bank12
	#define SPR123.SourceAddress	$B200
	#define SPR123.LineCount		$08
;.dstruct SPR123 instanceof SpriteDef DATA $12, $B200, $08 
	#define SPR124.BankNum			Bank12
	#define SPR124.SourceAddress	$B000
	#define SPR124.LineCount		$08
;.dstruct SPR124 instanceof SpriteDef DATA $12, $B000, $08 
	#define SPR125.BankNum			Bank12
	#define SPR125.SourceAddress	$AE00
	#define SPR125.LineCount		$08
;.dstruct SPR125 instanceof SpriteDef DATA $12, $AE00, $08 
	#define SPR126.BankNum			Bank12
	#define SPR126.SourceAddress	$AC00
	#define SPR126.LineCount		$08
;.dstruct SPR126 instanceof SpriteDef DATA $12, $AC00, $08
	#define SPR127.BankNum			Bank12
	#define SPR127.SourceAddress	$AA00
	#define SPR127.LineCount		$08 
;.dstruct SPR127 instanceof SpriteDef DATA $12, $AA00, $08 
	#define SPR128.BankNum			Bank12
	#define SPR128.SourceAddress	$A800
	#define SPR128.LineCount		$08
;.dstruct SPR128 instanceof SpriteDef DATA $12, $A800, $08 
	#define SPR129.BankNum			Bank12
	#define SPR129.SourceAddress	$A600
	#define SPR129.LineCount		$08
;.dstruct SPR129 instanceof SpriteDef DATA $12, $A600, $08 
	#define SPR130.BankNum			Bank12
	#define SPR130.SourceAddress	$A400
	#define SPR130.LineCount		$08
;.dstruct SPR130 instanceof SpriteDef DATA $12, $A400, $08
	#define SPR131.BankNum			Bank12
	#define SPR131.SourceAddress	$A200
	#define SPR131.LineCount		$08 
;.dstruct SPR131 instanceof SpriteDef DATA $12, $A200, $08
 	#define SPR132.BankNum			Bank12
	#define SPR132.SourceAddress	$A000
	#define SPR132.LineCount		$08 
;.dstruct SPR132 instanceof SpriteDef DATA $12, $A000, $08 
;.dstruct SPR133 instanceof SpriteDef DATA $12, $9E00, $08 
;.dstruct SPR134 instanceof SpriteDef DATA $12, $9C00, $08 
;.dstruct SPR135 instanceof SpriteDef DATA $12, $9A00, $08 
;.dstruct SPR136 instanceof SpriteDef DATA $12, $9800, $08 
;.dstruct SPR137 instanceof SpriteDef DATA $12, $9600, $08 
;.dstruct SPR138 instanceof SpriteDef DATA $12, $9400, $08 
;.dstruct SPR139 instanceof SpriteDef DATA $12, $9200, $08 
;.dstruct SPR140 instanceof SpriteDef DATA $12, $9000, $08 
;.dstruct SPR141 instanceof SpriteDef DATA $12, $8E00, $08 
;.dstruct SPR142 instanceof SpriteDef DATA $12, $8C00, $08 
;.dstruct SPR143 instanceof SpriteDef DATA $12, $8A00, $08 
;.dstruct SPR144 instanceof SpriteDef DATA $12, $8800, $08 
;.dstruct SPR145 instanceof SpriteDef DATA $12, $8600, $08 
;.dstruct SPR146 instanceof SpriteDef DATA $12, $8400, $08 
;.dstruct SPR147 instanceof SpriteDef DATA $12, $8200, $08 
;.dstruct SPR148 instanceof SpriteDef DATA $12, $8000, $08 
;.dstruct SPR149 instanceof SpriteDef DATA $11, $8000, $08 
;.dstruct SPR150 instanceof SpriteDef DATA $11, $8200, $08 
;.dstruct SPR151 instanceof SpriteDef DATA $11, $8400, $08 
;.dstruct SPR152 instanceof SpriteDef DATA $11, $8600, $08 
;.dstruct SPR153 instanceof SpriteDef DATA $11, $8800, $08 
;.dstruct SPR154 instanceof SpriteDef DATA $11, $8A00, $08 
;.dstruct SPR155 instanceof SpriteDef DATA $11, $8C00, $08 
;.dstruct SPR156 instanceof SpriteDef DATA $11, $8E00, $08 
;.dstruct SPR157 instanceof SpriteDef DATA $11, $9000, $08 
;.dstruct SPR158 instanceof SpriteDef DATA $11, $9200, $08 
;.dstruct SPR159 instanceof SpriteDef DATA $11, $9400, $08 
;.dstruct SPR160 instanceof SpriteDef DATA $11, $9600, $08 
;.dstruct SPR161 instanceof SpriteDef DATA $11, $9800, $08 
;.dstruct SPR162 instanceof SpriteDef DATA $11, $9A00, $08 
;.dstruct SPR163 instanceof SpriteDef DATA $11, $9C00, $08 
;.dstruct SPR164 instanceof SpriteDef DATA $08, $9B32, $04 
;.dstruct SPR165 instanceof SpriteDef DATA $08, $9C32, $04 
;.dstruct SPR166 instanceof SpriteDef DATA $08, $9D32, $04 
;.dstruct SPR167 instanceof SpriteDef DATA $08, $9E32, $04 
;.dstruct SPR168 instanceof SpriteDef DATA $08, $9F32, $04 
;.dstruct SPR169 instanceof SpriteDef DATA $08, $A032, $04 
;.dstruct SPR170 instanceof SpriteDef DATA $08, $A132, $04 
;.dstruct SPR171 instanceof SpriteDef DATA $08, $A232, $04 
;.dstruct SPR172 instanceof SpriteDef DATA $08, $A332, $04 
;.dstruct SPR173 instanceof SpriteDef DATA $08, $A432, $04 
;.dstruct SPR174 instanceof SpriteDef DATA $08, $A532, $04 
;.dstruct SPR175 instanceof SpriteDef DATA $08, $A632, $04 
;.dstruct SPR176 instanceof SpriteDef DATA $08, $A732, $04 
;.dstruct SPR177 instanceof SpriteDef DATA $11, $9E00, $03 
;.dstruct SPR178 instanceof SpriteDef DATA $11, $9EC0, $03 
;.dstruct SPR179 instanceof SpriteDef DATA $11, $9F80, $03 
;.dstruct SPR180 instanceof SpriteDef DATA $11, $A040, $03 
;.dstruct SPR181 instanceof SpriteDef DATA $11, $A100, $03 
;.dstruct SPR182 instanceof SpriteDef DATA $11, $A1C0, $03 
;.dstruct SPR183 instanceof SpriteDef DATA $11, $A280, $03 
;.dstruct SPR184 instanceof SpriteDef DATA $10, $AB80, $08 
;.dstruct SPR185 instanceof SpriteDef DATA $10, $AD80, $08 
;.dstruct SPR186 instanceof SpriteDef DATA $10, $B280, $08 
;.dstruct SPR187 instanceof SpriteDef DATA $10, $B480, $08 
;.dstruct SPR188 instanceof SpriteDef DATA $04, $B680, $06

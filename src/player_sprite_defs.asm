.ASSUME ADL=0
;================================================================
; 	Pointers to tile art for each frame of player object's 
;	animations.
;	Used by routine at $10BF to load player tile art into VRAM.
;================================================================

#macro dstruct(name, BankNum, SourceAddress, LineCount)
.db BankNum
.dw SourceAddress
.db LineCount
#endmacro

Data_PlayerSprites:

Sonic_Walking:			 ;6 frames
dstruct(Sonic_Walking_1, 04, $8000, $06)
dstruct(Sonic_Walking_2, 04, $8180, $06)
dstruct(Sonic_Walking_3, 04, $8300, $06)
dstruct(Sonic_Walking_4, 04, $8480, $06)
dstruct(Sonic_Walking_5, 04, $8600, $06)
dstruct(Sonic_Walking_6, 04, $8780, $06)

Sonic_Idle:			 ;3 frames
dstruct(Sonic_Idle_1, 04, $8900, $06) ;$07
dstruct(Sonic_Idle_2, 04, $AF80, $06) ;$08
dstruct(Sonic_Idle_3, 04, $B100, $06) ;$09

Sonic_Standing:			 ;1 frame
dstruct(Sonic_Standing_1, 04, $8D80, $06) ;$0A

Sonic_LookUp:			 ;1 frame
dstruct(Sonic_LookUp_1, 04, $8F00, $06) ;$0B

Sonic_Running:			 ;4 frames
dstruct(Sonic_Running_1, 04, $9080, $06) ;$0C
dstruct(Sonic_Running_2, 04, $9200, $06) ;$0D 
dstruct(Sonic_Running_3, 04, $9380, $06) ;$0E 
dstruct(Sonic_Running_4, 04, $9500, $06) ;$0F 

Sonic_LookDown:			 ;1 frame
dstruct(Sonic_LookDown_1, 04, $9680, $06) ;$10

Sonic_Roll:			 ;5 frames
dstruct(Sonic_Roll_1, 04, $9800, $06) ;$11
dstruct(Sonic_Roll_2, 04, $9980, $06) ;$12
dstruct(Sonic_Roll_3, 04, $9B00, $06) ;$13
dstruct(Sonic_Roll_4, 04, $9C80, $06) ;$14
dstruct(Sonic_Roll_5, 04, $9E00, $06) ;$15 

Sonic_Skid:			 ;2 frames
dstruct(Sonic_Skid_Left_1, 10, $9F80, $06) ;$16
dstruct(Sonic_Skid_Left_2, 10, $A100, $06) ;$17 

Sonic_Drowning:			 ;2 frames
dstruct(Sonic_Drowning_1, 04, $A280, $06) ;$18
dstruct(Sonic_Drowning_2, 04, $A400, $06) ;$19

Sonic_Leap:			 ;1 frame
dstruct(Sonic_Leap_1, 04, $A580, $06) ;$1A 

Sonic_Hurt:			 ;2 frames
dstruct(Sonic_Hurt_1, 04, $A700, $06) ;$1B
dstruct(Sonic_Hurt_2, 04, $A880, $06) ;$1C

Sonic_Spring			 ;1 frame
dstruct(Sonic_Spring_1, 04, $AA00, $06) ;$1D

;loop anims
dstruct(SPR19, 06, $8000, $08)		 ;$1D
dstruct(SPR20, 06, $8200, $08)		 ;$1E
dstruct(SPR21, 06, $8400, $08)		 ;$1F
dstruct(SPR22, 06, $8600, $08)		 ;$20
dstruct(SPR23, 06, $8800, $08)		 ;$21
dstruct(SPR24, 06, $8A00, $08)		 ;$22
dstruct(SPR25, 06, $8C00, $08)		 ;$23
dstruct(SPR26, 06, $8E00, $08)		 ;$24
dstruct(SPR27, 06, $9000, $08)		 ;$25
dstruct(SPR28, 06, $9200, $08)		 ;$26
dstruct(SPR29, 06, $9400, $08)		 ;$27
dstruct(SPR30, 06, $9600, $08)		 ;$28
dstruct(SPR31, 06, $9800, $08)		 ;$29
dstruct(SPR32, 06, $9A00, $08)		 ;$2A
dstruct(SPR33, 06, $9C00, $08)		 ;$2B
dstruct(SPR34, 06, $9E00, $08)		 ;$2C
dstruct(SPR35, 06, $A000, $08)		 ;$2D
dstruct(SPR36, 06, $A200, $08)		 ;$2E
dstruct(SPR37, 06, $A400, $08)		 ;$2F
dstruct(SPR38, 06, $A600, $08)		 ;$30
dstruct(SPR39, 06, $A800, $08)		 ;$31
dstruct(SPR40, 06, $AA00, $08)		 ;$32
dstruct(SPR41, 06, $AC00, $08)		 ;$33
dstruct(SPR42, 06, $AE00, $08)		 ;$34
dstruct(SPR43, 06, $B000, $08)		 ;$35
dstruct(SPR44, 06, $B200, $08)		 ;$36
dstruct(SPR45, 06, $B400, $08)		 ;$37
dstruct(SPR46, 06, $B600, $08)		 ;$38
dstruct(SPR47, 06, $B800, $08)		 ;$39
dstruct(SPR48, 06, $BA00, $08		 ;$3A

;glider
dstruct(SPR49, 05, $8000, $08)		 ;$3B
dstruct(SPR50, 05, $8200, $08)		 ;$3C
dstruct(SPR51, 05, $8400, $08)		 ;$3D
dstruct(SPR52, 05, $8600, $08)		 ;$3E
dstruct(SPR53, 05, $8800, $08)		 ;$3F
dstruct(SPR54, 05, $8A00, $08)		 ;$40
dstruct(SPR55, 05, $8C00, $08)		 ;$41
dstruct(SPR56, 05, $8E00, $08)		 ;$42
dstruct(SPR57, 05, $9000, $08)		 ;$43
dstruct(SPR58, 05, $9200, $08)		 ;$44
dstruct(SPR59, 05, $9400, $08)		 ;$45
dstruct(SPR60, 05, $9600, $08)		 ;$46
dstruct(SPR61, 05, $9800, $08)		 ;$47
dstruct(SPR62, 05, $9A00, $08)		 ;$48
dstruct(SPR63, 05, $9C00, $08)		 ;$49

;mini sonic (from intro)
dstruct(SPR64, 08, $9B32, $04)		 ;$4A
dstruct(SPR65, 08, $9C32, $04)		 ;$4B
dstruct(SPR66, 08, $9D32, $04)		 ;$4C
dstruct(SPR67, 08, $9E32, $04)		 ;$4D
dstruct(SPR68, 08, $9F32, $04)		 ;$4E
dstruct(SPR69, 08, $A032, $04)		 ;$4F
dstruct(SPR70, 08, $A132, $04)		 ;$50
dstruct(SPR71, 08, $A232, $04)		 ;$51
dstruct(SPR72, 08, $A332, $04)		 ;$52
dstruct(SPR73, 08, $A432, $04)		 ;$53
dstruct(SPR74, 08, $A532, $04)		 ;$54
dstruct(SPR75, 08, $A632, $04)		 ;$55
dstruct(SPR76, 08, $A732, $04)		 ;$56

;minecart
dstruct(SPR77, 05, $9E00, $03)		 ;$57
dstruct(SPR78, 05, $9EC0, $03)		 ;$58
dstruct(SPR79, 05, $9F80, $03)		 ;$59
dstruct(SPR80, 05, $A040, $03)		 ;$5A
dstruct(SPR81, 05, $A100, $03)		 ;$5B
dstruct(SPR82, 05, $A1C0, $03)		 ;$5C
dstruct(SPR83, 05, $A280, $03)		 ;$5D


dstruct(SPR84, 04, $AB80, $08)		 ;$5E
dstruct(SPR85, 04, $AD80, $08)		 ;$5F
dstruct(SPR86, 04, $B280, $08)		 ;$60
dstruct(SPR87, 04, $B480, $08)		 ;$61
dstruct(SPR88, 04, $B680, $06)		 ;$62



Data_PlayerSprites_Mirrored:
dstruct(SPR89, 10, $8000, $06)		 ;$63
dstruct(SPR90, 10, $8180, $06)		 ;$64
dstruct(SPR91, 10, $8300, $06)		 ;$65
dstruct(SPR92, 10, $8480, $06)		 ;$66
dstruct(SPR93, 10, $8600, $06)
dstruct(SPR94, 10, $8780, $06)
dstruct(SPR95, 10, $8900, $06)
dstruct(SPR96, 10, $AF80, $06)
dstruct(SPR97, 10, $B100, $06)
dstruct(SPR98, 10, $8D80, $06)
dstruct(SPR99, 10, $8F00, $06)
dstruct(SPR100, 10, $9080, $06)
dstruct(SPR101, 10, $9200, $06)
dstruct(SPR102, 10, $9380, $06)
dstruct(SPR103, 10, $9500, $06)
dstruct(SPR104, 10, $9680, $06)
dstruct(SPR105, 10, $9800, $06)
dstruct(SPR106, 10, $9980, $06)
dstruct(SPR107, 10, $9B00, $06)
dstruct(SPR108, 10, $9C80, $06)
dstruct(SPR109, 10, $9E00, $06)
dstruct(SPR110, 04, $9F80, $06)
dstruct(SPR111, 04, $A100, $06)
dstruct(SPR112, 10, $A280, $06)
dstruct(SPR113, 10, $A400, $06)
dstruct(SPR114, 10, $A580, $06)
dstruct(SPR115, 10, $A700, $06)
dstruct(SPR116, 10, $A880, $06)
dstruct(SPR117, 10, $AA00, $06)
dstruct(SPR118, 12, $BA00, $08)
dstruct(SPR119, 12, $B800, $08)
dstruct(SPR120, 12, $B600, $08)
dstruct(SPR121, 12, $B400, $08)
dstruct(SPR123, 12, $B200, $08)
dstruct(SPR124, 12, $B000, $08)
dstruct(SPR125, 12, $AE00, $08)
dstruct(SPR126, 12, $AC00, $08)
dstruct(SPR127, 12, $AA00, $08)
dstruct(SPR128, 12, $A800, $08)
dstruct(SPR129, 12, $A600, $08)
dstruct(SPR130, 12, $A400, $08)
dstruct(SPR131, 12, $A200, $08)
dstruct(SPR132, 12, $A000, $08)
dstruct(SPR133, 12, $9E00, $08)
dstruct(SPR134, 12, $9C00, $08)
dstruct(SPR135, 12, $9A00, $08)
dstruct(SPR136, 12, $9800, $08)
dstruct(SPR137, 12, $9600, $08)
dstruct(SPR138, 12, $9400, $08)
dstruct(SPR139, 12, $9200, $08)
dstruct(SPR140, 12, $9000, $08)
dstruct(SPR141, 12, $8E00, $08)
dstruct(SPR142, 12, $8C00, $08)
dstruct(SPR143, 12, $8A00, $08)
dstruct(SPR144, 12, $8800, $08)
dstruct(SPR145, 12, $8600, $08)
dstruct(SPR146, 12, $8400, $08)
dstruct(SPR147, 12, $8200, $08)
dstruct(SPR148, 12, $8000, $08)
dstruct(SPR149, 11, $8000, $08)
dstruct(SPR150, 11, $8200, $08)
dstruct(SPR151, 11, $8400, $08)
dstruct(SPR152, 11, $8600, $08)
dstruct(SPR153, 11, $8800, $08)
dstruct(SPR154, 11, $8A00, $08)
dstruct(SPR155, 11, $8C00, $08)
dstruct(SPR156, 11, $8E00, $08)
dstruct(SPR157, 11, $9000, $08)
dstruct(SPR158, 11, $9200, $08)
dstruct(SPR159, 11, $9400, $08)
dstruct(SPR160, 11, $9600, $08)
dstruct(SPR161, 11, $9800, $08)
dstruct(SPR162, 11, $9A00, $08)
dstruct(SPR163, 11, $9C00, $08)
dstruct(SPR164, 08, $9B32, $04)
dstruct(SPR165, 08, $9C32, $04)
dstruct(SPR166, 08, $9D32, $04)
dstruct(SPR167, 08, $9E32, $04)
dstruct(SPR168, 08, $9F32, $04)
dstruct(SPR169, 08, $A032, $04)
dstruct(SPR170, 08, $A132, $04)
dstruct(SPR171, 08, $A232, $04)
dstruct(SPR172, 08, $A332, $04)
dstruct(SPR173, 08, $A432, $04)
dstruct(SPR174, 08, $A532, $04)
dstruct(SPR175, 08, $A632, $04)
dstruct(SPR176, 08, $A732, $04)
dstruct(SPR177, 11, $9E00, $03)
dstruct(SPR178, 11, $9EC0, $03)
dstruct(SPR179, 11, $9F80, $03)
dstruct(SPR180, 11, $A040, $03)
dstruct(SPR181, 11, $A100, $03)
dstruct(SPR182, 11, $A1C0, $03)
dstruct(SPR183, 11, $A280, $03)
dstruct(SPR184, 10, $AB80, $08)
dstruct(SPR185, 10, $AD80, $08)
dstruct(SPR186, 10, $B280, $08)
dstruct(SPR187, 10, $B480, $08)
dstruct(SPR188, 04, $B680, $06)
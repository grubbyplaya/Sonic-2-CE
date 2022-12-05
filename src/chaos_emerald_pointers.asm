;Chaos Emerald tile data pointers
;pointers into bank 20
Bank20:
ChaosEmeraldData:
#ifdef CurrentLevel = Level_UGZ
.dw Art_ChaosEmerald_Blue
#endif
#ifdef CurrentLevel = Level_SHZ
.dw Art_ChaosEmerald_Yellow
#endif
#ifdef CurrentLevel = Level_ALZ
.dw Art_ChaosEmerald_Pink
#endif
#ifdef CurrentLevel = Level_GHZ
.dw Art_ChaosEmerald_Grey
#endif
#ifdef CurrentLevel = Level_GMZ
.dw Art_ChaosEmerald_Red
#endif
#ifdef CurrentLevel = Level_SEZ
.dw Art_ChaosEmerald_Green
#endif
#ifdef CurrentLevel = Level_CEZ
.dw Art_ChaosEmerald_Blue
#endif
#ifdef CurrentLevel = Level_End
.dw Art_ChaosEmerald_Blue
#endif
	ret
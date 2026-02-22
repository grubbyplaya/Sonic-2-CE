.ASSUME ADL=0
.dw DATA_2A34	;UGZ
.dw DATA_2AA4	;SHZ
.dw DATA_29C4	;ALZ
.dw DATA_2904	;GHZ
.dw DATA_2B14	;GMZ
.dw DATA_2BF4	;SEZ
.dw DATA_2C64	;CEZ

DATA_28FE:	;mappings for act logo
.dw DATA_2E04
.dw DATA_2E90
.dw DATA_2F1C


DATA_2904:	;mappings for "GREEN HILLS"
 #if Language = 1
  #import "src/mappings/titlecard/titlecard_mappings_2904.bin"
#else Language = 2
  #import "src/mappings/titlecard/titlecard_mappings_2904_FR.bin"
#endif


DATA_2974:
  #import "src/mappings/titlecard/titlecard_mappings_2974.bin"


DATA_299C:
  #import "src/mappings/titlecard/titlecard_mappings_299C.bin"


DATA_29C4:	;mappings for "AQUA LAKE"
#if Language = 1
  #import "src/mappings/titlecard/titlecard_mappings_29C4.bin"
#else Language = 2
  #import "src/mappings/titlecard/titlecard_mappings_29C4_FR.bin"
#endif


DATA_2A34:	;mappings for "UNDER GROUND"
#if Language = 1
  #import "src/mappings/titlecard/titlecard_mappings_2A34.bin"
#else Language = 2
  #import "src/mappings/titlecard/titlecard_mappings_2A34_FR.bin"
#endif


DATA_2AA4:	;mappings for "SKY HIGH"
#if Language = 1
  #import "src/mappings/titlecard/titlecard_mappings_2AA4.bin"
#else Language = 2
  #import "src/mappings/titlecard/titlecard_mappings_2AA4_FR.bin"
#endif



DATA_2B14:	;mappings for "GIMMICK MT."
#if Language = 1
  #import "src/mappings/titlecard/titlecard_mappings_2B14.bin"
#else Language = 2
  #import "src/mappings/titlecard/titlecard_mappings_2B14_FR.bin"
#endif


DATA_2B84:	;unused "MOUNTAIN" mappings
  #import "src/mappings/titlecard/titlecard_mappings_2B84.bin"


DATA_2BF4:	;mappings for "SCRAMBLED EGG"
#if Language = 1
  #import "src/mappings/titlecard/titlecard_mappings_2BF4.bin"
#else Language = 2
  #import "src/mappings/titlecard/titlecard_mappings_2BF4_FR.bin"
#endif


DATA_2C64:	;mappings for "CRYSTAL EGG"
#if Language = 1
  #import "src/mappings/titlecard/titlecard_mappings_2C64.bin"
#else Language = 2
  #import "src/mappings/titlecard/titlecard_mappings_2C64_FR.bin"
#endif

DATA_2D0C:	
  #import "src/mappings/titlecard/titlecard_mappings_2D0C.bin"


DATA_2D6C:
  #import "src/mappings/titlecard/titlecard_mappings_2D6C.bin"


DATA_2D98:
  #import "src/mappings/titlecard/titlecard_mappings_2D98.bin"


DATA_2DAC:
  #import "src/mappings/titlecard/titlecard_mappings_2DAC.bin"


DATA_2DC0:
  #import "src/mappings/titlecard/titlecard_mappings_2DC0.bin"


DATA_2DD4:
  #import "src/mappings/titlecard/titlecard_mappings_2DD4.bin"


DATA_2E04:
  #import "src/mappings/titlecard/titlecard_mappings_2E04.bin"


DATA_2E90:
  #import "src/mappings/titlecard/titlecard_mappings_2E90.bin"


DATA_2F1C:
  #import "src/mappings/titlecard/titlecard_mappings_2F1C.bin"
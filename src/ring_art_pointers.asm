RingArtPointers:
;pointers for each level
.dl RingArtPointers_UGZ
.dl RingArtPointers_SHZ
.dl RingArtPointers_ALZ
.dl RingArtPointers_GHZ
.dl RingArtPointers_GMZ
.dl RingArtPointers_SEZ
.dl RingArtPointers_CEZ	;same?
.dl DATA_231A
.dl RingArtPointers_CEZ	;same?
.dl DATA_2320

;pointers for each act
RingArtPointers_UGZ:
.dl RingArtPointers_UGZ1
.dl RingArtPointers_UGZ2
.dl RingArtPointers_UGZ3

RingArtPointers_SHZ:
.dl RingArtPointers_SHZ1
.dl RingArtPointers_SHZ2
.dl RingArtPointers_SHZ3

RingArtPointers_ALZ:
.dl RingArtPointers_ALZ1
.dl RingArtPointers_ALZ2
.dl RingArtPointers_ALZ3

RingArtPointers_GHZ:
.dl RingArtPointers_GHZ1
.dl RingArtPointers_GHZ2
.dl RingArtPointers_GHZ3

RingArtPointers_GMZ:
.dl RingArtPointers_GMZ1
.dl RingArtPointers_GMZ2
.dl RingArtPointers_GMZ3

RingArtPointers_SEZ
.dl RingArtPointers_SEZ1
.dl RingArtPointers_SEZ2
.dl RingArtPointers_SEZ3

RingArtPointers_CEZ:
.dl RingArtPointers_CEZ1
.dl RingArtPointers_CEZ2
.dl RingArtPointers_CEZ3

DATA_231A:
.dl DATA_23F8
.dl DATA_23F8
.dl DATA_23F8

DATA_2320:
.dl DATA_2402
.dl DATA_240C
.dl DATA_240C

;ring art headers for each level/act
;	2 bytes	-	pointer to collision data
;	2 bytes -	source address
;	2 bytes -	vram dest address
;	1 byte	-	first cycling palette index
;	1 byte	-	second cycling palette index
;	1 byte	-	third cycling palette index?
;	1 byte	-	fourth cycling palette index?
RingArtPointers_GHZ1:
.dl DATA_B30_9841, Art_Rings_GHZ, $2880, $0000, $0000
RingArtPointers_GHZ2:
.dl DATA_B30_9841, Art_Rings_GHZ, $2880, $0000, $0000
RingArtPointers_GHZ3:
.dl DATA_B30_9841, Art_Rings_GHZ, $2880, $0000, $0000

RingArtPointers_SHZ1:
.dl DATA_B30_9841, Art_Rings_SHZ1_3, $2A80, $0000, $0000
RingArtPointers_SHZ2:
.dl DATA_B30_9841, Art_Rings_SHZ2, $27C0, $0302, $0000
RingArtPointers_SHZ3:
.dl DATA_B30_9841, Art_Rings_SHZ1_3, $2A80, $0000, $0000

RingArtPointers_ALZ1:
.dl DATA_B30_9841, Art_Rings_ALZ, $2940, $0005, $0000
RingArtPointers_ALZ2:
.dl DATA_B30_9A41, Art_Rings_ALZ, $2940, $0005, $0000
RingArtPointers_ALZ3:
.dl DATA_B30_9841, Art_Rings_ALZ, $2940, $0005, $0000

RingArtPointers_UGZ1:
.dl DATA_B30_9841, Art_Rings_UGZ, $2DE0, $0004, $0000
RingArtPointers_UGZ2:
.dl DATA_B30_9841, Art_Rings_UGZ, $2DE0, $0004, $0000
RingArtPointers_UGZ3:
.dl DATA_B30_9841, Art_Rings_UGZ, $2DE0, $0004, $0000

RingArtPointers_GMZ1:
.dl DATA_B30_9841, Art_Rings_GMZ, $2860, $0706, $0000
RingArtPointers_GMZ2:
.dl DATA_B30_9841, Art_Rings_GMZ, $2860, $0706, $0000
RingArtPointers_GMZ3:
.dl DATA_B30_9841, Art_Rings_GMZ, $2860, $0706, $0000

RingArtPointers_SEZ1:
.dl DATA_B30_9841, Art_Rings_SEZ, $30A0, $0008, $0000
RingArtPointers_SEZ2:
.dl DATA_B30_9841, Art_Rings_SEZ, $3120, $0008, $0000
RingArtPointers_SEZ3:
.dl DATA_B30_9841, Art_Rings_SEZ, $30A0, $0008, $0000

RingArtPointers_CEZ1:
.dl DATA_B30_9841, Art_Rings_CEZ, $29A0, $000C, $0000
RingArtPointers_CEZ2:
.dl DATA_B30_9841, Art_Rings_CEZ, $29A0, $000C, $0000
RingArtPointers_CEZ3:
.dl DATA_B30_9841, Art_Rings_CEZ, $0000, $0B00, $0000

DATA_23F8:
.dl DATA_B30_9841, Art_Rings_CEZ, $0000, $0000, $0000
DATA_2402:
.dl DATA_B30_9841, Art_Rings_GHZ, $0000, $0000, $0000
DATA_240C:
.dl DATA_B30_9841, Art_Rings_GHZ, $0000, $0000, $0000
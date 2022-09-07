Layout_GHZ1:
#import "layout\ghz\layout_ghz1.bin"

Layout_GHZ2:
#import "layout\ghz\layout_ghz2.bin"

Layout_GHZ3:
#import "layout\ghz\layout_ghz3.bin"

Layout_SHZ1:
.IFEQ Version 2.2
#import "layout\shz\layout_shz1_2.2.bin"
.ELSE
#import "layout\shz\layout_shz1.bin"
.ENDIF

Layout_SHZ2:
.IFEQ Version 2.2
#import "layout\shz\layout_shz2_2.2.bin"
.ELSE
#import "layout\shz\layout_shz2.bin"
.ENDIF

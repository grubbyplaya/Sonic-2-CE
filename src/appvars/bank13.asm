Layout_GHZ1:
#import "layout\ghz\layout_ghz1.bin"

Layout_GHZ2:
#import "layout\ghz\layout_ghz2.bin"


Layout_GHZ3:
#if Version = 2
#import "layout\ghz\layout_ghz3.bin"
#else
#import "layout\ghz\layout_ghz3_og.bin"
#endif

Layout_SHZ1:
#if Version = 2
#import "layout\shz\layout_shz1_2.2.bin"
#else
#import "layout\shz\layout_shz1.bin"
#endif

Layout_SHZ2:
#if Verfsion = 2
#import "layout\shz\layout_shz2_2.2.bin"
#else
#import "layout\shz\layout_shz2.bin"
#endif

#define	Version=2

Layout_ALZ1:
#import "layout\alz\layout_alz1.bin"

Layout_ALZ2:
#import "layout\alz\layout_alz2.bin"

Layout_ALZ3:
#ifdef Version=2
#import "layout\alz\layout_alz3.bin"
#else
#import "layout\alz\layout_alz3_og.bin"
#endif

Layout_UGZ1:
#import "layout\ugz\layout_ugz1.bin"
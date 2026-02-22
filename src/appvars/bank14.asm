.ORG $8000

Layout_ALZ1:
#import "src/layout/alz/layout_alz1.bin"

Layout_ALZ2:
#import "src/layout/alz/layout_alz2.bin"

Layout_ALZ3:
#if Version = 2
#import "src/layout/alz/layout_alz3.bin"
#else
#import "src/layout/alz/layout_alz3_og.bin"
#endif

Layout_UGZ1:
#import "src/layout/ugz/layout_ugz1.bin"
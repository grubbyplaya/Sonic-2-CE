![](https://raw.githubusercontent.com/grubbyplaya/Sonic-2-CE/master/s2banner.png)

A currently unfinished port of the Sega Master System version of Sonic 2 to the TI-84+ CE.

So far, the game assembles into 32 appvars totaling 443 kilobytes in size. Every level works, but there are some image artifacts in some stages.

# Controls

Arrow keys - Move Sonic

2nd/Alpha - Jump

Mode - Pause Game

Clear - Quit Game

Delete - Reset Game

# To Do
 - [x] Get the codebase to assemble using SPASM
 - [x] Reimplement SMS mappers using appvars
 - [x] Replace original 6bpp palettes with 16bpp approximations
 - [x] Emulate the SMS VDP, rendering, caches, and all (~99% done)
 - [x] Fix remaining runtime errors
 - [ ] (MID PRIORITY) Get the game running at full speed
 - [ ] (VERY LOW PRIORITY) expand the rendering area to fill the 84+ CE's screen
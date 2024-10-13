![](https://raw.githubusercontent.com/grubbyplaya/Sonic-2-CE/master/s2banner.png)

A mostly complete port of the Sega Master System version of Sonic 2 to the TI-84+ CE.

The game is 443 kilobytes in size. Make sure that every appvar and the launcher (Sonic2.8xp) is stored in archive memory, as the game will crash if any appvar is stored in RAM.

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
 - [x] Emulate the SMS VDP, rendering, caches, and all
 - [x] Fix remaining runtime errors
 - [x] (MID PRIORITY) Get the game running at full speed
 - [ ] (VERY LOW PRIORITY) expand the rendering area to fill the 84+ CE's screen
![](https://raw.githubusercontent.com/grubbyplaya/Sonic-2-CE/master/s2banner.png)

A currently unfinished port of the Sega Master System version of Sonic 2 to the TI-84+ CE.

So far, the game assembles into a 35KB .8xp file, but launching it will crash your calculator. 

# Controls

Arrow keys - Move Sonic

2nd/Alpha - Jump

Clear - Quit Game

Delete - Reset Game

# To Do
 - [x] Get the code to assemble using SPASM
 - [x] Reimplement SMS mappers with TI-OS routines
 - [x] Move all SMS RAM pointers to CE RAM
 - [x] Replace original 6bpp palettes with 16bpp approximations
 - [x] Add an equate file for the ROM banks
 - [ ] Add emulated VDP routines (80% done)
 - [ ] Fix remaining pointer issues and runtime errors (~30% done)
 - [ ] (NOT NEEDED) expand the rendering area to fill the 84+ CE's screen
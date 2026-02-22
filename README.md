![](https://raw.githubusercontent.com/grubbyplaya/Sonic-2-CE/master/s2banner.png)

A mostly complete port of the Sega Master System version of Sonic 2 to the TI-84+ CE. Newer 84+ CE models, like post-2019 revision M and Python Edition models, will run this game faster than older models.

This game is 452 kilobytes in size. Make sure that every appvar and the launcher (Sonic2.8xp) is stored in archive memory, as the game will crash if any appvar is stored in RAM.

# Controls

Arrow keys - Move Sonic

2nd/Alpha - Jump

Mode - Pause Game

Clear - Quit Game

Delete - Reset Game

# To Do
 - [x] Port the disassembly from WLA-DX to SPASM
 - [x] Reimplement SMS mappers using appvars
 - [x] Emulate the SMS VDP (tilemap, sprites, scrolling, palettes, and priority tiles)
 - [x] Fix remaining bugs and crashes
 - [ ] (MID PRIORITY) Get the game running at full speed on all 84+ CE models
 - [ ] (VERY LOW PRIORITY) expand the rendering area to fill the 84+ CE's screen
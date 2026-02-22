
@echo off
set /P VersionType=What version are you building? (1 = Original, 2 = Normal): 
set /P Language=What language are you using? (1 = English, 2 = French): 

echo Assembling game...
spasm64 -E -D Version=%VersionType% src/launcher.asm bin/sonic2.8xp
spasm64 -E -L -O -D Version=%VersionType% -D Listing=1 -D Language=%Language% src/s2.asm bin/Sonic2.8xv

echo Building Rom Listings...
spasm64 -E -L -D Listing=1 src/object_logic/bank28.asm bin/S2B28.8xv
spasm64 -E -L -D Listing=1 src/appvars/bank30.asm bin/S2B30.8xv
spasm64 -E -L -D Listing=1 src/appvars/bank31.asm bin/S2B31.8xv

echo Bulding ROM Banks...
spasm64 -E -L src/appvars/bank04.asm bin/S2B04.8xv
spasm64 -E -L src/appvars/bank05.asm bin/S2B05.8xv
spasm64 -E -L src/appvars/bank06.asm bin/S2B06.8xv
spasm64 -E -L src/appvars/bank07.asm bin/S2B07.8xv
spasm64 -E -L src/appvars/bank08.asm bin/S2B08.8xv
spasm64 -E -L src/appvars/bank09.asm bin/S2B09.8xv
spasm64 -E -L src/appvars/bank10.asm bin/S2B10.8xv
spasm64 -E -L src/appvars/bank11.asm bin/S2B11.8xv
spasm64 -E -L src/appvars/bank12.asm bin/S2B12.8xv
spasm64 -E -L src/appvars/bank13.asm bin/S2B13.8xv
spasm64 -E -L src/appvars/bank14.asm bin/S2B14.8xv
spasm64 -E -L src/appvars/bank15.asm bin/S2B15.8xv
spasm64 -E -L src/appvars/bank16.asm bin/S2B16.8xv
spasm64 -E -L src/appvars/bank17.asm bin/S2B17.8xv
spasm64 -E -L src/appvars/bank18.asm bin/S2B18.8xv
spasm64 -E -L src/appvars/bank19.asm bin/S2B19.8xv
spasm64 -E -L src/appvars/bank20.asm bin/S2B20.8xv
spasm64 -E -L src/appvars/bank21.asm bin/S2B21.8xv
spasm64 -E -L src/appvars/bank22.asm bin/S2B22.8xv
spasm64 -E -L src/appvars/bank23.asm bin/S2B23.8xv
spasm64 -E -L src/appvars/bank24.asm bin/S2B24.8xv
spasm64 -E -L src/appvars/bank25.asm bin/S2B25.8xv
spasm64 -E -L src/appvars/bank26.asm bin/S2B26.8xv
spasm64 -E -L src/appvars/bank27.asm bin/S2B27.8xv
spasm64 -E -D Listing=0 src/object_logic/bank28.asm bin/S2B28.8xv
spasm64 -E -L src/bank29.asm bin/S2B29.8xv
spasm64 -E -D Listing=0 src/appvars/bank30.asm bin/S2B30.8xv
spasm64 -E -D Listing=0 src/appvars/bank31.asm bin/S2B31.8xv
spasm64 -E -L src/SHC/SHC.asm bin/S2B32.8xv
spasm64 -E -D Version=%VersionType% -D Listing=0 -D Language=%Language% src/s2.asm bin/Sonic2.8xv

echo Sonic the Hedgehog created by Sega
echo Sonic the Hedgehog 2 8-bit developed by Aspect
echo Sonic 2 CE ported by grubbycoder
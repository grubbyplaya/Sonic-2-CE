@echo off
cd src
echo Assembling game...
mkdir bin
spasm64 -E -D Version=2 s2.asm bin/s2.8xp

echo Bulding ROM Banks...
spasm64 -E -D Version=2 appvars/bank04.asm bin/bank04.8xv
spasm64 -E -D Version=2 appvars/bank05.asm bin/bank05.8xv
spasm64 -E -D Version=2 appvars/bank06.asm bin/bank06.8xv
spasm64 -E -D Version=2 appvars/bank07.asm bin/bank07.8xv
spasm64 -E -D Version=2 appvars/bank08.asm bin/bank08.8xv
spasm64 -E -D Version=2 appvars/bank09.asm bin/bank09.8xv
spasm64 -E -D Version=2 appvars/bank10.asm bin/bank10.8xv
spasm64 -E -D Version=2 appvars/bank11.asm bin/bank11.8xv
spasm64 -E -D Version=2 appvars/bank12.asm bin/bank12.8xv
spasm64 -E -D Version=2 appvars/bank13.asm bin/bank13.8xv
spasm64 -E -D Version=2 appvars/bank14.asm bin/bank14.8xv
spasm64 -E -D Version=2 appvars/bank15.asm bin/bank15.8xv
spasm64 -E -D Version=2 appvars/bank16.asm bin/bank16.8xv
spasm64 -E -D Version=2 appvars/bank17.asm bin/bank17.8xv
spasm64 -E -D Version=2 appvars/bank18.asm bin/bank18.8xv
spasm64 -E -D Version=2 appvars/bank19.asm bin/bank19.8xv
spasm64 -E -D Version=2 appvars/bank20.asm bin/bank20.8xv
spasm64 -E -D Version=2 appvars/bank21.asm bin/bank21.8xv
spasm64 -E -D Version=2 appvars/bank22.asm bin/bank22.8xv
spasm64 -E -D Version=2 appvars/bank23.asm bin/bank23.8xv
spasm64 -E -D Version=2 appvars/bank24.asm bin/bank24.8xv
spasm64 -E -D Version=2 appvars/bank25.asm bin/bank25.8xv
spasm64 -E -D Version=2 appvars/bank26.asm bin/bank26.8xv
spasm64 -E -D Version=2 appvars/bank27.asm bin/bank27.8xv
spasm64 -E -D Version=2 object_logic/bank28.asm bin/bank28.8xv
spasm64 -E -D Version=2 bank29.asm bin/bank29.8xv
spasm64 -E -D Version=2 appvars/bank30.asm bin/bank30.8xv
spasm64 -E -D Version=2 appvars/bank31.asm bin/bank31.8xv
cd ..

echo Sonic the Hedgehog created by Sega
echo Sonic the Hedgehog 2 8-bit developed by Aspect
echo Sonic 2 CE ported by grubbycoder
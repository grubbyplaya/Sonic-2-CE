@echo off
cd src
echo Assembling game...
spasm64 -E -D Version=2 s2.asm s2.8xp

echo Bulding ROM Banks...
spasm64 -E -D Version=2 appvars/bank04.asm appvars/bank04.8xv
spasm64 -E -D Version=2 appvars/bank05.asm appvars/bank05.8xv
spasm64 -E -D Version=2 appvars/bank06.asm appvars/bank06.8xv
spasm64 -E -D Version=2 appvars/bank07.asm appvars/bank07.8xv
spasm64 -E -D Version=2 appvars/bank08.asm appvars/bank08.8xv
spasm64 -E -D Version=2 appvars/bank09.asm appvars/bank09.8xv
spasm64 -E -D Version=2 appvars/bank10.asm appvars/bank10.8xv
spasm64 -E -D Version=2 appvars/bank11.asm appvars/bank11.8xv
spasm64 -E -D Version=2 appvars/bank12.asm appvars/bank12.8xv
spasm64 -E -D Version=2 appvars/bank13.asm appvars/bank13.8xv
spasm64 -E -D Version=2 appvars/bank14.asm appvars/bank14.8xv
spasm64 -E -D Version=2 appvars/bank15.asm appvars/bank15.8xv
spasm64 -E -D Version=2 appvars/bank16.asm appvars/bank16.8xv
spasm64 -E -D Version=2 appvars/bank17.asm appvars/bank17.8xv
spasm64 -E -D Version=2 appvars/bank18.asm appvars/bank18.8xv
spasm64 -E -D Version=2 appvars/bank19.asm appvars/bank19.8xv
spasm64 -E -D Version=2 appvars/bank20.asm appvars/bank20.8xv
spasm64 -E -D Version=2 appvars/bank21.asm appvars/bank21.8xv
spasm64 -E -D Version=2 appvars/bank22.asm appvars/bank22.8xv
spasm64 -E -D Version=2 appvars/bank23.asm appvars/bank23.8xv
spasm64 -E -D Version=2 appvars/bank24.asm appvars/bank24.8xv
spasm64 -E -D Version=2 appvars/bank25.asm appvars/bank25.8xv
spasm64 -E -D Version=2 appvars/bank26.asm appvars/bank26.8xv
spasm64 -E -D Version=2 appvars/bank27.asm appvars/bank27.8xv
spasm64 -E -D Version=2 bank29.asm appvars/bank29.8xv
spasm64 -E -D Version=2 appvars/bank30.asm appvars/bank30.8xv
spasm64 -E -D Version=2 appvars/bank31.asm appvars/bank31.8xv
cd ..

echo Sonic the Hedgehog created by Sega
echo Sonic the Hedgehog 2 8-bit developed by Aspect
echo Sonic 2 CE ported by grubbycoder
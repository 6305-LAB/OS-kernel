@echo off
if "%1"=="run" goto run
if "%1"=="debug" goto debug
if "%1"=="ndisasm" goto ndisasm
:run 
"C:\Program Files (x86)\Bochs-2.6.2\bochs" -q -f bochsrc.bxrc
goto last
:debug
"C:\Program Files (x86)\Bochs-2.6.2\bochsdbg.exe"
goto last
:ndisasm
nasm\ndisasm -o 0x88500 boot\loader.bin>loader.txt
nasm\ndisasm -o 0x7c00 boot\boot.bin>boot.txt
goto last
:last
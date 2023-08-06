
@ECHO OFF

REM Decode ESP exception after crash
ECHO %%USERPROFILE%% is:  %USERPROFILE%

REM set espTarget to one of: esp32 esp32s2 esp32s3
SET espTarget=esp32
ECHO espTarget set as:  %espTarget%

REM set elfTarget same as espTarget, except some boards may be different, eg ESP32 Pico D4 is pico32 instead of esp32
SET elfTarget=esp32
ECHO elfTarget set as:  %elfTarget%

REM gdb path
REM SET gdbPath=xtensa-%espTarget%-elf-gcc/esp-2021r2-patch5-8.4.0
SET gdbPath=xtensa-esp-elf-gdb/11.2_20220823
ECHO gdbPath set as:  %gdbPath%

REM get sketch name from sketch folder
FOR %%I IN ("%~dp0..") DO SET appname=%%~nxI
ECHO Sketch name is:  %appname%

SET addresses=%USERPROFILE%\Downloads\EspCrashDecoder.txt
SET decoded=%USERPROFILE%\Downloads\EspCrashDecoder.out
DEL %addresses% 2>nul 
DEL %decoded% 2>nul 

REM start browser based UI
START "" "EspCrashDecoder.htm"
ECHO Download directory is:  %USERPROFILE%\Downloads\ 

REM wait for user to create addresses file from UI
ECHO Waiting for user to generate addresses file ...
:CheckForFile
IF EXIST %addresses% GOTO FoundFile
TIMEOUT /T 1 >nul
GOTO CheckForFile

:FoundFile
REM use gdb to reference addresses to source code and output to file
SET HOME=%USERPROFILE%
%USERPROFILE%/AppData/Local/Arduino15/packages/esp32/tools/%gdbPath%/bin/xtensa-%espTarget%-elf-gdb.exe ../build/esp32.esp32.%elfTarget%/%appname%.ino.elf --batch --command=%addresses% > %decoded% 2>err.txt
ECHO Finished

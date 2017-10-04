@echo off

echo ipScan (C)2017 v.02 Anthony Burridge
if %1.==. (
    echo USAGE : ipscan.bat ipsubnet filename.txt
) else (
    call:srange %1 %2
)
goto:eof

:srange
if %2.==. (
    echo USAGE : ipscan.bat ipsubnet filename.txt
    echo Please specify a filename
    goto:eof
) 

set "ip=%1"
SET "offsets=0.0.0.-24"

for /f "tokens=1-4 delims=. " %%a in ("%ip%") do (
set octetA=%%a
set octetB=%%b
set octetC=%%c
set octetD=%%d
)
FOR /f "tokens=1-4 delims=." %%a in ("%offsets%") do (
SET /a octetA+=%%a
SET /a octetB+=%%b
SET /a octetC+=%%c
SET /a octetD+=%%d
)

set iprange=%octetA%.%octetB%.%octetC%
set ipout=%iprange%.0/24
echo Scanning %ipout%

set iprange=%iprange%.%%i
echo This will take some time...
echo ipScan results - %ipout%>%2
FOR /L %%i IN (1,1,254) DO (
ping -n 1 %iprange% | FIND /i "Reply">>%2
nslookup %iprange% | FIND /i "Name:">>%2
echo -->>%2)

echo Finished.
goto:eof

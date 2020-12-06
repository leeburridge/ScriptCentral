@echo off setlocal

echo: echo Setting OEMID in RegEdit... 
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Store" /v OEMID /f /t REG_SZ /d DELL echo:

echo Setting SCMID... 
echo Fetching System Model Name
for /f "tokens=2 delims==" %%a in ('wmic computersystem get model /format:list') do set SYSMODEL=%%a 

set SYSMODEL=%SYSMODEL: =%
echo System Model Name is "%SYSMODEL%"

if not "x%SYSMODEL:Alienware=%" == "x%SYSMODEL%" goto modelAlienware 

if not "x%SYSMODEL:Vostro=%" == "x%SYSMODEL%" goto modelVostro 

if not "x%SYSMODEL:XPS=%" == "x%SYSMODEL%" goto modelXPS

if not "x%SYSMODEL:Inspiron=%" == "x%SYSMODEL%"goto modelInspiron

:modelAlienware 
echo System model contains the name Alienware 
set SYSNAME=Alienware
goto modelFinish 

:modelVostro 
echo System model contains the name Vostro 
set SYSNAME=Vostro
goto modelFinish 

:modelXPS 
echo System model contains the name Xps 
set SYSNAME=Xps 
goto modelFinish 

:modelInspiron 
echo System model contains the name Inspiron 
set SYSNAME=Inspiron 
goto modelFinish 

:modelFinish 
echo System Name is %SYSNAME%

set SCMID=DELL_%SYSNAME%
echo SCMID to be set is %SCMID%

echo Setting SCMID in RegEdit 
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Store" /v StoreContentModifier /f /t REG_SZ /d %SCMID%

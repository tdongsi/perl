@echo off
setlocal
 
REM Location of 7z.exe
set exe=C:\Program Files\7-Zip\7z.exe
 
REM Location of root folder
set root=IG3.1\Win64
 
for /F "tokens=* usebackq" %%G in (`dir "%root%" /A:D /B`) do (
"%exe%" a -tzip "%root%\%%G.zip" "%root%\%%G" -mx1 > NUL
if exist "%root%\%%G.zip" echo rd /s /q "%root%\%%G"
)
 
endlocal
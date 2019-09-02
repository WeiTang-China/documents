@echo off
pushd %~p0 & for %%i in (.) do set curDirName=%%~ni
where 7z.exe 2>nul
if %errorlevel% NEQ 0 (
	echo 7z.exe NOT found!
	goto safety_exit
)
7z.exe a ..\%curDirName%.7z %~p0
if %errorlevel% NEQ 0 (
	echo 7z.exe exec FAILED! errorlevel=%errorlevel%
	goto safety_exit
)
adb push ..\%curDirName%.7z /sdcard/tangwei/
del ..\%curDirName%.7z

:safety_exit
pause

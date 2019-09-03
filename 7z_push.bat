@echo off

if "%1"=="" goto useBatFileDir

SET a1=%~a1
REM ECHO %a1:~0,1%
if "%a1:~0,1%"=="d" (
	pushd %1 & for %%i in (.) do (
		echo %%i
		set dirName=%%~ni
	)
	set dirPath=%~dp1
	goto start7z
) else (
	echo it's a file! do nothing!!!
	goto safety_exit
)


goto safety_exit

:useBatFileDir
pushd %~p0 & for %%i in (.) do (
	echo %%i
	set dirName=%%~ni
)
set dirPath=%~dp0..\

:start7z
ECHO dirPath=%dirPath%
ECHO dirName=%dirName%
where 7z.exe 2>nul
if %errorlevel% NEQ 0 (
	echo 7z.exe NOT found!
	goto safety_exit
)
7z.exe a %dirPath%%dirName%.7z %dirPath%%dirName%
if %errorlevel% NEQ 0 (
	echo 7z.exe exec FAILED! errorlevel=%errorlevel%
	goto safety_exit
)
adb push %dirPath%%dirName%.7z /sdcard/tangwei/
del %dirPath%%dirName%.7z

:safety_exit
pause

::Program:
::	Get package name from /data/app/ list.
::Author:
::	Braden Liu, liupu126@126.com
::History:
::	2018/06/28	Braden Liu	1st Release
::		1. Create file.

:: Usage: get_package_from_data_app [data_app_list file]
@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
set app_dir=%1

set OLDDIR=%cd%
cd /d %app_dir%

echo Generate app list ...
for /r %%i in (*.apk) DO @echo %%~fi >> 01.txt
echo Installing app...
for /f "delims= " %%i in (01.txt) do (
	echo Installing %%i
    adb install -r %%i > 02.txt
)

del 02.txt
echo ------ Done ------

cd /d OLDDIR=%cd%
pause
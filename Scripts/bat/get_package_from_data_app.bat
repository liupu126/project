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
set data_app_list=%1
set null=

:: if not set data_app_list in cmd, try to get from device
set list=
if "%data_app_list%" == "%null%" (
	set list=temp_data_app_list.txt
	del %list%
	adb wait-for-device
	echo Get data app list ...
	adb shell ls /data/app/ > temp_data_app_list.txt
) else (
	set list=%data_app_list%
)

set list_pkg=temp_package_list.txt
del %list_pkg%

echo Generate package list ...
for /f "tokens=1,2 delims=-" %%j in (%list%) do (
	echo %%j
	echo "%%j",>>%list_pkg%
)

::del %list%
::del %list_pkg%

echo ------ Done ------
pause
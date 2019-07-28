::Program:
::	Get dmesg log and open log file.
::Author:
::	Braden Liu, liupu126@126.com
::History:
::	2017/11/15	Braden Liu	1st Release
::		1. Create file.

@echo off
set op1=%1
set null=

set OLDDIR=%cd%

:: for naming log files
set /a hh=%time:~0,2%
if %hh% LSS 10 set hh=0%hh%
set log_suffix=%date:~0,4%%date:~5,2%%date:~8,2%%hh%%time:~3,2%%time:~6,2%

set TXT_EXE=E:\program\UltraEdit_v25.0.0.58_x64_zh_CN\UltraEdit\uedit64.exe
set dst_dir=H:\log\dmesg
set dst_file=%dst_dir%\dmesg_%log_suffix%

if not exist %dst_dir% mkdir %dst_dir%
cd /d %dst_dir%

adb wait-for-device

@if "%op1%" == "%null%" (
	adb shell dmesg > %dst_file%
	@echo %dst_file%
	start %TXT_EXE% %dst_file%
) else if "%op1%" == "-C" (
	adb shell dmesg -C
) else if "%op1%" == "-c" (
	adb shell dmesg -c
) else (
	echo Error: Invalid option!
)

cd /d %OLDDIR%

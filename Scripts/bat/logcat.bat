::Program:
::	Get logcat log and open log file.
::Author:
::	Braden Liu, liupu126@126.com
::History:
::	2017/11/15	Braden Liu	1st Release
::		1. Create file.

:: Usage: logcat [option]
::	logcat
::	logcat -d
::	logcat -c
@echo off

set op1=%1
set op2=%2
set op_last=%op2%
set null=

set OLDDIR=%cd%

:: for naming log files
set /a hh=%time:~0,2%
if %hh% LSS 10 set hh=0%hh%
set log_suffix=%date:~0,4%%date:~5,2%%date:~8,2%%hh%%time:~3,2%%time:~6,2%

@set txt_exe0=E:\program\Notepad++\notepad++.exe
@set txt_exe1=E:\program\UltraEdit_v25.0.0.58_x64_zh_CN\UltraEdit\uedit64.exe
@set txt_exe2=D:\Programs\UltraEdit\uedit64.exe
if "%op_last%" == "np" (
	set TXT_EXE=%txt_exe0%
	::set dst_dir=H:\log\logcat
	set dst_dir=N:\work\log\logcat
) else if exist %txt_exe1% (
	set TXT_EXE=%txt_exe1%
	::set dst_dir=H:\log\logcat
	set dst_dir=N:\work\log\logcat
) else (
	set TXT_EXE=%txt_exe2%
	set dst_dir=E:\Workspace\oneplus\logcat
)
set dst_file=%dst_dir%\logcat_%log_suffix%

if not exist %dst_dir% mkdir %dst_dir%

adb wait-for-device

@if "%op1%" == "%null%" (
	adb shell logcat
) else if "%op1%" == "a" (
	adb shell logcat -d -b all > %dst_file%.all
	start %TXT_EXE% %dst_file%.all
	echo %dst_file%.all
) else if "%op1%" == "c" (
	adb shell logcat -d -b crash > %dst_file%.crash
	start %TXT_EXE% %dst_file%.crash
	echo %dst_file%.crash
) else if "%op1%" == "e" (
	adb shell logcat -d -b events > %dst_file%.events
	start %TXT_EXE% %dst_file%.events
	echo %dst_file%.events
) else if "%op1%" == "s" (
	adb shell logcat -d -b system > %dst_file%.system
	start %TXT_EXE% %dst_file%.system
	echo %dst_file%.system
) else if "%op1%" == "m" (
	adb shell logcat -d -b main > %dst_file%.main
	start %TXT_EXE% %dst_file%.main
	echo %dst_file%.main
) else if "%op1%" == "r" (
	adb shell logcat -d -b radio > %dst_file%.radio
	start %TXT_EXE% %dst_file%.radio
	echo %dst_file%.radio
) else if "%op1%" == "d" (
	adb shell logcat -d > %dst_file%.default
	start %TXT_EXE% %dst_file%.default
	echo %dst_file%.default
) else if "%op1%" == "-c" (
	adb shell logcat -c
) else (
	::echo Error: Invalid option!
	adb shell logcat %1 %2 %3 %4 %5 %6 %7 %8 %9
)

::Program:
::	Get logs for common cases.
::Author:
::	Braden Liu, liupu126@126.com
::History:
::	2017/09/06	Braden Liu	1st Release
::		1. Add commands to get logs with command logcat.
set OLDDIR=%cd%

set logdir=d:\log_my
set lograr=d:\lograr_my

:: for naming log files by logcat
set /a hh=%time:~0,2%
if %hh% LSS 10 set hh=0%hh%
set logcat_prefix=%date:~0,4%%date:~5,2%%date:~8,2%%hh%%time:~3,2%%time:~6,2%
set logcat_suffix=txt

@echo 创建文件夹，清除旧日志
rmdir /s/q %logdir%
mkdir %logdir%
mkdir %lograr%
cd /d %logdir%

adb wait-for-devices

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
adb shell dmesg > kmsg.txt

:: get log by logcat
@if not exist logcat mkdir logcat 
adb shell logcat -d -b main > logcat/%logcat_prefix%.main.%logcat_suffix%
adb shell logcat -d -b system > logcat/%logcat_prefix%.system.%logcat_suffix%
adb shell logcat -d -b radio > logcat/%logcat_prefix%.radio.%logcat_suffix%
adb shell logcat -d -b events > logcat/%logcat_prefix%.events.%logcat_suffix%
adb shell logcat -d -b crash > logcat/%logcat_prefix%.crash.%logcat_suffix%
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: compress logs
:: may need change path "C:\Program Files (x86)\WinRAR\rar.exe"
copy /y "C:\Program Files (x86)\WinRAR\rar.exe" c:\windows\system32\
rar a -r -ed -ag-MMDD-HHMMSS %lograr%\log.zip %logdir%\
@echo Getting Completed.提取完成!

:: explorer %lograr%
explorer %logdir%

cd /d %OLDDIR%
pause

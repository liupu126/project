::@echo off
set param_time=%1

set OLDDIR=%cd%
set TARGET_DIR=%userprofile%\AppData\Local\Android\Sdk\platform-tools\systrace

:: set str_time
set /a hh=%time:~0,2%
if %hh% LSS 10 set hh=0%hh%
set str_time=%date:~0,4%%date:~5,2%%date:~8,2%%hh%%time:~3,2%%time:~6,2%
:: set device
for /F %%i in ('adb shell getprop ro.product.device') do ( set device=%%i)
:: set type
for /F %%i in ('adb shell getprop ro.build.type') do ( set type=%%i)
:: set serialno
for /F %%i in ('adb shell getprop ro.serialno') do ( set serialno=%%i)
:: set target_time
set null=
if "%param_time%" == "%null%" (
	set target_time=10
) else (
	set target_time=%param_time%
)

:: set filename
set filename=systrace_%str_time%_%device%_%type%_%serialno%_%target_time%s

cd /d %TARGET_DIR%
python systrace.py --time=%target_time% --buf-size=20480 gfx input view wm am sm video camera hal app res dalvik rs bionic binder_driver power sched freq idle irq mmc load sync workq memreclaim regulators -o %filename%.html
cd /d %OLDDIR%

start explorer %TARGET_DIR%

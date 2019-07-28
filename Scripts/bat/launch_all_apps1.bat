@echo off
:: 1. connect Wifi
:: 2. launch_all_apps1: start delay to 5s, execute bat, allow permissions
:: 3. launch_all_apps2: start delay to 30s, not stop application, then reboot and re-execute bat
SETLOCAL ENABLEDELAYEDEXPANSION
set list=temp_activity_list.txt
set list_app=temp_application_list.txt
set log=temp.txt
del %list%
del %list_app%
del %log%

adb wait-for-device
adb root
adb remount
adb wait-for-device
:: start activity, then stop the application
adb shell cmd package query-activities --components -a android.intent.action.MAIN -c android.intent.category.LAUNCHER > %list%
for /f "delims= " %%i in (%list%) do (
	:: start activity
	echo start activity: %%i
    adb shell am start -n %%i >> %log%
	ping 127.0.0.1 -n 12 > nul
	:: stop the application
	for /f "tokens=1,2 delims=/" %%j in ("%%i") do adb shell am force-stop --user current %%j & echo stop application: %%j
	ping 127.0.0.1 -n 3 > nul
)

::del %list%
::del %list_app%
del %log%

pause
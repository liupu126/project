::Program:
::	List apks
::Author:
::	Braden Liu, liupu126@126.com
::History:
::	2018/11/22	Braden Liu	1st Release
::		1. Create file.

:: Usage: apklist

echo off
set list_temp=list_temp.txt
set list_out=list_out.txt
del %list_temp%
del %list_out%

adb shell "pm list packages | cut -c 9-" > %list_temp%

for /f "delims= " %%i in (%list_temp%) do (
	adb shell pm path %%i >> %list_out%
)

:: then: ./list_filename.sh list_out.txt
echo ------ Done ------

pause
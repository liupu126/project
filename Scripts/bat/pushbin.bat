::Program:
::	Push bin file to /system|vendor/bin .
::Author:
::	Braden Liu, liupu126@126.com
::History:
::	2017/11/08	Braden Liu	1st Release
::		1. Create file.

:: Usage: pushbin <image_dir> <module name>
::        pushbin N:\18831\SM8150\android\out\target\product\guacamolet vold
set image_dir=%1
set module_name=%2

set sys_src_dir=%image_dir%\system\bin
set sys_src_file=%sys_src_dir%\%module_name%
set sys_dst_dir=/system/bin
set sys_dst_file=%sys_dst_dir%/%module_name%

set vnd_src_dir=%image_dir%\vendor\bin
set vnd_src_file=%vnd_src_dir%\%module_name%
set vnd_dst_dir=/vendor/bin
set vnd_dst_file=%vnd_dst_dir%/%module_name%

adb wait-for-device
adb remount

set /a flag=0

@if exist %sys_src_file% (
	echo Push: %sys_src_file% to %sys_dst_file%
	adb push %sys_src_file% %sys_dst_file% || call :PUSH_FAILED
	adb shell chmod 777 %sys_dst_file%
	adb shell chown root:root %sys_dst_file%
	adb shell ls -lZ %sys_dst_file%
	set /a flag=1
) else (
	echo Info: %sys_src_file% not exist!
)

@if exist %vnd_src_file% (
	echo Push: %vnd_src_file% to %vnd_dst_file%
	adb push %vnd_src_file% %vnd_dst_file% || call :PUSH_FAILED
	adb shell chmod 777 %vnd_dst_file%
	adb shell chown root:root %vnd_dst_file%
	adb shell ls -lZ %vnd_dst_file%
	set /a flag=1
) else (
	echo Info: %vnd_src_file% not exist!
)

@if "%flag%" == "1" (
	echo Info: push succeed!
) else (
	echo Error: push failed!
)
@goto end

:PUSH_FAILED
    echo Push failed, please check!
    @goto end

:end
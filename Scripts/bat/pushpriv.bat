::Program:
::	Push apk and related odex file to /system/priv-app .
::Author:
::	Braden Liu, liupu126@126.com
::History:
::	2018/02/02	Braden Liu	1st Release
::		1. Create file.

:: Usage: pushpriv <image_dir> <module name> [arch]
::	pushpriv N:\18831\SM8150\android\out\target\product\guacamolet Settings [32]

:: abosolute path of image dir
set image_dir=%1
set module_name=%2
set arch_tmp=%3
set null=

@if "32" == "%arch_tmp%" (
	set arch=%null%
) else (
	set arch=64
)

set src_dir=%image_dir%\system\priv-app\%module_name%
set src_file=%src_dir%\%module_name%.apk
set src_odex_file=%src_dir%\oat\arm%arch%\%module_name%.odex
set src_vdex_file=%src_dir%\oat\arm%arch%\%module_name%.vdex

set dst_dir=/system/priv-app/%module_name%
set dst_file=%dst_dir%/%module_name%.apk
set dst_odex_file=%dst_dir%/oat/arm%arch%/%module_name%.odex
set dst_vdex_file=%dst_dir%/oat/arm%arch%/%module_name%.vdex

adb wait-for-device
adb remount

@if exist %src_file% (
	echo Push: %src_file% to %dst_file%
	adb push %src_file% %dst_file% || call :PUSH_FAILED
	adb shell chmod 777 %dst_file%
	adb shell chown root:root %dst_file%
	adb shell ls -lZ %dst_file%
) else (
	echo Error: %src_file% not exist!
	goto end
)

@if exist %src_odex_file% (
	echo Push: %src_odex_file% to %dst_odex_file%
	adb push %src_odex_file% %dst_odex_file%  || call :PUSH_FAILED
	adb shell chmod 777 %dst_odex_file%
	adb shell chown root:root %dst_odex_file%
	adb shell ls -lZ %dst_odex_file%
) else (
	echo Info: %src_odex_file% not exist!
)
@if exist %src_vdex_file% (
	echo Push: %src_vdex_file% to %dst_vdex_file%
	adb push %src_vdex_file% %dst_vdex_file%  || call :PUSH_FAILED
	adb shell chmod 777 %dst_vdex_file%
	adb shell chown root:root %dst_vdex_file%
	adb shell ls -lZ %dst_vdex_file%
) else (
	echo Info: %src_vdex_file% not exist!
)
@goto end

:PUSH_FAILED
    echo Push failed, please check!
    @goto end

:end
::Program:
::	Install apk.
::Author:
::	Braden Liu, liupu126@126.com
::History:
::	2017/12/25	Braden Liu	1st Release
::		1. Create file.
::	2017/12/28	Braden Liu	1st Release
::		2. Support install system/vendor/data apk.

:: Usage: install 3701A alchemy ApkName
::	install 3701A alchemy FactoryTest [-r|...]
set project=%1
set project_alias=%2
set module_name=%3
:: other install options
set p1=%4

set project_dir=Z:\work

set sys_src_dir=%project_dir%\%project%\out\target\product\%project_alias%\system\app\%module_name%
set sys_src_file=%sys_src_dir%\%module_name%.apk

set vnd_src_dir=%project_dir%\%project%\out\target\product\%project_alias%\vendor\app\%module_name%
set vnd_src_file=%vnd_src_dir%\%module_name%.apk

set dat_src_dir=%project_dir%\%project%\out\target\product\%project_alias%\data\app\%module_name%
set dat_src_file=%dat_src_dir%\%module_name%.apk

adb wait-for-device

set /a flag=0

@if exist %sys_src_file% (
	echo Install: %sys_src_file%
	adb install %p1% %sys_src_file%
	set /a flag=1
) else (
	echo Info: %sys_src_file% not exist!
)

@if exist %vnd_src_file% (
	echo Install: %vnd_src_file%
	adb install %p1% %vnd_src_file%
	set /a flag=1
) else (
	echo Info: %vnd_src_file% not exist!
)

@if exist %dat_src_file% (
	echo Install: %dat_src_file%
	adb install %p1% %dat_src_file%
	set /a flag=1
) else (
	echo Info: %dat_src_file% not exist!
)

@if "%flag%" == "1" (
	echo Info: install succeed!
) else (
	echo Error: install failed!
)
@goto end

:end

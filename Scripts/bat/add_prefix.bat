::Program:
::	Add prefix to each line in provided text file.
::Author:
::	Braden Liu, liupu126@126.com
::History:
::	2018/07/03	Braden Liu	1st Release
::		1. Create file.
::	2018/09/11	Braden Liu	2nd Release
::		1. Add default prefix & input file.

:: Usage: add_coolpad_prefix <prefix> [test file]
::        add_coolpad_prefix
::        add_coolpad_prefix Coolpad_ sn.txt 

@echo off

set arg1=%1
set arg2=%2

set null=
@if "%arg1%" == "%null%" (
	set prefix=Coolpad_
	set in_file=sn.txt
) else (
	set prefix=%arg1%
	set in_file=%arg2%
)

set out_file=SN_OUT.txt
del %out_file%.tmp
echo Adding prefix...
for /f "delims= " %%i in (%in_file%) do (
	echo %%i - %prefix%%%i
	echo %prefix%%%i>> %out_file%.tmp
)

copy %out_file%.tmp %out_file%
del %out_file%.tmp
echo ------ Done ------

pause
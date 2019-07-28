::Program:
::	Delay n seconds.
::Author:
::	Braden Liu
::History:
::	2018/09/26	Braden Liu	1st Release
::		1. create file.

:: Usage: delay <N seconds>
::        delay	10
@echo off
set op1=%1
set null=

if "%op1%" == "%null%" (
	set /a delay=10
) else (
	set /a delay=%op1%
)

set /a num=%delay%
:loop
set /a num=num-1
:: delay
ping 127.0.0.1 -n 2 > nul
echo %num%
if "%num%"=="0" (
	goto end
)
goto loop

:end

::Program:
::	Run reboot tests of Android device.
::Author:
::	Mark Yue
::History:
::	2017/11/30	Mark Yue	1st Release
::		1. create file.
::	2017/11/30	Braden Liu	2nd Release
::		1. allow to set Max times.

:: Usage: run-rb <max-times> [time]
::        run-rb 10          [60]
::@echo off
set cmd=%0
set sum=%1
set interval=%2
set null=

if "%sum%" == "%null%" (
	call :USAGE
	goto end
)

if "%interval%" == "%null%" (
	set /a delay=0
) else (
	set /a delay=%interval%
)

set /a num=0
:loop
set /a num+=1
adb wait-for-device
:: delay
ping 127.0.0.1 -n %delay% > nul
:: reboot
adb reboot
echo num=%num%
if "%num%"=="%sum%" (
	echo delay=%delay%
	echo sum=%sum%
	goto end
)
goto loop

:: Usage
:USAGE
	echo Usage: %cmd% max-times [time]
	echo        %cmd% 10        [60]

:end

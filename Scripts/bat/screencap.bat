:: Open text file by Notepad++
@echo off
set op1=%1
set null=
if "%op1%" == "%null%" (
	set dst_file=screencap
) else (
	set dst_file=%op1%
)

adb shell screencap -p /sdcard/%dst_file%.png
adb pull /sdcard/%dst_file%.png .

set TXT_EXE=%windir%\system32\mspaint.exe
start %TXT_EXE% %dst_file%
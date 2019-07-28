@echo off

:: This script is use WIFI connect smartphone adb shell
:: How use:
:: 1,open the smartphone wifi and connect to WLAN
:: 2,connect the smartphone to computer via USB line
:: 3,run this script
:: 4,pull out USB line
:: 5,now you can adb shell log on the smartpone via wifi

for /f "tokens=3 delims=: " %%a in ('adb shell ifconfig^|findstr "inet addr:"') do (
 set IP=%%a
 goto next
)

:next

echo "The smartphone IP address is %IP%"

adb shell "setprop persist.adb.tcp.port 5555"

adb tcpip 5555

adb connect %IP%

echo "Connect smartphone %IP%"

pause
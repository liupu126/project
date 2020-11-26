adb root
adb remount

adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\oneplus-services.jar /system/framework/

adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\oat\arm64\oneplus-services.odex /system/framework/arm64/
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\oat\arm64\oneplus-services.vdex /system/framework/arm64/

adb shell sync
pause
adb reboot

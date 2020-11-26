adb root
adb remount

adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\framework.jar /system/framework/
::adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\boot-framework.vdex /system/framework/

adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm\boot-framework.vdex /system/framework/arm/
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm\boot-framework.art /system/framework/arm/
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm\boot-framework.oat /system/framework/arm/

adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm64\boot-framework.vdex /system/framework/arm64/
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm64\boot-framework.art /system/framework/arm64/
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm64\boot-framework.oat /system/framework/arm64/

adb shell sync
pause
adb reboot

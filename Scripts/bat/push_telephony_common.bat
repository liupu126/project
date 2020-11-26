adb root
adb remount

adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\telephony-common.jar /system/framework/
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\boot-telephony-common.vdex /system/framework/

adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm\boot-telephony-common.vdex /system/framework/arm/
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm\boot-telephony-common.art /system/framework/arm/
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm\boot-telephony-common.oat /system/framework/arm/

adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm64\boot-telephony-common.vdex /system/framework/arm64/
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm64\boot-telephony-common.art /system/framework/arm64/
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm64\boot-telephony-common.oat /system/framework/arm64/

adb shell sync
pause
adb reboot

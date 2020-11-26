adb root
adb remount

adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\oneplus-framework.jar /system/framework/
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\boot-oneplus-framework.vdex /system/framework/

adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm\boot-oneplus-framework.vdex /system/framework/arm/
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm\boot-oneplus-framework.art /system/framework/arm/
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm\boot-oneplus-framework.oat /system/framework/arm/

adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm64\boot-oneplus-framework.vdex /system/framework/arm64/
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm64\boot-oneplus-framework.art /system/framework/arm64/
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\arm64\boot-oneplus-framework.oat /system/framework/arm64/

adb shell sync
pause
adb reboot

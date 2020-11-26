adb root
adb remount

adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\services.jar /system/framework/services.jar
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\services.jar.bprof /system/framework/services.jar.bprof
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\services.jar.prof /system/framework/services.jar.prof
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\oat\arm64\services.art /system/framework/oat/arm64/services.art
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\oat\arm64\services.odex /system/framework/oat/arm64/services.odex
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\framework\oat\arm64\services.vdex /system/framework/oat/arm64/services.vdex


adb shell sync

pause
adb reboot
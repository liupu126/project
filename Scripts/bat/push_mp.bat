adb root
adb remount
adb shell rm -rf /system/apex/com.google.android.mediaprovider.apex

adb push Z:\work\r8250debug\android\out\target\product\qssi\system\apex\com.android.mediaprovider.apex /system/apex/

adb push Z:\work\r8250debug\android\out\target\product\qssi\system\lib\libfuse_jni.so /system/lib/libfuse_jni.so
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\lib64\libfuse_jni.so /system/lib64/libfuse_jni.so

adb push Z:\work\r8250debug\android\out\target\product\qssi\system\lib\libfuse.so /system/lib/libfuse.so
adb push Z:\work\r8250debug\android\out\target\product\qssi\system\lib64\libfuse.so /system/lib64/libfuse.so

adb push Z:\work\r8250debug\android\out\target\product\qssi\system\bin\vold /system/bin/vold

adb shell sync

adb shell setprop persist.sys.fuse.log true
adb shell setprop persist.log.tag.FuseDaemon V

pause
adb reboot
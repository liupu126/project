::
@adb wait-for-device
::adb shell setprop sys.verity 1
adb disable-verity
adb reboot
::
@adb wait-for-device
adb remount
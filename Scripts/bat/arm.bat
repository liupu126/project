::
@adb wait-for-device
adb shell setprop sys.verity 1
adb disable-verity
adb reboot
::
@adb wait-for-device
adb remount
::
adb shell rm -rf /system/priv-app/SetupWizard
adb reboot
@adb wait-for-device
adb remount
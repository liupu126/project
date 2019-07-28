::
adb reboot bootloader
fastboot ops 4F50040TR18FTR7FSTD5F01
fastboot ops disable_dm_verity
fastboot reboot
adb wait-for-device && adb remount
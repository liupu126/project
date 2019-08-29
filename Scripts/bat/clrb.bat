::bg5670
::adb reboot bootloader || fastboot reboot bootloader

fastboot ops 4F50040TR18FTR7FSTD5F01
::clear rollback index
fastboot ops 4F50040TR18FTR7FSTD5F02
fastboot set_active a
adb wait-for-device
:: ping 127.0.0.1 -n 200 > nul


@set ota_package=F:\local_sw\20854_R\ota_new_partition_layout\DailyBuildDEVELOPReleaseOXYGEN_NAMSM_20854_201028_1819_user\OTA\OnePlus9TMOOxygen_23.O.01_OTA_0000_all_2010281851_fa7cf34dac3d47d6.zip
@set opbackup=C:\Users\602527\Desktop\OPBackup_2.3.0.2.200911173208.5dce0c7.apk

adb push %ota_package% /sdcard/
adb install %opbackup%
adb shell am start -a oneplus.intent.action.CheckUpdate
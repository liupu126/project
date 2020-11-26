adb wait-for-device
:: ping 127.0.0.1 -n 200 > nul


@set ota_package=F:\local_sw\20854_R\ota\DailyBuildDEVELOPReleaseOXYGEN_NAMSM_20854_201021_0949_user\OTA\OnePlus9TMOOxygen_23.O.01_OTA_0000_all_2010211021_3a6a076d2d8b4a00.zip
@set opbackup=C:\Users\602527\Desktop\OPBackup_2.3.0.2.200911173208.5dce0c7.apk

adb push %ota_package% /sdcard/
adb install %opbackup%
adb shell am start -a oneplus.intent.action.CheckUpdate
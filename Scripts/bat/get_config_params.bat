@set CONFIG_FILE=config_params.cfg
@del %CONFIG_FILE%
adb wait-for-device
adb shell dumpsys engineer --get_config_params
adb pull /sdcard/%CONFIG_FILE% .
@adb shell rm /sdcard/%CONFIG_FILE%
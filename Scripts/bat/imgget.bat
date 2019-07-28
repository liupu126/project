set imgblk=%1
set imgname=%2
set bs=%3
set count=%4

adb wait-for-device
adb shell dd if=%imgblk% of=/sdcard/temp.img bs=%bs% count=%count%
adb pull /sdcard/temp.img %imgname%

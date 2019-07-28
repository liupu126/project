set directory=%1
set project=%2

::pull	H:\local_sw\system_vendor_size\pull	18825

set dir_project=%directory%\%project%
set dir_system=%dir_project%\system\
set dir_vendor=%dir_project%\vendor\

mkdir %dir_project%
mkdir %dir_system%
mkdir %dir_vendor%

adb pull /system/app %dir_system%
adb pull /system/priv-app %dir_system%
adb pull /system/lib %dir_system%
adb pull /system/lib64 %dir_system%
adb pull /system/framework %dir_system%
adb pull /system/fonts %dir_system%
adb pull /system/reserve %dir_system%

::adb pull /vendor/app %dir_vendor%
adb pull /vendor/lib %dir_vendor%
adb pull /vendor/lib64 %dir_vendor%
adb pull /vendor/etc %dir_vendor%
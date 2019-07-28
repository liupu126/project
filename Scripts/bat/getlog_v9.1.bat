@ REM ***************************************************************************
@ REM **        取手机及PC时间，并以PC时间命名文件夹保存信息及截图             **
@ REM ***************************************************************************
@ REM FOR /F "tokens=1-3 delims=- " %%i IN ("%date:~0,10%") DO SET d=%%i%%j%%k
@ REM FOR /F "tokens=1-3 delims=: " %%i IN ("%time:~0,8%")  DO SET t=%%i%%j%%k
@ REM SET log_dir=%d%_%t%
@ REM mkdir %log_dir%
@ REM cd %log_dir%
@rem explorer .
set OLDDIR=%cd%

set logdir=d:\log

@echo 创建文件夹，清除旧日志
rmdir /s/q %logdir%
mkdir %logdir%
mkdir d:\lograr
cd /d %logdir%

explorer .

@rem adb remount
@ REM ***************************************************************************
@ REM **～～分割线～分割线～分割线～分割线～分割线～分割线～分割线～分割线～～**
@ REM ***************************************************************************

@Echo Dumping kernel memory leaking log, available this moment
adb wait-for-devices

adb shell mount -t debugfs nodev /sys/kernel/debug/

echo. >>.\exp.log
echo ===异常时间：>>.\exp.log
adb shell date > exp.log
adb shell uptime >>.\exp.log
adb shell cat /proc/cmdline >>.\exp.log

echo. >>.\exp.log
echo ===挂载信息：>>.\exp.log
adb shell cat /proc/mounts >>.\exp.log
echo. >>.\exp.log
adb shell df >>.\exp.log
adb shell cat /proc/partitions >>.\exp.log

echo. >>.\exp.log
echo ===mmc0：>>.\exp.log
adb shell cat /d/mmc0/* >>.\exp.log
adb shell cat /d/mmc0/*/ext_csd >>.\exp.log
adb shell ls  /sys/devices/*/mmc_host/mmc0/mmc*/  >>.\exp.log
adb shell cat /sys/devices/*/mmc_host/mmc0/mmc*/*  >>.\exp.log
adb shell "cat /sys/class/mmc_host/mmc0/mmc0:0001/cid | cut -c 1-2" >>.\exp.log
adb shell "cat /sys/class/mmc_host/mmc0/mmc0:0001/cid | cut -c 7-18" >>.\exp.log
adb shell "cat /sys/kernel/debug/mmc0/mmc0:0001/ext_csd | cut -c 509-510" >>.\exp.log
echo ===mmc1：>>.\exp.log
adb shell cat /d/mmc1/* >>.\exp.log
adb shell cat /d/mmc1/*/ext_csd >>.\exp.log
adb shell ls  /sys/devices/*/mmc_host/mmc1/mmc*/  >>.\exp.log
adb shell cat /sys/devices/*/mmc_host/mmc1/mmc*/*  >>.\exp.log
echo ===mmc2：>>.\exp.log
adb shell cat /d/mmc2/* >>.\exp.log
adb shell cat /d/mmc2/*/ext_csd >>.\exp.log
adb shell ls  /sys/devices/*/mmc_host/mmc2/mmc*/  >>.\exp.log
adb shell cat /sys/devices/*/mmc_host/mmc2/mmc*/*  >>.\exp.log

echo. >>.\exp.log
echo ===stat：>>.\exp.log
adb shell cat  /proc/stat  >>.\exp.log

echo. >>.\exp.log
echo ===cpuinfo：>>.\exp.log
adb shell cat /proc/cpuinfo >>.\exp.log

echo. >>.\exp.log
echo ===meminfo：>>.\exp.log
adb shell cat /proc/meminfo >>.\exp.log

echo. >>.\exp.log
echo ===device：>>.\exp.log
adb shell cat /proc/devices >>.\exp.log

echo. >>.\exp.log
echo ===modules：>>.\exp.log
adb shell cat /proc/modules >>.\exp.log

echo. >>.\exp.log
echo ===lcd brightness：>>.\exp.log
adb shell cat /sys/class/leds/lcd-backlight/brightness >>.\exp.log
adb shell cat /sys/class/leds/lcd-backlight/max_brightness >>.\exp.log

echo. >>.\exp.log
echo ===gpio：>>.\exp.log
adb shell cat /d/gpio >>.\exp.log

echo. >>.\exp.log
echo ===中断：>>.\exp.log
adb shell cat  /proc/interrupts >>.\exp.log

echo. >>.\exp.log
echo ===TOP信息：>>.\exp.log
adb shell top -n 3 -m 10 >>.\exp.log


adb shell ps -t > ps.txt

adb shell cat /proc/*/stack > stack.txt

adb shell getprop  > property.txt

adb shell logcat -b all -v threadtime -d > logcat.txt

adb shell dumpsys meminfo > dumpsys.meminfo

adb shell cat /proc/meminfo > proc.meminfo

adb shell vmstat 1 5 > vmstat.txt

@echo =======备份重要数据=========
@if not exist backup mkdir backup
adb pull /data/system/packages.xml backup/packages.xml
adb pull /data/system/usagestats backup/usagestats
adb pull /data/system/users backup/users

adb shell cat /sys/kernel/debug/kmemleak > kmemleak.old.txt
@Rem Trigger an intermediate memory scan, and gather the result before quiting:
adb shell "echo clear > /sys/kernel/debug/kmemleak"
adb shell "echo scan > /sys/kernel/debug/kmemleak"

@if not exist data mkdir data
adb pull /data/log/  data/
@if exist data\*.txt goto END_DATA
@if exist data\*.pcap goto END_DATA
@rd data
:END_DATA

@if not exist sdcard mkdir sdcard
adb pull /sdcard/log/ sdcard/
@if exist sdcard\*.txt goto END_SDCARD
@if exist sdcard\*.pcap goto END_SDCARD
@rd sdcard
:END_SDCARD

@if not exist external_sd mkdir external_sd
adb pull /sdcard/external_sd/log/ external_sd/
@if exist external_sd\*.txt goto END_EXTERNAL_SD
@if exist external_sd\*.pcap goto END_EXTERNAL_SD
@rd external_sd
:END_EXTERNAL_SD

@if not exist udisk mkdir udisk
adb pull /udisk/log/ udisk/
@if exist udisk\*.txt goto END_UDISK
@if exist udisk\*.pcap goto END_UDISK
@rd udisk
:END_UDISK

@if not exist dropbox mkdir dropbox
adb pull /data/system/dropbox dropbox/
@if exist dropbox\*.txt goto END_DROPBOX
@if exist dropbox\*.gz goto END_DROPBOX
@rd dropbox
:END_DROPBOX

@if not exist anr mkdir anr
adb pull /data/anr/  anr/
@if exist anr\*.txt goto END_ANR
@if exist anr\*.log goto END_ANR
@if exist anr\*.bugreport goto END_ANR
@rd anr
:END_ANR

@if not exist dontpanic mkdir dontpanic
adb pull /data/dontpanic/ dontpanic/
@if not exist dontpanic\apanic* rd dontpanic

@if not exist tombstones mkdir tombstones
adb pull /data/tombstones/  tombstones/
@if not exist tombstones\tombstone* goto TOMBSTONES_NOT_EXIST
adb shell ls -l /data/tombstones > tombstones/file_writing_times.txt
@goto END_TOMBSTONES
:TOMBSTONES_NOT_EXIST
rd tombstones 
:END_TOMBSTONES

@if not exist recovery mkdir recovery 
adb pull /cache/recovery recovery/
@if not exist recovery\* rd recovery

adb pull /persist/reboot_type.log .

@if not exist ramdump mkdir ramdump
adb pull /data/ramdump/ ramdump/
adb pull /storage/sdcard1/ramdump ramdump/
@if not exist ramdump\* rd ramdump

@if not exist fctd mkdir fctd
adb pull /data/fctd/  fctd/
@if not exist fctd\* rd fctd

adb pull /panic/ panic/
adb shell ls -l /panic > panic/file_writing_times.txt
adb pull /sys/fs/pstore/ pstore/

@if not exist brs mkdir brs 
adb pull /data/brs/ brs/
@if not exist brs\* rd brs

echo "setting database"
adb pull /data/data/com.android.providers.settings/databases/settings.db .

echo "dumpsys"
adb shell dumpsys > dumpsys.txt



@Echo Dumping kernel memory leaking log, hot and sizzling!
adb shell cat /sys/kernel/debug/kmemleak > kmemleak.new.txt

set DUMP_DIR=dump_memory
mkdir %DUMP_DIR%
cd /d %DUMP_DIR%

echo "dump memory layout"
adb shell cat /proc/meminfo        > proc_meminfo.txt
adb shell cat /d/memblock/memory   > memblock_memory.txt
adb shell cat /d/memblock/reserved > memblock_reserved.txt

echo "dump system memory"
@REM adb shell procrank              > procrank.txt
adb shell dumpsys meminfo            >dumpsys_meminfo.txt
adb shell dumpsys procstats          >dumpsys_procstats.txt
adb shell dumpsys procstats -a        >dumpsys_procstats_a.txt
adb shell dumpsys SurfaceFlinger      >dumpsys_SurfaceFlinger.txt
adb shell dumpsys gfxinfo             >dumpsys_gfxinfo.txt

echo "dump ion"
adb shell ls  /d/ion/heaps/*       > ion_heaps_dir.txt
adb shell cat /d/ion/heaps/*       > ion_heaps_txt

echo "dump ion for qc8974ab"
adb shell cat /d/ion/heaps/adsp    > ion_heaps_adsp.txt
adb shell cat /d/ion/heaps/audio   > ion_heaps_audio.txt
adb shell cat /d/ion/heaps/kmalloc > ion_heaps_kmalloc.txt
adb shell cat /d/ion/heaps/mm      > ion_heaps_mm.txt
adb shell cat /d/ion/heaps/pil_1   > ion_heaps_pil_1.txt
adb shell cat /d/ion/heaps/pil_2   > ion_heaps_pil_2.txt
adb shell cat /d/ion/heaps/qsecom  > ion_heaps_qsecom.txt
adb shell cat /d/ion/heaps/system  > ion_heaps_system.txt


@REM  oom
echo "dump lowmemorykiller"
adb shell ls /sys/module/lowmemorykiller/parameters/*   > lowmemorykiller_parameters_dir.txt
adb shell cat /sys/module/lowmemorykiller/parameters/*  > lowmemorykiller_parameters_txt

echo "dump ps"
adb shell ps -p -P -t           > ps.thread.txt
adb shell ps                    > ps.txt


adb shell dmesg > kmsg.txt
@rem adb shell cat /sys/module/yl_debug/parameters/dump
@rem adb shell dmesg >> kmsg.txt

#adb shell screencap /data/cap.png
#adb pull /data/cap.png .
#adb shell rm /data/cap.png

echo "dump window"
adb shell dumpsys window        >dumpsys_window.txt

@Echo -----------------------------------------------------
@Echo Dumpstate may take a few seconds, buddy!
@Echo If dumpstate does NOT quit, please press Ctrl + C keys.
@Echo ATTN: Get dumpstate ASAP when it is jammed, running slowly, or black out!
@Echo -----------------------------------------------------

adb shell dumpstate > dumpstate.txt

move c:\"program files"\winrar\rar.exe c:\windows\system32\
rar a -r -ed -ag-MMDD-HHMMSS d:\lograr\log.rar %logdir%\
@echo Getting Completed.提取完成!

explorer d:\lograr

cd /d %OLDDIR%
:END


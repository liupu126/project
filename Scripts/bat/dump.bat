set pid=%1
set count=%2

adb shell dumpsys meminfo %pid% > dumpsys.meminfo.%count%
adb shell am dumpheap %pid% /data/local/tmp/dumpheap_%count%.hprof
adb pull /data/local/tmp/dumpheap_%count%.hprof .
adb shell rm -rf /data/local/tmp/*

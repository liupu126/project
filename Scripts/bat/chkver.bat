@echo off
:: build & verified boot
adb shell "getprop ro.boot.type && getenforce && getprop ro.boot.slot_suffix && getprop ro.boot.opcarrier && getprop gsm.current.phone-type && getprop ro.boot.verifiedbootstate && getprop vendor.boot.verifiedbootstate && getprop ro.boot.veritymode && getprop vendor.boot.veritymode"
:: version: fingerprint & ota
adb shell "getprop ro.system.build.fingerprint && getprop ro.product.build.fingerprint && getprop ro.vendor.build.fingerprint && getprop persist.sys.version.lastota && getprop persist.sys.version.ota && getprop ro.build.ota.versionname"
:: others
adb shell "getprop ro.build.version.security_patch && getprop ro.vendor.build.security_patch && getprop ro.com.google.gmsversion"
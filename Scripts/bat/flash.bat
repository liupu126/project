::Program:
::	Flash images according to parameters
::Author:
::	Braden Liu, liupu126@126.com
::History:
::	2017/10/19	Braden Liu	1st Release
::		1. Create file.
::	2018/12/18	Braden Liu	2nd Release
::		1. Change flash ways for new sourcecode dirs. --- 18811/SDM845/android/...

:: Usage: flash <image_dir> <option OR partion name> [image_name]
::	flash Z:\18811\SDM845\android\out\target\product\fajitat pabsvvd
::	flash Z:\18811\SDM845\android\out\target\product\fajitat boot boot
::	flash C:\myspace\sw_release\18831\DailyBuild_DEV\guacamolet_12_A.01_181205 pabsvvd
::	flash C:\myspace\sw_release\18831\DailyBuild_DEV\guacamolet_12_A.01_181205 abl abl

:: abosolute path of image dir
set image_dir=%1
:: option OR partion name
set image_option=%2
:: must not null, if 'image_option' is partion name.
set image_name=%3

:: for comparison
set null=

:: flashing images
call :CHECK_PARAMETERS
call :ENTER_FASTBOOT
@pause
call :FLASHING
::@pause
call :EXIT_FASTBOOT
@goto :end

:FLASH_BOOTLOADER
	fastboot flash abl %image_dir%\abl.elf || goto :FASTBOOT_FAILED
@goto :end

:FLASH_BOOT
	fastboot flash boot %image_dir%\boot.img || goto :FASTBOOT_FAILED
@goto :end

:FLASH_SYSTEM
	fastboot flash system %image_dir%\system.img || goto :FASTBOOT_FAILED
@goto :end
	
:FLASH_VENDOR
	fastboot flash vendor %image_dir%\vendor.img || goto :FASTBOOT_FAILED
@goto :end

:FLASH_USERDATA
	fastboot flash userdata %image_dir%\userdata.img || goto :FASTBOOT_FAILED
@goto :end

:FLASH_RECOVERY
	fastboot flash recovery %image_dir%\recovery.img || goto :FASTBOOT_FAILED
@goto :end

:FLASH_VBMETA
	fastboot flash vbmeta %image_dir%\vbmeta.img || goto :FASTBOOT_FAILED
@goto :end

:FLASH_DTBO
	fastboot flash dtbo %image_dir%\dtbo.img || goto :FASTBOOT_FAILED
@goto :end

:FLASH_METADATA
	fastboot flash metadata %image_dir%\metadata.img || goto :FASTBOOT_FAILED
@goto :end

:FLASH_AB
	call :FLASH_BOOTLOADER
	call :FLASH_BOOT
@goto :end

:FLASH_ABSU
	call :FLASH_BOOTLOADER
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_USERDATA
@goto :end

:FLASH_ABSVU
	call :FLASH_BOOTLOADER
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_USERDATA
@goto :end

:FLASH_BS
	call :FLASH_BOOT
	call :FLASH_SYSTEM
@goto :end

:FLASH_BSV
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
@goto :end

:FLASH_BSVU
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_USERDATA
@goto :end

:FLASH_ALL
	call :FLASH_BOOTLOADER
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_USERDATA
@goto :end

::::::::::::::::::::::::::::::::::::::::::::::::::P begin
:FLASH_P_ABSVVD
	call :FLASH_BOOTLOADER
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_VBMETA
	call :FLASH_DTBO
@goto :end

:FLASH_P_ABSVVDU
	call :FLASH_BOOTLOADER
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_VBMETA
	call :FLASH_DTBO
	call :FLASH_USERDATA
@goto :end

:FLASH_P_ABSVVDR
	call :FLASH_BOOTLOADER
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_VBMETA
	call :FLASH_DTBO
	call :FLASH_RECOVERY
@goto :end

:FLASH_P_BSVVD
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_VBMETA
	call :FLASH_DTBO
@goto :end

:FLASH_P_BSVVDU
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_VBMETA
	call :FLASH_DTBO
	call :FLASH_USERDATA
@goto :end

:FLASH_P_BSVVDR
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_VBMETA
	call :FLASH_DTBO
	call :FLASH_RECOVERY
@goto :end

:FLASH_P_ALL
	call :FLASH_BOOTLOADER
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_VBMETA
	call :FLASH_DTBO
	call :FLASH_USERDATA
	call :FLASH_METADATA
@goto :end
::::::::::::::::::::::::::::::::::::::::::::::::::P end

:FLASH_OTHER
	@if exist %image_dir%\%image_option%.img (
		fastboot flash %image_option% %image_dir%\%image_option%.img || goto :FASTBOOT_FAILED
	) else if exist %image_dir%\%image_option%.elf (
		fastboot flash %image_option% %image_dir%\%image_option%.elf || goto :FASTBOOT_FAILED
	) else if exist %image_dir%\%image_option%.mbn (
		fastboot flash %image_option% %image_dir%\%image_option%.mbn || goto :FASTBOOT_FAILED
	) else if exist %image_dir%\%image_option%.bin (
		fastboot flash %image_option% %image_dir%\%image_option%.bin || goto :FASTBOOT_FAILED
	) else (
		echo %image_dir%\%image_option%.img|.elf|.mbn|.bin not exist!
	)
@goto :end

:FLASH_OTHER2
	@if exist %image_dir%\%image_name%.img (
		fastboot flash %image_option% %image_dir%\%image_name%.img || goto :FASTBOOT_FAILED
	) else if exist %image_dir%\%image_option%.elf (
		fastboot flash %image_option% %image_dir%\%image_option%.elf || goto :FASTBOOT_FAILED
	) else if exist %image_dir%\%image_name%.mbn (
		fastboot flash %image_option% %image_dir%\%image_name%.mbn || goto :FASTBOOT_FAILED
	) else if exist %image_dir%\%image_name%.bin (
		fastboot flash %image_option% %image_dir%\%image_name%.bin || goto :FASTBOOT_FAILED
	) else (
		echo %image_dir%\%image_name%.img|.elf|.mbn|.bin not exist!
	)
@goto :end

:CHECK_PARAMETERS
	@if "%image_option%" == "%null%" (
		echo image_option is empty!
		@goto end
	) else if not exist %image_dir% (
		echo %image_dir% not exist!
		@goto end
	)
@goto :end

:ENTER_FASTBOOT
::	adb reboot bootloader || call :ENTER_FASTBOOT_FAILED
	adb reboot bootloader
@goto :end

:FLASHING
::	fastboot oem unlock-go
::	fastboot flashing unlock_critical
	fastboot ops 4F50040TR18FTR7FSTD5F01
::	fastboot ops disable_dm_verity
	@if "%image_option%" == "a" (
		call :FLASH_BOOTLOADER
	) else if "%image_option%" == "b" (
		call :FLASH_BOOT
	) else if "%image_option%" == "s" (
		call :FLASH_SYSTEM
	) else if "%image_option%" == "u" (
		call :FLASH_USERDATA
	) else if "%image_option%" == "v" (
		call :FLASH_VENDOR
	) else if "%image_option%" == "r" (
		call :FLASH_RECOVERY
	) else if "%image_option%" == "pv" (
		call :FLASH_VBMETA
	) else if "%image_option%" == "d" (
		call :FLASH_DTBO
	) else if "%image_option%" == "m" (
		call :FLASH_METADATA
	) else if "%image_option%" == "ab" (
		call :FLASH_AB
	) else if "%image_option%" == "bs" (
		call :FLASH_BS
	) else if "%image_option%" == "absu" (
		call :FLASH_ABSU
	) else if "%image_option%" == "absvu" (
		call :FLASH_ABSVU
	) else if "%image_option%" == "bsv" (
		call :FLASH_BSV
	) else if "%image_option%" == "bsvu" (
		call :FLASH_BSVU
	) else if "%image_option%" == "all" (
		call :FLASH_ALL
	) else if "%image_option%" == "pabsvvd" (
		call :FLASH_P_ABSVVD
	) else if "%image_option%" == "pabsvvdu" (
		call :FLASH_P_ABSVVDU
	) else if "%image_option%" == "pabsvvdr" (
		call :FLASH_P_ABSVVDR
	) else if "%image_option%" == "pbsvvd" (
		call :FLASH_P_BSVVD
	) else if "%image_option%" == "pbsvvdu" (
		call :FLASH_P_BSVVDU
	) else if "%image_option%" == "pbsvvdr" (
		call :FLASH_P_BSVVDR
	) else if "%image_option%" == "pall" (
		call :FLASH_P_ALL
	) else if "%image_name%" == "%null%" (
		call :FLASH_OTHER
	) else (
		call :FLASH_OTHER2
	)
	@goto end
@goto :end

:EXIT_FASTBOOT
	@fastboot reboot
	@goto end

:ENTER_FASTBOOT_FAILED
	@echo Enter fastboot failed, please check!
	pause
    @goto end
	
:FASTBOOT_FAILED
    @echo Fastboot failed, please check!
    @goto end

:end

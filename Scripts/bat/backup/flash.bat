::Program:
::	Flash images according to parameters
::Author:
::	Braden Liu, liupu126@126.com
::History:
::	2017/10/19	Braden Liu	1st Release
::		1. Create file.

:: Usage: flash 3701A alchemy [a b s u ab bs absu all <partition-name>] [image-name]
::	flash 3701A alchemy ab -> flash aboot & boot
::	flash 3701A alchemy aboot emmc_appsboot -> flash aboot
:: 3 parameters, at least
set project=%1
set project_alias=%2
set image_option=%3
set image_name=%4

set project_dir=Z:\work
set image_dir=%project_dir%\%project%\out\target\product\%project_alias%

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

:FLASH_ABOOT
	fastboot flash aboot %image_dir%\emmc_appsboot.mbn || goto :FASTBOOT_FAILED
	fastboot flash abootbak %image_dir%\emmc_appsboot.mbn || goto :FASTBOOT_FAILED
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

::::::::::::::::::::::::::::::::::::::::::::::::::P begin
:FLASH_VBMETA
	fastboot flash vbmeta %image_dir%\vbmeta.img || goto :FASTBOOT_FAILED
@goto :end

:FLASH_DTBO
	fastboot flash dtbo %image_dir%\dtbo.img || goto :FASTBOOT_FAILED
@goto :end
::::::::::::::::::::::::::::::::::::::::::::::::::P end

:FLASH_AB
	call :FLASH_ABOOT
	call :FLASH_BOOT
@goto :end

:FLASH_ABSU
	call :FLASH_ABOOT
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_USERDATA
@goto :end

:FLASH_ABSVU
	call :FLASH_ABOOT
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
	call :FLASH_ABOOT
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_USERDATA
	call :FLASH_RECOVERY
@goto :end

::::::::::::::::::::::::::::::::::::::::::::::::::P begin
:FLASH_P_ABSVVD
	call :FLASH_ABOOT
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_VBMETA
	call :FLASH_DTBO
@goto :end

:FLASH_P_ABSVVDU
	call :FLASH_ABOOT
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_VBMETA
	call :FLASH_DTBO
	call :FLASH_USERDATA
@goto :end

:FLASH_P_ABSVVDR
	call :FLASH_ABOOT
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
	call :FLASH_ABOOT
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_VBMETA
	call :FLASH_DTBO
	call :FLASH_USERDATA
	call :FLASH_RECOVERY
@goto :end
::::::::::::::::::::::::::::::::::::::::::::::::::P end

:FLASH_OTHER
	@if exist %image_dir%\%image_option%.img (
		fastboot flash %image_option% %image_dir%\%image_option%.img || goto :FASTBOOT_FAILED
	) else if exist %image_dir%\%image_option%.mbn (
		fastboot flash %image_option% %image_dir%\%image_option%.mbn || goto :FASTBOOT_FAILED
	) else if exist %image_dir%\%image_option%.bin (
		fastboot flash %image_option% %image_dir%\%image_option%.bin || goto :FASTBOOT_FAILED
	) else (
		echo %image_dir%\%image_option%.img|.mbn|.bin not exist!
	)
@goto :end

:FLASH_OTHER2
	@if exist %image_dir%\%image_name%.img (
		fastboot flash %image_option% %image_dir%\%image_name%.img || goto :FASTBOOT_FAILED
	) else if exist %image_dir%\%image_name%.mbn (
		fastboot flash %image_option% %image_dir%\%image_name%.mbn || goto :FASTBOOT_FAILED
	) else if exist %image_dir%\%image_name%.bin (
		fastboot flash %image_option% %image_dir%\%image_name%.bin || goto :FASTBOOT_FAILED
	) else (
		echo %image_dir%\%image_name%.img|.mbn|.bin not exist!
	)
@goto :end

:CHECK_PARAMETERS
	@if "%project%" == "%null%" (
		echo project is empty!
		@goto end
	) else if "%project_alias%" == "%null%" (
		echo project_alias is empty!
		@goto end
	) else if "%image_option%" == "%null%" (
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
	@if "%image_option%" == "a" (
		call :FLASH_ABOOT
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
	) else if "%image_option%" == "pd" (
		call :FLASH_DTBO
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

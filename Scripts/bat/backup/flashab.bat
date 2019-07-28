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
	fastboot flash aboot_a %image_dir%\emmc_appsboot.mbn || goto :FASTBOOT_FAILED
	fastboot flash aboot_b %image_dir%\emmc_appsboot.mbn || goto :FASTBOOT_FAILED
@goto :end

:FLASH_BOOT
	fastboot flash boot_a %image_dir%\boot.img || goto :FASTBOOT_FAILED
	fastboot flash boot_b %image_dir%\boot.img || goto :FASTBOOT_FAILED
@goto :end

:FLASH_SYSTEM
	fastboot flash system_a %image_dir%\system.img || goto :FASTBOOT_FAILED
	fastboot flash system_b %image_dir%\system.img || goto :FASTBOOT_FAILED
@goto :end
	
:FLASH_VENDOR
	fastboot flash vendor_a %image_dir%\vendor.img || goto :FASTBOOT_FAILED
	fastboot flash vendor_b %image_dir%\vendor.img || goto :FASTBOOT_FAILED
@goto :end

:FLASH_VBMETA
	fastboot flash vbmeta_a %image_dir%\vbmeta.img || goto :FASTBOOT_FAILED
	fastboot flash vbmeta_b %image_dir%\vbmeta.img || goto :FASTBOOT_FAILED
@goto :end

:FLASH_DTBO
	fastboot flash dtbo_a %image_dir%\dtbo.img || goto :FASTBOOT_FAILED
	fastboot flash dtbo_b %image_dir%\dtbo.img || goto :FASTBOOT_FAILED
@goto :end

:FLASH_USERDATA
	fastboot flash userdata %image_dir%\userdata.img || goto :FASTBOOT_FAILED
@goto :end

::::::::::::::::::::::::::::::::::::::::::::::::::P begin
:FLASH_ALL
	call :FLASH_ABOOT
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_VBMETA
	call :FLASH_DTBO
	call :FLASH_USERDATA
@goto :end

:FLASH_ABSVVD
	call :FLASH_ABOOT
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_VBMETA
	call :FLASH_DTBO
@goto :end

:FLASH_ABSVVDU
	call :FLASH_ABOOT
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_VBMETA
	call :FLASH_DTBO
	call :FLASH_USERDATA
@goto :end

:FLASH_BSVVD
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_VBMETA
	call :FLASH_DTBO
@goto :end

:FLASH_BSVVDU
	call :FLASH_BOOT
	call :FLASH_SYSTEM
	call :FLASH_VENDOR
	call :FLASH_VBMETA
	call :FLASH_DTBO
	call :FLASH_USERDATA
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
	) else if "%image_option%" == "v" (
		call :FLASH_VENDOR
	) else if "%image_option%" == "vb" (
		call :FLASH_VBMETA
	) else if "%image_option%" == "d" (
		call :FLASH_DTBO
	) else if "%image_option%" == "u" (
		call :FLASH_USERDATA
	) else if "%image_option%" == "absvvd" (
		call :FLASH_ABSVVD
	) else if "%image_option%" == "absvvdu" (
		call :FLASH_ABSVVDU
	) else if "%image_option%" == "bsvvd" (
		call :FLASH_BSVVD
	) else if "%image_option%" == "bsvvdu" (
		call :FLASH_BSVVDU
	) else if "%image_option%" == "all" (
		call :FLASH_ALL
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

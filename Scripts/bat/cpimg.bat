::Program:
::	Flash images according to parameters
::Author:
::	Braden Liu, liupu126@126.com
::History:
::	2018/01/09	Braden Liu	1st Release
::		1. Create file.

:: Usage: cpimg <image_src_dir> <image_dst_dir> <option OR partion name> [image_name]
::	flash Z:\18811\SDM845\android\out\target\product\fajitat pabsvvd
::	flash Z:\18811\SDM845\android\out\target\product\fajitat boot boot
::	flash C:\myspace\sw_release\18831\DailyBuild_DEV\guacamolet_12_A.01_181205 pabsvvd
::	flash C:\myspace\sw_release\18831\DailyBuild_DEV\guacamolet_12_A.01_181205 abl abl

:: abosolute path of image src dir
set image_src_dir=%1
:: abosolute path of image dst dir
set image_dst_dir=%2
:: option OR partion name
set image_option=%3
:: must not null, if 'image_option' is partion name.
set image_name=%4

set COPY_CMD=copy
:: for comparison
set null=

:: flashing images
call :CHECK_PARAMETERS
call :COPYING
@goto :end

:COPY_BOOTLOADER
	%COPY_CMD% %image_src_dir%\abl.elf %image_dst_dir%\ || goto :COPY_FAILED
@goto :end

:COPY_BOOT
	%COPY_CMD% %image_src_dir%\boot.img %image_dst_dir%\ || goto :COPY_FAILED
@goto :end

:COPY_SYSTEM
	%COPY_CMD% %image_src_dir%\system.img %image_dst_dir%\ || goto :COPY_FAILED
@goto :end
	
:COPY_VENDOR
	%COPY_CMD% %image_src_dir%\vendor.img %image_dst_dir%\ || goto :COPY_FAILED
@goto :end

:COPY_USERDATA
	%COPY_CMD% %image_src_dir%\userdata.img %image_dst_dir%\ || goto :COPY_FAILED
@goto :end

:COPY_RECOVERY
	%COPY_CMD% %image_src_dir%\recovery.img %image_dst_dir%\ || goto :COPY_FAILED
@goto :end

:COPY_VBMETA
	%COPY_CMD% %image_src_dir%\vbmeta.img %image_dst_dir%\ || goto :COPY_FAILED
@goto :end

:COPY_DTBO
	%COPY_CMD% %image_src_dir%\dtbo.img %image_dst_dir%\ || goto :COPY_FAILED
@goto :end

:COPY_METADATA
	%COPY_CMD% %image_src_dir%\metadata.img %image_dst_dir%\ || goto :FASTBOOT_FAILED
@goto :end

:COPY_AB
	call :COPY_BOOTLOADER
	call :COPY_BOOT
@goto :end

:COPY_ABSU
	call :COPY_BOOTLOADER
	call :COPY_BOOT
	call :COPY_SYSTEM
	call :COPY_USERDATA
@goto :end

:COPY_ABSVU
	call :COPY_BOOTLOADER
	call :COPY_BOOT
	call :COPY_SYSTEM
	call :COPY_VENDOR
	call :COPY_USERDATA
@goto :end

:COPY_BS
	call :COPY_BOOT
	call :COPY_SYSTEM
@goto :end

:COPY_BSV
	call :COPY_BOOT
	call :COPY_SYSTEM
	call :COPY_VENDOR
@goto :end

:COPY_BSVU
	call :COPY_BOOT
	call :COPY_SYSTEM
	call :COPY_VENDOR
	call :COPY_USERDATA
@goto :end

:COPY_ALL
	call :COPY_BOOTLOADER
	call :COPY_BOOT
	call :COPY_SYSTEM
	call :COPY_VENDOR
	call :COPY_USERDATA
	call :COPY_RECOVERY
@goto :end

::::::::::::::::::::::::::::::::::::::::::::::::::P begin
:COPY_P_ABSVVD
	call :COPY_BOOTLOADER
	call :COPY_BOOT
	call :COPY_SYSTEM
	call :COPY_VENDOR
	call :COPY_VBMETA
	call :COPY_DTBO
@goto :end

:COPY_P_ABSVVDU
	call :COPY_BOOTLOADER
	call :COPY_BOOT
	call :COPY_SYSTEM
	call :COPY_VENDOR
	call :COPY_VBMETA
	call :COPY_DTBO
	call :COPY_USERDATA
@goto :end

:COPY_P_ABSVVDR
	call :COPY_BOOTLOADER
	call :COPY_BOOT
	call :COPY_SYSTEM
	call :COPY_VENDOR
	call :COPY_VBMETA
	call :COPY_DTBO
	call :COPY_RECOVERY
@goto :end

:COPY_P_BSVVD
	call :COPY_BOOT
	call :COPY_SYSTEM
	call :COPY_VENDOR
	call :COPY_VBMETA
	call :COPY_DTBO
@goto :end

:COPY_P_BSVVDU
	call :COPY_BOOT
	call :COPY_SYSTEM
	call :COPY_VENDOR
	call :COPY_VBMETA
	call :COPY_DTBO
	call :COPY_USERDATA
@goto :end

:COPY_P_BSVVDR
	call :COPY_BOOT
	call :COPY_SYSTEM
	call :COPY_VENDOR
	call :COPY_VBMETA
	call :COPY_DTBO
	call :COPY_RECOVERY
@goto :end

:COPY_P_ALL
	call :COPY_BOOTLOADER
	call :COPY_BOOT
	call :COPY_SYSTEM
	call :COPY_VENDOR
	call :COPY_VBMETA
	call :COPY_DTBO
	call :COPY_USERDATA
	call :COPY_METADATA
@goto :end
::::::::::::::::::::::::::::::::::::::::::::::::::P end

:COPY_OTHER
	@if exist %image_src_dir%\%image_option%.img (
		copy %image_src_dir%\%image_option%.img %image_dst_dir% || goto :COPY_FAILED
	) else if exist %image_src_dir%\%image_option%.elf (
		copy %image_src_dir%\%image_option%.elf %image_dst_dir% || goto :COPY_FAILED
	) else if exist %image_src_dir%\%image_option%.mbn (
		copy %image_src_dir%\%image_option%.mbn %image_dst_dir% || goto :COPY_FAILED
	) else if exist %image_src_dir%\%image_option%.bin (
		copy %image_src_dir%\%image_option%.bin %image_dst_dir% || goto :COPY_FAILED
	) else (
		echo %image_src_dir%\%image_option%.img|.elf|.mbn|.bin not exist!
	)
@goto :end

:COPY_OTHER2
	@if exist %image_src_dir%\%image_name%.img (
		copy %image_src_dir%\%image_name%.img %image_dst_dir% || goto :COPY_FAILED
	) else if exist %image_src_dir%\%image_name%.elf (
		copy %image_src_dir%\%image_name%.elf %image_dst_dir% || goto :COPY_FAILED
	) else if exist %image_src_dir%\%image_name%.mbn (
		copy %image_src_dir%\%image_name%.mbn %image_dst_dir% || goto :COPY_FAILED
	) else if exist %image_src_dir%\%image_name%.bin (
		copy %image_src_dir%\%image_name%.bin %image_dst_dir% || goto :COPY_FAILED
	) else (
		echo %image_src_dir%\%image_name%.img|.elf|.mbn|.bin not exist!
	)
@goto :end

:CHECK_PARAMETERS
	@if "%image_option%" == "%null%" (
		echo image_option is empty!
		@goto end
	) else if not exist %image_src_dir% (
		echo %image_src_dir% not exist!
		@goto end
	)
@goto :end

:COPYING
	@if "%image_option%" == "a" (
		call :COPY_BOOTLOADER
	) else if "%image_option%" == "b" (
		call :COPY_BOOT
	) else if "%image_option%" == "s" (
		call :COPY_SYSTEM
	) else if "%image_option%" == "u" (
		call :COPY_USERDATA
	) else if "%image_option%" == "v" (
		call :COPY_VENDOR
	) else if "%image_option%" == "r" (
		call :COPY_RECOVERY
	) else if "%image_option%" == "pv" (
		call :COPY_VBMETA
	) else if "%image_option%" == "d" (
		call :COPY_DTBO
	) else if "%image_option%" == "m" (
		call :COPY_METADATA
	) else if "%image_option%" == "ab" (
		call :COPY_AB
	) else if "%image_option%" == "bs" (
		call :COPY_BS
	) else if "%image_option%" == "absu" (
		call :COPY_ABSU
	) else if "%image_option%" == "absvu" (
		call :COPY_ABSVU
	) else if "%image_option%" == "bsv" (
		call :COPY_BSV
	) else if "%image_option%" == "bsvu" (
		call :COPY_BSVU
	) else if "%image_option%" == "all" (
		call :COPY_ALL
	) else if "%image_option%" == "pabsvvd" (
		call :COPY_P_ABSVVD
	) else if "%image_option%" == "pabsvvdu" (
		call :COPY_P_ABSVVDU
	) else if "%image_option%" == "pabsvvdr" (
		call :COPY_P_ABSVVDR
	) else if "%image_option%" == "pbsvvd" (
		call :COPY_P_BSVVD
	) else if "%image_option%" == "pbsvvdu" (
		call :COPY_P_BSVVDU
	) else if "%image_option%" == "pbsvvdr" (
		call :COPY_P_BSVVDR
	) else if "%image_option%" == "pall" (
		call :COPY_P_ALL
	) else if "%image_name%" == "%null%" (
		call :COPY_OTHER
	) else (
		call :COPY_OTHER2
	)
	@goto end
@goto :end
	
:COPY_FAILED
    @echo Copy failed, please check!
    @goto end

:end

set image_dir=%1

::check options
set last_option=%image_dir%
set null=
@if "%last_option%" == "%null%" (
	echo last_option is empty!
	@goto end
) 

adb reboot bootloader
fastboot ops 4F50040TR18FTR7FSTD5F01
:: fastboot ops disable_dm_verity

::flash images
fastboot flash abl %image_dir%\abl.elf
fastboot flash boot %image_dir%\boot.img
fastboot flash super %image_dir%\super.img
fastboot flash vbmeta %image_dir%\vbmeta.img
fastboot flash vbmeta_system %image_dir%\vbmeta_system.img
fastboot flash dtbo %image_dir%\dtbo.img
fastboot flash metadata %image_dir%\metadata.img
fastboot flash userdata %image_dir%\userdata.img
:: fastboot flash recovery %image_dir%\recovery.img

::reboot
pause
fastboot reboot

:end

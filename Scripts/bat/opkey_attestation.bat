::For example:
:: opkey_attestation OP7ProNRSpr.xml

:: for comparison
set null=
set last_param=%1
@if "%last_param%" == "%null%" (
	echo Param num must be 1 !
	@goto end
)

set attestation_file=%1

adb wait-for-device

::Keymaster Attestation
adb shell mkdir -p /sdcard/.lii
adb push %attestation_file% /sdcard/.lii/keyboxes_ciphered.xml
adb shell dumpsys engineer.native --install_keybox

adb reboot

:end

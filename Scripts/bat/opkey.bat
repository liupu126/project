::For example:
:: opkey OP7ProNRSpr.xml <widevine_keydata>

:: for comparison
set null=
set last_param=%2
@if "%last_param%" == "%null%" (
	echo Param num must be 2 !
	@goto end
)

set attestation_file=%1
set widevine_keydata=%2

::RPMB
adb wait-for-device
adb shell dumpsys android.security.keystore --enable_rpmb
adb reboot

ping 127.0.0.1 -n 5 > nul
adb wait-for-device

::Keymaster Attestation
ping 127.0.0.1 -n 20 > nul
adb shell mkdir -p /sdcard/.lii
adb push %attestation_file% /sdcard/.lii/keyboxes_ciphered.xml
:: Android P
:: adb shell dumpsys engineer.native --install_keybox
:: Android Q
adb shell dumpsys engineer --install_keybox

::Media keybox
adb shell dumpsys media.drm --provision_keybox=%widevine_keydata%

adb reboot

:end

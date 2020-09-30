::For example:
:: opkey_attest OP7ProNRSpr.xml

:: for comparison
set null=
set last_param=%1
@if "%last_param%" == "%null%" (
	echo Param num must be 1 !
	@goto end
)

set attestation_file=%1

::Keymaster Attestation
:: I mv      : type=1400 audit(0.0:337): avc: denied { setattr } for name=".lii" dev="sda7" ino=32772 scontext=u:r:vold:s0 tcontext=u:object_r:op2_file:s0 tclass=dir permissive=0
adb shell setenforce 0
adb shell mkdir -p /sdcard/.lii
adb push %attestation_file% /sdcard/.lii/keyboxes_ciphered.xml
:: Android P
:: adb shell dumpsys engineer.native --install_keybox
:: Android Q
adb shell dumpsys engineer --install_keybox

adb reboot

:end

::Usage: run-widevine-fail option serialno dst_log
::       run-widevine-fail ocmr1  faffdab9 d:\run-widevine-fail-ocmr1
set option=%1
set serialno=%2
set logfile=%3
set null=
_ 2>nul > %logfile%

@if "%option%" == "oc" (
	call :OC
) else if "%option%" == "ocmr1" (
	call :OCMR1
) else (
	call :NO_OPTION
)
goto :end

:OC
	@echo TEST:/data/bin/cdm_extended_duration_test >> %logfile%
	adb -s %serialno% shell /data/bin/cdm_extended_duration_test >> %logfile%

	@echo TEST:/data/bin/libwvdrmdrmplugin_hidl_test >> %logfile%
	adb -s %serialno% shell /data/bin/libwvdrmdrmplugin_hidl_test >> %logfile%

	@echo TEST:/data/bin/libwvdrmdrmplugin_test >> %logfile%
	adb -s %serialno% shell /data/bin/libwvdrmdrmplugin_test >> %logfile%

	@echo TEST:/data/bin/request_license_test >> %logfile%
	adb -s %serialno% shell /data/bin/request_license_test >> %logfile%
goto :end

:OCMR1
	@echo TEST:/data/bin/request_license_test >> %logfile%
	adb -s %serialno% shell /data/bin/request_license_test >> %logfile%

	@echo TEST:/data/bin/cdm_extended_duration_test >> %logfile%
	adb -s %serialno% shell /data/bin/cdm_extended_duration_test >> %logfile%

	@echo TEST:/data/bin/wv_cdm_metrics_test >> %logfile%
	adb -s %serialno% shell /data/bin/wv_cdm_metrics_test >> %logfile%
goto :end

:NO_OPTION
	echo Error: No option!
goto :end

:: MediaDrmAPITest
:end

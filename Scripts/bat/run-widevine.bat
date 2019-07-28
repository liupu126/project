::Program:
::	Run widevine test.
::Author:
::	Braden Liu
::History:
::	2017/12/21	Braden Liu	1st Release
::		1. create file, according to vendor/widevine/libwvdrmengine/run_all_unit_tests.sh in Android.

::Usage: run-widevine option serialno dst_log
::       run-widevine oc     faffdab9 d:\run-widevine-oc

::@echo off
set option=%1
set serialno=%2
set dst_log=%3
::New empty file
_ 2>nul > %dst_log%

@if "%option%" == "oc" (
	call :OC
) else if "%option%" == "ocmr1" (
	call :OCMR1
) else if "%option%" == "wv7" (
	call :WV7
) else (
	call :NO_OPTION
)
goto :end

:OC
	::Disable DroidGuard to prevent provisioning collisions
	@call :adb_shell_run pm disable com.google.android.gms/com.google.android.gms.droidguard.DroidGuardService
	::Run oemcrypto tests first due to historical test order issues
	@call :adb_shell_run /data/bin/oemcrypto_test "--gtest_filter=*-*Level1Required"
	::	@call :adb_shell_run /data/bin/oemcrypto_test
	::Run request_license_test next to ensure device is provisioned
	@call :adb_shell_run /data/bin/request_license_test
	::cdm_extended_duration_test takes >30 minutes to run.
	@call :adb_shell_run /data/bin/cdm_extended_duration_test
	::Additional tests
	@call :adb_shell_run /data/bin/base64_test
	@call :adb_shell_run /data/bin/buffer_reader_test
	@call :adb_shell_run /data/bin/cdm_engine_test
	@call :adb_shell_run /data/bin/cdm_session_unittest
	@call :adb_shell_run /data/bin/device_files_unittest
	@call :adb_shell_run /data/bin/distribution_test
	@call :adb_shell_run /data/bin/event_metric_test
	@call :adb_shell_run /data/bin/file_store_unittest
	@call :adb_shell_run /data/bin/file_utils_unittest
	@call :adb_shell_run /data/bin/http_socket_test
	@call :adb_shell_run /data/bin/initialization_data_unittest
	@call :adb_shell_run /data/bin/libwvdrmdrmplugin_hidl_test
	@call :adb_shell_run /data/bin/libwvdrmdrmplugin_test
	@call :adb_shell_run /data/bin/libwvdrmmediacrypto_hidl_test
	@call :adb_shell_run /data/bin/libwvdrmmediacrypto_test
	@call :adb_shell_run /data/bin/license_keys_unittest
	@call :adb_shell_run /data/bin/license_unittest
	@call :adb_shell_run /data/bin/policy_engine_constraints_unittest
	@call :adb_shell_run /data/bin/policy_engine_unittest
	@call :adb_shell_run /data/bin/service_certificate_unittest
	@call :adb_shell_run /data/bin/timer_unittest
	@call :adb_shell_run /data/bin/usage_table_header_unittest
	@call :adb_shell_run "LD_LIBRARY_PATH=/vendor/lib/mediadrm:/vendor/lib64/mediadrm" /data/bin/libwvdrmengine_test
	@call :adb_shell_run /data/bin/libwvdrmengine_hidl_test
	::Re-enable DroidGuard
	@call :adb_shell_run pm enable com.google.android.gms/com.google.android.gms.droidguard.DroidGuardService
	::adb shell am start com.widevine.test/com.widevine.test.MediaDrmAPITest
goto :end

:OCMR1
	::Disable DroidGuard to prevent provisioning collisions
	@call :adb_shell_run pm disable com.google.android.gms/com.google.android.gms.droidguard.DroidGuardService
	::Run oemcrypto tests first due to historical test order issues
	@call :adb_shell_run /data/bin/oemcrypto_test "--gtest_filter=*-*Level1Required"
	::	@call :adb_shell_run /data/bin/oemcrypto_test
	::Run request_license_test next to ensure device is provisioned
	@call :adb_shell_run /data/bin/request_license_test
	::cdm_extended_duration_test takes >30 minutes to run.
	@call :adb_shell_run /data/bin/cdm_extended_duration_test
	::cdm_feature_test to be run with modified/mock oemcrypto
	::	@call :adb_shell_run cdm_feature_test
	::Additional tests
	@call :adb_shell_run /data/bin/base64_test
	@call :adb_shell_run /data/bin/buffer_reader_test
	@call :adb_shell_run /data/bin/cdm_engine_test
	@call :adb_shell_run /data/bin/cdm_session_unittest
	@call :adb_shell_run /data/bin/counter_metric_unittest
	@call :adb_shell_run /data/bin/crypto_session_unittest
	@call :adb_shell_run /data/bin/device_files_unittest
	@call :adb_shell_run /data/bin/distribution_test
	@call :adb_shell_run /data/bin/event_metric_test
	@call :adb_shell_run /data/bin/file_store_unittest
	@call :adb_shell_run /data/bin/file_utils_unittest
	@call :adb_shell_run /data/bin/http_socket_test
	@call :adb_shell_run /data/bin/initialization_data_unittest
	@call :adb_shell_run /data/bin/libwvdrmdrmplugin_hidl_test
	@call :adb_shell_run /data/bin/libwvdrmdrmplugin_test
	@call :adb_shell_run /data/bin/libwvdrmmediacrypto_hidl_test
	@call :adb_shell_run /data/bin/libwvdrmmediacrypto_test
	@call :adb_shell_run /data/bin/license_keys_unittest
	@call :adb_shell_run /data/bin/license_unittest
	@call :adb_shell_run /data/bin/policy_engine_constraints_unittest
	@call :adb_shell_run /data/bin/policy_engine_unittest
	@call :adb_shell_run /data/bin/service_certificate_unittest
	@call :adb_shell_run /data/bin/timer_unittest
	@call :adb_shell_run /data/bin/usage_table_header_unittest
	@call :adb_shell_run /data/bin/value_metric_unittest
	@call :adb_shell_run /data/bin/wv_cdm_metrics_test
	@call :adb_shell_run "LD_LIBRARY_PATH=/vendor/lib/mediadrm:/vendor/lib64/mediadrm" /data/bin/libwvdrmengine_test
	@call :adb_shell_run /data/bin/libwvdrmengine_hidl_test
	::Re-enable DroidGuard
	@call :adb_shell_run pm enable com.google.android.gms/com.google.android.gms.droidguard.DroidGuardService
	::adb shell am start com.widevine.test/com.widevine.test.MediaDrmAPITest
goto :end

:WV7
	::Disable DroidGuard to prevent provisioning collisions
	@call :adb_shell_run pm disable com.google.android.gms/com.google.android.gms.droidguard.DroidGuardService
	::Run oemcrypto tests first due to historical test order issues
	@call :adb_shell_run /system/bin/oemcrypto_test "--gtest_filter=*-*Level1Required"
	::	@call :adb_shell_run /system/bin/oemcrypto_test
	::Run request_license_test next to ensure device is provisioned
	@call :adb_shell_run /system/bin/request_license_test
	::cdm_extended_duration_test takes >30 minutes to run.
	@call :adb_shell_run /system/bin/cdm_extended_duration_test
	::Additional tests
	@call :adb_shell_run /system/bin/max_res_engine_unittest
	@call :adb_shell_run /system/bin/policy_engine_unittest
	@call :adb_shell_run /system/bin/libwvdrmmediacrypto_test
	@call :adb_shell_run /system/bin/libwvdrmdrmplugin_test
	@call :adb_shell_run /system/bin/cdm_engine_test
	@call :adb_shell_run /system/bin/cdm_session_unittest
	@call :adb_shell_run /system/bin/file_store_unittest
	@call :adb_shell_run /system/bin/license_unittest
	@call :adb_shell_run /system/bin/initialization_data_unittest
	@call :adb_shell_run /system/bin/device_files_unittest
	@call :adb_shell_run /system/bin/timer_unittest
	@call :adb_shell_run /system/bin/buffer_reader_test
	@call :adb_shell_run /system/bin/circular_buffer_test
	@call :adb_shell_run /system/bin/entry_writer_test
	@call :adb_shell_run "LD_LIBRARY_PATH=/vendor/lib/mediadrm:/vendor/lib64/mediadrm" /system/bin/libwvdrmengine_test
	::Re-enable DroidGuard
	@call :adb_shell_run pm enable com.google.android.gms/com.google.android.gms.droidguard.DroidGuardService
	::adb shell am start com.widevine.test/com.widevine.test.MediaDrmAPITest
goto :end

:adb_shell_run
	@echo START: %1 %2 %3 %4 %5 %6 %7 %8 %9 >> %dst_log%
	adb -s %serialno% shell %1 %2 %3 %4 %5 %6 %7 %8 %9 >> %dst_log%
	@echo END  : %1 %2 %3 %4 %5 %6 %7 %8 %9 >> %dst_log%

:end

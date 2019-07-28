@set project=%1
@set project_alias=%2
@set module=%3

@set project_dir=Z:\work
@set dst_sys_app=%project_dir%\%project%\out\target\product\%project_alias%\system\app\%module%
@set dst_sys_priv=%project_dir%\%project%\out\target\product\%project_alias%\system\priv-app\%module%
@set dst_sys_fwk=%project_dir%\%project%\out\target\product\%project_alias%\system\framework\%module%
@set dst_vnd_app=%project_dir%\%project%\out\target\product\%project_alias%\vendor\app\%module%

:: for comparison
@set null=
@if "%project%" == "%null%" (
	set dst_dir=.
) else if "%project_alias%" == "%null%" (
	set dst_dir=%project_dir%\%project%\
) else if "%module%" == "%null%" (
	set dst_dir=%project_dir%\%project%\out\target\product\%project_alias%\
) else if exist %dst_sys_app% (
	set dst_dir=%dst_sys_app%
) else if exist %dst_sys_priv% (
	set dst_dir=%dst_sys_priv%
) else if exist %dst_sys_fwk% (
	set dst_dir=%dst_sys_fwk%
) else if exist %dst_vnd_app% (
	set dst_dir=%dst_vnd_app%
) else (
	echo Error: Invalid parameters!
	set dst_dir=.
)

@if exist %dst_dir% (
	echo explorer %dst_dir%
	explorer %dst_dir%
) else (
	echo explorer %1 %2 %3 %4 %5 %6 %7 %8 %9
	explorer %1 %2 %3 %4 %5 %6 %7 %8 %9
)



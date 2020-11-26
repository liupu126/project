set carrier=%1
adb shell am broadcast -a com.oneplus.action.sim_operator_changed --ei currentParamCode %carrier% --ez adbDebug true
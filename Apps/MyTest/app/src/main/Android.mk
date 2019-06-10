#Waring! Not Done!

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE_TAGS := optional

LOCAL_PACKAGE_NAME := MyTest

# LOCAL_RESOURCE_DIR += frameworks/support/v7/appcompat/res
# LOCAL_RESOURCE_DIR += $(LOCAL_PATH)/res

LOCAL_SRC_FILES := \
    $(call all-java-files-under, java)

LOCAL_STATIC_JAVA_LIBRARIES += android-support-v7-appcompat \

LOCAL_DEX_PREOPT := false
LOCAL_PROGUARD_ENABLED := disabled

include $(BUILD_PACKAGE)

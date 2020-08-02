include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = JitterPrefs
JitterPrefs_FILES = XXXRootListController.m
JitterPrefs_INSTALL_PATH = /Library/PreferenceBundles
JitterPrefs_FRAMEWORKS = UIKit
JitterPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/JitterPrefs.plist$(ECHO_END)

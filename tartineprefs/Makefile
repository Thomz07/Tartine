ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = TartinePrefs

TartinePrefs_FILES = TARRootListController.m TARFolderController.m TARDockController.m
TartinePrefs_INSTALL_PATH = /Library/PreferenceBundles
TartinePrefs_FRAMEWORKS = UIKit
TartinePrefs_PRIVATE_FRAMEWORKS = Preferences
TartinePrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/TartinePrefs.plist$(ECHO_END)

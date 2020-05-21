include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = preferences

preferences_FILES = TARRootListController.m
preferences_INSTALL_PATH = /Library/PreferenceBundles
preferences_FRAMEWORKS = UIKit
preferences_PRIVATE_FRAMEWORKS = Preferences
preferences_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/preferences.plist$(ECHO_END)

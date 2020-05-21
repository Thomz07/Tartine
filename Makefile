ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Tartine

Tartine_FILES = Tweak.xm
Tartine_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += tartineprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

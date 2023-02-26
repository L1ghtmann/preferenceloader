ARCHS = arm64 arm64e
TARGET = iphone:latest:11.0
INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libprefs
libprefs_GENERATOR = libhooker
libprefs_FILES = prefs.xm
libprefs_FRAMEWORKS = Foundation
libprefs_LIBRARIES = substrate
libprefs_PRIVATE_FRAMEWORKS = Preferences
libprefs_CFLAGS = -fobjc-arc -I.
libprefs_COMPATIBILITY_VERSION = 2.2.0
libprefs_LIBRARY_VERSION = $(shell echo "$(THEOS_PACKAGE_BASE_VERSION)" | cut -d'~' -f1)
libprefs_LDFLAGS  = -compatibility_version $($(THEOS_CURRENT_INSTANCE)_COMPATIBILITY_VERSION)
libprefs_LDFLAGS += -current_version $($(THEOS_CURRENT_INSTANCE)_LIBRARY_VERSION)
libprefs_LDFLAGS += -F.

TWEAK_NAME = PreferenceLoader
PreferenceLoader_FILES = Tweak.xm
PreferenceLoader_FRAMEWORKS = Foundation
PreferenceLoader_PRIVATE_FRAMEWORKS = Preferences
PreferenceLoader_LIBRARIES = prefs
PreferenceLoader_CFLAGS = -fobjc-arc -I.
PreferenceLoader_LDFLAGS = -L$(THEOS_OBJ_DIR) -F.

include $(THEOS_MAKE_PATH)/library.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-libprefs-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/usr/include/libprefs$(ECHO_END)
	$(ECHO_NOTHING)cp prefs.h $(THEOS_STAGING_DIR)/usr/include/libprefs/prefs.h$(ECHO_END)

after-stage::
	$(FAKEROOT) chown -R 0:80 $(THEOS_STAGING_DIR)
	mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceBundles $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences

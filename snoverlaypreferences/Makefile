include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = snoverlaypreferences
snoverlaypreferences_FILES = SNOWRootListController.m
snoverlaypreferences_INSTALL_PATH = /Library/PreferenceBundles
snoverlaypreferences_FRAMEWORKS = UIKit
snoverlaypreferences_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/snoverlaypreferences.plist$(ECHO_END)

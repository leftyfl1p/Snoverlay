include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Snoverlay
Snoverlay_FILES = Tweak.xm ./FallingSnow/UIView+XMASFallingSnow.m ./FallingSnow/XMASFallingSnowView.m

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

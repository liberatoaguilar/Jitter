include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Jitter
Jitter_FILES = Tweak.xm
DEBUG=0

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += jitterprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

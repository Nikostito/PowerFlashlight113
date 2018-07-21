PACKAGE_VERSION = 1.0
FINALPACKAGE=1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PowerFlashlight113
PowerFlashlight113_FILES = Tweak.xm
PowerFlashlight113_PRIVATE_FRAMEWORKS = AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

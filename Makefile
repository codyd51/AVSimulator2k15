ARCHS = armv7 arm64
TARGET = iphone:clang:latest:latest
THEOS_BUILD_DIR = Packages
GO_EASY_ON_ME = 1

include theos/makefiles/common.mk

TWEAK_NAME = AVSimulator2k15
AVSimulator2k15_FILES = Tweak.xm
AVSimulator2k15_FRAMEWORKS = UIKit
AVSimulator2k15_FRAMEWORKS += CoreGraphics
AVSimulator2k15_FRAMEWORKS += QuartzCore
AVSimulator2k15_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

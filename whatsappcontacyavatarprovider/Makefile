ARCHS = arm64 arm64e
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = WhatsappContacyAvatarProvider

WhatsappContacyAvatarProvider_FILES = WhatsappAvatarProvider.mm
WhatsappContacyAvatarProvider_INSTALL_PATH = /Library/Contacy/ContactImageProvider
WhatsappContacyAvatarProvider_FRAMEWORKS = UIKit
WhatsappContacyAvatarProvider_LDFLAGS = ./ContactNotificationKit.tbd
WhatsappContacyAvatarProvider_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

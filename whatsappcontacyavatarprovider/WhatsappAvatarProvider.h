#import "Headers/CNContactAvatarProvider.h"
#import "Headers/CNNotification.h"

@interface WhatsappAvatarProvider : CNContactAvatarProvider

- (UIImage *)fetchAvatarForContactNotification:(CNNotification *)notification;

@end

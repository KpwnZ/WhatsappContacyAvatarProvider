#import "WhatsappAvatarProvider.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NCNotificationRequest : NSObject
@property(nonatomic, copy) NSString *threadIdentifier;
@end

NSString *findFolder(NSString *appName, NSString *dir) {
	NSFileManager *manager = [NSFileManager defaultManager];

	NSError *error = nil;
	NSArray *folders = [manager contentsOfDirectoryAtPath:dir error:&error];

	if (!error) {
		for (NSString *folder in folders) {
			NSString *folderPath = [dir stringByAppendingString:folder];
			NSArray *items = [manager contentsOfDirectoryAtPath:folderPath error:&error];

			for (NSString *itemPath in items) {
				if ([itemPath rangeOfString:@".com.apple.mobile_container_manager.metadata.plist"].location != NSNotFound) {
					NSString *fullpath = [NSString stringWithFormat:@"%@/%@", folderPath, itemPath];
					NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:fullpath];

					NSString *mcmmetadata = dict[@"MCMMetadataIdentifier"];
					if (mcmmetadata && [mcmmetadata.lowercaseString isEqualToString:appName.lowercaseString]) {
						return folderPath;
					}
				}
			}
		}
	}
	return nil;
}

NSString *findSharedFolder(NSString *appName) {
	NSString *dir = @"/var/mobile/Containers/Shared/AppGroup/";
	NSString *result = findFolder(appName, dir);
	return result;
}

@implementation WhatsappAvatarProvider

- (UIImage *)fetchAvatarForContactNotification:(CNNotification *)notification {
	NCNotificationRequest *request = [notification request];
	NSString *threadId = [request threadIdentifier];
	NSString *chatId = [threadId componentsSeparatedByString:@"@"][0];
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSArray *identifiers = @[ @"group.net.whatsapp.WhatsApp.shared", @"group.net.whatsapp.WhatsAppSMB.shared" ];

	for (NSString *identifier in identifiers) {
		NSString *file;
		NSString *profilePicture;
		NSString *containerPath = findSharedFolder(identifier);
		NSString *picturesPath = [NSString stringWithFormat:@"%@/Media/Profile", containerPath];
		NSDirectoryEnumerator *files = [fileManager enumeratorAtPath:picturesPath];

		while (file = [files nextObject]) {
			NSArray *parts = [file componentsSeparatedByString:@"-"];

			// DMs
			if ([parts count] == 2) {
				if ([chatId isEqualToString:parts[0]]) {
					profilePicture = file;
				}
			}

			// Groups
			if ([parts count] == 3) {
				if ([chatId isEqualToString:[NSString stringWithFormat:@"%@-%@", parts[0], parts[1]]]) {
					profilePicture = file;
				}
			}

			if (profilePicture) {
				NSString *imagePath = [NSString stringWithFormat:@"%@/%@", picturesPath, profilePicture];
				UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
				return image;
			}
		}
	}
	return nil;
}

@end

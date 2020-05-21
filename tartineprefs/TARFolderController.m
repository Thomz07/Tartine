#import "TARFolderController.h"

@implementation TARFolderController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Folders" target:self];
	}

	return _specifiers;
}

@end
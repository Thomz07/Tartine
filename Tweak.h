#import <UIKit/UIKit.h>

// interfaces

@interface _SBFakeBlurView : UIView
@end

@interface _UIVisualEffectSubview : UIView
@end

@interface _UIVisualEffectBackdropView : UIView
@end

@interface MTMaterialView : UIView
@end

// preferences bool

BOOL enabled;

#define PLIST_PATH @"/User/Library/Preferences/com.thomz.tartineprefs.plist"
#define kIdentifier @"com.thomz.tartineprefs"
#define kSettingsChangedNotification (CFStringRef)@"com.thomz.tartineprefs.plist/reload"
#define kSettingsPath @"/var/mobile/Library/Preferences/com.thomz.tartineprefs.plist"

NSDictionary *prefs;

static void reloadPrefs() {
    if ([NSHomeDirectory() isEqualToString:@"/var/mobile"]) {
        CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

        if (keyList) {
            prefs = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));

            if (!prefs) {
                prefs = [NSDictionary new];
            }
            CFRelease(keyList);
        }
    } else {
        prefs = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
    }
}

static BOOL boolValueForKey(NSString *key, BOOL defaultValue) {
    return (prefs && [prefs objectForKey:key] ? [[prefs objectForKey:key] boolValue] : defaultValue);
}


/*static double numberForValue(NSString *key, double defaultValue) {
	return (prefs && [prefs objectForKey:key] ? [[prefs objectForKey:key] doubleValue] : defaultValue);
}*/

static void preferencesChanged() {
    CFPreferencesAppSynchronize((CFStringRef)kIdentifier);
    reloadPrefs();

    enabled = boolValueForKey(@"enabled", YES);
}

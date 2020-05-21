#import <UIKit/UIKit.h>

// interfaces

@interface SBFolderBackgroundView : UIView
@property (nonatomic, strong) UIVisualEffectView *blurView;
@end

@interface _UICustomBlurEffect : UIBlurEffect
@property (assign,nonatomic) double grayscaleTintLevel; 
@property (assign,nonatomic) double grayscaleTintAlpha; 
@property (assign,nonatomic) bool lightenGrayscaleWithSourceOver; 
@property (nonatomic,retain) UIColor* colorTint; 
@property (assign,nonatomic) double colorTintAlpha; 
@property (assign,nonatomic) double colorBurnTintLevel; 
@property (assign,nonatomic) double colorBurnTintAlpha; 
@property (assign,nonatomic) double darkeningTintAlpha; 
@property (assign,nonatomic) double darkeningTintHue; 
@property (assign,nonatomic) double darkeningTintSaturation; 
@property (assign,nonatomic) bool darkenWithSourceOver; 
@property (assign,nonatomic) double blurRadius; 
@property (assign,nonatomic) double saturationDeltaFactor; 
@property (assign,nonatomic) double scale; 
@property (assign,nonatomic) double zoom;
@end

// global preferences bool

BOOL enabled;

// folders prefs

double folders_container_blurFactor;
double folders_container_colorTintAlpha;
double folders_container_saturationDeltafactor;
double folders_container_red;
double folders_container_green;
double folders_container_blue;
float folders_container_red_float;
float folders_container_green_float;
float folders_container_blue_float;

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


static double numberForValue(NSString *key, double defaultValue) {
	return (prefs && [prefs objectForKey:key] ? [[prefs objectForKey:key] doubleValue] : defaultValue);
}

static void preferencesChanged() {
    CFPreferencesAppSynchronize((CFStringRef)kIdentifier);
    reloadPrefs();

    // global

    enabled = boolValueForKey(@"enabled", YES);

    // folder

    folders_container_blurFactor = numberForValue(@"folders_container_blurFactor", 40);
    folders_container_colorTintAlpha = numberForValue(@"folders_container_colorTintAlpha", 0.3);
    folders_container_saturationDeltafactor = numberForValue(@"folders_container_saturationDeltafactor",1.9);
    folders_container_red = numberForValue(@"folders_container_red", 40);
    folders_container_green = numberForValue(@"folders_container_green", 0.3);
    folders_container_blue = numberForValue(@"folders_container_blue",1.9);

    folders_container_red_float = (float) folders_container_red;
    folders_container_green_float = (float) folders_container_green;
    folders_container_blue_float = (float) folders_container_blue;
}

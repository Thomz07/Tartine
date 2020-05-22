#import "TARFolderController.h"

_UICustomBlurEffect *blurViewNotification;
UIVisualEffectView *blurView;

@implementation TARFolderController

void updateFolderBlurView() { 

	prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.tartineprefs"];

	double folders_container_blurFactor = [[prefs valueForKey:@"folders_container_blurFactor"] doubleValue];
	double folders_container_colorTintAlpha = [[prefs valueForKey:@"folders_container_colorTintAlpha"] doubleValue];
	double folders_container_saturationDeltafactor = [[prefs valueForKey:@"folders_container_saturationDeltafactor"] doubleValue];
	double folders_container_redFactor = [[prefs valueForKey:@"folders_container_redFactor"] doubleValue];
	double folders_container_greenFactor = [[prefs valueForKey:@"folders_container_greenFactor"] doubleValue];
	double folders_container_blueFactor = [[prefs valueForKey:@"folders_container_blueFactor"] doubleValue];
	float folders_container_red_float = (float) folders_container_redFactor;
	float folders_container_green_float = (float) folders_container_greenFactor;
	float folders_container_blue_float = (float) folders_container_blueFactor;

	blurViewNotification = [[_UICustomBlurEffect alloc] init];
	blurViewNotification.blurRadius = folders_container_blurFactor;
	blurViewNotification.colorTint = [UIColor colorWithRed:folders_container_red_float green:folders_container_green_float blue:folders_container_blue_float alpha:1.0];
	blurViewNotification.colorTintAlpha = folders_container_colorTintAlpha;
	blurViewNotification.saturationDeltaFactor = folders_container_saturationDeltafactor;
	blurViewNotification.scale = ([UIScreen mainScreen].scale);
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Folders" target:self];
	}

	return _specifiers;
}

-(void)viewDidLoad {

	[super viewDidLoad];

	UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
    self.navigationItem.rightBarButtonItem = applyButton;

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)updateFolderBlurView, CFSTR("com.thomz.tartineprefs/foldersBlurView"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

-(void)respring:(id)sender {

	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Respring"
							message:@"Are you sure you want to Respring"
							preferredStyle:UIAlertControllerStyleActionSheet];

		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel
		handler:^(UIAlertAction * action) {}];

		UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive
		handler:^(UIAlertAction * action) {
			NSTask *t = [[NSTask alloc] init];
			[t setLaunchPath:@"usr/bin/sbreload"];
			[t launch];
		}];

		[alert addAction:defaultAction];
		[alert addAction:yes];
		[self presentViewController:alert animated:YES completion:nil];
}

@end

@implementation TartinePreviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {

	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if(self){
		
		UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurViewNotification];
		blurView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 300)/2,20,300,60);
		blurView.layer.masksToBounds = YES;
		blurView.layer.cornerRadius = 20;

		[self updateBlur];
		[self addSubview:blurView];

	}
	
	return self;
}

-(void)updateBlur {
	updateFolderBlurView();
}

@end
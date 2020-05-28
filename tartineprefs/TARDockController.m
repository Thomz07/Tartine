#import "TARDockController.h"

_UICustomBlurEffect *blurEffectNotification;
UIVisualEffectView *blurView;

@implementation TARDockController

void updateDockBlurView() { 

	prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.tartineprefs"];

	blurEffectNotification = [[_UICustomBlurEffect alloc]init];

	double dock_blurFactor = [[prefs valueForKey:@"dock_blurFactor"] doubleValue];
	double dock_colorTintAlpha = [[prefs valueForKey:@"dock_colorTintAlpha"] doubleValue];
	double dock_saturationDeltafactor = [[prefs valueForKey:@"dock_saturationDeltafactor"] doubleValue];
	double dock_redFactor = [[prefs valueForKey:@"dock_redFactor"] doubleValue];
	double dock_greenFactor = [[prefs valueForKey:@"dock_greenFactor"] doubleValue];
	double dock_blueFactor = [[prefs valueForKey:@"dock_blueFactor"] doubleValue];
	float dock_redFactor_float = (float) dock_redFactor;
	float dock_greenFactor_float = (float) dock_greenFactor;
	float dock_blueFactor_float = (float) dock_blueFactor;//

	blurEffectNotification = [[_UICustomBlurEffect alloc] init];
	blurEffectNotification.blurRadius = dock_blurFactor;
	blurEffectNotification.colorTint = [UIColor colorWithRed:dock_redFactor_float green:dock_greenFactor_float blue:dock_blueFactor_float alpha:1.0];
	blurEffectNotification.colorTintAlpha = dock_colorTintAlpha;
	blurEffectNotification.saturationDeltaFactor = dock_saturationDeltafactor;
	blurEffectNotification.scale = ([UIScreen mainScreen].scale);

	blurView.effect = blurEffectNotification;
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Dock" target:self];
	}

	return _specifiers;
}

-(void)viewDidLoad {

	[super viewDidLoad];

	updateDockBlurView();

	UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
    self.navigationItem.rightBarButtonItem = applyButton;

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)updateDockBlurView, CFSTR("com.thomz.tartineprefs/foldersBlurView"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
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

@implementation TartinePreviewCellDock

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {

	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if(self){

		updateDockBlurView();
		
		blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffectNotification];
		blurView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 300)/2,20,300,60);
		blurView.layer.masksToBounds = YES;
		blurView.layer.cornerRadius = 20;

		NSBundle *bundle = [[NSBundle alloc]initWithPath:@"/var/mobile/Library/SpringBoard"];
		UIImage *wallpaperImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"HomeBackgroundThumbnail" ofType:@"jpg"]];
		UIImageView *wallpaperView = [[UIImageView alloc]initWithImage:wallpaperImage];
		wallpaperView.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,100);

		UILabel *previewLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,40,[UIScreen mainScreen].bounds.size.width,20)];
		previewLabel.text = @"Live preview blur";
		previewLabel.textAlignment = NSTextAlignmentCenter;

		[self addSubview:previewLabel];
		[self addSubview:blurView];
		[self addSubview:wallpaperView];
		[self bringSubviewToFront:blurView];
		[self bringSubviewToFront:previewLabel];

	}
	
	return self;
}

@end


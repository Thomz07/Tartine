#import "TARFolderController.h"

_UICustomBlurEffect *blurEffectNotification;
UIVisualEffectView *blurView;

@implementation TARFolderController

void updateFolderBlurView() { 

	prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.tartineprefs"];

	blurEffectNotification = [[_UICustomBlurEffect alloc]init];

	double folders_container_blurFactor = [[prefs valueForKey:@"folders_container_blurFactor"] doubleValue];
	double folders_container_colorTintAlpha = [[prefs valueForKey:@"folders_container_colorTintAlpha"] doubleValue];
	double folders_container_saturationDeltafactor = [[prefs valueForKey:@"folders_container_saturationDeltafactor"] doubleValue];
	double folders_container_redFactor = [[prefs valueForKey:@"folders_container_redFactor"] doubleValue];
	double folders_container_greenFactor = [[prefs valueForKey:@"folders_container_greenFactor"] doubleValue];
	double folders_container_blueFactor = [[prefs valueForKey:@"folders_container_blueFactor"] doubleValue];
	float folders_container_red_float = (float) folders_container_redFactor;
	float folders_container_green_float = (float) folders_container_greenFactor;
	float folders_container_blue_float = (float) folders_container_blueFactor;

	blurEffectNotification = [[_UICustomBlurEffect alloc] init];
	blurEffectNotification.blurRadius = folders_container_blurFactor;
	blurEffectNotification.colorTint = [UIColor colorWithRed:folders_container_red_float green:folders_container_green_float blue:folders_container_blue_float alpha:1.0];
	blurEffectNotification.colorTintAlpha = folders_container_colorTintAlpha;
	blurEffectNotification.saturationDeltaFactor = folders_container_saturationDeltafactor;
	blurEffectNotification.scale = ([UIScreen mainScreen].scale);

	blurView.effect = blurEffectNotification;
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

		updateFolderBlurView();
		
		blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffectNotification];
		blurView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 300)/2,20,300,60);
		blurView.layer.masksToBounds = YES;
		blurView.layer.cornerRadius = 20;

		NSBundle *bundle = [[NSBundle alloc]initWithPath:@"/var/mobile/Library/SpringBoard"];
		UIImage *wallpaperImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"LockBackgroundThumbnail" ofType:@"jpg"]];
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
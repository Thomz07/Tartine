#import "Tweak.h"

%group Tweak

%hook SBFolderBackgroundView
%property (nonatomic, strong) UIVisualEffectView *blurView;

-(void)layoutSubviews { // i know using layoutSubviews is not good, will fix asap
	%orig;

	BOOL foldedInstalled = (([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Folded.dylib"]) ? YES : NO);

	float folders_container_red_float = (float) folders_container_redFactor;
	float folders_container_green_float = (float) folders_container_greenFactor;
	float folders_container_blue_float = (float) folders_container_blueFactor;

	_UICustomBlurEffect *blur = [[_UICustomBlurEffect alloc] init];
	blur.blurRadius = folders_container_blurFactor;
	blur.colorTint = [UIColor colorWithRed:folders_container_red_float green:folders_container_green_float blue:folders_container_blue_float alpha:1.0];
	blur.colorTintAlpha = folders_container_colorTintAlpha;
	blur.saturationDeltaFactor = folders_container_saturationDeltafactor;
	blur.scale = ([UIScreen mainScreen].scale);
	
	self.blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
	self.blurView.frame = self.bounds;

	if(folders_container_enable && !foldedInstalled){
		[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
		[self addSubview:self.blurView];
	}
}

%end

/*%hook SBFolderControllerBackgroundView
%property (nonatomic, strong) UIVisualEffectView *blurView;

-(void)layoutSubviews {

	UIView *blurViewMaterial = MSHookIvar<UIView *>(self,"_blurView");

	_UICustomBlurEffect *blur = [[_UICustomBlurEffect alloc] init];
	blur.blurRadius = 40;
	blur.colorTint = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	blur.colorTintAlpha = 0.3;
	blur.saturationDeltaFactor = 1.9;
	blur.scale = ([UIScreen mainScreen].scale);

	self.blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
	self.blurView.frame = self.bounds;

	blurViewMaterial = self.blurView;
	[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[self addSubview:self.blurView];
}

%end*/ // WIP, this is laggy and the view doesn't appear with a fade effect

%hook SBDockView
%property (nonatomic, strong) UIVisualEffectView *blurView;

-(void)layoutSubviews { // i know using layoutSubviews is not good, will fix asap

	%orig;

	float dock_redFactor_float = (float) dock_redFactor;
	float dock_greenFactor_float = (float) dock_greenFactor;
	float dock_blueFactor_float = (float) dock_blueFactor;

	UIView *backgroundView = MSHookIvar<UIView *>(self,"_backgroundView");

	_UICustomBlurEffect *blur = [[_UICustomBlurEffect alloc] init];
	blur.blurRadius = dock_blurFactor;
	blur.colorTint = [UIColor colorWithRed:dock_redFactor_float green:dock_greenFactor_float blue:dock_blueFactor_float alpha:1.0];
	blur.colorTintAlpha = dock_colorTintAlpha;
	blur.saturationDeltaFactor = dock_saturationDeltafactor;
	blur.scale = ([UIScreen mainScreen].scale);

	self.blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
	self.blurView.frame = self.bounds;

	if(dock_enable){
		[[backgroundView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
		[backgroundView addSubview:self.blurView];
	}

}

%end

%end

%ctor{

	preferencesChanged();

	if(enabled){
		%init(Tweak);
	}

}


#import "Tweak.h"

%group Tweak

%hook SBFolderBackgroundView
%property (nonatomic, strong) UIVisualEffectView *blurView;

-(void)layoutSubviews {
	%orig;

	_UICustomBlurEffect *blur = [[_UICustomBlurEffect alloc] init];
	blur.blurRadius = folders_container_blurFactor;
	blur.colorTint = [UIColor whiteColor];
	blur.colorTintAlpha = folders_container_colorTintAlpha;
	blur.saturationDeltaFactor = folders_container_saturationDeltafactor;
	blur.scale = ([UIScreen mainScreen].scale);
	
	self.blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
	self.blurView.frame = self.bounds;

	MSHookIvar<UIVisualEffectView *>(self, "_blurView") = self.blurView;
	[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[self addSubview:self.blurView];
}

%end

%end

%ctor{

	preferencesChanged();
	if(enabled){
		%init(Tweak);
	}

}


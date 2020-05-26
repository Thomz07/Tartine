#import "Tweak.h"

%group Tweak

%hook SBFolderBackgroundView
%property (nonatomic, strong) UIVisualEffectView *blurView;

-(void)layoutSubviews {
	%orig;

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

	if(folders_container_enable){
		[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
		[self addSubview:self.blurView];
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


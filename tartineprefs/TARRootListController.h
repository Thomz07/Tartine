#import "TARRequirements.h"

@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(id)arg1;
@end

@interface TARRootListController : PSListController
@end

@interface KRLabeledSliderCell : PSSliderTableCell
@end

@interface TartineHeaderCell : PSTableCell <PreferencesTableCustomView> {
    UIView *bgView;
    UILabel *packageNameLabel;
    UILabel *developerLabel;
    UILabel *versionLabel;
}
@end




#import <UIKit/UIKit.h>

#define BSPUserInfoViewMaleSelected @"BSPUserInfoViewMaleSelected"
#define BSPUserInfoViewFemaleSelected @"BSPUserInfoViewFemaleSelected"

@interface BSPUserInfoView : UIView
-(void)setMaleSelected:(BOOL)selected;
-(void)setFemaleSelected:(BOOL)selected;
@end

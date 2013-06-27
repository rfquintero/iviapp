#import <UIKit/UIKit.h>

#define BSPUserInfoViewMaleSelected @"BSPUserInfoViewMaleSelected"
#define BSPUserInfoViewFemaleSelected @"BSPUserInfoViewFemaleSelected"
#define BSPUserInfoViewFirstNameChanged @"BSPUserInfoViewFirstNameChanged"
#define BSPUserInfoViewLastNameChanged @"BSPUserInfoViewLastNameChanged"
#define BSPUserInfoViewGroupChanged @"BSPUserInfoViewGroupChanged"
#define BSPUserInfoViewValueKey @"BSPUserInfoViewValueKey"

@interface BSPUserInfoView : UIView
-(void)setMaleSelected:(BOOL)selected;
-(void)setFemaleSelected:(BOOL)selected;
-(void)clearFields;
@end

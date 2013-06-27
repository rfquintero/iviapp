#import <UIKit/UIKit.h>
#import "BSPApplicationState.h"
#import "BSPUserModel.h"

@interface BSPStudyControllerViewController : UIViewController
-(id)initWithAppState:(BSPApplicationState*)applicationState userModel:(BSPUserModel*)userModel;
@end

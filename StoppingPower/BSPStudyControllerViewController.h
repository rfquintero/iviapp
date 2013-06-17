#import <UIKit/UIKit.h>
#import "BSPApplicationState.h"
#import "BSPStudy.h"

@interface BSPStudyControllerViewController : UIViewController
-(id)initWithAppState:(BSPApplicationState*)applicationState study:(BSPStudy*)study;
@end

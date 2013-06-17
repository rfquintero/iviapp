#import <UIKit/UIKit.h>
#import "BSPStudy.h"

#define BSPStudyPairViewCompleted @"BSPStudyPairViewCompleted"
#define BSPStudyPairViewCancelled @"BSPStudyPairViewCancelled"

@interface BSPStudyPairView : UIView
-(id)initWithFrame:(CGRect)frame study:(BSPStudy*)study;
@end

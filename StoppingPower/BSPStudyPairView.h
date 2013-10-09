#import <UIKit/UIKit.h>
#import "BSPStudy.h"

#define BSPStudyPairViewCompleted @"BSPStudyPairViewCompleted"
#define BSPStudyPairViewCancelled @"BSPStudyPairViewCancelled"
#define BSPStudyPairViewImageSelected @"BSPStudyPairViewImageSelected"
#define BSPStudyPairViewImageKey @"BSPStudyPairViewImageKey"

@interface BSPStudyPairView : UIView
-(id)initWithFrame:(CGRect)frame study:(BSPStudy*)study pairs:(NSArray*)pairs;
-(void)startStudyTimer;
-(void)killTimer;
@end

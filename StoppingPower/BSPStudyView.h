#import <UIKit/UIKit.h>
#import "BSPStudy.h"

@interface BSPStudyView : UIView
@property (nonatomic, readonly) BSPStudy *selectedStudy;
-(void)setStudies:(NSArray*)studies;
-(void)refresh;
@end

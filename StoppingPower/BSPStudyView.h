#import <UIKit/UIKit.h>
#import "BSPStudy.h"

#define BSPStudyViewStudySelected @"BSPStudyViewStudySelected"

@interface BSPStudyView : UIView
@property (nonatomic, readonly) BSPStudy *selectedStudy;
-(void)setStudies:(NSArray*)studies;
-(void)refresh;
-(void)clearSelection;
@end

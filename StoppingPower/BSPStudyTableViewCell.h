#import <UIKit/UIKit.h>
#import "BSPStudy.h"

@interface BSPStudyTableViewCell : UITableViewCell
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
-(void)setStudy:(BSPStudy*)study number:(NSUInteger)number;
-(void)setCellSelected:(BOOL)selected;
+(CGFloat)heightForCell;
@end

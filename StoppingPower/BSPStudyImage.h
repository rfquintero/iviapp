#import <UIKit/UIKit.h>

@interface BSPStudyImage : UIView
-(void)setImageWithURL:(NSString*)imageUrl caption:(NSString*)caption;
-(void)addTarget:(id)target action:(SEL)action;
@end

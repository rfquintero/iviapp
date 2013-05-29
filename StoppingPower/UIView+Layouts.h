#import <UIKit/UIKit.h>

#define CGSizeUnbounded CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
#define UIViewFlexibleHeightWidth UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth


@interface UIView (Layouts)

-(void)centerInBounds:(CGRect)bounds offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY;
-(void)centerHorizonallyAtY:(CGFloat)y inBounds:(CGRect)bounds withSize:(CGSize)size;
-(void)centerHorizonallyAtY:(CGFloat)y inBounds:(CGRect)bounds thatFits:(CGSize)size;
-(void)centerVerticallyAtX:(CGFloat)x inBounds:(CGRect)bounds withSize:(CGSize)size;
-(void)centerVerticallyAtX:(CGFloat)x inBounds:(CGRect)bounds thatFits:(CGSize)size;
-(void)centerVerticallyAtX:(CGFloat)x inBounds:(CGRect)bounds withWidth:(CGFloat)width;
-(void)centerVerticallyAtX:(CGFloat)x inBounds:(CGRect)bounds withSize:(CGSize)size offsetY:(CGFloat)offsetY;
-(void)centerVerticallyAtX:(CGFloat)x inBounds:(CGRect)bounds thatFits:(CGSize)size offsetY:(CGFloat)offsetY;

-(void)setFrameAtOrigin:(CGPoint)origin;
-(void)setFrameAtOriginThatFitsUnbounded:(CGPoint)origin;
-(void)setFrameAtOrigin:(CGPoint)origin thatFits:(CGSize)size;
-(void)snapToGrid;

@end

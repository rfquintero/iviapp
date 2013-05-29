#import "UIView+Layouts.h"

@implementation UIView (Layouts)

-(void)centerInBounds:(CGRect)bounds offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY {
    CGSize sz = [self sizeThatFits:CGSizeMake(bounds.size.width - 2 * offsetX, bounds.size.height - offsetY)];
    self.frame = CGRectMake(offsetX + (bounds.size.width-sz.width)/2, offsetY, sz.width - 2 * offsetX, sz.height);
}

-(void)centerHorizonallyAtY:(CGFloat)y inBounds:(CGRect)bounds withSize:(CGSize)size {
    self.frame = CGRectMake(roundf((bounds.size.width-size.width)/2), y, size.width, size.height);
}

-(void)centerHorizonallyAtY:(CGFloat)y inBounds:(CGRect)bounds thatFits:(CGSize)size {
    [self centerHorizonallyAtY:y inBounds:bounds withSize:[self sizeThatFits:size]];
}

-(void)centerVerticallyAtX:(CGFloat)x inBounds:(CGRect)bounds withSize:(CGSize)size {
    [self centerVerticallyAtX:x inBounds:bounds withSize:size offsetY:0];
}

-(void)centerVerticallyAtX:(CGFloat)x inBounds:(CGRect)bounds thatFits:(CGSize)size {
    [self centerVerticallyAtX:x inBounds:bounds withSize:[self sizeThatFits:size] offsetY:0];
}

-(void)centerVerticallyAtX:(CGFloat)x inBounds:(CGRect)bounds withWidth:(CGFloat)width {
    CGSize size = [self sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    size.width = width;
    [self centerVerticallyAtX:x inBounds:bounds withSize:size];
}

-(void)centerVerticallyAtX:(CGFloat)x inBounds:(CGRect)bounds withSize:(CGSize)size offsetY:(CGFloat)offsetY {
    self.frame = CGRectMake(x, roundf((bounds.size.height-size.height)/2) + offsetY, size.width, size.height);
}

-(void)centerVerticallyAtX:(CGFloat)x inBounds:(CGRect)bounds thatFits:(CGSize)size offsetY:(CGFloat)offsetY {
    [self centerVerticallyAtX:x inBounds:bounds withSize:[self sizeThatFits:size] offsetY:offsetY];
}

-(void)setFrameAtOrigin:(CGPoint)origin {
    self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
}

-(void)setFrameAtOriginThatFitsUnbounded:(CGPoint)origin {
    [self setFrameAtOrigin:origin thatFits:CGSizeUnbounded];
}

-(void)setFrameAtOrigin:(CGPoint)origin thatFits:(CGSize)size {
    CGSize fitSize = [self sizeThatFits:size];
    self.frame = CGRectMake(origin.x, origin.y, fitSize.width, fitSize.height);
}

-(void)snapToGrid {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x = roundf(self.frame.origin.x * scale) / scale;
    CGFloat y = roundf(self.frame.origin.y * scale) / scale;
    CGFloat width = roundf(self.frame.size.width * scale) / scale;
    CGFloat height = roundf(self.frame.size.height * scale) / scale;
    self.frame = CGRectMake(x, y, width, height);
}

@end

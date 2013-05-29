#import "BSPUI.h"

@implementation BSPUI
+(UIFont*)fontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+(UIFont*)boldFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];    
}

+(UIFont*)italicFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Italic" size:size];
}

+(UIFont*)boldItalicFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:size];
}

+(UILabel*)labelWithFont:(UIFont*)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

@end

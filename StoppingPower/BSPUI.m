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

+(UIFont*)myriadFontOfSize:(CGFloat)size {
   return [UIFont fontWithName:@"MyriadPro-Regular" size:size];
}

+(UIFont*)myriadBoldFontOfSize:(CGFloat)size {
   return [UIFont fontWithName:@"MyriadPro-Bold" size:size];
}

+(UIFont*)myriadItaliceFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"MyriadPro-It" size:size];
}

+(UIFont*)myriadBoldItalicFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"MyriadPro-BoldIt" size:size];
}

+(UILabel*)labelWithFont:(UIFont*)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    return label;
}



@end

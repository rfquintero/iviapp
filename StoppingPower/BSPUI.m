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

+(UIButton*)blackButtonWithTitle:(NSString*)title {
    UIImage *buttonImage = [UIImage imageNamed:@"button_black"];
    buttonImage = [buttonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTintColor:[UIColor blackColor]];
    [button.titleLabel setFont:[BSPUI boldFontOfSize:16.0f]];
    [button setContentEdgeInsets:UIEdgeInsetsMake(2, 10, 2, 10)];
    return button;
    
}



@end

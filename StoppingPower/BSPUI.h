//
//  BSPUI.h
//  StoppingPower
//
//  Created by Ruben Quintero on 5/28/13.
//  Copyright (c) 2013 Ruben Quintero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Layouts.h"
#import "UIColor+Custom.h"

@interface BSPUI : NSObject
+(UIFont*)fontOfSize:(CGFloat)size;
+(UIFont*)boldFontOfSize:(CGFloat)size;
+(UIFont*)italicFontOfSize:(CGFloat)size;
+(UIFont*)boldItalicFontOfSize:(CGFloat)size;

+(UIFont*)myriadFontOfSize:(CGFloat)size;
+(UIFont*)myriadBoldFontOfSize:(CGFloat)size;
+(UIFont*)myriadItaliceFontOfSize:(CGFloat)size;
+(UIFont*)myriadBoldItalicFontOfSize:(CGFloat)size;

+(UILabel*)labelWithFont:(UIFont*)font;
@end

//
//  BSPPanelView.h
//  StoppingPower
//
//  Created by Ruben Quintero on 5/28/13.
//  Copyright (c) 2013 Ruben Quintero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSPPanelView : UIView
- (id)initWithFrame:(CGRect)frame contentView:(UIView*)contentView;
-(void)setTitle:(NSString*)title;
-(void)setRightButtonTitle:(NSString*)title target:(id)target action:(SEL)action;
@end

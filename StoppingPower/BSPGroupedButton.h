//
//  BSPGroupedButton.h
//  StoppingPower
//
//  Created by Ruben Quintero on 5/29/13.
//  Copyright (c) 2013 Ruben Quintero. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BSPGroupedButtonSelected @"BSPGroupedButtonSelected"

@interface BSPGroupedButton : UIView

-(void)setSelected:(BOOL)selected;
-(void)setTitle:(NSString*)title;
@end

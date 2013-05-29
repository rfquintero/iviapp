//
//  BSPUserInfoView.h
//  StoppingPower
//
//  Created by Ruben Quintero on 5/28/13.
//  Copyright (c) 2013 Ruben Quintero. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BSPUserInfoViewMaleSelected @"BSPUserInfoViewMaleSelected"
#define BSPUserInfoViewFemaleSelected @"BSPUserInfoViewFemaleSelected"

@interface BSPUserInfoView : UIView
-(void)setMaleSelected:(BOOL)selected;
-(void)setFemaleSelected:(BOOL)selected;
@end

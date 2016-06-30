//
//  BSPUserInfoCell.h
//  StoppingPower
//
//  Created by Ruben Quintero on 5/29/13.
//  Copyright (c) 2013 Ruben Quintero. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BSPUserInfoCellDelegate <UITextFieldDelegate>
-(void)textFieldChanged:(UITextField*)textField;
@end

@interface BSPUserInfoCell : UITableViewCell
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
-(void)setTitle:(NSString*)title;
-(void)setInputTag:(NSInteger)tag;
-(void)setInputDelegate:(id<BSPUserInfoCellDelegate>)delegate;
-(void)clear;
@end

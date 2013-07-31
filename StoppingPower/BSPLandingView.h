#import <UIKit/UIKit.h>

@protocol BSPLandingViewDelegate <NSObject>
-(void)maleSelected;
-(void)femaleSelected;
-(void)settingsSelected;
-(void)startSelected;
-(void)refreshSelected;
-(void)firstNameChanged:(NSString*)value;
-(void)lastNameChanged:(NSString*)value;
-(void)groupChanged:(NSString*)value;
@end

@interface BSPLandingView : UIScrollView
-(void)setMaleSelected:(BOOL)selected;
-(void)setFemaleSelected:(BOOL)selected;
-(void)setStartEnabled:(BOOL)enabled;
-(void)clearFields;
-(void)setLandingDelegate:(id<BSPLandingViewDelegate>)delegate;

-(void)animateOffsetX:(CGFloat)offsetX showInfo:(BOOL)show;
-(void)setLoading:(BOOL)loading animated:(BOOL)animated;
-(void)stopLoadingIndicator;
@end

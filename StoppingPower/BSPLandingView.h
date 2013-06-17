#import <UIKit/UIKit.h>

@protocol BSPLandingViewDelegate <NSObject>
-(void)maleSelected;
-(void)femaleSelected;
-(void)settingsSelected;
@end

@interface BSPLandingView : UIScrollView
-(void)setMaleSelected:(BOOL)selected;
-(void)setFemaleSelected:(BOOL)selected;
-(void)setLandingDelegate:(id<BSPLandingViewDelegate>)delegate;
-(void)animateOffsetX:(CGFloat)offsetX showInfo:(BOOL)show;
-(void)setLoading:(BOOL)loading animated:(BOOL)animated;
@end

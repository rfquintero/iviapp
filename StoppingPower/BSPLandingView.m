#import "BSPLandingView.h"
#import "BSPPanelView.h"
#import "BSPUserInfoView.h"
#import "BSPUI.h"

@interface BSPLandingView()
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *logoView;
@property (nonatomic) UIButton *settingsButton;
@property (nonatomic) BSPPanelView *panelView;
@property (nonatomic) BSPUserInfoView *userInfoView;
@property (nonatomic) UIActivityIndicatorView *spinner;
@property (nonatomic) UILabel *loadingLabel;
@property (nonatomic, weak) id<BSPLandingViewDelegate> landingDelegate;
@property (nonatomic) CGFloat offsetX;
@property (nonatomic) BOOL loading;
@end

@implementation BSPLandingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"brado_logo"]];
        
        BSPUserInfoView *userInfoView = [[BSPUserInfoView alloc] initWithFrame:CGRectZero];
        self.userInfoView = userInfoView;
        
        BSPPanelView *panelView = [[BSPPanelView alloc] initWithFrame:CGRectZero contentView:userInfoView];
        [panelView setTitle:@"User Information"];
        [panelView setRightButtonTitle:@"Start Test" target:self action:@selector(startSelected)];
        self.panelView = panelView;
        
        UIImage *buttonImage = [UIImage imageNamed:@"button_black"];
        buttonImage = [buttonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
        
        UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingsButton setTitle:@"Select Study" forState:UIControlStateNormal];
        [settingsButton addTarget:self action:@selector(settingsSelected) forControlEvents:UIControlEventTouchUpInside];
        [settingsButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [settingsButton setTintColor:[UIColor blackColor]];
        [settingsButton.titleLabel setFont:[BSPUI boldFontOfSize:16.0f]];
        [settingsButton setContentEdgeInsets:UIEdgeInsetsMake(2, 10, 2, 10)];
        self.settingsButton = settingsButton;
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.spinner startAnimating];
        [self.spinner sizeToFit];
        
        self.loadingLabel = [BSPUI labelWithFont:[BSPUI boldFontOfSize:20.0f]];
        self.loadingLabel.text = @"Loading...";
        self.loadingLabel.textColor = [UIColor whiteColor];
        [self.loadingLabel sizeToFit];
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.logoView];
        [self addSubview:self.spinner];
        [self addSubview:self.loadingLabel];
        [self addSubview:panelView];
        [self addSubview:settingsButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(maleSelected) name:BSPUserInfoViewMaleSelected object:self.userInfoView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(femaleSelected) name:BSPUserInfoViewFemaleSelected object:self.userInfoView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstNameChanged:) name:BSPUserInfoViewFirstNameChanged object:self.userInfoView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lastNameChanged:) name:BSPUserInfoViewLastNameChanged object:self.userInfoView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupChanged:) name:BSPUserInfoViewGroupChanged object:self.userInfoView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect boundsWithOffset = CGRectMake(0, 0, self.bounds.size.width-self.offsetX, self.bounds.size.height);
    
    self.settingsButton.hidden = self.loading;
    self.loadingLabel.hidden = !self.loading;
    self.spinner.hidden = !self.loading;
    
    self.backgroundView.frame = self.bounds;
    [self.logoView centerHorizonallyAtY:(self.loading ? 175 : 65) inBounds:boundsWithOffset thatFits:CGSizeUnbounded];
    [self.panelView centerHorizonallyAtY:CGRectGetMaxY(self.logoView.frame)+35 inBounds:self.bounds withSize:CGSizeMake(540,375)];
    [self.spinner centerHorizonallyAtY:CGRectGetMaxY(self.logoView.frame)+35 inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.loadingLabel centerHorizonallyAtY:CGRectGetMaxY(self.spinner.frame)+10 inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.settingsButton setFrameAtOrigin:CGPointMake(20, self.bounds.size.height-50) thatFits:CGSizeUnbounded];
}

-(void)setStartEnabled:(BOOL)enabled {
    [self.panelView setRightButtonEnabled:enabled];
}

-(void)setMaleSelected:(BOOL)selected {
    [self.userInfoView setMaleSelected:selected];
}

-(void)setFemaleSelected:(BOOL)selected {
    [self.userInfoView setFemaleSelected:selected];
}

-(void)clearFields {
    [self.userInfoView setMaleSelected:NO];
    [self.userInfoView setFemaleSelected:NO];
    [self.userInfoView clearFields];
}

-(void)animateOffsetX:(CGFloat)offsetX showInfo:(BOOL)show {
    self.panelView.hidden = NO;
    self.offsetX = offsetX;
    NSString *settingsTitle = show ? @"Select Study" : @"Close Selection";
    [UIView animateWithDuration:0.3f animations:^{
        [self setFrameAtOrigin:CGPointMake(offsetX, self.frame.origin.y)];
        self.panelView.alpha = show ? 1.0f : 0.0f;
        [self.settingsButton setTitle:settingsTitle forState:UIControlStateNormal];
        [self layoutSubviews];
    } completion:^(BOOL finished) {
        self.panelView.hidden = !show;
    }];
}

-(void)setLoading:(BOOL)loading animated:(BOOL)animated {
    _loading = loading;
    if(!loading) {
        [self.spinner stopAnimating];
    } else {
        [self.spinner startAnimating];
    }

    self.panelView.hidden = NO;
    if(animated) {
        [UIView animateWithDuration:0.3f animations:^{
            self.panelView.alpha = self.loading ? 0.0f : 1.0f;
            [self layoutSubviews];
        } completion:^(BOOL finished) {
            self.panelView.hidden = loading;
        }];
    } else {
        self.panelView.alpha = self.loading ? 0.0f : 1.0f;
        [self layoutSubviews];
    }
}

-(void)stopLoadingIndicator {
    [self.spinner stopAnimating];
}

#pragma mark callbacks

-(void)startSelected {
    [self.landingDelegate startSelected];
}

-(void)settingsSelected {
    [self.landingDelegate settingsSelected];
}

-(void)maleSelected {
    [self.landingDelegate maleSelected];
}

-(void)femaleSelected {
    [self.landingDelegate femaleSelected];
}

-(void)firstNameChanged:(NSNotification*)notification {
    [self.landingDelegate firstNameChanged:notification.userInfo[BSPUserInfoViewValueKey]];
}

-(void)lastNameChanged:(NSNotification*)notification {
    [self.landingDelegate lastNameChanged:notification.userInfo[BSPUserInfoViewValueKey]];
}

-(void)groupChanged:(NSNotification*)notification {
    [self.landingDelegate groupChanged:notification.userInfo[BSPUserInfoViewValueKey]];
}

# pragma mark keyboard

-(void)keyboardShown {
    [self setContentOffset:CGPointMake(0, self.panelView.frame.origin.y-10) animated:YES];
}

-(void)keyboardHidden {
    [self setContentOffset:CGPointMake(0, 0) animated:YES];
}

@end

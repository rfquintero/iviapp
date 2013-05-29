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
@end

@implementation BSPLandingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.logoView];
        [self addSubview:panelView];
        [self addSubview:settingsButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(maleSelected) name:BSPUserInfoViewMaleSelected object:self.userInfoView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(femaleSelected) name:BSPUserInfoViewFemaleSelected object:self.userInfoView];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
    [self.logoView centerHorizonallyAtY:65 inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.panelView centerHorizonallyAtY:CGRectGetMaxY(self.logoView.frame)+35 inBounds:self.bounds withSize:CGSizeMake(540,375)];
    [self.settingsButton setFrameAtOrigin:CGPointMake(20, self.bounds.size.height-50) thatFits:CGSizeUnbounded];
}

-(void)setMaleSelected:(BOOL)selected {
    [self.userInfoView setMaleSelected:selected];
}

-(void)setFemaleSelected:(BOOL)selected {
    [self.userInfoView setFemaleSelected:selected];
}

#pragma mark callbacks

-(void)startSelected {
    
}

-(void)settingsSelected {
    
}

-(void)maleSelected {
    [[NSNotificationCenter defaultCenter] postNotificationName:BSPUserInfoViewMaleSelected object:self];
}

-(void)femaleSelected {
    [[NSNotificationCenter defaultCenter] postNotificationName:BSPUserInfoViewFemaleSelected object:self];
}


@end

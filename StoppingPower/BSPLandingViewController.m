#import "BSPLandingViewController.h"
#import "BSPLandingView.h"
#import "BSPUserInfoView.h"
#import "BSPUI.h"

@interface BSPLandingViewController ()
@property (nonatomic) BSPLandingView *landingView;
@end

@implementation BSPLandingViewController

-(void)loadView {
    [super loadView];
    
    self.landingView = [[BSPLandingView alloc] initWithFrame:self.view.bounds];
    self.landingView.autoresizingMask = UIViewFlexibleHeightWidth;
    [self.view addSubview:self.landingView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(maleSelected) name:BSPUserInfoViewMaleSelected object:self.landingView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(femaleSelected) name:BSPUserInfoViewFemaleSelected object:self.landingView];
}

#pragma mark callbacks
-(void)maleSelected {
    [self.landingView setMaleSelected:YES];
    [self.landingView setFemaleSelected:NO];
}

-(void)femaleSelected {
    [self.landingView setMaleSelected:NO];
    [self.landingView setFemaleSelected:YES];
}

@end

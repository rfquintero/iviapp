#import "BSPLandingViewController.h"
#import "BSPLandingView.h"
#import "BSPStudyView.h"
#import "BSPUI.h"
#import "BSPStudy.h"


#define kSettingsWidth 480

@interface BSPLandingViewController ()<BSPLandingViewDelegate>
@property (nonatomic) BSPLandingView *landingView;
@property (nonatomic) BSPStudyView *studyView;
@property (nonatomic) BOOL settingsShowing;
@end

@implementation BSPLandingViewController

-(void)loadView {
    [super loadView];
    
    self.landingView = [[BSPLandingView alloc] initWithFrame:self.view.bounds];
    self.landingView.autoresizingMask = UIViewFlexibleHeightWidth;
    self.landingView.landingDelegate = self;
    
    self.studyView = [[BSPStudyView alloc] initWithFrame:CGRectMake(0, 0, kSettingsWidth, self.view.bounds.size.height)];
    self.studyView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self.studyView setStudies:[self createStudies]];
    
    [self.view addSubview:self.studyView];
    [self.view addSubview:self.landingView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

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

-(void)settingsSelected {
    self.settingsShowing = !self.settingsShowing;
    CGFloat x = self.settingsShowing ? kSettingsWidth : 0;
    [self.landingView animateOffsetX:x showInfo:!self.settingsShowing];
}


-(NSArray*)createStudies {
    NSMutableArray *studies = [NSMutableArray array];
    [studies addObject:[[BSPStudy alloc] initWithTitle:@"Study 1" description:@"This is my description that stretches into two separate lines!"]];
    [studies addObject:[[BSPStudy alloc] initWithTitle:@"Study 2" description:@"This is my description"]];
    [studies addObject:[[BSPStudy alloc] initWithTitle:@"Study 3" description:@"This is my description"]];
    [studies addObject:[[BSPStudy alloc] initWithTitle:@"Study 4" description:@"This is my description"]];
    [studies addObject:[[BSPStudy alloc] initWithTitle:@"Study 5" description:@"This is my description"]];
    [studies addObject:[[BSPStudy alloc] initWithTitle:@"Study 6" description:@"This is my description"]];
    [studies addObject:[[BSPStudy alloc] initWithTitle:@"Study 7" description:@"This is my description"]];
    [studies addObject:[[BSPStudy alloc] initWithTitle:@"Study 8" description:@"This is my description"]];
    return studies;
}

@end

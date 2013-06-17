#import "BSPLandingViewController.h"
#import "BSPLandingView.h"
#import "BSPStudyView.h"
#import "BSPUI.h"
#import "BSPStudyModel.h"


#define kSettingsWidth 480

@interface BSPLandingViewController ()<BSPLandingViewDelegate>
@property (nonatomic) BSPLandingView *landingView;
@property (nonatomic) BSPStudyView *studyView;
@property (nonatomic) BSPStudyModel *model;
@property (nonatomic) BOOL settingsShowing;
@end

@implementation BSPLandingViewController

-(id)initWithAppState:(BSPApplicationState*)applicationState {
    if(self = [super init]) {
        self.model = [[BSPStudyModel alloc] initWithDao:applicationState.dao];
    }
    return self;
}

-(void)loadView {
    [super loadView];
    
    self.landingView = [[BSPLandingView alloc] initWithFrame:self.view.bounds];
    self.landingView.autoresizingMask = UIViewFlexibleHeightWidth;
    self.landingView.landingDelegate = self;
    [self.landingView setLoading:YES animated:NO];
    
    self.studyView = [[BSPStudyView alloc] initWithFrame:CGRectMake(0, 0, kSettingsWidth, self.view.bounds.size.height)];
    self.studyView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.studyView];
    [self.view addSubview:self.landingView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(studiesFound) name:BSPStudyModelStudiesRetrieved object:self.model];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imagesRetrieved) name:BSPStudyModelStudyImagesRetrieved object:self.model];
    if(self.model.studies.count < 1) {
        [self.model retrieveStudies];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

-(void)studiesFound {
    [self.studyView setStudies:self.model.studies];
    [self.landingView setLoading:NO animated:YES];
}



@end

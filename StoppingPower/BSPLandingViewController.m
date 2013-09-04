#import "BSPLandingViewController.h"
#import "BSPLandingView.h"
#import "BSPStudyView.h"
#import "BSPUI.h"
#import "BSPStudyModel.h"
#import "BSPStudyControllerViewController.h"
#import "BSPUserModel.h"
#import "TestFlight.h"

#define kSettingsWidth 480

@interface BSPLandingViewController ()<BSPLandingViewDelegate>
@property (nonatomic) BSPApplicationState *applicationState;
@property (nonatomic) BSPLandingView *landingView;
@property (nonatomic) BSPStudyView *studyView;
@property (nonatomic) BSPStudyModel *model;
@property (nonatomic) BSPUserModel *userModel;
@property (nonatomic) BOOL settingsShowing;
@property (nonatomic) UIAlertView *alertView;
@end

@implementation BSPLandingViewController

-(id)initWithAppState:(BSPApplicationState*)applicationState {
    if(self = [super init]) {
        self.applicationState = applicationState;
        self.model = [[BSPStudyModel alloc] initWithDao:applicationState.dao database:applicationState.database];
        self.userModel = [[BSPUserModel alloc] init];
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
    
    if(self.model.studies.count < 1) {
        TFLog(@"**No studies present, updating**");
        [self updateStudies];
    } else {
        [self.studyView setStudies:self.model.studies];
        [self.landingView setLoading:NO animated:YES];
    }
    
    [self.view addSubview:self.studyView];
    [self.view addSubview:self.landingView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(studiesFound) name:BSPStudyModelStudiesRetrieved object:self.model];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imagesRetrieved) name:BSPStudyModelStudyImagesRetrieved object:self.model];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(error:) name:BSPStudyModelError object:self.model];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(studySelected) name:BSPStudyViewStudySelected object:self.studyView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:BSPUserModelChanged object:self.userModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becameActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self syncResults];
    [self clearFields];
    [self refresh];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)syncResults {
    [self.applicationState.resultSync sync];
}

-(void)updateStudies {
    TFLog(@"**Updating Studies**");
    [self.landingView setLoading:YES animated:NO];
    [self.userModel setStudy:nil];
    [self.studyView clearSelection];
    [self.model retrieveStudies];
}

-(void)becameActive {
    [self syncResults];
}

-(void)clearFields {
    [self.userModel clearFields];
    [self.landingView clearFields];
}

-(void)refresh {
    [self.landingView setStartEnabled:self.userModel.infoComplete];
}

#pragma mark callbacks
-(void)maleSelected {
    [self.landingView setMaleSelected:YES];
    [self.landingView setFemaleSelected:NO];
    [self.userModel setGender:@"Male"];
}

-(void)femaleSelected {
    [self.landingView setMaleSelected:NO];
    [self.landingView setFemaleSelected:YES];
    [self.userModel setGender:@"Female"];
}

-(void)settingsSelected {
    self.settingsShowing = !self.settingsShowing;
    CGFloat x = self.settingsShowing ? kSettingsWidth : 0;
    [self.landingView animateOffsetX:x showInfo:!self.settingsShowing];
    [self.studyView refresh];
}

-(void)refreshSelected {
    TFLog(@"Refresh selected, updating studies");
    [self settingsSelected];
    [self updateStudies];
}

-(void)startSelected {
    if(self.studyView.selectedStudy) {
        TFLog(@"**Beginning study: %@ User: %@ %@", self.userModel.study.title, self.userModel.firstName, self.userModel.lastName);
        UIViewController *vc = [[BSPStudyControllerViewController alloc] initWithAppState:self.applicationState userModel:self.userModel];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)firstNameChanged:(NSString *)value {
    [self.userModel setFirstName:value];
}

-(void)lastNameChanged:(NSString *)value {
    [self.userModel setLastName:value];
}

-(void)groupChanged:(NSString *)value {
    [self.userModel setGroupId:value];
}

# pragma mark Studies callbacks
-(void)studiesFound {
    [self.studyView setStudies:self.model.studies];
    [self.model retrieveAllImages];
}

-(void)imagesRetrieved {
    [self.landingView setLoading:NO animated:YES];
}

-(void)error:(NSNotification*)notification {
    NSError *error = [notification.userInfo objectForKey:BSPStudyModelErrorKey];
    if(!self.alertView) {
        self.alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [self.alertView show];
        [self.landingView stopLoadingIndicator];
    }
}

-(void)studySelected {
    [self.userModel setStudy:self.studyView.selectedStudy];
    TFLog(@"Study selected: %@", self.studyView.selectedStudy.title);
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    TFLog(@"Received memory warning: showing alert message.");
    if(self.alertView) {
        [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    }
    self.alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Not enough free space to store all study images. Please de-activate unneeded studies and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [self.alertView show];
    [self.landingView stopLoadingIndicator];
}

@end

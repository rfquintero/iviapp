#import "BSPLandingViewController.h"
#import "BSPLandingView.h"
#import "BSPStudyView.h"
#import "BSPUI.h"
#import "BSPStudyModel.h"
#import "BSPStudyControllerViewController.h"
#import "BSPUserModel.h"

#define kSettingsWidth 480
#define kAlertRegister 101

@interface BSPLandingViewController ()<BSPLandingViewDelegate, UIAlertViewDelegate>
@property (nonatomic) BSPApplicationState *applicationState;
@property (nonatomic) BSPLandingView *landingView;
@property (nonatomic) BSPStudyView *studyView;
@property (nonatomic) BSPStudyModel *model;
@property (nonatomic) BSPUserModel *userModel;
@property (nonatomic) BOOL settingsShowing;
@property (nonatomic) UIAlertView *alertView;
@property (nonatomic, readonly) BOOL authorized;
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
    
    if(self.model.studies.count < 1 && self.authorized) {
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStart) name:BSPUserModelChanged object:self.userModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becameActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registered) name:BSPStudyModelRegistered object:self.model];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRegistration) name:BSPDaoAuthorizationChanged object:self.applicationState.dao];
    
    [self syncResults];
    [self clearFields];
    [self refreshStart];
    [self refreshRegistration];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)authorized {
    return self.applicationState.dao.authorized;
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

-(void)refreshStart {
    [self.landingView setStartEnabled:(self.userModel.infoComplete && self.authorized)];
}

-(void)showAlertView:(UIAlertView*)alertView {
    [_alertView dismissWithClickedButtonIndex:_alertView.cancelButtonIndex animated:NO];
    _alertView = alertView;
    [alertView show];
}

#pragma mark registration

-(void)registered {
    [self refreshRegistration];
    if(self.model.studies.count < 1) {
        TFLog(@"**No studies present, updating**");
        [self updateStudies];
    } else {
        [self.landingView setLoading:NO animated:YES];
    }
}

-(void)refreshRegistration {
    [self.landingView setRegisterHidden:self.authorized animated:YES];
    [self.studyView setStudies:self.model.studies];
}

-(void)requestToken {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter Access Key" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alert.tag = kAlertRegister;
    [self showAlertView:alert];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == kAlertRegister) {
        if(buttonIndex == alertView.cancelButtonIndex) {
            
        } else {
            NSString *key = [alertView textFieldAtIndex:0].text;
            if(key.length > 0) {
                [self.landingView setLoading:YES animated:NO];
                [self.model registerDevice:key];
            }
        }
    }
    self.alertView = nil;
}

#pragma mark callbacks

-(void)registerSelected {
    [self requestToken];
}

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

    [self showAlertView:[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil]];
    
    [self.landingView setLoading:NO animated:YES];
    [self refreshRegistration];
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
    
    [self showAlertView:[[UIAlertView alloc] initWithTitle:@"Error" message:@"Not enough free space to store all study images. Please de-activate unneeded studies and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]];
    [self.landingView stopLoadingIndicator];
}

@end

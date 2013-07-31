#import "BSPStudyControllerViewController.h"
#import "BSPStudyPairView.h"
#import "BSPUI.h"
#import "BSPCompletionView.h"
#import "BSPInstructionView.h"
#import "TestFlight.h"

@interface BSPStudyControllerViewController ()<UIAlertViewDelegate>
@property (nonatomic) BSPApplicationState *applicationState;
@property (nonatomic) BSPStudyPairView *pairView;
@property (nonatomic) BSPCompletionView *completeView;
@property (nonatomic) BSPInstructionView *instructionView;
@property (nonatomic) BSPUserModel *model;
@end

@implementation BSPStudyControllerViewController

-(id)initWithAppState:(BSPApplicationState*)applicationState userModel:(BSPUserModel*)userModel {
    if(self = [super init]) {
        self.applicationState = applicationState;
        self.model = userModel;
        [self.model prepare];
    }
    return self;
}

-(void)loadView {
    [super loadView];
    
    BSPStudyPairView *pairView = [[BSPStudyPairView alloc] initWithFrame:self.view.bounds study:self.model.study];
    pairView.autoresizingMask = UIViewFlexibleHeightWidth;
    self.pairView = pairView;
    
    BSPCompletionView *completeView = [[BSPCompletionView alloc] initWithFrame:self.view.bounds];
    completeView.autoresizingMask = UIViewFlexibleHeightWidth;
    completeView.hidden = YES;
    [completeView addDoneTarget:self action:@selector(finished)];
    self.completeView = completeView;
    
    BSPInstructionView *instructionView = [[BSPInstructionView alloc] initWithFrame:self.view.bounds];
    instructionView.autoresizingMask = UIViewFlexibleHeightWidth;
    self.instructionView = instructionView;
    
    [self.view addSubview:pairView];
    [self.view addSubview:completeView];
    [self.view addSubview:instructionView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(studyComplete) name:BSPStudyPairViewCompleted object:self.pairView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(studyCancelled) name:BSPStudyPairViewCancelled object:self.pairView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageSelected:) name:BSPStudyPairViewImageSelected object:self.pairView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startStudy) name:BSPInstructionViewDismissed object:self.instructionView];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)startStudy {
    [self.pairView startStudyTimer];
}

-(void)studyComplete {
    self.completeView.hidden = NO;
}

-(void)studyCancelled {
    TFLog(@"**Cancel Selected**");
    [self.pairView killTimer];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancel Study?" message:@"Are you sure you want to cancel the study?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}

-(void)imageSelected:(NSNotification*)notification {
    [self.model selectedImageWithId:notification.userInfo[BSPStudyPairViewImageKey]];
}

-(void)finished {
    TFLog(@"**Study completed! Adding result to sync. Study: %@ User: %@ %@", self.model.study.title, self.model.firstName, self.model.lastName);
    [self.applicationState.resultSync addResult:[self.model createResult]];
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == alertView.cancelButtonIndex) {
        TFLog(@"Cancel aborted, resuming study.");
        [self.pairView startStudyTimer];
    } else {
        TFLog(@"Study cancelled. Returning to dashboard.");
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

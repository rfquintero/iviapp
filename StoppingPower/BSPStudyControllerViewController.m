#import "BSPStudyControllerViewController.h"
#import "BSPStudyPairView.h"
#import "BSPUI.h"
#import "BSPCompletionView.h"
#import "BSPInstructionView.h"

@interface BSPStudyControllerViewController ()
@property (nonatomic) BSPApplicationState *applicationState;
@property (nonatomic) BSPStudyPairView *pairView;
@property (nonatomic) BSPCompletionView *completeView;
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
    
    [self.view addSubview:pairView];
    [self.view addSubview:completeView];
    [self.view addSubview:instructionView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(studyComplete) name:BSPStudyPairViewCompleted object:self.pairView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(studyCancelled) name:BSPStudyPairViewCancelled object:self.pairView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageSelected:) name:BSPStudyPairViewImageSelected object:self.pairView];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)studyComplete {
    self.completeView.hidden = NO;
}

-(void)studyCancelled {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)imageSelected:(NSNotification*)notification {
    [self.model selectedImageWithId:notification.userInfo[BSPStudyPairViewImageKey]];
}

-(void)finished {
    [self.applicationState.resultSync addResult:[self.model createResult]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

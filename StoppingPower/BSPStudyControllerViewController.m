#import "BSPStudyControllerViewController.h"
#import "BSPStudyPairView.h"
#import "BSPUI.h"
#import "BSPCompletionView.h"

@interface BSPStudyControllerViewController ()
@property (nonatomic) BSPApplicationState *applicationState;
@property (nonatomic) BSPStudyPairView *pairView;
@property (nonatomic) BSPCompletionView *completeView;
@property (nonatomic) BSPStudy *study;
@end

@implementation BSPStudyControllerViewController

-(id)initWithAppState:(BSPApplicationState*)applicationState study:(BSPStudy*)study {
    if(self = [super init]) {
        self.applicationState = applicationState;
        self.study = study;
    }
    return self;
}

-(void)loadView {
    [super loadView];
    
    BSPStudyPairView *pairView = [[BSPStudyPairView alloc] initWithFrame:self.view.bounds study:self.study];
    pairView.autoresizingMask = UIViewFlexibleHeightWidth;
    self.pairView = pairView;
    
    BSPCompletionView *completeView = [[BSPCompletionView alloc] initWithFrame:self.view.bounds];
    completeView.autoresizingMask = UIViewFlexibleHeightWidth;
    completeView.hidden = YES;
    [completeView addDoneTarget:self action:@selector(finished)];
    self.completeView = completeView;
    
    [self.view addSubview:pairView];
    [self.view addSubview:completeView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(studyComplete) name:BSPStudyPairViewCompleted object:self.pairView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(studyCancelled) name:BSPStudyPairViewCancelled object:self.pairView];
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

-(void)finished {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

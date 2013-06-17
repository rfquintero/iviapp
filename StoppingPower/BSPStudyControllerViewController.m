#import "BSPStudyControllerViewController.h"
#import "BSPStudyPairView.h"
#import "BSPUI.h"

@interface BSPStudyControllerViewController ()
@property (nonatomic) BSPApplicationState *applicationState;
@property (nonatomic) BSPStudyPairView *pairView;
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
    [self.view addSubview:pairView];
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)studyCancelled {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

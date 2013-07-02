#import "BSPStudyPairView.h"
#import "BSPUI.h"
#import "BSPImagePair.h"
#import "BSPStudyImage.h"

@interface BSPStudyPairView()
@property (nonatomic) BSPImagePair *currentPair;
@property (nonatomic) NSMutableArray *pairs;

@property (nonatomic) NSUInteger totalPairs;
@property (nonatomic) UIView *header;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *descriptionLabel;
@property (nonatomic) UILabel *pageLabel;
@property (nonatomic) BSPStudyImage *leftImage;
@property (nonatomic) BSPStudyImage *rightImage;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UILabel *timerLabel;

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSDate *startTime;
@end

@implementation BSPStudyPairView

- (id)initWithFrame:(CGRect)frame study:(BSPStudy*)study {
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor studyBgDarkGray];
        self.pairs = [NSMutableArray arrayWithArray:study.pairs];
        self.totalPairs = self.pairs.count;
        
        self.titleLabel = [BSPUI labelWithFont:[BSPUI boldFontOfSize:16.0f]];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.text = study.title;
        
        self.descriptionLabel = [BSPUI labelWithFont:[BSPUI fontOfSize:14.0f]];
        self.descriptionLabel.textColor = [UIColor whiteColor];
        self.descriptionLabel.text = study.description;
        
        self.pageLabel = [BSPUI labelWithFont:[BSPUI fontOfSize:14.0f]];
        self.pageLabel.textColor = [UIColor whiteColor];
        
        self.leftImage = [[BSPStudyImage alloc] initWithFrame:CGRectZero];
        [self.leftImage addTarget:self action:@selector(leftSelected)];
                
        self.rightImage = [[BSPStudyImage alloc] initWithFrame:CGRectZero];
        [self.rightImage addTarget:self action:@selector(leftSelected)];
        
        self.timerLabel = [BSPUI labelWithFont:[BSPUI boldFontOfSize:24.0f]];
        self.timerLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
        self.timerLabel.textColor = [UIColor whiteColor];
        self.timerLabel.textAlignment = NSTextAlignmentCenter;
        
        UIImage *buttonImage = [UIImage imageNamed:@"button_black"];
        buttonImage = [buttonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
        
        UIButton *cancelButton = [BSPUI blackButtonWithTitle:@"Cancel Study"];
        [cancelButton addTarget:self action:@selector(cancelStudy) forControlEvents:UIControlEventTouchUpInside];
        self.cancelButton = cancelButton;
        
        self.header = [[UIView alloc] init];
        self.header.backgroundColor = [UIColor blackColor];
        
        [self.header addSubview:self.titleLabel];
        [self.header addSubview:self.descriptionLabel];
        [self.header addSubview:self.pageLabel];
        
        [self addSubview:self.header];
        [self addSubview:self.leftImage];
        [self addSubview:self.rightImage];
        [self addSubview:self.cancelButton];
        [self addSubview:self.timerLabel];
        
        [self loadNextPage];
    }
    return self;
}

-(void)dealloc {
    [self killTimer];
    self.timer = nil;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    self.header.frame = CGRectMake(0, 0, width, 40);
    [self.titleLabel centerVerticallyAtX:5.0 inBounds:self.header.bounds thatFits:CGSizeUnbounded];
    
    CGSize pageSize = [self.pageLabel sizeThatFits:CGSizeUnbounded];
    [self.pageLabel centerVerticallyAtX:width-pageSize.width-5 inBounds:self.header.bounds withSize:pageSize];
    
    CGFloat descriptionWidth = width - CGRectGetMaxX(self.titleLabel.frame) - pageSize.width - 5 - 20;
    [self.descriptionLabel centerVerticallyAtX:CGRectGetMaxX(self.titleLabel.frame)+10 inBounds:self.header.bounds thatFits:CGSizeMake(descriptionWidth, CGFLOAT_MAX)];
    
    [self.timerLabel centerHorizonallyAtY:CGRectGetMaxY(self.header.frame) inBounds:self.bounds withSize:CGSizeMake(100, 25)];
    
    CGSize cancelSize = [self.cancelButton sizeThatFits:CGSizeUnbounded];
    self.cancelButton.frame = CGRectMake(width-cancelSize.width-10, height-cancelSize.height-10, cancelSize.width, cancelSize.height);
    
    CGFloat imageOffsetY = CGRectGetMaxY(self.header.frame);
    CGSize imageSize = CGSizeMake(roundf((width-2)/2), roundf(CGRectGetMinY(self.cancelButton.frame)-10-imageOffsetY));
    self.leftImage.frame = CGRectMake(0, imageOffsetY, imageSize.width, imageSize.height);
    self.rightImage.frame = CGRectMake(width-imageSize.width, imageOffsetY, imageSize.width, imageSize.height);
}

-(void)cancelStudy {
    [[NSNotificationCenter defaultCenter] postNotificationName:BSPStudyPairViewCancelled object:self];
}

-(void)loadNextPage {
    if(self.pairs.count > 0) {
        self.currentPair = self.pairs[0];
        [self.leftImage setImageWithURL:self.currentPair.leftImageUrlString caption:self.currentPair.leftCaption];
        [self.rightImage setImageWithURL:self.currentPair.rightImageUrlString caption:self.currentPair.rightCaption];
        self.pageLabel.text = [NSString stringWithFormat:@"%i of %i", (self.totalPairs - self.pairs.count + 1), self.totalPairs];
        
        [self setNeedsLayout];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:BSPStudyPairViewCompleted object:self];
    }
}

-(void)setTimer:(NSTimer *)timer {
    [self.timer invalidate];
    _timer = timer;
}

-(void)killTimer {
    self.timer = nil;
}

-(void)startStudyTimer {
    self.startTime = [NSDate date];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

-(void)timerFired {
    NSTimeInterval elapsed = 2.0f+[self.startTime timeIntervalSinceNow];
    if(elapsed < 0 && self.pairs.count > 0) {
        [self killTimer];
        id pair = [self dequeuePair];
        [self.pairs addObject:pair];
        [self loadNextAndCheckTimer];
    } else {
        self.timerLabel.text = [NSString stringWithFormat:@"%0.2f", elapsed];
    }
    [self setNeedsLayout];
}

-(void)leftSelected {
    [self imageSelected:self.currentPair.leftId];
}

-(void)rightSelected {
    [self imageSelected:self.currentPair.rightId];
}

-(void)imageSelected:(NSString*)imageId {
    [self killTimer];
    [[NSNotificationCenter defaultCenter] postNotificationName:BSPStudyPairViewImageSelected object:self userInfo:@{BSPStudyPairViewImageKey : imageId}];
    [self dequeuePair];
    [self loadNextAndCheckTimer];
}

-(void)loadNextAndCheckTimer {
    [self loadNextPage];
    if(self.pairs.count > 0) {
        [self startStudyTimer];
    }
}

-(id)dequeuePair {
    if(self.pairs.count > 0) {
        id pair = self.pairs[0];
        [self.pairs removeObjectAtIndex:0];
        return pair;
    }
    return nil;
}

@end

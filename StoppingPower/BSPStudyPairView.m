#import "BSPStudyPairView.h"
#import "BSPUI.h"
#import "BSPImagePair.h"
#import "BSPStudyImage.h"

@interface BSPStudyPairView()
@property (nonatomic) BSPStudy *study;
@property (nonatomic) BSPImagePair *currentPair;

@property (nonatomic) NSUInteger page;
@property (nonatomic) UIView *header;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *descriptionLabel;
@property (nonatomic) UILabel *pageLabel;
@property (nonatomic) BSPStudyImage *leftImage;
@property (nonatomic) BSPStudyImage *rightImage;
@property (nonatomic) UIButton *cancelButton;
@end

@implementation BSPStudyPairView

- (id)initWithFrame:(CGRect)frame study:(BSPStudy*)study {
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor studyBgDarkGray];
        self.study = study;
        self.page = 0;
        
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
        
        [self loadNextPage];
    }
    return self;
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
    if(self.page < self.study.pairs.count) {
        self.currentPair = self.study.pairs[self.page];
        [self.leftImage setImageWithURL:self.currentPair.leftImageUrlString caption:self.currentPair.leftCaption];
        [self.rightImage setImageWithURL:self.currentPair.rightImageUrlString caption:self.currentPair.rightCaption];
        self.pageLabel.text = [NSString stringWithFormat:@"%i of %i", (self.page+1), self.study.pairs.count];
        
        self.page = self.page + 1;
        [self setNeedsLayout];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:BSPStudyPairViewCompleted object:self];
    }
}

-(void)startStudyTimer {
    
}

-(void)leftSelected {
    [self imageSelected:self.currentPair.leftId];
}

-(void)rightSelected {
    [self imageSelected:self.currentPair.rightId];
}

-(void)imageSelected:(NSString*)imageId {
    [[NSNotificationCenter defaultCenter] postNotificationName:BSPStudyPairViewImageSelected object:self userInfo:@{BSPStudyPairViewImageKey : imageId}];
    [self loadNextPage];
}

@end

#import "BSPStudyPairView.h"
#import "BSPUI.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "BSPImagePair.h"

@interface BSPStudyPairView()
@property (nonatomic) BSPStudy *study;
@property (nonatomic) BSPImagePair *currentPair;

@property (nonatomic) NSUInteger page;
@property (nonatomic) UIView *header;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *descriptionLabel;
@property (nonatomic) UILabel *pageLabel;
@property (nonatomic) UIButton *leftImage;
@property (nonatomic) UIButton *rightImage;
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
        
        self.leftImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.leftImage addTarget:self action:@selector(leftSelected) forControlEvents:UIControlEventTouchUpInside];
        
        self.rightImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.rightImage addTarget:self action:@selector(rightSelected) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *buttonImage = [UIImage imageNamed:@"button_black"];
        buttonImage = [buttonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"Cancel Study" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelStudy) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [cancelButton setTintColor:[UIColor blackColor]];
        [cancelButton.titleLabel setFont:[BSPUI boldFontOfSize:16.0f]];
        [cancelButton setContentEdgeInsets:UIEdgeInsetsMake(2, 10, 2, 10)];
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
    CGSize imageSize = CGSizeMake(500, 600);
    
    self.header.frame = CGRectMake(0, 0, width, 40);
    [self.titleLabel centerVerticallyAtX:5.0 inBounds:self.header.bounds thatFits:CGSizeUnbounded];
    
    CGSize pageSize = [self.pageLabel sizeThatFits:CGSizeUnbounded];
    [self.pageLabel centerVerticallyAtX:width-pageSize.width-5 inBounds:self.header.bounds withSize:pageSize];
    
    CGFloat descriptionWidth = width - CGRectGetMaxX(self.titleLabel.frame) - pageSize.width - 5 - 20;
    [self.descriptionLabel centerVerticallyAtX:CGRectGetMaxX(self.titleLabel.frame)+10 inBounds:self.header.bounds thatFits:CGSizeMake(descriptionWidth, CGFLOAT_MAX)];
    
    CGRect imageBounds = CGRectMake(0, CGRectGetMaxY(self.header.frame), width, height - self.header.frame.size.height);
    [self.leftImage centerVerticallyAtX:0 inBounds:imageBounds withSize:imageSize];
    [self.rightImage centerVerticallyAtX:width-imageSize.width inBounds:imageBounds withSize:imageSize];
    
    CGSize cancelSize = [self.cancelButton sizeThatFits:CGSizeUnbounded];
    self.cancelButton.frame = CGRectMake(width-cancelSize.width-10, height-cancelSize.height-10, cancelSize.width, cancelSize.height);
}

-(void)cancelStudy {
    [[NSNotificationCenter defaultCenter] postNotificationName:BSPStudyPairViewCancelled object:self];
}

-(void)loadNextPage {
    if(self.page < self.study.pairs.count) {
        self.currentPair = self.study.pairs[self.page];
        [self.leftImage setImageWithURL:[NSURL URLWithString:self.currentPair.leftImageUrlString] forState:UIControlStateNormal];
        [self.rightImage setImageWithURL:[NSURL URLWithString:self.currentPair.rightImageUrlString]  forState:UIControlStateNormal];
        self.pageLabel.text = [NSString stringWithFormat:@"%i of %i", (self.page+1), self.study.pairs.count];
        
        self.page = self.page + 1;
        [self setNeedsLayout];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:BSPStudyPairViewCompleted object:self];
    }
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

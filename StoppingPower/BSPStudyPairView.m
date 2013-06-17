#import "BSPStudyPairView.h"
#import "BSPUI.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BSPImagePair.h"

@interface BSPStudyPairView()
@property (nonatomic) BSPStudy *study;
@property (nonatomic) NSUInteger page;
@property (nonatomic) UIView *header;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *descriptionLabel;
@property (nonatomic) UILabel *pageLabel;
@property (nonatomic) UIImageView *leftImage;
@property (nonatomic) UIImageView *rightImage;
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
        
        UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftSelected)];
        UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftSelected)];
        
        self.leftImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.leftImage.contentMode = UIViewContentModeScaleAspectFit;
        self.leftImage.userInteractionEnabled = YES;
        [self.leftImage addGestureRecognizer:leftTap];
        
        self.rightImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.rightImage.contentMode = UIViewContentModeScaleAspectFit;
        self.rightImage.userInteractionEnabled = YES;
        [self.rightImage addGestureRecognizer:rightTap];
        
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
        BSPImagePair *pair = self.study.pairs[self.page];
        [self.leftImage setImageWithURL:[NSURL URLWithString:pair.leftImageUrlString]];
        [self.rightImage setImageWithURL:[NSURL URLWithString:pair.rightImageUrlString]];
        self.pageLabel.text = [NSString stringWithFormat:@"%i of %i", (self.page+1), self.study.pairs.count];
        
        self.page = self.page + 1;
        [self setNeedsLayout];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:BSPStudyPairViewCompleted object:self];
    }
}

-(void)leftSelected {
    [self loadNextPage];
}

@end

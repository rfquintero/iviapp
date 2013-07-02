#import "BSPStudyImage.h"
#import "BSPUI.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BSPStudyImage()
@property (nonatomic) UIImageView* imageView;
@property (nonatomic) UIButton *touchView;
@property (nonatomic) UILabel *caption;
@end

@implementation BSPStudyImage

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.touchView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.touchView.backgroundColor = [UIColor clearColor];
        [self.touchView addTarget:self action:@selector(startSelection) forControlEvents:UIControlEventTouchDown];
        [self.touchView addTarget:self action:@selector(endSelection) forControlEvents:UIControlEventTouchUpInside];
        [self.touchView addTarget:self action:@selector(endSelection) forControlEvents:UIControlEventTouchUpOutside];
        [self.touchView addTarget:self action:@selector(endSelection) forControlEvents:UIControlEventTouchCancel];
        
        self.caption = [BSPUI labelWithFont:[BSPUI fontOfSize:18.0f]];
        self.caption.textColor = [UIColor whiteColor];
        self.caption.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.imageView];
        [self addSubview:self.caption];
        [self addSubview:self.touchView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.touchView.frame = self.bounds;
}

-(void)setImageWithURL:(NSString*)imageUrl caption:(NSString*)caption {
    [self.imageView setImageWithURL:[NSURL URLWithString:imageUrl]];
}

-(void)addTarget:(id)target action:(SEL)action {
    [self.touchView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)startSelection {
    self.touchView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
}

-(void)endSelection {
    self.touchView.backgroundColor = [UIColor clearColor];
}

@end

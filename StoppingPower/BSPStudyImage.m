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
    if(self.imageView.image) {
        CGSize rect = self.bounds.size;
        CGSize image = self.imageView.image.size;
        CGFloat captionHeight = 25;
        rect.height -= captionHeight;
        
        CGFloat xRatio = image.width / rect.width;
        CGFloat yRatio = image.height / rect.height;
        CGPoint origin;
        CGSize size;
        
        if(xRatio > yRatio) {
            CGFloat ratio = rect.width / image.width;
            size = CGSizeMake(rect.width, image.height*ratio);
            origin = CGPointMake(0, roundf((rect.height-image.height*ratio)/2));
        } else {
            CGFloat ratio = rect.height / image.height;
            size = CGSizeMake(image.width*ratio, rect.height);
            origin = CGPointMake(roundf((rect.width-image.width*ratio)/2),0);
        }
        
        self.caption.frame = CGRectMake(0, origin.y, rect.width, captionHeight);
        self.imageView.frame = CGRectMake(origin.x, origin.y + captionHeight, size.width, size.height);
        self.touchView.frame = self.imageView.frame;
    }
}

-(void)setImageWithURL:(NSString*)imageUrl caption:(NSString*)caption {
    __block id _self = self;
    [self.imageView setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [_self setNeedsLayout];
    }];
    [self.caption setText:caption];
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

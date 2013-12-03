#import "BSPPanelView.h"
#import "UIView+Layouts.h"
#import <QuartzCore/QuartzCore.h>

@interface BSPPanelView()
@property (nonatomic) UINavigationBar *navBar;
@property (nonatomic) UINavigationItem *navItem;
@property (nonatomic) UIView *contentView;

@end

@implementation BSPPanelView

- (id)initWithFrame:(CGRect)frame contentView:(UIView*)contentView {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 7.0f;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 4.0f;
        self.layer.shadowOpacity = 0.8f;
        self.layer.shadowOffset = CGSizeMake(2, 1);
        self.clipsToBounds = YES;
        
        self.navItem = [[UINavigationItem alloc] initWithTitle:@""];
        
        self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
        [self.navBar setTranslucent:NO];
        [self.navBar pushNavigationItem:self.navItem animated:NO];
    
        self.contentView = contentView;
        
        [self addSubview:self.navBar];
        [self addSubview:self.contentView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    [self.navBar setFrameAtOrigin:CGPointMake(0,0) thatFits:CGSizeMake(width, height)];
    self.contentView.frame = CGRectMake(0, self.navBar.frame.size.height, width, height - self.navBar.frame.size.height);
}

-(void)setTitle:(NSString*)title {
    [self.navItem setTitle:title];
}

-(void)setRightButtonTitle:(NSString*)title target:(id)target action:(SEL)action {
    [self.navItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:target action:action] animated:NO];
}

-(void)setRightButtonEnabled:(BOOL)enabled {
    self.navItem.rightBarButtonItem.enabled = enabled;
}

@end

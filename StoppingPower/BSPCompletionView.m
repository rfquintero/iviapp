#import "BSPCompletionView.h"
#import "BSPUI.h"

@interface BSPCompletionView()
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *textLabel;
@property (nonatomic) UIButton *doneButton;
@end

@implementation BSPCompletionView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor studyBgDarkGray];
        
        UILabel *titleLabel = [BSPUI labelWithFont:[BSPUI boldFontOfSize:48.0f]];
        titleLabel.text = @"Study Complete!";
        titleLabel.textColor = [UIColor studyOrange];

        UILabel *textLabel = [BSPUI labelWithFont:[BSPUI boldFontOfSize:24.0f]];
        textLabel.text = @"Thank you for completing the study!";
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.numberOfLines = 0;
        textLabel.textColor = [UIColor whiteColor];
        
        UIButton *doneButton = [BSPUI blackButtonWithTitle:@"Return to Home Screen"];
        doneButton.titleLabel.font = [BSPUI boldFontOfSize:20.0f];
        
        self.titleLabel = titleLabel;
        self.textLabel = textLabel;
        self.doneButton = doneButton;
        
        [self addSubview:titleLabel];
        [self addSubview:textLabel];
        [self addSubview:doneButton];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel centerHorizonallyAtY:150 inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.textLabel centerHorizonallyAtY:350 inBounds:self.bounds thatFits:CGSizeMake(self.bounds.size.width-100, CGFLOAT_MAX)];
    [self.doneButton centerHorizonallyAtY:400 inBounds:self.bounds thatFits:CGSizeUnbounded];
}

-(void)addDoneTarget:(id)target action:(SEL)action {
    [self.doneButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end

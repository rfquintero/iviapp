#import "BSPGroupedButton.h"
#import "BSPUI.h"

@interface BSPGroupedButton()
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UILabel *label;
@property (nonatomic) UIImageView *checkBoxView;
@end


@implementation BSPGroupedButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonSelected)];
        [self addGestureRecognizer:tapRecognizer];
        
        UIImage *groupedImage = [[UIImage imageNamed:@"bg_grouped_table"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 14)];
        self.backgroundView = [[UIImageView alloc] initWithImage:groupedImage];
        
        self.label = [BSPUI labelWithFont:[BSPUI boldFontOfSize:16.0f]];
        self.label.textColor = [UIColor blackColor];
        
        self.checkBoxView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_check_off"]];
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.label];
        [self addSubview:self.checkBoxView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
    
    [self.checkBoxView centerVerticallyAtX:self.bounds.size.width - self.checkBoxView.frame.size.width-10 inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.label centerVerticallyAtX:20 inBounds:self.bounds thatFits:CGSizeUnbounded];
}

-(void)setSelected:(BOOL)selected {
    if(selected) {
        self.checkBoxView.image = [UIImage imageNamed:@"ic_check_on"];
    } else {
        self.checkBoxView.image = [UIImage imageNamed:@"ic_check_off"];
    }
}

-(void)setTitle:(NSString*)title {
    self.label.text = title;
    [self setNeedsLayout];
}

-(void)buttonSelected {
    [[NSNotificationCenter defaultCenter] postNotificationName:BSPGroupedButtonSelected object:self];
}

@end

#import "BSPUserInfoCell.h"
#import "BSPUI.h"

@interface BSPUserInfoCell()
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UITextField *textField;
@end

@implementation BSPUserInfoCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier {
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [BSPUI labelWithFont:[BSPUI boldFontOfSize:16.0f]];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.textField.font = [BSPUI fontOfSize:16.0f];
        self.textField.textColor = [UIColor groupedTableBlue];
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.textField];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel centerVerticallyAtX:20 inBounds:self.contentView.bounds withWidth:100];
    
    CGFloat offsetX = CGRectGetMaxX(self.titleLabel.frame)+10;
    [self.textField centerVerticallyAtX:offsetX inBounds:self.contentView.bounds withSize:CGSizeMake(self.contentView.bounds.size.width-offsetX, self.contentView.frame.size.height)];
}

-(void)setTitle:(NSString*)title {
    self.titleLabel.text = title;
    [self setNeedsLayout];
}

@end

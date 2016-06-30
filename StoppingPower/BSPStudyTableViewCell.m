#import "BSPStudyTableViewCell.h"
#import "BSPUI.h"
#import <QuartzCore/QuartzCore.h>

#define kCellSpacing 14

@interface BSPStudyTableViewCell()
@property (nonatomic) UIImageView *background;
@property (nonatomic) UIImageView *circle;
@property (nonatomic) UILabel *numberLabel;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *descriptionLabel;
@property (nonatomic) BOOL cellSelected;
@end

@implementation BSPStudyTableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.background = [[UIImageView alloc] init];
        self.circle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_study_circle"]];
        
        UILabel *numberLabel = [BSPUI labelWithFont:[BSPUI myriadBoldFontOfSize:36.0f]];
        numberLabel.textColor = [UIColor studyGray];
        [self addShadow:numberLabel];
        
        UILabel *titleLabel = [BSPUI labelWithFont:[BSPUI myriadBoldFontOfSize:24.0f]];
        titleLabel.textColor = [UIColor whiteColor];
        [self addShadow:titleLabel];
        
        UILabel *descriptionLabel = [BSPUI labelWithFont:[BSPUI myriadFontOfSize:18.0f]];
        descriptionLabel.textColor = [UIColor whiteColor];
        descriptionLabel.numberOfLines = 2;
        [self addShadow:descriptionLabel];
        
        self.titleLabel = titleLabel;
        self.numberLabel = numberLabel;
        self.descriptionLabel = descriptionLabel;
        
        [self setCellSelected:NO];
        
        [self.circle addSubview:numberLabel];
        [self.contentView addSubview:self.background];
        [self.background addSubview:self.circle];
        [self.background addSubview:titleLabel];
        [self.background addSubview:descriptionLabel];
    }
    return self;
}

-(void)addShadow:(UIView*)view {
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(1,1);
    view.layer.shadowOpacity = 0.4f;
    view.layer.shadowRadius = 1.0f;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat paddingX = 20.0f;
    self.background.frame = CGRectMake(paddingX, 0, self.contentView.bounds.size.width - 2*paddingX, self.background.image.size.height);
    [self.circle centerVerticallyAtX:paddingX inBounds:self.background.bounds thatFits:CGSizeUnbounded];
    [self.numberLabel centerInBounds:self.circle.bounds offsetX:0 offsetY:10];
    
    CGFloat textOffsetX = CGRectGetMaxX(self.circle.frame)+14.0f;
    CGSize textSize = CGSizeMake(self.background.bounds.size.width - textOffsetX - paddingX, CGFLOAT_MAX);
    [self.titleLabel setFrameAtOrigin:CGPointMake(textOffsetX, 18.0f) thatFits:textSize];
    [self.descriptionLabel setFrameAtOrigin:CGPointMake(textOffsetX, CGRectGetMaxY(self.titleLabel.frame)-1.0f) thatFits:textSize];
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if(!self.cellSelected) {
        [self drawSelected:highlighted];
    }
}

-(void)setCellSelected:(BOOL)selected {
    _cellSelected = selected;
    [self drawSelected:selected];
}

-(void)drawSelected:(BOOL)selected {
    if(selected) {
        self.background.image = [[UIImage imageNamed:@"bg_study_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
        self.numberLabel.textColor = [UIColor studyOrange];
    } else {
        self.background.image = [[UIImage imageNamed:@"bg_study"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
        self.numberLabel.textColor = [UIColor studyGray];
    }
    [self setNeedsLayout];
}

-(void)setStudy:(BSPStudy*)study number:(NSUInteger)number {
    self.titleLabel.text = study.title;
    self.descriptionLabel.text = study.info;
    self.numberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)number];
}

+(CGFloat)heightForCell {
    return [UIImage imageNamed:@"bg_study"].size.height+ kCellSpacing;
}

@end

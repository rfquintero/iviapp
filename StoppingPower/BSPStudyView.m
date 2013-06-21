#import "BSPStudyView.h"
#import "BSPStudyTableViewCell.h"
#import "BSPUI.h"
#import <QuartzCore/QuartzCore.h>

#define kFadeHeight 300

@interface BSPStudyView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIView *fade;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) NSArray *studies;
@end

@implementation BSPStudyView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        tableView.rowHeight = [BSPStudyTableViewCell heightForCell];
        tableView.backgroundColor = [UIColor studyBgDarkGray];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.autoresizingMask = UIViewFlexibleHeightWidth;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView = tableView;
        
        UIColor *gradientStart = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        UIColor *gradientEnd = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        self.fade = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, kFadeHeight)];
        [self.fade setUserInteractionEnabled:NO];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.fade.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)gradientStart.CGColor, (id)gradientEnd.CGColor, nil];
        [self.fade.layer insertSublayer:gradient atIndex:0];
        
        self.selectedIndex = -1;
        
        [self addSubview:tableView];
        [self addSubview:self.fade];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    self.fade.frame = CGRectMake(0, self.bounds.size.height-kFadeHeight, self.bounds.size.width, kFadeHeight);
}

-(BSPStudy*)selectedStudy {
    if(self.selectedIndex >= 0) {
        return self.studies[self.selectedIndex];
    } else {
        return nil;
    }
}

-(void)setStudies:(NSArray *)studies {
    _studies = studies;
    [self.tableView reloadData];
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

-(void)refresh {
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.studies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"BSPStudyTableViewCell";
    BSPStudy *study = self.studies[indexPath.row];
    BSPStudyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell) {
        cell = [[BSPStudyTableViewCell alloc] initWithReuseIdentifier:identifier];
    }

    [cell setStudy:study number:indexPath.row + 1];

    [cell setCellSelected:indexPath.row == self.selectedIndex];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger lastRow = self.selectedIndex;
    self.selectedIndex = indexPath.row;
    if(lastRow != indexPath.row) {
        [tableView beginUpdates];
        
        if(lastRow >= 0) {
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
        [tableView endUpdates];
    }
}

@end

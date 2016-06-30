#import "BSPUserInfoView.h"
#import "BSPGroupedButton.h"
#import "BSPUserInfoCell.h"
#import "BSPUI.h"
#import "BSPConstants.h"

@interface BSPUserInfoView()<UITableViewDataSource, UITableViewDelegate, BSPUserInfoCellDelegate>
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) BSPGroupedButton *maleButton;
@property (nonatomic) BSPGroupedButton *femaleButton;
@end

@implementation BSPUserInfoView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundView = nil;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsHorizontalScrollIndicator = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.scrollEnabled = NO;
        
        self.maleButton = [[BSPGroupedButton alloc] initWithFrame:CGRectZero];
        [self.maleButton setTitle:@"Male"];
        self.femaleButton = [[BSPGroupedButton alloc] initWithFrame:CGRectZero];
        [self.femaleButton setTitle:@"Female"];
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.tableView];
        [self addSubview:self.maleButton];
        [self addSubview:self.femaleButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(maleSelected) name:BSPGroupedButtonSelected object:self.maleButton];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(femaleSelected) name:BSPGroupedButtonSelected object:self.femaleButton];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
    self.tableView.frame = CGRectMake(0, 10, self.bounds.size.width, 232);
    
    CGFloat offset = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 10.0f : 5.0f;
    self.maleButton.frame = CGRectMake(30, CGRectGetMaxY(self.tableView.frame)+offset, 200, 46);
    self.femaleButton.frame = CGRectMake(CGRectGetMaxX(self.maleButton.frame)+20, self.maleButton.frame.origin.y, 200, 46);
}

-(void)setMaleSelected:(BOOL)selected {
    [self.maleButton setSelected:selected];
}

-(void)setFemaleSelected:(BOOL)selected {
    [self.femaleButton setSelected:selected];
}

-(void)postNotification:(NSString*)name value:(id)value {
    NSDictionary *userInfo = nil;
    if(value) {
        userInfo = @{BSPUserInfoViewValueKey : value};
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:userInfo];
}

#pragma mark callbacks

-(void)maleSelected {
    [self postNotification:BSPUserInfoViewMaleSelected value:nil];
}

-(void)femaleSelected {
    [self postNotification:BSPUserInfoViewFemaleSelected value:nil];
}

-(void)clearFields {
    for (BSPUserInfoCell *cell in [self.tableView visibleCells]) {
        [cell clear];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return 3;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"BSPUserInfoCell";
    BSPUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell) {
        cell = [[BSPUserInfoCell alloc] initWithReuseIdentifier:identifier];
        [cell setInputTag:indexPath.row];
        [cell setInputDelegate:self];
    }
    
    switch(indexPath.row) {
        default:
        case 0:
            cell.title = @"First Name";
            break;
        case 1:
            cell.title = @"Last Name";
            break;
        case 2:
            cell.title = @"Group ID";
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"Information";
    else
        return @"Gender";
}

#pragma mark Textfields
-(BOOL)textFieldShouldReturn:(UITextField*)textField; {
    NSInteger nextTag = textField.tag + 1;
    UIView* nextResponder = [self.tableView viewWithTag:nextTag];
    if (nextResponder && !nextResponder.hidden ) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField.tag == 0) {
        [self postNotification:BSPUserInfoViewFirstNameChanged value:textField.text];
    } else if (textField.tag == 1) {
        [self postNotification:BSPUserInfoViewLastNameChanged value:textField.text];
    } else if (textField.tag == 2) {
        [self postNotification:BSPUserInfoViewGroupChanged value:textField.text];
    }
}

-(void)textFieldChanged:(UITextField *)textField {
    [self textFieldDidEndEditing:textField];
}

@end

#import "BSPApplicationState.h"
#import "BSPDao.h"

@interface BSPApplicationState()
@property (nonatomic, readwrite) BSPDao *dao;
@property (nonatomic, readwrite) BSPResultSync *resultSync;
@end

@implementation BSPApplicationState
-(id)init {
    if(self = [super init]) {
        self.dao = [[BSPDao alloc] init];
        self.resultSync = [[BSPResultSync alloc] initWithDao:self.dao];
    }
    return self;
}
@end

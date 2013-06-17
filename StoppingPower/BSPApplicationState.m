#import "BSPApplicationState.h"
#import "BSPDao.h"

@interface BSPApplicationState()
@property (nonatomic, readwrite) BSPDao *dao;
@end

@implementation BSPApplicationState
-(id)init {
    if(self = [super init]) {
        self.dao = [[BSPDao alloc] init];
    }
    return self;
}
@end

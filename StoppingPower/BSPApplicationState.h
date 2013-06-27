#import <Foundation/Foundation.h>
#import "BSPDao.h"
#import "BSPResultSync.h"

@interface BSPApplicationState : NSObject
@property (nonatomic, readonly) BSPDao *dao;
@property (nonatomic, readonly) BSPResultSync *resultSync;
@end

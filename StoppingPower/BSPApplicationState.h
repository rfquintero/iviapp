#import <Foundation/Foundation.h>
#import "BSPDao.h"
#import "BSPResultSync.h"
#import "BSPDatabase.h"

@interface BSPApplicationState : NSObject
@property (nonatomic, readonly) BSPDao *dao;
@property (nonatomic, readonly) BSPResultSync *resultSync;
@property (nonatomic, readonly) BSPDatabase *database;
@end

#import <Foundation/Foundation.h>
#import "BSPDao.h"
#import "BSPDatabase.h"

@interface BSPResultSync : NSObject
-(id)initWithDao:(BSPDao*)dao database:(BSPDatabase*)database;
-(void)sync;
-(void)addResult:(BSPResult*)result;
@end

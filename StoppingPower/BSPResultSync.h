#import <Foundation/Foundation.h>
#import "BSPDao.h"

@interface BSPResultSync : NSObject
-(id)initWithDao:(BSPDao*)dao;
-(void)sync;
-(void)addResult:(BSPResult*)result;
-(void)saveToDisk;
@end

#import <Foundation/Foundation.h>
#import "BSPResult.h"

@interface BSPDao : NSObject
@property (nonatomic,readonly) NSString *endpoint;
-(void)retrieveStudies:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;
-(void)publishResult:(BSPResult*)result handler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;
@end

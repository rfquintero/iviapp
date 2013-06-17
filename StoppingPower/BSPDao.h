#import <Foundation/Foundation.h>

@interface BSPDao : NSObject
-(void)retrieveStudies:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;
@end

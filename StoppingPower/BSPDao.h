#import <Foundation/Foundation.h>

@interface BSPDao : NSObject
@property (nonatomic,readonly) NSString *endpoint;
-(void)retrieveStudies:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;
@end

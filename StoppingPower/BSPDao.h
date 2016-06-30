#import <Foundation/Foundation.h>
#import "BSPResult.h"
#import "BSPDatabase.h"

#define BSPDaoAuthorizationChanged @"kBSPDaoAuthorizationChanged"

typedef void(^BSPCallback)(NSHTTPURLResponse *response, NSData* data, NSError *error);

@interface BSPDao : NSObject
@property (nonatomic,readonly) NSString *endpoint;
@property (nonatomic, readonly) BOOL authorized;

-(id)initWithDatabase:(BSPDatabase*)database;
-(void)retrieveStudies:(BSPCallback)handler;
-(void)publishResult:(BSPResult*)result handler:(BSPCallback)handler;
-(void)registerDevice:(NSString*)password handler:(BSPCallback)handler;
@end

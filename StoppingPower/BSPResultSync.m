#import "BSPResultSync.h"
#import "TestFlight.h"

@interface BSPResultSync()
@property (nonatomic) BSPDao *dao;
@property (nonatomic) BSPDatabase *database;
@property (nonatomic) BOOL syncing;
@end

@implementation BSPResultSync
-(id)initWithDao:(BSPDao*)dao database:(BSPDatabase *)database {
    if(self = [super init]) {
        self.dao = dao;
        self.database = database;
    }
    return self;
}

-(void)sync {
    [self performSelectorOnMainThread:@selector(startSync) withObject:nil waitUntilDone:NO];
}

-(void)startSync {
    NSArray *results = [self.database getResults];
    if(results.count > 0 && !self.syncing) {
        self.syncing = YES;
        BSPResult *result = results[0];
        TFLog(@"Publishing Result %i: %@ %@ - S:%@", result.objectId, result.firstName, result.lastName, result.studyId);
        [self.dao publishResult:result handler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if(!error && response) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                if(httpResponse.statusCode == 200) {
                    [self performSelectorOnMainThread:@selector(resultPosted:) withObject:result waitUntilDone:NO];
                } else {
                    [self performSelectorOnMainThread:@selector(failed:) withObject:result waitUntilDone:NO];
                }
            } else {
                [self performSelectorOnMainThread:@selector(failed:) withObject:result waitUntilDone:NO];
            }
        }];
    }
}

-(void)resultPosted:(BSPResult*)result {
    TFLog(@"Successfully Published Result %i: %@ %@ - S:%@", result.objectId, result.firstName, result.lastName, result.studyId);
    self.syncing = NO;
    [self.database removeResult:result];
    [self startSync];
}

-(void)failed:(BSPResult*)result {
    TFLog(@"Failed to published result %i: %@ %@ - S:%@", result.objectId, result.firstName, result.lastName, result.studyId);
    self.syncing = NO;
}

-(void)addResult:(BSPResult*)result {
    [self.database saveResult:result];
}

@end

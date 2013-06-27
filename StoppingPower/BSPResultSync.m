#import "BSPResultSync.h"

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
        [self.dao publishResult:result handler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if(!error && response) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                if(httpResponse.statusCode == 200) {
                    [self performSelectorOnMainThread:@selector(resultPosted:) withObject:result waitUntilDone:NO];
                } else {
                    [self performSelectorOnMainThread:@selector(failed) withObject:nil waitUntilDone:NO];
                }
            } else {
                [self performSelectorOnMainThread:@selector(failed) withObject:nil waitUntilDone:NO];
            }
        }];
    }
}

-(void)resultPosted:(BSPResult*)result {
    self.syncing = NO;
    [self.database removeResult:result];
    [self startSync];
}

-(void)failed {
    self.syncing = NO;
}

-(void)addResult:(BSPResult*)result {
    [self.database saveResult:result];
}

@end

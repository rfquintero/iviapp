#import "BSPResultSync.h"

@interface BSPResultSync()
@property (nonatomic) BSPDao *dao;
@property (nonatomic) NSMutableArray *results;
@property (nonatomic) BOOL syncing;
@end

@implementation BSPResultSync
-(id)initWithDao:(BSPDao*)dao {
    if(self = [super init]) {
        self.dao = dao;
        self.results = [NSMutableArray array];
    }
    return self;
}

-(void)sync {
    [self performSelectorOnMainThread:@selector(startSync) withObject:nil waitUntilDone:NO];
}

-(void)startSync {
    if(self.results.count > 0 && !self.syncing) {
        self.syncing = YES;
        BSPResult *result = self.results[0];
        [self.dao publishResult:result handler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if(!error && response) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                if(httpResponse.statusCode == 200) {
                    [self performSelectorOnMainThread:@selector(resultPosted) withObject:nil waitUntilDone:NO];
                } else {
                    [self performSelectorOnMainThread:@selector(failed) withObject:nil waitUntilDone:NO];
                }
            } else {
                [self performSelectorOnMainThread:@selector(failed) withObject:nil waitUntilDone:NO];
            }
        }];
    }
}

-(void)resultPosted {
    self.syncing = NO;
    [self.results removeObjectAtIndex:0];
    [self startSync];
}

-(void)failed {
    self.syncing = NO;
}

-(void)addResult:(BSPResult*)result {
    [self.results addObject:result];
}

-(void)saveToDisk {
    
}

@end

#import "BSPStudy.h"

@interface BSPStudy()
@property (nonatomic, readwrite) NSString *objectId;
@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSString *info;
@property (nonatomic, readwrite) NSArray *pairs;
@property (nonatomic, readwrite) NSString *instructions;
@property (nonatomic, readwrite) CGFloat timer;
@property (nonatomic, readwrite) NSInteger warmupPairs;
@property (nonatomic, readwrite) BOOL randomize;
@end

@implementation BSPStudy

-(id)initWithId:(NSString*)objectId title:(NSString*)title description:(NSString*)description pairs:(NSArray*)pairs instructions:(NSString *)instructions timer:(CGFloat)timer randomize:(BOOL)randomize warmupPairs:(NSInteger)warmupPairs {
    if(self = [super init]) {
        self.objectId = objectId;
        self.title = title;
        self.info = description;
        self.pairs = pairs;
        self.instructions = instructions;
        self.timer = timer;
        self.randomize = randomize;
        self.warmupPairs = warmupPairs;
    }
    return self;
}

@end

#import "BSPStudy.h"

@interface BSPStudy()
@property (nonatomic, readwrite) NSString *objectId;
@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSString *description;
@property (nonatomic, readwrite) NSArray *pairs;
@end

@implementation BSPStudy

-(id)initWithId:(NSString*)objectId title:(NSString*)title description:(NSString*)description pairs:(NSArray*)pairs {
    if(self = [super init]) {
        self.objectId = objectId;
        self.title = title;
        self.description = description;
        self.pairs = pairs;
    }
    return self;
}

@end

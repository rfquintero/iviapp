#import <Foundation/Foundation.h>

@interface BSPStudy : NSObject
@property (nonatomic, readonly) NSString *objectId;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSString* description;
@property (nonatomic, readonly) NSString* instructions;
@property (nonatomic, readonly) CGFloat timer;
@property (nonatomic, readonly) NSInteger warmupPairs;
@property (nonatomic, readonly) BOOL randomize;
@property (nonatomic, readonly) NSArray *pairs;

-(id)initWithId:(NSString*)objectId title:(NSString*)title description:(NSString*)description pairs:(NSArray*)pairs instructions:(NSString*)instructions timer:(CGFloat)timer randomize:(BOOL)randomize warmupPairs:(NSInteger)warmupPairs;
@end

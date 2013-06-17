#import <Foundation/Foundation.h>

@interface BSPStudy : NSObject
@property (nonatomic, readonly) NSString *objectId;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSString* description;
@property (nonatomic, readonly) NSArray *pairs;

-(id)initWithId:(NSString*)objectId title:(NSString*)title description:(NSString*)description pairs:(NSArray*)pairs;
@end

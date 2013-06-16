#import <Foundation/Foundation.h>

@interface BSPStudy : NSObject
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSString* description;

-(id)initWithTitle:(NSString*)title description:(NSString*)description;
@end

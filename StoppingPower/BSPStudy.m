#import "BSPStudy.h"

@interface BSPStudy()
@property (nonatomic, readwrite) NSString* title;
@property (nonatomic, readwrite) NSString* description;
@end

@implementation BSPStudy

-(id)initWithTitle:(NSString*)title description:(NSString*)description {
    if(self = [super init]) {
        self.title = title;
        self.description = description;
    }
    return self;
}

@end

#import "BSPImagePair.h"

@interface BSPImagePair()
@property (nonatomic, readwrite) NSString *leftImageUrlString;;
@property (nonatomic, readwrite) NSString *rightImageUrlString;

@end

@implementation BSPImagePair
-(id)initWithLeftImageUrlString:(NSString*)leftImageUrlString right:(NSString*)rightImageUrlString {
    if(self = [super init]) {
        self.leftImageUrlString = leftImageUrlString;
        self.rightImageUrlString = rightImageUrlString;
    }
    
    return self;
}

@end

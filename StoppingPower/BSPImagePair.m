#import "BSPImagePair.h"

@interface BSPImagePair()
@property (nonatomic, readwrite) NSString *leftId;
@property (nonatomic, readwrite) NSString *leftImageUrlString;
@property (nonatomic, readwrite) NSString *rightId;
@property (nonatomic, readwrite) NSString *rightImageUrlString;
@end

@implementation BSPImagePair
-(id)initWithLeftId:(NSString*)leftId leftUrlString:(NSString*)leftUrlString rightId:(NSString*)rightId rightUrlString:(NSString*)rightUrlString {
    if(self = [super init]) {
        self.leftId = leftId;
        self.leftImageUrlString = leftUrlString;
        self.rightId = rightId;
        self.rightImageUrlString = rightUrlString;
    }
    
    return self;
}

@end

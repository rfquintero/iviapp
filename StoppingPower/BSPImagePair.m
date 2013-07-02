#import "BSPImagePair.h"

@interface BSPImagePair()
@property (nonatomic, readwrite) NSString *leftId;
@property (nonatomic, readwrite) NSString *leftImageUrlString;
@property (nonatomic, readwrite) NSString *leftCaption;
@property (nonatomic, readwrite) NSString *rightId;
@property (nonatomic, readwrite) NSString *rightImageUrlString;
@property (nonatomic, readwrite) NSString *rightCaption;
@end

@implementation BSPImagePair
-(id)initWithLeftId:(NSString*)leftId leftUrlString:(NSString*)leftUrlString leftCaption:(NSString*)leftCaption rightId:(NSString*)rightId rightUrlString:(NSString*)rightUrlString rightCaption:(NSString*)rightCaption {
    if(self = [super init]) {
        self.leftId = leftId;
        self.leftImageUrlString = leftUrlString;
        self.leftCaption = leftCaption;
        self.rightId = rightId;
        self.rightImageUrlString = rightUrlString;
        self.rightCaption = rightCaption;
    }
    
    return self;
}

@end

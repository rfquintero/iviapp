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

-(BSPImagePair*)pairRandomized:(BOOL)randomized {
    BOOL flip = randomized ? (arc4random() % 2) : NO;
    return [self copyFlipped:flip];
}

-(BSPImagePair*)copyFlipped:(BOOL)flip {
    if(flip) {
        return [[BSPImagePair alloc] initWithLeftId:self.rightId leftUrlString:self.rightImageUrlString leftCaption:self.rightCaption rightId:self.leftId rightUrlString:self.leftImageUrlString rightCaption:self.leftCaption];
    } else {
        return [[BSPImagePair alloc] initWithLeftId:self.leftId leftUrlString:self.leftImageUrlString leftCaption:self.leftCaption rightId:self.rightId rightUrlString:self.rightImageUrlString rightCaption:self.rightCaption];
    }
}

@end

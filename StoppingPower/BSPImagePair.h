#import <Foundation/Foundation.h>

@interface BSPImagePair : NSObject
@property (nonatomic) NSUInteger clickCount;
@property (nonatomic, readonly) NSString *leftImageUrlString;;
@property (nonatomic, readonly) NSString *rightImageUrlString;
-(id)initWithLeftImageUrlString:(NSString*)leftImageUrlString right:(NSString*)rightImageUrlString;
@end

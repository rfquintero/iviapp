#import <Foundation/Foundation.h>

@interface BSPImagePair : NSObject
@property (nonatomic, readonly) NSString *leftId;
@property (nonatomic, readonly) NSString *leftImageUrlString;
@property (nonatomic, readonly) NSString *rightId;
@property (nonatomic, readonly) NSString *rightImageUrlString;
-(id)initWithLeftId:(NSString*)leftId leftUrlString:(NSString*)leftUrlString rightId:(NSString*)rightId rightUrlString:(NSString*)rightUrlString;
@end

#import <Foundation/Foundation.h>

@interface BSPImagePair : NSObject
@property (nonatomic, readonly) NSString *leftId;
@property (nonatomic, readonly) NSString *leftImageUrlString;
@property (nonatomic, readonly) NSString *leftCaption;
@property (nonatomic, readonly) NSString *rightId;
@property (nonatomic, readonly) NSString *rightImageUrlString;
@property (nonatomic, readonly) NSString *rightCaption;
-(id)initWithLeftId:(NSString*)leftId leftUrlString:(NSString*)leftUrlString leftCaption:(NSString*)leftCaption rightId:(NSString*)rightId rightUrlString:(NSString*)rightUrlString rightCaption:(NSString*)rightCaption;
@end

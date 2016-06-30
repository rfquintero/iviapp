#import <Foundation/Foundation.h>

@interface BSPResult : NSObject
@property (nonatomic) NSInteger objectId;

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *groupId;
@property (nonatomic) NSString *gender;
@property (nonatomic) NSString *studyId;
@property (nonatomic) NSArray *selections;

@property (nonatomic, readonly) NSDictionary *toJson;
@property (nonatomic, readonly) NSData *jsonData;
@end

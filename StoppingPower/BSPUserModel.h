#import <Foundation/Foundation.h>
#import "BSPStudy.h"
#import "BSPResult.h"

#define BSPUserModelChanged @"BSPUserModelChanged"

@interface BSPUserModel : NSObject
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *groupId;
@property (nonatomic) NSString *gender;
@property (nonatomic) BSPStudy *study;
@property (nonatomic, readonly) NSArray *sessionPairs;
@property (nonatomic, readonly) BOOL infoComplete;

-(void)clearFields;
-(void)prepare;
-(void)selectedImageWithId:(NSString*)imageId;
-(BSPResult*)createResult;
@end

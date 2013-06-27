#import <Foundation/Foundation.h>
#import "BSPStudy.h"

#define BSPUserModelChanged @"BSPUserModelChanged"

@interface BSPUserModel : NSObject
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *groupId;
@property (nonatomic) NSString *gender;
@property (nonatomic, readonly) BOOL infoComplete;

-(void)setStudy:(BSPStudy*)study;
-(void)clearFields;
@end

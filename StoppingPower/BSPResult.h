#import <Foundation/Foundation.h>

@interface BSPResult : NSObject
@property (nonatomic, readonly) NSData *jsonData;

-(void)setFirstName:(NSString*)firstName;
-(void)setLastName:(NSString*)lastName;
-(void)setGroupId:(NSString*)groupId;
-(void)setGender:(NSString*)gender;
-(void)setStudyId:(NSString*)studyId;
-(void)setSelections:(NSArray*)selections;
@end

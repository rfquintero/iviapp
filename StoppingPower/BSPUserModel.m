#import "BSPUserModel.h"

@interface BSPUserModel()
@property (nonatomic) NSMutableArray *selections;
@end

@implementation BSPUserModel

-(id)init {
    if(self = [super init]) {
        self.selections = [NSMutableArray array];
    }
    return self;
}

-(void)setFirstName:(NSString *)firstName {
    _firstName = firstName;
    [self changed];
}

-(void)setLastName:(NSString *)lastName {
    _lastName = lastName;
    [self changed];
}

-(void)setGender:(NSString *)gender {
    _gender = gender;
    [self changed];
}

-(void)setGroupId:(NSString *)groupId {
    _groupId = groupId;
    [self changed];
}

-(void)setStudy:(BSPStudy*)study {
    _study = study;
    [self changed];
}

-(void)selectedImageWithId:(NSString*)imageId {
    [self.selections addObject:imageId];
}

-(void)changed {
    [[NSNotificationCenter defaultCenter] postNotificationName:BSPUserModelChanged object:self];
}

-(BOOL)infoComplete {
    return (self.firstName.length > 0 && self.lastName.length > 0 &&
            self.gender.length > 0 && self.groupId.length > 0 && self.study);
}

-(void)clearFields {
    self.firstName = @"";
    self.lastName = @"";
    self.groupId = @"";
    self.gender = @"";
    [self prepare];
}

-(BSPResult*)createResult {
    BSPResult *result = [[BSPResult alloc] init];
    result.firstName = self.firstName;
    result.lastName = self.lastName;
    result.groupId = self.groupId;
    result.gender = self.gender;
    result.studyId = self.study.objectId;
    result.selections = self.selections;
    return result;
}

-(void)prepare {
    self.selections = [NSMutableArray array];
}

@end

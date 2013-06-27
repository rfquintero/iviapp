#import "BSPUserModel.h"

@interface BSPUserModel()
@property (nonatomic) BSPStudy *study;
@end

@implementation BSPUserModel

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
}

@end

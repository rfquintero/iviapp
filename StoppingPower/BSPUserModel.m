#import "BSPUserModel.h"
#import "BSPImagePair.h"

@interface BSPUserModel()
@property (nonatomic) NSMutableArray *selections;
@property (nonatomic, readwrite) NSArray *sessionPairs;
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
    self.sessionPairs = [self createSessionPairs];
}

-(NSArray*)createSessionPairs {
    if(self.study.randomize) {
        NSUInteger count = self.study.pairs.count;
        NSMutableArray *pairs = [NSMutableArray arrayWithArray:self.study.pairs];
        
        for (NSUInteger i = self.study.warmupPairs; i < count; ++i) {
            NSInteger nElements = count - i;
            NSInteger n = (arc4random() % nElements) + i;
            [pairs exchangeObjectAtIndex:i withObjectAtIndex:n];
        }
        
        for (NSUInteger i = 0; i< count; ++i) {
            BSPImagePair *pair = [pairs objectAtIndex:i];
            [pairs replaceObjectAtIndex:i withObject:[pair pairRandomized:self.study.randomize]];
        }
        return pairs;
    } else {
        return self.study.pairs;
    }
}

@end

#import "BSPResult.h"

@interface BSPResult()
@property (nonatomic) NSMutableDictionary *dictionary;
@end

@implementation BSPResult

-(id)init {
    if(self = [super init]) {
        self.dictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)setFirstName:(NSString*)firstName {
    self.dictionary[@"first_name"] = firstName;
}

-(void)setLastName:(NSString*)lastName {
    self.dictionary[@"last_name"] = lastName;
}

-(void)setGroupId:(NSString*)groupId {
    self.dictionary[@"group_id"] = groupId;
}

-(void)setGender:(NSString*)gender {
    self.dictionary[@"gender"] = gender;
}

-(void)setStudyId:(NSString*)studyId {
    self.dictionary[@"study_id"] = studyId;
}

-(void)setSelections:(NSArray*)selections {
    self.dictionary[@"selections"] = selections;
}

-(NSData*)jsonData {
    NSDictionary *result = @{@"result" : self.dictionary};
    return [NSJSONSerialization dataWithJSONObject:result options:0 error:nil];
}

@end

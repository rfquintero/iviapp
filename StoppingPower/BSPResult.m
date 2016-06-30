#import "BSPResult.h"

@implementation BSPResult

-(void)setStudyId:(NSString *)studyId {
    _studyId = [self stringify:studyId];
}

-(void)setGroupId:(NSString *)groupId {
    _groupId = [self stringify:groupId];
}

-(NSString*)stringify:(id)value {
    return [NSString stringWithFormat:@"%@", value];
}

-(NSDictionary*)toJson {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    result[@"first_name"] = self.firstName;
    result[@"last_name"] = self.lastName;
    result[@"group_id"] = self.groupId;
    result[@"gender"] = self.gender;
    result[@"study_id"] = self.studyId;
    result[@"selections"] = self.selections;
    
    return @{@"result" : result};
}

-(NSData*)jsonData {
    return [NSJSONSerialization dataWithJSONObject:[self toJson] options:0 error:nil];
}

@end

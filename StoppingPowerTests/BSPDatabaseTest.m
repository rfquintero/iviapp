#import <GHUnitIOS/GHUnit.h>
#import "BSPDatabase.h"

@interface BSPDatabaseTest : GHTestCase {
    BSPDatabase *testObject;
    BSPDatabase *testObject2;
}

@end


@implementation BSPDatabaseTest

-(void)setUp {
    [super setUp];
    [super setUp];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"test_database.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:dbPath error:&error];
    
    testObject = [[BSPDatabase alloc] initWithDatabasePath:dbPath];
    testObject2 = [[BSPDatabase alloc] initWithDatabasePath:dbPath];
}

-(BSPResult*)createResult {
    BSPResult *result = [[BSPResult alloc] init];
    result.firstName = @"First";
    result.lastName = @"Last";
    result.gender = @"Gender";
    result.groupId = @"Group";
    result.studyId = @"Study";
    result.selections = @[@"1", @"3"];
    return result;
}

-(void)testWhenResultIsSavedThenItCanBeRetrieved {
    BSPResult *result1 = [self createResult];
    BSPResult *result2 = [self createResult];
    
    [testObject saveResult:result1];
    [testObject saveResult:result2];
    
    GHAssertEqualObjects(result1.jsonData, ((BSPResult*)[testObject getResults][0]).jsonData, nil);
    GHAssertEqualObjects(result2.jsonData, ((BSPResult*)[testObject getResults][1]).jsonData, nil);
}

-(void)testWhenResultIsRemovedThenItCannotBeRetrieved {
    BSPResult *result1 = [self createResult];
    BSPResult *result2 = [self createResult];
    result2.firstName = @"First2";
    
    [testObject saveResult:result1];
    [testObject saveResult:result2];
    
    NSArray *results = [testObject2 getResults];
    [testObject removeResult:results[0]];
    
    GHAssertTrue([testObject2 getResults].count == 1, nil);
    GHAssertEqualObjects(result2.jsonData, ((BSPResult*)[testObject2 getResults][0]).jsonData, nil);
}

@end

#import <GHUnitIOS/GHUnit.h>
#import "BSPDatabase.h"
#import "BSPStudy.h"
#import "BSPImagePair.h"

@interface BSPDatabaseTest : GHTestCase {
    BSPDatabase *testObject;
    BSPDatabase *testObject2;
}

@end


@implementation BSPDatabaseTest

-(void)setUp {
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

-(void)testWhenStudiesAreSavedThenTheyCanBeRetrieved {
    BSPImagePair *pair1 = [[BSPImagePair alloc] initWithLeftId:@"l1" leftUrlString:@"lurl1" leftCaption:@"lcap1" rightId:@"r1" rightUrlString:@"rurl1" rightCaption:@"rcap1"];
    BSPImagePair *pair2 = [[BSPImagePair alloc] initWithLeftId:@"l2" leftUrlString:@"lurl2" leftCaption:@"lcap2" rightId:@"r2" rightUrlString:@"rurl2" rightCaption:@"rcap2"];
    BSPImagePair *pair3 = [[BSPImagePair alloc] initWithLeftId:@"l3" leftUrlString:@"lurl3" leftCaption:@"lcap3" rightId:@"r3" rightUrlString:@"rurl3" rightCaption:@"rcap3"];
    BSPImagePair *pair4 = [[BSPImagePair alloc] initWithLeftId:@"l4" leftUrlString:@"lurl4" leftCaption:@"lcap4" rightId:@"r4" rightUrlString:@"rurl4" rightCaption:@"rcap4"];
    BSPStudy *study1 = [[BSPStudy alloc] initWithId:@"1" title:@"title1" description:@"desc1" pairs:@[pair1, pair2, pair3] instructions:@"Hi" timer:1.5 randomize:YES];
    BSPStudy *study2 = [[BSPStudy alloc] initWithId:@"2" title:@"title2" description:@"desc2" pairs:@[pair4] instructions:@"Hello" timer:0.0 randomize:NO];
    
    [testObject saveStudies:@[study1, study2]];
    
    NSArray* studies = [testObject2 getStudies];
    
    [self assertStudy:studies[0] isEqual:study1];
    [self assertStudy:studies[1] isEqual:study2];
}

-(void)testWhenStudiesAreSavedThenOldStudiesAreRemoved {
    BSPImagePair *pair1 = [[BSPImagePair alloc] initWithLeftId:@"l1" leftUrlString:@"lurl1" leftCaption:@"lcap1" rightId:@"r1" rightUrlString:@"rurl1" rightCaption:@"rcap1"];
    BSPImagePair *pair2 = [[BSPImagePair alloc] initWithLeftId:@"l2" leftUrlString:@"lurl2" leftCaption:@"lcap2" rightId:@"r2" rightUrlString:@"rurl2" rightCaption:@"rcap2"];
    BSPImagePair *pair3 = [[BSPImagePair alloc] initWithLeftId:@"l3" leftUrlString:@"lurl3" leftCaption:@"lcap3" rightId:@"r3" rightUrlString:@"rurl3" rightCaption:@"rcap3"];
    BSPImagePair *pair4 = [[BSPImagePair alloc] initWithLeftId:@"l4" leftUrlString:@"lurl4" leftCaption:@"lcap4" rightId:@"r4" rightUrlString:@"rurl4" rightCaption:@"rcap4"];
    BSPStudy *study1 = [[BSPStudy alloc] initWithId:@"1" title:@"title1" description:@"desc1" pairs:@[pair1, pair2, pair3] instructions:@"Hi" timer:1.5 randomize:YES];
    BSPStudy *study2 = [[BSPStudy alloc] initWithId:@"2" title:@"title2" description:@"desc2" pairs:@[pair4] instructions:@"Hello" timer:0.0 randomize:NO];
    BSPStudy *study3 = [[BSPStudy alloc] initWithId:@"3" title:@"title3" description:@"desc3" pairs:@[pair1, pair4] instructions:@"Take the study" timer:2.5 randomize:YES];
    
    [testObject saveStudies:@[study1, study2]];
    [testObject saveStudies:@[study3]];
    
    NSArray* studies = [testObject getStudies];
    
    GHAssertTrue(studies.count == 1, nil);
    [self assertStudy:studies[0] isEqual:study3];
}

-(void)assertStudy:(BSPStudy*)study1 isEqual:(BSPStudy*)study2 {
    GHAssertEqualObjects(study1.objectId, study2.objectId, nil);
    GHAssertEqualObjects(study1.title, study2.title, nil);
    GHAssertEqualObjects(study1.description, study2.description, nil);
    GHAssertEqualObjects(study1.instructions, study2.instructions, nil);
    GHAssertEqualsWithAccuracy(study1.timer, study2.timer, 0.0001, nil);
    GHAssertEquals(study1.randomize, study2.randomize, nil);
    
    GHAssertEquals(study1.pairs.count, study2.pairs.count, nil);
    for(int i=0; i<study1.pairs.count; i++) {
        BSPImagePair *pair1 = study1.pairs[i];
        BSPImagePair *pair2 = study2.pairs[i];
        GHAssertEqualObjects(pair1.leftId, pair2.leftId, nil);
        GHAssertEqualObjects(pair1.leftImageUrlString, pair2.leftImageUrlString, nil);
        GHAssertEqualObjects(pair1.leftCaption, pair2.leftCaption, nil);
        GHAssertEqualObjects(pair1.rightId, pair2.rightId, nil);
        GHAssertEqualObjects(pair1.rightImageUrlString, pair2.rightImageUrlString, nil);
        GHAssertEqualObjects(pair1.rightCaption, pair2.rightCaption, nil);
    }
}

@end

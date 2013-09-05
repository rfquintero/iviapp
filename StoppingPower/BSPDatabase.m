#import "BSPDatabase.h"
#import "BSPDatabaseUtilities.h"
#import "BSPStudy.h"
#import "BSPImagePair.h"

@interface BSPDatabase()
@property(nonatomic, assign) sqlite3 *database;
@end

@implementation BSPDatabase

static int const kSchemaVersion = 3;

- (id)initWithDatabasePath:(NSString *)databasePath {
    if ((self = [super init])) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL databaseExists = [fileManager fileExistsAtPath:databasePath];
        sqlite3 *database = NULL;
        if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            if (databaseExists) {
                int version = -1;
                const char *sql = "SELECT version FROM version";
                sqlite3_stmt *statement = NULL;
                sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    version = sqlite3_column_int(statement, 0);
                }
                sqlite3_finalize(statement);
                
                if (version != kSchemaVersion) {
                    [self performUpdateOnDatabase:database from:version to:kSchemaVersion];
                }
            } else {
                [self performCreate:database];
            }
        } else {
            sqlite3_close(database);
            database = NULL;
            NSLog(@"Failed to open cache database");
        }
        self.database = database;
    }
    return self;
}

- (void)dealloc {
    sqlite3_close(self.database);
    self.database = NULL;
}

- (void)performCreate:(sqlite3 *)database {
    sqlite3_execute(database, @"CREATE TABLE results (first_name TEXT, last_name TEXT, group_id TEXT, gender TEXT, study_id TEXT, selections TEXT)");
    sqlite3_execute(database, @"CREATE TABLE ipairs (left_id TEXT, left_url TEXT, left_caption TEXT, right_id TEXT, right_url TEXT, right_caption TEXT)");
    sqlite3_execute(database, @"CREATE TABLE studies (object_id TEXT PRIMARY KEY, title TEXT, description TEXT, pairIds TEXT)");
    
    sqlite3_execute(database, @"CREATE TABLE version (version INTEGER PRIMARY KEY)");
    sqlite3_execute(database, [NSString stringWithFormat:@"INSERT INTO version VALUES (%d)", kSchemaVersion]);
}

- (void)performUpdateOnDatabase:(sqlite3 *)database from:(int)oldVersion to:(int)newVersion {
    sqlite3_execute(database, @"DROP TABLE IF EXISTS results");
    sqlite3_execute(database, @"DROP TABLE IF EXISTS studies");
    sqlite3_execute(database, @"DROP TABLE IF EXISTS ipairs");
    sqlite3_execute(database, @"DROP TABLE IF EXISTS version");
    [self performCreate:database];
}

-(void)saveResult:(BSPResult *)result {
    @synchronized(self) {
        NSData *selectionData = [NSJSONSerialization dataWithJSONObject:result.selections options:0 error:nil];
        static const char *sql = "INSERT INTO results (first_name, last_name, group_id, gender, study_id, selections) VALUES (?, ?, ?, ?, ?, ?)";
        sqlite3_stmt *statement = NULL;
        sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL);
        sqlite3_bind_string(statement, 1, result.firstName);
        sqlite3_bind_string(statement, 2, result.lastName);
        sqlite3_bind_string(statement, 3, result.groupId);
        sqlite3_bind_string(statement, 4, result.gender);
        sqlite3_bind_string(statement, 5, result.studyId);
        sqlite3_bind_blob(statement, 6, selectionData.bytes, selectionData.length, SQLITE_TRANSIENT);
        sqlite3_step(statement);
        sqlite3_finalize(statement);
    }
}


-(NSArray*)getResults {
    NSMutableArray *results = [NSMutableArray array];
    @synchronized(self) {
        const char *sql = "SELECT first_name, last_name, group_id, gender, study_id, selections, ROWID FROM results";
        sqlite3_stmt *statement = NULL;
        sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL);
        BSPResult *result;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            result  = [[BSPResult alloc] init];
            result.firstName = sqlite3_column_string(statement, 0);
            result.lastName = sqlite3_column_string(statement, 1);
            result.groupId = sqlite3_column_string(statement, 2);
            result.gender = sqlite3_column_string(statement, 3);
            result.studyId = sqlite3_column_string(statement, 4);
            result.objectId = sqlite3_column_int64(statement, 6);
            
            const void * bytes = sqlite3_column_blob(statement, 5);
            int length = sqlite3_column_bytes(statement, 5);
            NSData *selectionData = [NSData dataWithBytes:bytes length:length];
            result.selections = [NSJSONSerialization JSONObjectWithData:selectionData options:0 error:nil];
            
            [results addObject:result];
        }
        sqlite3_finalize(statement);
    }
    return results;
}

-(void)removeResult:(BSPResult*)result {
    @synchronized(self) {
        const char *sql = "DELETE FROM results WHERE ROWID=?";
        sqlite3_stmt *statement = NULL;
        sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL);
        sqlite3_bind_int64(statement, 1, result.objectId);
        sqlite3_step(statement);
        sqlite3_finalize(statement);
    }
}

-(void)saveStudies:(NSArray *)studies {
    @synchronized(self) {
        [self removeStudies];
        [self removePairs];
        for(BSPStudy* study in studies) {
            NSMutableArray *pairIds = [NSMutableArray array];
            for(int i=0; i<study.pairs.count; i++) {
                BSPImagePair *pair = study.pairs[i];
                [pairIds addObject:@([self savePair:pair])];
            }
            
            NSData *pairData = [NSJSONSerialization dataWithJSONObject:pairIds options:0 error:nil];
            static const char *sql = "INSERT INTO studies (object_id, title, description, pairIds) VALUES (?, ?, ?, ?)";
            sqlite3_stmt *statement = NULL;
            sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL);
            sqlite3_bind_string(statement, 1, study.objectId);
            sqlite3_bind_string(statement, 2, study.title);
            sqlite3_bind_string(statement, 3, study.description);
            sqlite3_bind_blob(statement, 4, pairData.bytes, pairData.length, SQLITE_TRANSIENT);
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
    }
}

-(NSArray*)getStudies {
    NSMutableArray *studies = [NSMutableArray array];
    @synchronized(self) {
        const char *sql = "SELECT object_id, title, description, pairIds FROM studies";
        sqlite3_stmt *statement = NULL;
        sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL);

        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *objectId = sqlite3_column_string(statement, 0);
            NSString *title = sqlite3_column_string(statement, 1);
            NSString *description = sqlite3_column_string(statement, 2);
            
            const void * bytes = sqlite3_column_blob(statement, 3);
            int length = sqlite3_column_bytes(statement, 3);
            NSData *pairData = [NSData dataWithBytes:bytes length:length];
            NSArray *pairIds = [NSJSONSerialization JSONObjectWithData:pairData options:0 error:nil];
            
            NSMutableArray *pairs = [NSMutableArray array];
            for(NSNumber *pairId in pairIds) {
                BSPImagePair *pair = [self getPair:[pairId longValue]];
                if(pair) {
                    [pairs addObject:pair];
                }
            }
            
            [studies addObject:[[BSPStudy alloc] initWithId:objectId title:title description:description pairs:pairs]];
        }
        sqlite3_finalize(statement);
    }
    return studies;
}

-(void)removeStudies {
    const char *sql = "DELETE FROM studies";
    sqlite3_stmt *statement = NULL;
    sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL);
    sqlite3_step(statement);
    sqlite3_finalize(statement);
}

-(void)removePairs {
    const char *sql = "DELETE FROM ipairs";
    sqlite3_stmt *statement = NULL;
    sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL);
    sqlite3_step(statement);
    sqlite3_finalize(statement);
}

-(sqlite3_int64)savePair:(BSPImagePair*)pair {
    static const char *sql = "INSERT INTO ipairs (left_id, left_url, left_caption, right_id, right_url, right_caption) VALUES (?, ?, ?, ?, ?, ?)";
    sqlite3_stmt *statement = NULL;
    sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL);
    sqlite3_bind_string(statement, 1, pair.leftId);
    sqlite3_bind_string(statement, 2, pair.leftImageUrlString);
    sqlite3_bind_string(statement, 3, pair.leftCaption);
    sqlite3_bind_string(statement, 4, pair.rightId);
    sqlite3_bind_string(statement, 5, pair.rightImageUrlString);
    sqlite3_bind_string(statement, 6, pair.rightCaption);
    sqlite3_step(statement);
    sqlite3_finalize(statement);
    int rowId = sqlite3_last_insert_rowid(self.database);

    return rowId;
}

-(BSPImagePair*)getPair:(sqlite3_int64)pairId {
    const char *sql = "SELECT left_id, left_url, left_caption, right_id, right_url, right_caption FROM ipairs WHERE ROWID=?";
    sqlite3_stmt *statement = NULL;
    sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL);
    sqlite3_bind_int64(statement, 1, pairId);
    BSPImagePair *pair = nil;
    if (sqlite3_step(statement) == SQLITE_ROW) {
        NSString *leftId = sqlite3_column_string(statement, 0);
        NSString *leftUrl = sqlite3_column_string(statement, 1);
        NSString *leftCaption = sqlite3_column_string(statement, 2);
        
        NSString *rightId = sqlite3_column_string(statement, 3);
        NSString *rightUrl = sqlite3_column_string(statement, 4);
        NSString *rightCaption = sqlite3_column_string(statement, 5);

        pair = [[BSPImagePair alloc] initWithLeftId:leftId leftUrlString:leftUrl leftCaption:leftCaption rightId:rightId rightUrlString:rightUrl rightCaption:rightCaption];
    }
    sqlite3_finalize(statement);
    return pair;
}


@end

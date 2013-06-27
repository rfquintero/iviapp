#import "BSPDatabase.h"
#import "BSPDatabaseUtilities.h"

@interface BSPDatabase()
@property(nonatomic, assign) sqlite3 *database;
@end

@implementation BSPDatabase

static int const kSchemaVersion = 1;

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

    sqlite3_execute(database, @"CREATE TABLE version (version INTEGER PRIMARY KEY)");
    sqlite3_execute(database, [NSString stringWithFormat:@"INSERT INTO version VALUES (%d)", kSchemaVersion]);
}

- (void)performUpdateOnDatabase:(sqlite3 *)database from:(int)oldVersion to:(int)newVersion {
    sqlite3_execute(database, @"DROP TABLE IF EXISTS results");
    [self performCreate:database];
}

-(void)saveResult:(BSPResult *)result {
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


-(NSArray*)getResults {
    NSMutableArray *results = [NSMutableArray array];
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
    return results;
}

-(void)removeResult:(BSPResult*)result {
    const char *sql = "DELETE FROM results WHERE ROWID=?";
    sqlite3_stmt *statement = NULL;
    sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL);
    sqlite3_bind_int64(statement, 1, result.objectId);
    sqlite3_step(statement);
    sqlite3_finalize(statement);
}


@end

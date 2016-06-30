#import "BSPDatabaseUtilities.h"

int sqlite3_bind_string(sqlite3_stmt *statement, int column, NSString *string) {
    int returnCode;
    if (string) {
        const char *value = [string UTF8String];
        returnCode = sqlite3_bind_text(statement, column, value, (int)strlen(value), SQLITE_TRANSIENT);
    } else {
        returnCode = sqlite3_bind_null(statement, column);
    }
    return returnCode;
}

void sqlite3_bind_strings(sqlite3_stmt *statement, int startColumn, id<NSFastEnumeration> strings) {
    int currentColumn = startColumn;
    for (NSString *string in strings) {
        sqlite3_bind_string(statement, currentColumn++, string);
    }
}

NSString *sqlite3_column_string(sqlite3_stmt *statement, int column) {
    char *rawString = (char *) sqlite3_column_text(statement, column);
    if (rawString == NULL) {
        return nil;
    }
    return [NSString stringWithUTF8String:rawString];
}

void sqlite3_execute(sqlite3 *database, NSString *sql) {
    sqlite3_stmt *statement = NULL;
    sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
    sqlite3_step(statement);
}
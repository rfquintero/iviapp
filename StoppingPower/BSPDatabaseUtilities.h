#import <sqlite3.h>

void sqlite3_bind_strings(sqlite3_stmt *statement, int startColumn, id<NSFastEnumeration> strings);

int sqlite3_bind_string(sqlite3_stmt *statement, int column, NSString *string);

NSString *sqlite3_column_string(sqlite3_stmt *statement, int column);

void sqlite3_execute(sqlite3 *database, NSString *sql);
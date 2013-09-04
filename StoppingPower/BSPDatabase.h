#import <Foundation/Foundation.h>
#import "BSPResult.h"

@interface BSPDatabase : NSObject
- (id)initWithDatabasePath:(NSString *)databasePath;

-(void)saveResult:(BSPResult*)result;
-(void)removeResult:(BSPResult*)result;
-(NSArray*)getResults;

-(void)saveStudies:(NSArray*)studies;
-(NSArray*)getStudies;
@end

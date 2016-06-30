#import <Foundation/Foundation.h>
#import "BSPStudy.h"
#import "BSPDao.h"
#import "BSPDatabase.h"

#define BSPStudyModelStudiesRetrieved @"BSPStudyModelStudiesRetrieved"
#define BSPStudyModelStudyImagesRetrieved @"BSPStudyModelStudyImagesRetrieved"
#define BSPStudyModelRegistered @"BSPStudyModelRegistered"
#define BSPStudyModelError @"BSPStudyModelError"
#define BSPStudyModelErrorKey @"BSPStudyModelErrorKey"

@interface BSPStudyModel : NSObject
@property (nonatomic, readonly) NSArray *studies;

-(id)initWithDao:(BSPDao*)dao database:(BSPDatabase*)database;
-(void)retrieveStudies;
-(void)retrieveAllImages;
-(void)registerDevice:(NSString*)password;
@end

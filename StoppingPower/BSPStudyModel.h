#import <Foundation/Foundation.h>
#import "BSPStudy.h"
#import "BSPDao.h"

#define BSPStudyModelStudiesRetrieved @"BSPStudyModelStudiesRetrieved"
#define BSPStudyModelStudyImagesRetrieved @"BSPStudyModelStudyImagesRetrieved"
#define BSPStudyModelError @"BSPStudyModelError"
#define BSPStudyModelErrorKey @"BSPStudyModelErrorKey"

@interface BSPStudyModel : NSObject
@property (nonatomic, readonly) NSArray *studies;

-(id)initWithDao:(BSPDao*)dao;
-(void)retrieveStudies;
-(void)retrieveImagesForStudy:(BSPStudy*) study;
@end

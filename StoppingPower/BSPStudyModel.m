#import "BSPStudyModel.h"
#import "BSPImagePair.h"
#import <SDWebImage/SDWebImageManager.h>

@interface BSPStudyModel()
@property (nonatomic, readwrite) NSArray *studies;
@property (atomic) NSUInteger imageCount;
@property (atomic) NSUInteger studyCount;
@property (nonatomic) NSUInteger imageProgress;
@property (nonatomic) BSPDao *dao;
@end

@implementation BSPStudyModel

-(id)initWithDao:(BSPDao*)dao {
    if(self = [super init]) {
        self.dao = dao;
    }
    
    return self;
}

-(void)retrieveStudies {
    [self.dao retrieveStudies:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error) {
            [self postNotificationOnMainThread:BSPStudyModelError userInfo:@{BSPStudyModelErrorKey : error}];
        } else if(!response){
            error = [NSError errorWithDomain:@"Unable to reach server. Please check your internet connection." code:0 userInfo:nil];
            [self postNotificationOnMainThread:BSPStudyModelError userInfo:@{BSPStudyModelErrorKey : error}];
        } else {
            NSArray *studies = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [self parseStudies:studies];
        }
    }];
}

-(void)parseStudies:(NSArray*)jsonStudies {
    NSMutableArray *studies = [NSMutableArray array];
    for(NSDictionary *jsonStudy in jsonStudies) {
        BOOL published = [jsonStudy[@"published"] boolValue];
        if(published) {
            NSString *objectId = jsonStudy[@"id"];
            NSString *title = jsonStudy[@"name"];
            NSString *description = nil;
            NSArray *pairs = [self parsePairs:jsonStudy[@"pairs"]];

            [studies addObject:[[BSPStudy alloc] initWithId:objectId title:title description:description pairs:pairs]];
        }
    }
    
    self.studies = studies;
    [self postNotificationOnMainThread:BSPStudyModelStudiesRetrieved userInfo:nil];
}

-(NSArray*)parsePairs:(NSArray*)jsonPairs {
    NSMutableArray *pairs = [NSMutableArray array];
    for(NSDictionary *jsonPair in jsonPairs) {
        NSString *leftUrl = [NSString stringWithFormat:@"%@", jsonPair[@"choice1"]];
        NSString *rightUrl = [NSString stringWithFormat:@"%@", jsonPair[@"choice2"]];
        NSUInteger clickCount = 0;
        
        BSPImagePair *pair = [[BSPImagePair alloc] initWithLeftImageUrlString:leftUrl right:rightUrl];
        pair.clickCount = clickCount;
        [pairs addObject:pair];
    }
    
    return pairs;
}

-(void)postNotificationOnMainThread:(NSString*)name userInfo:(NSDictionary*)userInfo {
    NSNotification *notification = [NSNotification notificationWithName:name object:self userInfo:userInfo];
    [self performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
}

-(void)postNotification:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void)retrieveAllImages {
    self.studyCount = 0;
    [self retrieveNextStudyImages];
}

-(void)retrieveNextStudyImages {
    if(self.studyCount < self.studies.count) {
        [self retrieveImagesForStudy:self.studies[self.studyCount]];
    } else {
        [self postNotificationOnMainThread:BSPStudyModelStudyImagesRetrieved userInfo:nil];
    }
}

-(void)imageRetrieved {
    self.imageProgress = self.imageProgress + 1;
    if(self.imageProgress >= self.imageCount) {
        self.studyCount = self.studyCount + 1;
        [self retrieveNextStudyImages];
    }
}

-(void)retrieveImagesForStudy:(BSPStudy*)study {
    self.imageCount = study.pairs.count*2;
    self.imageProgress = 0;
    for(BSPImagePair *pair in study.pairs) {
        [self downloadImage:pair.leftImageUrlString];
        [self downloadImage:pair.rightImageUrlString];
    }
}

-(void)downloadImage:(NSString*)imageUrlString {
    NSURL* imageUrl = [NSURL URLWithString:imageUrlString];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:imageUrl options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {}
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                       if(image && finished) {
                           [self performSelectorOnMainThread:@selector(imageRetrieved) withObject:nil waitUntilDone:NO];
                       } else {
                           error = [NSError errorWithDomain:@"An error occured while retrieving study information. Please try again later." code:0 userInfo:nil];
                           [self postNotificationOnMainThread:BSPStudyModelError userInfo:@{BSPStudyModelErrorKey : error}];
                       }
    }];
}

@end
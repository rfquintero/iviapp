#import "BSPStudyModel.h"
#import "BSPImagePair.h"
#import <SDWebImage/SDWebImageManager.h>

@interface BSPStudyModel()
@property (nonatomic, readwrite) NSArray *studies;
@property (atomic) NSUInteger imageCount;
@property (atomic) NSUInteger studyCount;
@property (nonatomic) NSUInteger imageProgress;
@property (nonatomic) BSPDao *dao;
@property (nonatomic) BSPDatabase *database;
@end

@implementation BSPStudyModel

-(id)initWithDao:(BSPDao*)dao database:(BSPDatabase*)database{
    if(self = [super init]) {
        self.dao = dao;
        self.database = database;
        self.studies = [self.database getStudies];
        TFLog(@"Retrieved %lu studies from the db.", (unsigned long)self.studies.count);
    }
    
    return self;
}

-(void)registerDevice:(NSString*)password {
    [self.dao registerDevice:password handler:^(NSHTTPURLResponse *response, NSData *data, NSError *error) {
        if(error) {
            [self postNotificationNamed:BSPStudyModelError userInfo:@{BSPStudyModelErrorKey : error}];
        } else {
            [self postNotificationNamed:BSPStudyModelRegistered userInfo:nil];
        }
    }];
}

-(void)retrieveStudies {
    [self.dao retrieveStudies:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error) {
            [self postNotificationNamed:BSPStudyModelError userInfo:@{BSPStudyModelErrorKey : error}];
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
        BOOL active = [jsonStudy[@"active"] boolValue];
        if(published && active) {
            NSString *objectId = [self nullSafe:jsonStudy[@"id"]];
            NSString *title = [self nullSafe:jsonStudy[@"name"]];
            NSString *description = [self nullSafe:jsonStudy[@"caption"]];
            NSArray *pairs = [self parsePairs:jsonStudy[@"pairs"]];
            NSString *instructions = [self nullSafe:jsonStudy[@"instructions"]];
            CGFloat timer = [[self nullSafeId:jsonStudy[@"timer"]] floatValue];
            NSInteger warmupPairs = [[self nullSafeId:jsonStudy[@"warmup_pairs"]] integerValue];
            BOOL randomize = [[self nullSafeId:jsonStudy[@"randomize"]] boolValue];
            

            [studies addObject:[[BSPStudy alloc] initWithId:objectId title:title description:description pairs:pairs
                                instructions:instructions timer:timer randomize:randomize warmupPairs:warmupPairs]];
        }
    }
    
    [self.database saveStudies:studies];
    self.studies = studies;
    [self postNotificationNamed:BSPStudyModelStudiesRetrieved userInfo:nil];
}

-(NSArray*)parsePairs:(NSArray*)jsonPairs {
    NSMutableArray *pairs = [NSMutableArray array];
    for(NSDictionary *jsonPair in jsonPairs) {
        NSString *leftUrl = [self nullSafe:jsonPair[@"choice1"]];
        NSString *rightUrl = [self nullSafe:jsonPair[@"choice2"]];
        NSString *leftId = [self nullSafe:jsonPair[@"choice1_id"]];
        NSString *rightId = [self nullSafe:jsonPair[@"choice2_id"]];
        NSString *leftCaption = [self nullSafe:jsonPair[@"choice1_caption"]];
        NSString *rightCaption = [self nullSafe:jsonPair[@"choice2_caption"]];
        
        [pairs addObject:[[BSPImagePair alloc] initWithLeftId:leftId leftUrlString:leftUrl leftCaption:leftCaption rightId:rightId rightUrlString:rightUrl rightCaption:rightCaption]];
    }
    
    return pairs;
}

-(NSString*)nullSafe:(NSString*)string {
    if(string == NULL) {
        return @"";
    } else if (!string) {
        return @"";
    } else if ([[NSNull null] isEqual:string]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@", string];
}

-(id)nullSafeId:(id)object {
    if(object == NULL) {
        return nil;
    } else if (!object) {
        return nil;
    } else if ([[NSNull null] isEqual:object]) {
        return nil;
    }
    return object;
}

-(void)postNotificationOnMainThread:(NSString*)name userInfo:(NSDictionary*)userInfo {
    NSNotification *notification = [NSNotification notificationWithName:name object:self userInfo:userInfo];
    [self performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
}

-(void)postNotificationNamed:(NSString*)name userInfo:(NSDictionary*)userInfo {
    NSNotification *notification = [NSNotification notificationWithName:name object:self userInfo:userInfo];
    [self postNotification:notification];
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
    [manager downloadWithURL:imageUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                       NSLog(@"Image Retrieved from (0-web, 1-disk, 2-mem): %i", (int)cacheType);
                       if(image && finished) {
                           [self performSelectorOnMainThread:@selector(imageRetrieved) withObject:nil waitUntilDone:NO];
                       } else {
                           error = [NSError errorWithDomain:@"An error occured while retrieving study information. Please try again later." code:0 userInfo:nil];
                           [self postNotificationOnMainThread:BSPStudyModelError userInfo:@{BSPStudyModelErrorKey : error}];
                       }
    }];
}

@end
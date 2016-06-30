#import "BSPDao.h"

@interface BSPDaoResponse : NSObject
@property (nonatomic) NSHTTPURLResponse *response;
@property (nonatomic) NSError *error;
@property (nonatomic) NSData *data;
@property (nonatomic) BOOL unauthorized;
@property (nonatomic, copy) BSPCallback handler;
@end

@implementation BSPDaoResponse
+(instancetype)response:(NSHTTPURLResponse*)response data:(NSData*)data error:(NSError*)error handler:(BSPCallback)handler {
    BSPDaoResponse *dr = [[BSPDaoResponse alloc] init];
    dr.response = response;
    dr.data = data;
    dr.error = error;
    dr.handler = handler;
    return dr;
}
@end

@interface BSPDao()
@property (nonatomic) NSOperationQueue *queue;
@property (nonatomic, readwrite) NSString *endpoint;
@property (nonatomic) BSPDatabase *database;
@property (nonatomic) NSString *token;
@end

@implementation BSPDao

-(id)initWithDatabase:(BSPDatabase*)database {
    if (self = [super init]) {
        self.endpoint = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BSPWebEndpoint"];
        self.queue = [[NSOperationQueue alloc] init];
        self.database = database;
        
        [self retrieveToken];
    }
    
    return self;
}

-(BOOL)authorized {
    return self.token != nil;
}

-(void)retrieveToken {
    self.token = [self.database getToken];
}

-(void)retrieveStudies:(BSPCallback) handler {
    NSString *path = [NSString stringWithFormat:@"app.json%@", [self queryString:[self parametersWithAuthorization:nil]]];
    NSMutableURLRequest *request = [self request:@"GET" path:path];

    [self performRequest:request handler:handler];
}

-(void)publishResult:(BSPResult*)result handler:(BSPCallback)handler {
    NSMutableURLRequest *request = [self request:@"POST" path:@"app/result.json"];
    NSDictionary *params = [self parametersWithAuthorization:result.toJson];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:0 error:nil]];
    
    [self performRequest:request handler:handler];
}

-(void)registerDevice:(NSString*)password handler:(BSPCallback)handler {
    if(!password) {
        password = @"";
    }
    
    NSMutableURLRequest *request = [self request:@"POST" path:@"app/register.json"];
    NSDictionary *params = @{@"password" : password, @"name" : [self deviceName]};
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:0 error:nil]];
    
    [self performRequest:request handler:^(NSHTTPURLResponse *response, NSData *data, NSError *error) {
        if(response) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [self.database saveToken:json[@"token"]];
            [self retrieveToken];
        }
        handler(response, data, error);
    }];
}

# pragma mark Helper Methods

-(void)responseReceived:(BSPDaoResponse*)dr {
    if(dr.unauthorized) {
        [self.database removeAllStudies];
        [self.database removeToken];
        self.token = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:BSPDaoAuthorizationChanged object:self];
    }
    dr.handler(dr.response, dr.data, dr.error);
}

-(void)performRequest:(NSURLRequest*)request handler:(BSPCallback)handler {
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        BSPDaoResponse *dr = nil;
        if(error) {
            dr = [BSPDaoResponse response:nil data:nil error:error handler:handler];
        } else if(!response) {
            error = [NSError errorWithDomain:@"Unable to reach server. Please check your internet connection." code:0 userInfo:nil];
            dr = [BSPDaoResponse response:nil data:nil error:error handler:handler];
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if(httpResponse.statusCode == 403) {
                error = [NSError errorWithDomain:@"Unauthorized request. Please activate web access and try again." code:0 userInfo:nil];
                dr = [BSPDaoResponse response:nil data:nil error:error handler:handler];
                dr.unauthorized = YES;
            } else if(httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                dr = [BSPDaoResponse response:httpResponse data:data error:nil handler:handler];
            } else {
                error = [NSError errorWithDomain:@"An unexpected error occurred. Please try again later." code:0 userInfo:nil];
                if(data) {
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    if(json && json[@"error"]) {
                        error = [NSError errorWithDomain:json[@"error"] code:0 userInfo:nil];
                    }
                }
                
                dr = [BSPDaoResponse response:nil data:nil error:error handler:handler];
            }
        }
        [self performSelectorOnMainThread:@selector(responseReceived:) withObject:dr waitUntilDone:NO];
    }];
}

-(NSString*)encode:(NSString*)unencodedString {
    if([unencodedString isKindOfClass:NSString.class]) {
        return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)unencodedString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 ));
    } else {
        return unencodedString;
    }
}

-(NSMutableURLRequest*)request:(NSString*)method path:(NSString*)path {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.endpoint, path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setTimeoutInterval:30.0f];
    [request setHTTPMethod:method];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    return request;
}

-(NSDictionary*)parametersWithAuthorization:(NSDictionary*)parameters {
    NSMutableDictionary *authParams = parameters ? [parameters mutableCopy] : [NSMutableDictionary dictionary];
    
    [authParams setObject:[self deviceName] forKey:@"name"];
    if(self.token) {
        [authParams setObject:self.token forKey:@"token"];
    }
    
    return authParams;
}

-(NSString*)queryString:(NSDictionary*)parameters {
    if(parameters.count > 0) {
        return [NSString stringWithFormat:@"?%@", [self paramString:parameters]];
    } else {
        return @"";
    }
}

-(NSString*)paramString:(NSDictionary*)parameters {
    NSMutableArray *params = [NSMutableArray array];
    for(NSString *key in [parameters allKeys]) {
        [params addObject:[NSString stringWithFormat:@"%@=%@", [self encode:key], [self encode:[parameters objectForKey:key]]]];
    }
    return [params componentsJoinedByString:@"&"];
}

-(NSString*)deviceName {
    return [[UIDevice currentDevice] name];
}

@end

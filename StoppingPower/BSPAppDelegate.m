//
//  BSPAppDelegate.m
//  StoppingPower
//
//  Created by Ruben Quintero on 5/28/13.
//  Copyright (c) 2013 Ruben Quintero. All rights reserved.
//

#import "BSPAppDelegate.h"
#import "BSPLandingViewController.h"
#import "BSPApplicationState.h"
#import "TestFlight.h"

@interface BSPAppDelegate()
@property (nonatomic) BSPApplicationState *applicationState;

@end

@implementation BSPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    [TestFlight takeOff:@"43d83872-75b2-43c6-8808-152eeedb34b2"];
    
    BSPApplicationState *applicationState = [[BSPApplicationState alloc] init];
    self.applicationState = applicationState;
    
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[BSPLandingViewController alloc] initWithAppState:applicationState]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end

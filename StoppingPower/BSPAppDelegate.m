//
//  BSPAppDelegate.m
//  StoppingPower
//
//  Created by Ruben Quintero on 5/28/13.
//  Copyright (c) 2013 Ruben Quintero. All rights reserved.
//

#import "BSPAppDelegate.h"
#import "BSPLandingViewController.h"

@implementation BSPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[BSPLandingViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

@end

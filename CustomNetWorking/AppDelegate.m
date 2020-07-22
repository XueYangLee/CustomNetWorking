//
//  AppDelegate.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomNetWorkManager.h"
#import "NetRequestConfig.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [CustomNetWorkManager sharedManager].config=[NetRequestConfig new];
    return YES;
}



@end

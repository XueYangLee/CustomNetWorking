//
//  NetRequestConfig.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/27.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "NetRequestConfig.h"

@implementation NetRequestConfig

- (NSMutableDictionary *)requestHeader{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]?:@"";
    [dic setObject:currentVersion forKey:@"AppVersion"];
    
    NSString *metaData = [NSString stringWithFormat:@"AppStore_iOS_%@",currentVersion];
    [dic setObject:metaData forKey:@"Metadata"];
    
    return dic;
}


- (BOOL)activityIndicatorOpen{
    return YES;
}

- (NSMutableDictionary *)publicParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"2dca7299f47cae1ada2ab1b864f3ce8c" forKey:@"key"];
    return dic;
}

@end

//
//  CustomNetWorkRequestLog+LogDecode.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/27.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "CustomNetWorkRequestLog+LogDecode.h"
#import "NSObject+SwizzleMethod.h"

@implementation CustomNetWorkRequestLog (LogDecode)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//保证方法替换只被执行一次

        [CustomNetWorkRequestLog swizzleClassMethodWithOriginalSEL:@selector(logWithSessionTask:ResponseObj:Error:) SwizzleNewSEL:@selector(swizzle_logWithSessionTask:ResponseObj:Error:)];
    });
}

+ (void)swizzle_logWithSessionTask:(NSURLSessionDataTask *)sessionTask ResponseObj:(id)responseObj Error:(NSError *)error{
    if (error) {
        DLog(@"**********请求失败---URL:%@\nHeader:%@\nError:\n%@", sessionTask.currentRequest.URL,sessionTask.currentRequest.allHTTPHeaderFields,error.description);
    }else{
        DLog(@"**********请求成功---URL:%@\nHeader:%@\nResponseObj:\n%@", sessionTask.currentRequest.URL,sessionTask.currentRequest.allHTTPHeaderFields,responseObj);
    }
}

@end

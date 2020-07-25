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

        [CustomNetWorkRequestLog swizzleClassMethodWithOriginalSEL:@selector(logWithSessionTask:responseObj:error:) swizzleNewSEL:@selector(swizzle_logWithSessionTask:responseObj:error:)];
    });
}


+ (void)swizzle_logWithSessionTask:(NSURLSessionTask *)sessionTask responseObj:(id)responseObj error:(NSError *)error{
    if (error) {
        DLog(@"**********请求失败:\nURL:%@\nHeader:%@\nError:\n%@\n*********ERROR*", sessionTask.currentRequest.URL,sessionTask.currentRequest.allHTTPHeaderFields,error.description);
    }else{
        DLog(@"**********请求成功:\nURL:%@\nHeader:%@\nResponseObj:\n%@\n*********SUCCESS*", sessionTask.currentRequest.URL,sessionTask.currentRequest.allHTTPHeaderFields,responseObj);
    }
}


@end

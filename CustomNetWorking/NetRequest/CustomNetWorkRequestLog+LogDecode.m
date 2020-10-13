//
//  CustomNetWorkRequestLog+LogDecode.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/27.
//  Copyright © 2020 XueYangLee. All rights reserved.
//  !!!!!此分类可直接拖入项目中添加自定义项!!!!!

#import "CustomNetWorkRequestLog+LogDecode.h"
#import "NSObject+SwizzleMethod.h"

@implementation CustomNetWorkRequestLog (LogDecode)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//保证方法替换只被执行一次

        [CustomNetWorkRequestLog swizzleClassMethodWithOriginalSEL:@selector(logWithSessionTask:responseObj:error:) swizzleNewSEL:@selector(swizzle_logWithSessionTask:responseObj:error:)];
        
//        [CustomNetWorkRequestLog swizzleClassMethodWithOriginalSEL:@selector(disposeError:sessionTask:) swizzleNewSEL:@selector(swizzle_disposeError:sessionTask:)];
    });
}


+ (void)swizzle_logWithSessionTask:(NSURLSessionTask *)sessionTask responseObj:(id)responseObj error:(NSError *)error{
    if (error) {
        DLog(@"**********请求失败:\nURL:%@\nHeader:%@\nError:\n%@\n*********ERROR*", sessionTask.currentRequest.URL,sessionTask.currentRequest.allHTTPHeaderFields,error.description);
    }else{
        DLog(@"**********请求成功:\nURL:%@\nHeader:%@\nResponseObj:\n%@\n*********SUCCESS*", sessionTask.currentRequest.URL,sessionTask.currentRequest.allHTTPHeaderFields,responseObj);
    }
}


+ (void)swizzle_disposeError:(NSError *)error sessionTask:(NSURLSessionTask *)sessionTask{
    NSHTTPURLResponse *responseObj = (NSHTTPURLResponse *)sessionTask.response;
    NSInteger statusCode = responseObj.statusCode;
    NSInteger errorCode = error.code;
    DLog(@"****%ld*statusCode*\n****%ld*errorCode*",statusCode,errorCode)
}


@end

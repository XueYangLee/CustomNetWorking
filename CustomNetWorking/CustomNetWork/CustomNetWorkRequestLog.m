//
//  CustomNetWorkRequestLog.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "CustomNetWorkRequestLog.h"
#import "NSError+CustomNetWorkExt.h"

@implementation CustomNetWorkRequestLog

+ (void)logWithSessionTask:(NSURLSessionTask * _Nullable)sessionTask responseObj:(id _Nullable)responseObj error:(NSError * _Nullable)error {
    
}

+ (void)disposeError:(NSError *)error sessionTask:(NSURLSessionTask *)sessionTask {
    NSHTTPURLResponse *responseObj = (NSHTTPURLResponse *)sessionTask.response;
    NSInteger statusCode = responseObj.statusCode;
    error.statusCode = [NSNumber numberWithInteger:statusCode];
    error.errorMessage = [NSString stringWithFormat:@"数据异常，一会再试试吧(%li)!",(long)statusCode];
}

@end

//
//  CustomNetWork.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "CustomNetWork.h"

@implementation CustomNetWork

#pragma mark - 网络状态
+ (void)netWorkStatusWithBlock:(CustomNetWorkStatusBlock)netWorkStatus {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                netWorkStatus ? netWorkStatus(NetWorkStatusUnknow) : nil;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netWorkStatus ? netWorkStatus(NetWorkStatusNotReachable) : nil;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                netWorkStatus ? netWorkStatus(NetWorkStatusReachableViaWWAN) : nil;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                netWorkStatus ? netWorkStatus(NetWorkStatusReachableViaWiFi) : nil;
                break;
        }
    }];
}

+ (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

+ (NSURLSessionDataTask *)GET:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable)RespComp {
    return [self dataTaskWithRequestMethod:RequestMethodGET URL:URLString parameters:parameters completion:RespComp];
}

+ (NSURLSessionDataTask *)POST:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable)RespComp {
    return [self dataTaskWithRequestMethod:RequestMethodPOST URL:URLString parameters:parameters completion:RespComp];
}

+ (NSURLSessionDataTask *)HEAD:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable)RespComp {
    return [self dataTaskWithRequestMethod:RequestMethodHEAD URL:URLString parameters:parameters completion:RespComp];
}

+ (NSURLSessionDataTask *)PUT:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable)RespComp {
    return [self dataTaskWithRequestMethod:RequestMethodPUT URL:URLString parameters:parameters completion:RespComp];
}

+ (NSURLSessionDataTask *)PATCH:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable)RespComp {
    return [self dataTaskWithRequestMethod:RequestMethodPATCH URL:URLString parameters:parameters completion:RespComp];
}

+ (NSURLSessionDataTask *)DELETE:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable)RespComp {
    return [self dataTaskWithRequestMethod:RequestMethodDELETE URL:URLString parameters:parameters completion:RespComp];
}


#pragma mark - 接口管理 数据请求 核心
+ (NSURLSessionDataTask *)dataTaskWithRequestMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable)RespComp {
    if (!URLString) {
        URLString = @"";
    }
    parameters = [self disposeParameters:parameters];
    
    NSMutableURLRequest *request = [[CustomNetWorkManager sharedManager].sessionManager.requestSerializer requestWithMethod:[self requestTypeWithMethod:method] URLString:URLString parameters:parameters error:nil];
    
    __block NSURLSessionDataTask *dataTask = [[CustomNetWorkManager sharedManager].sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            [CustomNetWorkRequestLog disposeError:error sessionTask:dataTask];
            [CustomNetWorkRequestLog logWithSessionTask:dataTask responseObj:nil error:error];
            
            RespComp ? RespComp([CustomNetWorkResponseObject createErrorDataWithError:error]) : nil;
            
        } else {
            [CustomNetWorkRequestLog logWithSessionTask:dataTask responseObj:responseObject error:nil];
            
            RespComp ? RespComp([CustomNetWorkResponseObject createDataWithResponse:responseObject]) : nil;
        }
    }];
    [dataTask resume];

    return dataTask;
}



#pragma mark - 参数处理 添加公共参数
+ (NSDictionary *)disposeParameters:(NSDictionary *)parameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if ([CustomNetWorkManager sharedManager].config.publicParams && [CustomNetWorkManager sharedManager].config.publicParams.count > 0) {
        [params addEntriesFromDictionary:[CustomNetWorkManager sharedManager].config.publicParams];//添加公共参数
    }
    return params.copy;
}

#pragma mark - 请求方式处理
+ (NSString *)requestTypeWithMethod:(CustomNetWorkRequestMethod)method {
    NSString *requestMethod = @"GET";
    switch (method) {
        case RequestMethodGET:
            requestMethod = @"GET";
            break;
        case RequestMethodPOST:
            requestMethod = @"POST";
            break;
        case RequestMethodHEAD:
            requestMethod = @"HEAD";
            break;
        case RequestMethodPUT:
            requestMethod = @"PUT";
            break;
        case RequestMethodPATCH:
            requestMethod = @"PATCH";
            break;
        case RequestMethodDELETE:
            requestMethod = @"DELETE";
            break;
            
        default:
            break;
    }
    return requestMethod;
}

@end

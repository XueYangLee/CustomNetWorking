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

#pragma mark - 基础数据请求方式
+ (NSURLSessionDataTask *_Nullable)GET:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp {
    return [self dataTaskWithRequestMethod:RequestMethodGET URL:URLString parameters:parameters completion:respComp];
}

+ (NSURLSessionDataTask *_Nullable)POST:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp {
    return [self dataTaskWithRequestMethod:RequestMethodPOST URL:URLString parameters:parameters completion:respComp];
}

+ (NSURLSessionDataTask *_Nullable)HEAD:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp {
    return [self dataTaskWithRequestMethod:RequestMethodHEAD URL:URLString parameters:parameters completion:respComp];
}

+ (NSURLSessionDataTask *_Nullable)PUT:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp {
    return [self dataTaskWithRequestMethod:RequestMethodPUT URL:URLString parameters:parameters completion:respComp];
}

+ (NSURLSessionDataTask *_Nullable)PATCH:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp {
    return [self dataTaskWithRequestMethod:RequestMethodPATCH URL:URLString parameters:parameters completion:respComp];
}

+ (NSURLSessionDataTask *_Nullable)DELETE:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp {
    return [self dataTaskWithRequestMethod:RequestMethodDELETE URL:URLString parameters:parameters completion:respComp];
}

#pragma mark - 基础数据请求方式 支持缓存
+ (void)GET:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp {
    [self requestWithMethod:RequestMethodGET URL:URLString parameters:parameters cachePolicy:cachePolicy cacheValidTime:validTime completion:comp];
}

+ (void)POST:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp {
    [self requestWithMethod:RequestMethodPOST URL:URLString parameters:parameters cachePolicy:cachePolicy cacheValidTime:validTime completion:comp];
}

+ (void)HEAD:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp {
    [self requestWithMethod:RequestMethodHEAD URL:URLString parameters:parameters cachePolicy:cachePolicy cacheValidTime:validTime completion:comp];
}

+ (void)PUT:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp {
    [self requestWithMethod:RequestMethodPUT URL:URLString parameters:parameters cachePolicy:cachePolicy cacheValidTime:validTime completion:comp];
}

+ (void)PATCH:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp {
    [self requestWithMethod:RequestMethodPATCH URL:URLString parameters:parameters cachePolicy:cachePolicy cacheValidTime:validTime completion:comp];
}

+ (void)DELETE:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp {
    [self requestWithMethod:RequestMethodDELETE URL:URLString parameters:parameters cachePolicy:cachePolicy cacheValidTime:validTime completion:comp];
}

#pragma mark - 数据请求+数据缓存 结果统一返回
+ (void)requestWithMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp {
    [self requestWithMethod:method URL:URLString parameters:parameters cachePolicy:cachePolicy cacheValidTime:validTime cacheComp:^(CustomNetWorkResponseObject * _Nullable respObj) {
        comp ? comp(respObj) : nil;
    } respComp:^(CustomNetWorkResponseObject * _Nullable respObj) {
        comp ? comp(respObj) : nil;
    }];
}

#pragma mark - 数据请求+数据缓存 核心方法
+ (void)requestWithMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime cacheComp:(CustomNetWorkCacheComp _Nullable )cacheComp respComp:(CustomNetWorkRespComp _Nullable )respComp {
    
    if (cachePolicy == CachePolicyRequestWithoutCahce) {
        //仅返回网络请求数据不做数据缓存处理
        [self dataTaskWithRequestMethod:method URL:URLString parameters:parameters completion:respComp];
        
    }else if (cachePolicy == CachePolicyMainCacheSaveRequest) {
        //主要返回缓存数据并缓存网络请求的数据，缓存无数据时返回网络数据，第一次请求没有缓存数据时从网络先请求数据
        __weak typeof(self) weakSelf = self;
        [CustomNetWorkCache getRespCacheWithURL:URLString parameters:parameters validTime:validTime completion:^(id  _Nullable cacheData) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (cacheData) {
                cacheComp ? cacheComp([CustomNetWorkResponseObject createDataWithResponse:cacheData]) : nil;
            }
            [strongSelf dataTaskWithRequestMethod:method URL:URLString parameters:parameters completion:^(CustomNetWorkResponseObject * _Nullable respObj) {
                if (respObj.requestSuccess) {
                    [CustomNetWorkCache setRespCacheWithData:respObj.originalData URL:URLString parameters:parameters validTime:validTime];
                }
                if (!cacheData) {
                    respComp ? respComp(respObj) : nil;
                }
            }];
        }];
        
    }else if (cachePolicy == CachePolicyOnlyCacheOnceRequest) {
        //仅返回缓存数据而不请求网络，数据第一次请求或缓存失效的情况下再从网络请求数据并缓存
        __weak typeof(self) weakSelf = self;
        [CustomNetWorkCache getRespCacheWithURL:URLString parameters:parameters validTime:validTime completion:^(id  _Nullable cacheData) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (cacheData) {
                cacheComp ? cacheComp([CustomNetWorkResponseObject createDataWithResponse:cacheData]) : nil;
            }else {
                [strongSelf dataTaskWithRequestMethod:method URL:URLString parameters:parameters completion:^(CustomNetWorkResponseObject * _Nullable respObj) {
                    if (respObj.requestSuccess) {
                        [CustomNetWorkCache setRespCacheWithData:respObj.originalData URL:URLString parameters:parameters validTime:validTime];
                    }
                    respComp ? respComp(respObj) : nil;
                }];
            }
        }];
        
    }else if (cachePolicy == CachePolicyMainRequestFailCache) {
        //主要返回网络请求数据，请求失败或请求超时的情况下再返回请求成功时缓存的数据
        [self dataTaskWithRequestMethod:method URL:URLString parameters:parameters completion:^(CustomNetWorkResponseObject * _Nullable respObj) {
            if (respObj.requestSuccess) {
                [CustomNetWorkCache setRespCacheWithData:respObj.originalData URL:URLString parameters:parameters validTime:validTime];
                respComp ? respComp(respObj) : nil;
            }else {
                [CustomNetWorkCache getRespCacheWithURL:URLString parameters:parameters validTime:validTime completion:^(id  _Nullable cacheData) {
                    cacheComp ? cacheComp([CustomNetWorkResponseObject createDataWithResponse:cacheData]) : nil;
                }];
            }
        }];
        
    }else if (cachePolicy == CachePolicyRequsetAndCache) {
        //网络请求数据和缓存数据共同返回
        [CustomNetWorkCache getRespCacheWithURL:URLString parameters:parameters validTime:validTime completion:^(id  _Nullable cacheData) {
            cacheComp ? cacheComp([CustomNetWorkResponseObject createDataWithResponse:cacheData]) : nil;
        }];
        
        [self dataTaskWithRequestMethod:method URL:URLString parameters:parameters completion:^(CustomNetWorkResponseObject * _Nullable respObj) {
            if (respObj.requestSuccess) {
                [CustomNetWorkCache setRespCacheWithData:respObj.originalData URL:URLString parameters:parameters validTime:validTime];
            }
            respComp ? respComp(respObj) : nil;
        }];
    }
}

#pragma mark - 数据请求 核心方法
+ (NSURLSessionDataTask *_Nullable)dataTaskWithRequestMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp {
    
    if (!URLString) {
        URLString = @"";
    }
    parameters = [self disposeParameters:parameters];
    
    NSMutableURLRequest *request = [[CustomNetWorkManager sharedManager].sessionManager.requestSerializer requestWithMethod:[self requestTypeWithMethod:method] URLString:URLString parameters:parameters error:nil];
    
    __block NSURLSessionDataTask *dataTask = [[CustomNetWorkManager sharedManager].sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            [CustomNetWorkRequestLog disposeError:error sessionTask:dataTask];
            [CustomNetWorkRequestLog logWithSessionTask:dataTask responseObj:nil error:error];
            
            respComp ? respComp([CustomNetWorkResponseObject createErrorDataWithError:error]) : nil;
            
        } else {
            [CustomNetWorkRequestLog logWithSessionTask:dataTask responseObj:responseObject error:nil];
            
            respComp ? respComp([CustomNetWorkResponseObject createDataWithResponse:responseObject]) : nil;
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

//
//  CustomNetWork.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "CustomNetWork.h"
#import "CustomNetWorkManager.h"

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

#pragma mark - 接口管理 数据请求



#pragma mark - 参数处理
+ (NSDictionary *)disposeParameters:(NSDictionary *)parameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if ([CustomNetWorkManager sharedManager].config.publicParams && [CustomNetWorkManager sharedManager].config.publicParams.count > 0) {
        [params addEntriesFromDictionary:[CustomNetWorkManager sharedManager].config.publicParams];//添加公共参数
    }
    return params.copy;
}

@end

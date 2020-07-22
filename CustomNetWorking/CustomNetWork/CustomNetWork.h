//
//  CustomNetWork.h
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    /** 未知网络 */
    NetWorkStatusUnknow,
    /** 无网络 */
    NetWorkStatusNotReachable,
    /** 手机网络 */
    NetWorkStatusReachableViaWWAN,
    /** WiFi网络 */
    NetWorkStatusReachableViaWiFi,
} CustomNetWorkNetStatus;//网络状态

typedef void(^CustomNetWorkStatusBlock)(CustomNetWorkNetStatus netWorkStatus);


typedef enum : NSUInteger {
    RequestMethodGET = 0,
    RequestMethodPOST,
    RequestMethodHEAD,
    RequestMethodPUT,
    RequestMethodPATCH,
    RequestMethodDELETE,
} NetRequestMethod;//请求方式


typedef enum : NSUInteger {
    /** 仅数据请求不做数据缓存处理 */
    CachePolicyRequestWithoutCahce,
    /** 无缓存数据时进行数据请求 有缓存时返回缓存数据同时请求数据并缓存 */
    CachePolicyMainCacheFirstRequest,
    /** 数据请求及缓存数据同时返回 */
    CachePolicyRequsetAndCache,
} NetRequestCachePolicy;



NS_ASSUME_NONNULL_BEGIN

@interface CustomNetWork : NSObject

/** 获取当前网络状态 */
+ (void)netWorkStatusWithBlock:(CustomNetWorkStatusBlock)netWorkStatus;

/** 当前是否有网络 */
+ (BOOL)isNetwork;

/** 当前网络是否为手机网络 */
+ (BOOL)isWWANNetwork;

/** 当前网络是否为WiFi网络 */
+ (BOOL)isWiFiNetwork;

@end

NS_ASSUME_NONNULL_END

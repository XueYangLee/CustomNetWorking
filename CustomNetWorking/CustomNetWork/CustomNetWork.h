//
//  CustomNetWork.h
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//
/**
 注意 info.plist 不要忘记添加
 <key>NSAppTransportSecurity</key>
 <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
 </dict>
 */

#import <Foundation/Foundation.h>
#import "CustomNetWorkManager.h"
#import "CustomNetWorkResponseObject.h"
#import "CustomNetWorkCache.h"
#import "CustomNetWorkRequestLog.h"

/** 网络状态 */
typedef NS_ENUM(NSUInteger, CustomNetWorkNetStatus) {
    /** 未知网络 */
    NetWorkStatusUnknow,
    /** 无网络 */
    NetWorkStatusNotReachable,
    /** 手机网络 */
    NetWorkStatusReachableViaWWAN,
    /** WiFi网络 */
    NetWorkStatusReachableViaWiFi,
};

/** 请求方式 */
typedef NS_ENUM(NSUInteger, CustomNetWorkRequestMethod) {
    /** GET请求 */
    RequestMethodGET = 0,
    /** POST请求 */
    RequestMethodPOST,
    /** HEAD请求 */
    RequestMethodHEAD,
    /** PUT请求 */
    RequestMethodPUT,
    /** PATCH请求 */
    RequestMethodPATCH,
    /** DELETE请求 */
    RequestMethodDELETE,
};

/** 缓存策略 */
typedef NS_ENUM(NSUInteger, CustomNetWorkRequestCachePolicy) {
    /** 仅从网络请求数据不做数据缓存处理 */
    CachePolicyRequestWithoutCahce = 0,
    /** 先从缓存获取数据并缓存网络请求的数据，没有缓存数据的时候再从网络请求数据（第一次请求） */
    CachePolicyMainCacheFirstRequest,
    /** 仅从缓存获取数据而不不请求网络，缓存没有数据时再从网络请求数据并缓存 */
    CachePolicyOnlyCacheFirstRequest,
    /** 先从网络请求数据，请求失败或请求超时的情况下再从缓存获取数据 */
    CachePolicyMainRequestFailCache,
    /** 网络请求数据和缓存数据一起返回 */
    CachePolicyRequsetAndCache,
};

/** 网络状态block */
typedef void(^CustomNetWorkStatusBlock)(CustomNetWorkNetStatus netWorkStatus);

/** 网络数据结果block返回 */
typedef void(^CustomNetWorkRespComp)(CustomNetWorkResponseObject * _Nullable respObj);


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


/** GET 数据请求 */
+ (NSURLSessionDataTask *)GET:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable)RespComp;
/** POST 数据请求 */
+ (NSURLSessionDataTask *)POST:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable)RespComp;
/** HEAD 数据请求 */
+ (NSURLSessionDataTask *)HEAD:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable)RespComp;
/** PUT 数据请求 */
+ (NSURLSessionDataTask *)PUT:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable)RespComp;
/** PATCH 数据请求 */
+ (NSURLSessionDataTask *)PATCH:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable)RespComp;
/** DELETE 数据请求 */
+ (NSURLSessionDataTask *)DELETE:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable)RespComp;


/**
 数据请求 （核心方法）
 
 @param method 请求方式
 @param URLString 请求URL
 @param parameters 请求参数
 @param RespComp 请求返回的结果
 */
+ (NSURLSessionDataTask *)dataTaskWithRequestMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable)RespComp;

@end

NS_ASSUME_NONNULL_END

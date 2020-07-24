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
typedef NS_ENUM(NSUInteger, CustomNetWorkCachePolicy) {
    /** 仅返回网络请求数据不做数据缓存处理 */
    CachePolicyRequestWithoutCahce = 0,
    /** 主要返回缓存数据并缓存网络请求的数据，缓存无数据时返回网络数据，第一次请求没有缓存数据时从网络先请求数据 */
    CachePolicyMainCacheSaveRequest,
    /** 仅返回缓存数据而不请求网络，数据第一次请求或缓存失效的情况下再从网络请求数据并缓存 */
    CachePolicyOnlyCacheOnceRequest,
    /** 主要返回网络请求数据，请求失败或请求超时的情况下再返回请求成功时缓存的数据 */
    CachePolicyMainRequestFailCache,
    /** 网络请求数据和缓存数据共同返回 */
    CachePolicyRequsetAndCache,
};

/** 网络状态block */
typedef void(^CustomNetWorkStatusBlock)(CustomNetWorkNetStatus netWorkStatus);

/** 网络数据结果block返回 */
typedef void(^CustomNetWorkRespComp)(CustomNetWorkResponseObject * _Nullable respObj);

/** 缓存数据结果block返回 */
typedef void(^CustomNetWorkCacheComp)(CustomNetWorkResponseObject * _Nullable respObj);

/** 网络数据及缓存数据结果block返回 */
typedef void(^CustomNetWorkResultComp)(CustomNetWorkResponseObject * _Nullable respObj);


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
+ (NSURLSessionDataTask *_Nullable)GET:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp;
/** POST 数据请求 */
+ (NSURLSessionDataTask *_Nullable)POST:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp;
/** HEAD 数据请求 */
+ (NSURLSessionDataTask *_Nullable)HEAD:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp;
/** PUT 数据请求 */
+ (NSURLSessionDataTask *_Nullable)PUT:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp;
/** PATCH 数据请求 */
+ (NSURLSessionDataTask *_Nullable)PATCH:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp;
/** DELETE 数据请求 */
+ (NSURLSessionDataTask *_Nullable)DELETE:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp;

/** GET 数据请求 支持缓存 */
+ (void)GET:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp;
/** POST 数据请求 支持缓存 */
+ (void)POST:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp;
/** HEAD 数据请求 支持缓存 */
+ (void)HEAD:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp;
/** PUT 数据请求 支持缓存 */
+ (void)PUT:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp;
/** PATCH 数据请求 支持缓存 */
+ (void)PATCH:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp;
/** DELETE 数据请求 支持缓存 */
+ (void)DELETE:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp;


/**
 数据请求+数据缓存 数据结果统一返回
 
 @param method 请求方式
 @param URLString 请求URL
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param validTime 缓存有效时间(秒)  0或CacheValidTimeForever为永久有效
 @param comp 网络请求或缓存的数据结果  CachePolicyRequsetAndCache时结果返回两次
 */
+ (void)requestWithMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp;

/**
 数据请求+数据缓存 （核心方法）  数据结果分开返回
 
 @param method 请求方式
 @param URLString 请求URL
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param validTime 缓存有效时间(秒)  0或CacheValidTimeForever为永久有效
 @param cacheComp 缓存数据结果
 @param respComp 网络请求数据结果
 */
+ (void)requestWithMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime cacheComp:(CustomNetWorkCacheComp _Nullable )cacheComp respComp:(CustomNetWorkRespComp _Nullable )respComp;

/**
 数据请求 （核心方法）
 
 @param method 请求方式
 @param URLString 请求URL
 @param parameters 请求参数
 @param respComp 网络请求数据结果
 */
+ (NSURLSessionDataTask *_Nullable)dataTaskWithRequestMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp;

@end

NS_ASSUME_NONNULL_END

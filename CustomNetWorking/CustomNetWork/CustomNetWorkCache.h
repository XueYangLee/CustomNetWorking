//
//  CustomNetWorkCache.h
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 永久有效 */
#define CacheValidTimeForever    0
/** 半天 12小时 */
#define CacheValidTimeHalfDay    43200
/** 一天 24小时 */
#define CacheValidTimeDay        86400
/** 一周 */
#define CacheValidTimeWeek       604800
/** 半个月 15天 */
#define CacheValidTimeHalfMonth  1296000
/** 一个月 30天 */
#define CacheValidTimeMonth      2592000
/** 半年 6个月 */
#define CacheValidTimeHalfYear   15552000
/** 一年 */
#define CacheValidTimeYear       31536000


typedef void(^CustomNetWorkCacheDataComp)(id _Nullable cacheData);

NS_ASSUME_NONNULL_BEGIN

@interface CustomNetWorkCache : NSObject

/** 异步缓冲网络请求 （以URL和parameter组合做缓存的key） */
+ (void)setRespCacheWithData:(id _Nullable )data URL:(NSString *_Nullable)URL parameters:(NSDictionary *_Nullable)parameters validTime:(NSTimeInterval)validTime;

/** 获取网络请求的缓存数据 （以URL和parameter组合的key获取） */
+ (id _Nullable )getRespCacheWithURL:(NSString *_Nullable)URL parameters:(NSDictionary *_Nullable)parameters validTime:(NSTimeInterval)validTime;

/** 获取网络请求的缓存数据  block返回缓存数据内容 */
+ (void)getRespCacheWithURL:(NSString *_Nullable)URL parameters:(NSDictionary *_Nullable)parameters validTime:(NSTimeInterval)validTime completion:(CustomNetWorkCacheDataComp _Nullable )cacheComp;


/** 移除指定URL及parameters的数据缓存 */
+ (void)removeCacheWithURL:(NSString *_Nullable)URL parameters:(NSDictionary *_Nullable)parameters;

/** 移除所有网络请求数据缓存 */
+ (void)removeAllCache;

/** 移除所有网络请求数据缓存带结果回调 (缓存数据量大时移除缓存会占用线程直到移除结束) */
+ (void)removeAllCacheWithCompletion:(void(^_Nullable)(void))comp;

/** 获取网络缓存的总大小 （bytes 字节） */
+ (NSInteger)getAllCacheSize;

/** 获取网络缓存的总大小  直接返回计算好的KB MB GB */
+ (NSString *_Nullable)cacheSize;


@end

NS_ASSUME_NONNULL_END

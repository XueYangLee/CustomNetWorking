//
//  CustomNetWorkCache.h
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomNetWorkCache : NSObject

/** 异步缓冲网络请求 （以URL和parameter组合做缓存的key） */
+ (void)setRespCacheWithData:(id)data URL:(NSString *)URL parameters:(NSDictionary *_Nullable)parameters;

/** 获取网络请求的缓存数据 （以URL和parameter组合的key获取） */
+ (id)getRespCacheWithURL:(NSString *)URL parameters:(NSDictionary *_Nullable)parameters;


/** 移除指定URL及parameters的数据缓存 */
+ (void)removeCacheWithURL:(NSString *)URL parameters:(NSDictionary *_Nullable)parameters;

/** 移除所有网络请求数据缓存 */
+ (void)removeAllCache;

/** 获取网络缓存的总大小 （bytes 字节） */
+ (NSInteger)getAllCacheSize;

/** 获取网络缓存的总大小  直接返回计算好的KB MB GB */
+ (NSString *)cacheSize;


@end

NS_ASSUME_NONNULL_END

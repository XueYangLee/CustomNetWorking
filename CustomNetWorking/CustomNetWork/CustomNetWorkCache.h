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
+ (void)setResponseCacheWithData:(id)data URL:(NSString *)url Parameters:(NSDictionary *)parameters;

/** 获取网络请求的缓存数据 （以URL和parameter组合的key获取） */
+ (id)getResponseCacheWithURL:(NSString *)url Parameters:(NSDictionary *)parameters;

/** 获取网络缓存的总大小 （bytes 字节） */
+ (NSInteger)getAllResponseCacheSize;

/** 获取网络缓存的总大小  直接返回计算好的KB MB GB */
+ (NSString *)responseCacheSize;

/** 移除所有网络请求数据缓存 */
+ (void)removeAllResponseCache;

@end

NS_ASSUME_NONNULL_END

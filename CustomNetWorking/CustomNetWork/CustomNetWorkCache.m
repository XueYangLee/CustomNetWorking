//
//  CustomNetWorkCache.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//
//此处不用单例原因 如果为了节省资源将数据库连接池对象设计为的单例类，可能会导致共享连接池对象的程序过多而出现连接池溢出；如果实例化的对象长时间不被利用，系统会认为是垃圾而被回收，这将导致对象状态的丢失

#import "CustomNetWorkCache.h"
#import <YYCache/YYCache.h>
#import "CustomNetWorkManager.h"

static NSString *const CustomNetWorkRespObjCache = @"CustomNetWorkRespObjCache";
static NSString *const CustomNetWorkRespObjCacheValidTime = @"CustomNetWorkRespObjCacheValidTime";

@implementation CustomNetWorkCache
static YYCache *_dataCache;

+ (void)initialize {
    _dataCache = [YYCache cacheWithName:CustomNetWorkRespObjCache];
}

#pragma mark - set
+ (void)setRespCacheWithData:(id _Nullable )data URL:(NSString *_Nullable)URL parameters:(NSDictionary *_Nullable)parameters validTime:(NSTimeInterval)validTime {
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:[self filterNeedlessParams:parameters]];
    //异步缓存,不会阻塞主线程
    [_dataCache setObject:data forKey:cacheKey];
    
    if (validTime != 0) {
        [self setCacheValidTimeWithCacheKey:cacheKey];
    }
}

#pragma mark - get
+ (id _Nullable )getRespCacheWithURL:(NSString *_Nullable)URL parameters:(NSDictionary *_Nullable)parameters validTime:(NSTimeInterval)validTime {
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:[self filterNeedlessParams:parameters]];
    id data = [_dataCache objectForKey:cacheKey];
    if (!data) {
        return nil;
    }
    
    if (validTime != 0) {
        if ([self verifyCacheValidWithCacheKey:cacheKey validTime:validTime]) {
            return data;
        }else {
            [_dataCache removeObjectForKey:cacheKey];
            NSString *cacheValidTimeKey = [NSString stringWithFormat:@"%@_%@",cacheKey, CustomNetWorkRespObjCacheValidTime];
            [_dataCache removeObjectForKey:cacheValidTimeKey];
            return nil;
        }
    }
    
    return data;
}

+ (void)getRespCacheWithURL:(NSString *_Nullable)URL parameters:(NSDictionary *_Nullable)parameters validTime:(NSTimeInterval)validTime completion:(CustomNetWorkCacheDataComp _Nullable )cacheComp {
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:[self filterNeedlessParams:parameters]];
    id data = [_dataCache objectForKey:cacheKey];
    
    if (validTime != 0) {
        if ([self verifyCacheValidWithCacheKey:cacheKey validTime:validTime]) {
            cacheComp ? cacheComp(data) : nil;
        }else {
            [_dataCache removeObjectForKey:cacheKey];
            NSString *cacheValidTimeKey = [NSString stringWithFormat:@"%@_%@",cacheKey, CustomNetWorkRespObjCacheValidTime];
            [_dataCache removeObjectForKey:cacheValidTimeKey];
            
            cacheComp ? cacheComp(nil) : nil;
        }
    }else {
        cacheComp ? cacheComp(data) : nil;
    }
    
}


#pragma mark - remove
+ (void)removeCacheWithURL:(NSString *)URL parameters:(NSDictionary *_Nullable)parameters {
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:[self filterNeedlessParams:parameters]];
    [_dataCache removeObjectForKey:cacheKey];
}

+ (void)removeAllCache {
    [_dataCache removeAllObjects];
}

+ (void)removeAllCacheWithCompletion:(void(^_Nullable)(void))comp {
    [_dataCache removeAllObjectsWithBlock:^{
        comp ? comp() : nil;
    }];
}

#pragma mark - cacheSize
+ (NSInteger)getAllCacheSize {
    return [_dataCache.diskCache totalCost];
}

+ (NSString *)cacheSize {
    NSInteger cacheSize = [_dataCache.diskCache totalCost];
    if (cacheSize < 1024) {
        return [NSString stringWithFormat:@"%ldB",(long)cacheSize];
    } else if (cacheSize < powf(1024.f, 2)) {
        return [NSString stringWithFormat:@"%.2fKB",cacheSize / 1024.f];
    } else if (cacheSize < powf(1024.f, 3)) {
        return [NSString stringWithFormat:@"%.2fMB",cacheSize / powf(1024.f, 2)];
    } else {
        return [NSString stringWithFormat:@"%.2fGB",cacheSize / powf(1024.f, 3)];
    }
}

#pragma mark - cacheValidTime
/** 存入缓存时间 */
+ (void)setCacheValidTimeWithCacheKey:(NSString *)cacheKey {
    NSString *cacheValidTimeKey = [NSString stringWithFormat:@"%@_%@",cacheKey, CustomNetWorkRespObjCacheValidTime];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    [_dataCache setObject:@(currentTime) forKey:cacheValidTimeKey];
}

/** 判断缓存在有效时间内是否有效 */
+ (BOOL)verifyCacheValidWithCacheKey:(NSString *)cacheKey validTime:(NSTimeInterval)validTime {
    NSString *cacheValidTimeKey = [NSString stringWithFormat:@"%@_%@",cacheKey, CustomNetWorkRespObjCacheValidTime];
    id createRecordTime = [_dataCache objectForKey:cacheValidTimeKey];
    
    NSTimeInterval createTime = [createRecordTime doubleValue];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    if ((currentTime - createTime) < validTime) {
        return YES;
    }
    return NO;
}


#pragma mark - 缓存参数拼接处理
+ (NSString *)cacheKeyWithURL:(NSString *)url parameters:(NSDictionary *)parameters {
    if(!parameters || parameters.count == 0) {
        return url;
    }
    // 将参数字典转换成字符串
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paramsString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@",url,paramsString];
    
    return [NSString stringWithFormat:@"%@",cacheKey];
}

#pragma mark - 参数过滤
/** 用作过滤参数字典中不必要的参数 (有点请求中类似时间戳等可变内容需要加到参数中而不是请求头中时需过滤此类参数) */
+ (NSDictionary *)filterNeedlessParams:(NSDictionary *)params {
    NSMutableDictionary *filterParams = [NSMutableDictionary dictionaryWithDictionary:params];
    if ([CustomNetWorkManager sharedManager].config.cacheNeedlessParamsForKeys && [CustomNetWorkManager sharedManager].config.cacheNeedlessParamsForKeys > 0) {
        [filterParams removeObjectsForKeys:[CustomNetWorkManager sharedManager].config.cacheNeedlessParamsForKeys];
    }
    return filterParams.copy;
}

@end

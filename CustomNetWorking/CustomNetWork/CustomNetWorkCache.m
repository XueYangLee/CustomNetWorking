//
//  CustomNetWorkCache.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "CustomNetWorkCache.h"
#import <YYCache.h>

static NSString *const CustomNetWorkResponseObjCache = @"CustomNetWorkResponseObjCache";

@implementation CustomNetWorkCache
static YYCache *_dataCache;

+ (void)initialize{
    _dataCache = [YYCache cacheWithName:CustomNetWorkResponseObjCache];
}

+ (void)setResponseCacheWithData:(id)data URL:(NSString *)url Parameters:(NSDictionary *)parameters{
    NSString *cacheKey = [self cacheKeyWithURL:url parameters:[self filterNeedlessParams:parameters]];
    //异步缓存,不会阻塞主线程
    [_dataCache setObject:data forKey:cacheKey];
}

+ (id)getResponseCacheWithURL:(NSString *)url Parameters:(NSDictionary *)parameters{
    NSString *cacheKey = [self cacheKeyWithURL:url parameters:[self filterNeedlessParams:parameters]];
    id data = [_dataCache objectForKey:cacheKey];
    if (!data) {
        return nil;
    }
    return data;
}



+ (NSInteger)getAllResponseCacheSize{
    return [_dataCache.diskCache totalCost];
}

+ (void)removeAllResponseCache{
    [_dataCache.diskCache removeAllObjects];
    [_dataCache removeAllObjects];
}


#pragma mark - 缓存参数拼接处理

+ (NSString *)cacheKeyWithURL:(NSString *)url parameters:(NSDictionary *)parameters {
    if(!parameters || parameters.count == 0){
        return url;
    }
    // 将参数字典转换成字符串
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paramsString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@",url,paramsString];
    
    return [NSString stringWithFormat:@"%@",cacheKey];
}

/** 用作过滤参数字典中不必要的参数 (有点请求中类似时间戳等可变内容需要加到参数中而不是请求头中时需过滤此类参数) */
+ (NSDictionary *)filterNeedlessParams:(NSDictionary *)params{
    NSMutableDictionary *filterParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [filterParams removeObjectsForKeys:@[]];
    return filterParams.copy;
}

@end

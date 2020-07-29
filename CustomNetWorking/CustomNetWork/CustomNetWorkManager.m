//
//  CustomNetWorkManager.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "CustomNetWorkManager.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation CustomNetWorkManager

+ (instancetype)sharedManager {
    static CustomNetWorkManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[CustomNetWorkManager alloc] init];
    });
    return shareManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        if (!_sessionManager) {
            _sessionManager = [AFHTTPSessionManager manager];
            _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];//default->AFHTTPRequestSerializer
            _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];//default->AFJSONResponseSerializer
            _sessionManager.requestSerializer.timeoutInterval = 15.f;
            _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
        }
        
    }
    return self;
}

- (void)setConfig:(CustomNetWorkConfig *)config {
    _config=config;
    
    if (config.requestSerializer != CustomRequestSerializerDefault) {//设置数据请求格式
        if (config.requestSerializer == CustomRequestSerializerHTTP) {
            _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        }else if (config.requestSerializer == CustomRequestSerializerJSON){
            _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        }
    }
    
    if (config.responseSerializer != CustomResponseSerializerDefault) {//设置数据响应格式
        if (config.responseSerializer == CustomResponseSerializerHTTP) {
            _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }else if (config.responseSerializer == CustomResponseSerializerJSON){
            _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        }
    }
    
    if (config.timeoutInterval > 0) {//设置数据超时时间
        _sessionManager.requestSerializer.timeoutInterval = config.timeoutInterval;
    }
    
    if (config.userAgentForHeader.length) {//设置请求UA
        [_sessionManager.requestSerializer setValue:config.userAgentForHeader forHTTPHeaderField:@"User-Agent"];
    }
    
    if (config.requestHeader && config.requestHeader.count > 0) {//设置请求头 如版本号或机器码等固定不变的值
        for (NSString *key in config.requestHeader) {
            id value = config.requestHeader[key];
            [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }
    
    
    if (config.securityPolicy) {//自建请求证书校验
        _sessionManager.securityPolicy = config.securityPolicy;
    }
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:config.activityIndicatorOpen];//状态栏等待指示器
}


@end

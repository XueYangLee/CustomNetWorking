//
//  CustomNetWorkConfig.h
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/27.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

/** 数据请求格式 */
typedef NS_ENUM(NSUInteger, CustomRequestSerializer) {
    CustomRequestSerializerUnknown = 0,
    CustomRequestSerializerHTTP,
    CustomRequestSerializerJSON,
};

/** 数据响应格式 */
typedef NS_ENUM(NSUInteger, CustomResponseSerializer) {
    CustomResponseSerializerUnknow = 0,
    CustomResponseSerializerHTTP,
    CustomResponseSerializerJSON,
};


NS_ASSUME_NONNULL_BEGIN

@interface CustomNetWorkConfig : NSObject

/** 设置请求数据格式 不设置默认HTTP二进制 */
@property (nonatomic,assign) CustomRequestSerializer requestSerializer;

/** 设置响应数据格式 不设置默认JSON格式 */
@property (nonatomic,assign) CustomResponseSerializer responseSerializer;

/** 请求超时时间 默认15秒 */
@property (nonatomic,assign) NSTimeInterval timeoutInterval;

/** 数据请求头的User-Agent */
@property (nonatomic,strong) NSString *userAgentForHeader;

/** 数据请求的请求头 */
@property (nonatomic,strong) NSMutableDictionary *requestHeader;

/** 数据请求的公共参数 参数相同会覆盖 */
@property (nonatomic,strong) NSMutableDictionary *publicParams;


/** 数据缓存的参数中需要过滤掉的无用参数的key */
@property (nonatomic,strong) NSArray *cacheNeedlessParamsForKeys;


/** 请求证书校验 配置自建证书  其中allowInvalidCertificates为无效证书验证通过开关、validatesDomainName是否需要验证证书域名开关 */
@property (nonatomic,strong) AFSecurityPolicy *securityPolicy; //其中的validatesDomainName是否需要验证域名，默认为YES. 如果证书的域名与请求的域名不一致，需设置为NO;即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险,建议打开.validatesDomainName=NO,主要用于这种情况:客户端请求的是子域名,而证书上的是另外一个域名。因为SSL证书上的域名是独立的,假如证书上注册的域名是www.google.com, 那么mail.google.com是无法验证通过的

/** 状态栏等待指示器 默认不开启 */
@property (nonatomic,assign) BOOL activityIndicatorOpen;


@end

NS_ASSUME_NONNULL_END

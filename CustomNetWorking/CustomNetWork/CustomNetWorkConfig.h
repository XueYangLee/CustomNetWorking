//
//  CustomNetWorkConfig.h
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/27.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    CustomRequestSerializerUnknown = 0,
    CustomRequestSerializerHTTP,
    CustomRequestSerializerJSON,
} CustomRequestSerializer;//请求数据格式

typedef enum : NSUInteger {
    CustomResponseSerializerUnknow = 0,
    CustomResponseSerializerHTTP,
    CustomResponseSerializerJSON,
} CustomResponseSerializer;//响应数据格式


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

/** 数据请求的公共参数 */
@property (nonatomic,strong) NSMutableDictionary *publicParams;

/** 状态栏等待指示器 默认不开启 */
@property (nonatomic,assign) BOOL activityIndicatorOpen;


@end

NS_ASSUME_NONNULL_END

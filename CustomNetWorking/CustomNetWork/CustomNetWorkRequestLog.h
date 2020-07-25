//
//  CustomNetWorkRequestLog.h
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomNetWorkRequestLog : NSObject

/** 数据请求打印信息 */
+ (void)logWithSessionTask:(NSURLSessionTask * _Nullable)sessionTask responseObj:(id _Nullable)responseObj error:(NSError * _Nullable)error;

/** 请求错误的提示预处理 */
+ (void)disposeError:(NSError *)error sessionTask:(NSURLSessionTask *)sessionTask;

@end

NS_ASSUME_NONNULL_END

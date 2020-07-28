//
//  CustomNetWorkManager.h
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "CustomNetWorkConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomNetWorkManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;

/** 设置网络请求配置 ***在程序开始时调用*** */
@property (nonatomic,strong) CustomNetWorkConfig *config;

@end

NS_ASSUME_NONNULL_END

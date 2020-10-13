//
//  CustomNetWorkOriginalObject.h
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/10/13.
//  Copyright © 2020 XueYangLee. All rights reserved.
//  请求的原始数据处理

#import <Foundation/Foundation.h>
#import "NSError+CustomNetWorkExt.h"

NS_ASSUME_NONNULL_BEGIN
/** 原始数据请求结果 */
@interface CustomNetWorkOriginalObject : NSObject


/** 数据请求是否成功 */
@property (nonatomic,assign) BOOL requestSuccess;

/** 未经任何处理的原始数据源 */
@property (nonatomic,strong) id _Nullable data;

/** 数据请求失败的error信息 */
@property (nonatomic,strong) NSError *_Nullable error;


/** 请求成功的原始数据赋值处理 */
+ (CustomNetWorkOriginalObject *)originalDataWithResponse:(id)responseObj;
/** 请求失败的原始数据赋值处理 */
+ (CustomNetWorkOriginalObject *)originalErrorDataWithError:(NSError *)error;


@end

NS_ASSUME_NONNULL_END

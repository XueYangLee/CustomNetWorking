//
//  CustomNetWorkResponseObject.h
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
// !!!!!!!!!!!!!!!此页面必须实现 当前页面实现或分类实现!!!!!!!!!!!!!!!!!!!!!!

#import <Foundation/Foundation.h>
#import "NSError+CustomNetWorkExt.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomNetWorkResponseObject : NSObject


/** 请求成功返回的数据  [参数的使用由后台数据是否返回决定] （data、result） */
@property (nonatomic,strong) id result;

/** 请求成功返回的数据  [参数的使用由后台数据是否返回决定] （data、result） */
@property (nonatomic,strong) id data;

/** 是否请求成功  [参数的使用由后台数据是否返回决定]  后台返回数据可能为code==200  另需处理 */
@property (nonatomic,assign) BOOL success;

/** 数据结果code  [参数的使用由后台数据是否返回决定]  一般数据中由code值决定数据结果或其他操作 */
@property (nonatomic,strong) NSString *code;

/** 数据状态值  [参数的使用由后台数据是否返回决定] 一般判断数据结果及类型 */
@property (nonatomic,strong) NSString *status;

/** 时间戳  [参数的使用由后台数据是否返回决定] */
@property (nonatomic, assign) long long timestamp;

/** 时间信息  [参数的使用由后台数据是否返回决定] */
@property (nonatomic,strong) NSString *date;

/** 接口信息  [参数的使用由后台数据是否返回决定] */
@property (nonatomic,strong) NSString *msg;

/** 接口信息  [参数的使用由后台数据是否返回决定] */
@property (nonatomic,strong) NSString *message;

/** 接口信息  [参数的使用由后台数据是否返回决定] */
@property (nonatomic,strong) NSString *reason;

/** errorCode  [参数的使用由后台数据是否返回决定]  特殊操作处理（CE-001类似处理） */
@property (nonatomic,strong) NSString *errorCode;

/** errorCode  [参数的使用由后台数据是否返回决定]  特殊操作处理（CE-001类似处理） */
@property (nonatomic,strong) NSString *error_code;




/** 错误信息 */
@property (nonatomic,strong) NSString *errorMsg;

/** 数据请求失败的error信息 */
@property (nonatomic,strong) NSError *_Nullable error;



/** **必须赋值** 未经任何处理的原始数据源 */
@property (nonatomic,strong) id originalData;

/** **必须赋值** 数据请求是否成功  由数据请求结果中的error决定 */
@property (nonatomic,assign) BOOL requestSuccess;


/** 转换请求数据为当前对象处理 */
+ (CustomNetWorkResponseObject *)createDataWithResponse:(id)responseObj;
/** 转换请求失败的error为当前对象处理 */
+ (CustomNetWorkResponseObject *)createErrorDataWithError:(NSError *)error;


@end

NS_ASSUME_NONNULL_END

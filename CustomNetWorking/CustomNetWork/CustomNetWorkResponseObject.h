//
//  CustomNetWorkResponseObject.h
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
// !!!!!!!!!!!!!!!此页面必须实现 当前页面实现或分类实现!!!!!!!!!!!!!!!!!!!!!!

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/** 数据请求处理结果 */
@interface CustomNetWorkResponseObject : NSObject


/** 数据结果是否成功/正确 【若参数后台未返回则另需处理】 */
@property (nonatomic,assign) BOOL success;


/** 请求成功返回的数据  [参数的使用由后台数据是否返回决定] （data、result） */
@property (nonatomic,strong) id _Nullable result;

/** 请求成功返回的数据  [参数的使用由后台数据是否返回决定] （data、result） */
@property (nonatomic,strong) id _Nullable data;


/** 数据结果code  [参数的使用由后台数据是否返回决定]  一般数据中由code值决定数据结果或其他操作 */
@property (nonatomic,strong) NSString *code;

/** 数据状态值  [参数的使用由后台数据是否返回决定] 一般判断数据结果及类型 */
@property (nonatomic,strong) NSString *status;

/** 数据状态值  [参数的使用由后台数据是否返回决定] 一般判断数据结果及类型 */
@property (nonatomic,strong) NSString *statusCode;


/** 时间戳  [参数的使用由后台数据是否返回决定] */
@property (nonatomic,assign) long long timestamp;

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


/** 错误信息  [参数的使用由后台数据是否返回决定] */
@property (nonatomic,strong) NSString *errorMsg;

/** 错误信息  [参数的使用由后台数据是否返回决定] */
@property (nonatomic,strong) NSString *errorMessage;



/** *******************此间的参数已由CustomNetWorkOriginalObject对象做处理 视情况决定是否额外再赋值处理(如错误码处理等)******************* */
/** 数据请求是否成功 [源数据处理] */
@property (nonatomic,assign) BOOL obj_requestSuccess;

/** 未经任何处理的原始数据源 [源数据处理] */
@property (nonatomic,strong) id _Nullable obj_originalData;

/** 数据请求失败的error信息 [源数据处理] */
@property (nonatomic,strong) NSError *_Nullable obj_error;
/** *******************此间的参数已由CustomNetWorkOriginalObject对象做处理 视情况决定是否额外再赋值处理(如错误码处理等)******************* */



/** 转换请求数据为当前对象处理 */
+ (CustomNetWorkResponseObject *)createDataWithResponse:(id)responseObj;
/** 转换请求失败的error为当前对象处理 */
+ (CustomNetWorkResponseObject *)createErrorDataWithError:(NSError *)error;


@end

NS_ASSUME_NONNULL_END

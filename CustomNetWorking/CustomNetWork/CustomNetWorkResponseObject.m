//
//  CustomNetWorkResponseObject.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "CustomNetWorkResponseObject.h"

@implementation CustomNetWorkResponseObject

/** 转换请求数据为当前对象处理 */
+ (CustomNetWorkResponseObject *)createDataWithResponse:(id)responseObj{
    return nil;
}

/** 转换请求失败的error为当前对象处理 */
+ (CustomNetWorkResponseObject *)createErrorDataWithError:(NSError *)error{
    return nil;
}

@end

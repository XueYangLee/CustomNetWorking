//
//  CustomNetWorkOriginalObject.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/10/13.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "CustomNetWorkOriginalObject.h"

@implementation CustomNetWorkOriginalObject


/** 请求成功的原始数据赋值处理 */
+ (CustomNetWorkOriginalObject *)originalDataWithResponse:(id)responseObj{
    CustomNetWorkOriginalObject *obj = [CustomNetWorkOriginalObject new];
    obj.requestSuccess = YES;
    obj.data = responseObj;
    
    obj.error = nil;
    return obj;
}


/** 请求失败的原始数据赋值处理 */
+ (CustomNetWorkOriginalObject *)originalErrorDataWithError:(NSError *)error{
    CustomNetWorkOriginalObject *obj = [CustomNetWorkOriginalObject new];
    obj.requestSuccess = NO;
    obj.data = nil;
    
    obj.error = error;
    return obj;
}


@end

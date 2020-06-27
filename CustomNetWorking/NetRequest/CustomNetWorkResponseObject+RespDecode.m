//
//  CustomNetWorkResponseObject+RespDecode.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/27.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "CustomNetWorkResponseObject+RespDecode.h"
#import "NSError+CustomNetWorkExt.h"
#import "NSObject+SwizzleMethod.h"
#import <YYModel.h>

@implementation CustomNetWorkResponseObject (RespDecode)

+ (void)load{
    [CustomNetWorkResponseObject objc_swizzleClassMethod:@selector(createDataWithResponse:) with:@selector(swizzle_createDataWithResponse:)];
    
    [CustomNetWorkResponseObject objc_swizzleClassMethod:@selector(createErrorDataWithResponse:) with:@selector(swizzle_createErrorDataWithResponse:)];
}


+ (CustomNetWorkResponseObject *)swizzle_createDataWithResponse:(id)responseObj{
    CustomNetWorkResponseObject *obj=[CustomNetWorkResponseObject yy_modelWithJSON:responseObj];
    obj.originalData=responseObj;
    
    return obj;
}


+ (CustomNetWorkResponseObject *)swizzle_createErrorDataWithResponse:(NSError *)error{
    CustomNetWorkResponseObject *obj=[CustomNetWorkResponseObject new];
    obj.originalData=error;
    obj.success=NO;
    obj.errorMsg=error.errorMessage;
    return obj;
}

@end

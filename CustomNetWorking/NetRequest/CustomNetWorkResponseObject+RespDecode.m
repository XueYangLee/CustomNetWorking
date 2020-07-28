//
//  CustomNetWorkResponseObject+RespDecode.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/27.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "CustomNetWorkResponseObject+RespDecode.h"
#import "NSObject+SwizzleMethod.h"
#import <YYModel.h>

@implementation CustomNetWorkResponseObject (RespDecode)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//保证方法替换只被执行一次

        [CustomNetWorkResponseObject swizzleClassMethodWithOriginalSEL:@selector(createDataWithResponse:) swizzleNewSEL:@selector(swizzle_createDataWithResponse:)];
        
        [CustomNetWorkResponseObject swizzleClassMethodWithOriginalSEL:@selector(createErrorDataWithError:) swizzleNewSEL:@selector(swizzle_createErrorDataWithError:)];
    });
    
}


+ (CustomNetWorkResponseObject *)swizzle_createDataWithResponse:(id)responseObj{
    CustomNetWorkResponseObject *obj=[CustomNetWorkResponseObject yy_modelWithJSON:responseObj];
    obj.originalData=responseObj;
    obj.requestSuccess=YES;
    obj.error=nil;
    
    return obj;
}


+ (CustomNetWorkResponseObject *)swizzle_createErrorDataWithError:(NSError *)error{
    CustomNetWorkResponseObject *obj=[CustomNetWorkResponseObject new];
    obj.originalData=error;
    obj.requestSuccess=NO;
    obj.error=error;
    
    obj.success=NO;
    obj.errorMsg=error.errorMessage;
    return obj;
}

@end

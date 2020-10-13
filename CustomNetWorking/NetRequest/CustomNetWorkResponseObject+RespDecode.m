//
//  CustomNetWorkResponseObject+RespDecode.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/27.
//  Copyright © 2020 XueYangLee. All rights reserved.
//  !!!!!此分类可直接拖入项目中添加自定义项!!!!!

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

#pragma mark - 数据处理模板 其他自定义项自行添加
/** 数据请求成功的处理 */
+ (CustomNetWorkResponseObject *)swizzle_createDataWithResponse:(id)responseObj{
    CustomNetWorkResponseObject *obj=[CustomNetWorkResponseObject yy_modelWithJSON:responseObj];
//    if ([obj.code integerValue]==200) {
//        obj.success=YES;
//    }else{
//        obj.success=NO;
//    }
    
    return obj;
}

/** 数据请求失败的处理 */
+ (CustomNetWorkResponseObject *)swizzle_createErrorDataWithError:(NSError *)error{
    CustomNetWorkResponseObject *obj=[CustomNetWorkResponseObject new];
    obj.success=NO;
    obj.obj_error=error;
    
    return obj;
}
#pragma mark 数据处理模板 其他自定义项自行添加 -

@end

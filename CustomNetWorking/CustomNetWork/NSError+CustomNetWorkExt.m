//
//  NSError+CustomNetWorkExt.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/27.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "NSError+CustomNetWorkExt.h"
#import <objc/runtime.h>

static char statusCodeKey;
static char errorMessageKey;

@implementation NSError (CustomNetWorkExt)

- (void)setStatusCode:(NSNumber *)statusCode{
    objc_setAssociatedObject(self, &statusCodeKey, statusCode, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)statusCode{
    return objc_getAssociatedObject(self, &statusCodeKey);
}


- (void)setErrorMessage:(NSString *)errorMessage{
    objc_setAssociatedObject(self, &errorMessageKey, errorMessage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)errorMessage{
    return objc_getAssociatedObject(self, &errorMessageKey);
}

@end

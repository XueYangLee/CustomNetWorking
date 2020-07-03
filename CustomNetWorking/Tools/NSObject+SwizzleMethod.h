//
//  NSObject+SwizzleMethod.h
//  BaseTools
//
//  Created by Singularity on 2019/12/30.
//  Copyright © 2019 Singularity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SwizzleMethod)

/* 实例方法替换 当前class **/
+ (void)swizzleInstanceMethodWithOriginalSEL:(SEL)originalSel SwizzleNewSEL:(SEL)newSel;

/** 实例方法替换 自定义class */
+ (void)swizzleInstanceMethodWithClass:(Class)class OriginalSEL:(SEL)originalSel SwizzleNewSEL:(SEL)newSel;



/* 类方法替换 当前class **/
+ (void)swizzleClassMethodWithOriginalSEL:(SEL)originalSel SwizzleNewSEL:(SEL)newSel;

/** 类方法替换 自定义class */
+ (void)swizzleClassMethodWithClass:(Class)class OriginalSEL:(SEL)originalSel SwizzleNewSEL:(SEL)newSel;


@end

NS_ASSUME_NONNULL_END

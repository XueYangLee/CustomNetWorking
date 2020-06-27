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

/* 实例方法替换 **/
+ (void)objc_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;

/* 类方法替换 **/
+ (void)objc_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;


@end

NS_ASSUME_NONNULL_END

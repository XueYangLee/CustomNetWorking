//
//  NSObject+SwizzleMethod.m
//  BaseTools
//
//  Created by XueYangLee on 2019/12/30.
//  Copyright © 2019 Singularity. All rights reserved.
//

#import "NSObject+SwizzleMethod.h"
#import <objc/runtime.h>

@implementation NSObject (SwizzleMethod)

+ (void)swizzleInstanceMethodWithOriginalSEL:(SEL)originalSel swizzleNewSEL:(SEL)newSel {
    
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) {
        return;
    }
    //加一层保护措施，如果添加成功，则表示该方法不存在于本类，而是存在于父类中，不能交换父类的方法,否则父类的对象调用该方法会crash；添加失败则表示本类存在该方法
    BOOL addMethod = class_addMethod(self, originalSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (addMethod) {
        //再将原有的实现替换到swizzledMethod方法上，从而实现方法的交换，并且未影响到父类方法的实现
        class_replaceMethod(self, newSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, newMethod);
    }
    
}

+ (void)swizzleInstanceMethodWithClass:(Class)class originalSEL:(SEL)originalSel swizzleNewSEL:(SEL)newSel {
    
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod || !class) {
        return;
    }
    //加一层保护措施，如果添加成功，则表示该方法不存在于本类，而是存在于父类中，不能交换父类的方法,否则父类的对象调用该方法会crash；添加失败则表示本类存在该方法
    BOOL addMethod = class_addMethod(class, originalSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (addMethod) {
        //再将原有的实现替换到swizzledMethod方法上，从而实现方法的交换，并且未影响到父类方法的实现
        class_replaceMethod(class, newSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, newMethod);
    }
    
}




+ (void)swizzleClassMethodWithOriginalSEL:(SEL)originalSel swizzleNewSEL:(SEL)newSel {
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) {
        return;
    }
    
    BOOL addMethod = class_addMethod(class, originalSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (addMethod) {
        class_replaceMethod(class, newSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, newMethod);
    }
    
}


+ (void)swizzleClassMethodWithClass:(Class)class originalSEL:(SEL)originalSel swizzleNewSEL:(SEL)newSel {
    
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod || !class) {
        return;
    }
    
    BOOL addMethod = class_addMethod(class, originalSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (addMethod) {
        class_replaceMethod(class, newSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, newMethod);
    }
    
}


@end

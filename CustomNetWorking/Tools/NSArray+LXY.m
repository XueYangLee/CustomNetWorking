//
//  NSArray+LXY.m
//  textPod
//
//  Created by 李雪阳 on 2017/11/20.
//  Copyright © 2017年 singularity. All rights reserved.
//

#import "NSArray+LXY.h"

@implementation NSArray (LXY)

- (NSString *)descriptionWithLocale:(id)locale{
    
    NSMutableString *string = [NSMutableString string];
    
    [string appendString:@"(\n"];
    
    for (NSString *title in self) {
        
        [string appendFormat:@"\t\"%@\",\n",title];
    }
    [string appendString:@")"];
    
    return string;
}

@end

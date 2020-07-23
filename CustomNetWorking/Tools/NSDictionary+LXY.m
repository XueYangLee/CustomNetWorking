//
//  NSDictionary+LXY.m
//  textPod
//
//  Created by 李雪阳 on 2017/11/20.
//  Copyright © 2017年 singularity. All rights reserved.
//

#import "NSDictionary+LXY.h"

@implementation NSDictionary (LXY)

- (NSString *)descriptionWithLocale:(id)locale{
    
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"{\n"];
    
    for (NSString *key in self) {
        
        NSString *value =[self valueForKey:key];
        [string appendFormat:@"\t\"%@\" = %@;\n",key,value];
    }
    
    [string appendString:@"}"];
    return string;
}

@end

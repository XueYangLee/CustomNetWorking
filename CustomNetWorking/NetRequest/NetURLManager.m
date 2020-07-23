//
//  NetURLManager.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/27.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "NetURLManager.h"

@implementation NetURLManager

+ (NetURLMode)currentURLMode{
    #ifdef DEBUG
        return NetURLModeProduct;
    #else
        return NetURLModeProduct;
    #endif
}

+ (NSString *)currentHostURL{
    NSString *hostURL=@"";
    switch ([NetURLManager currentURLMode]) {
        case NetURLModeProduct:
            hostURL=@"https://www.xxx.xxx";
            break;
            
        case NetURLModeDev:
            hostURL=@"https://www.xxx.xxx";
            break;
            
        default:
            break;
    }
    return hostURL;
}



+ (NSString *)URLForPath:(NSString *)urlPath{
    return [NetURLManager mergeURLWithHost:[NetURLManager currentHostURL] path:urlPath];
}

+ (NSString *)mergeURLWithHost:(NSString *)host path:(NSString *)path{
    if (path.length==0) {
        return host;
    }
    return [NSString stringWithFormat:@"%@%@%@",host, [[path substringToIndex:1] isEqualToString:@"/"]?@"":@"/", path];
}

@end

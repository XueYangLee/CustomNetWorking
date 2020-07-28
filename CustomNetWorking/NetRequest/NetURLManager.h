//
//  NetURLManager.h
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/27.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define APIString(URLPath) [NetURLManager URLForPath:URLPath]

typedef enum : NSUInteger {
    NetURLModeProduct,//线上正式生产环境
    NetURLModeDev,//开发环境
} NetURLMode;

@interface NetURLManager : NSObject

/** 当前网络环境 */
+ (NetURLMode)currentURLMode;
/** 当前环境下的hostURL */
+ (NSString *)currentHostURL;

/** 当前环境下完整的请求路径  拼接path*/
+ (NSString *)URLForPath:(NSString *_Nullable)urlPath;

@end

NS_ASSUME_NONNULL_END

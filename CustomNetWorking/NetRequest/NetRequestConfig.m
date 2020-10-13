//
//  NetRequestConfig.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/27.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "NetRequestConfig.h"

@implementation NetRequestConfig

- (NSMutableDictionary *)publicParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"2dca7299f47cae1ada2ab1b864f3ce8c" forKey:@"key"];
    return dic;
}

- (NSMutableDictionary<NSString *,NSString *> *)requestHeader{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]?:@"";
    [dic setObject:currentVersion forKey:@"AppVersion"];
    
    NSString *metaData = [NSString stringWithFormat:@"AppStore_iOS_%@",currentVersion];
    [dic setObject:metaData forKey:@"Metadata"];
    
    return dic;
}

- (NSMutableDictionary<NSString *,NSString *> *)requestMutableHeader{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    if ((arc4random() % 4)!=0) {
        [dic setObject:[NSString stringWithFormat:@"%d",arc4random() % 10] forKey:@"count"];
    }
    
    if ((arc4random() % 4)!=0) {
        [dic setObject:[NSString stringWithFormat:@"%d",arc4random() % 10] forKey:@"number"];
    }
    
    return dic;
}


- (BOOL)activityIndicatorOpen{
    return YES;
}

/*  自建校验证书
- (AFSecurityPolicy *)securityPolicy{
    NSData *cerData = [NSData dataWithContentsOfFile:@"自建Https证书的路径"];
    // 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果需要验证自建证书(无效证书)，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // 是否需要验证域名，默认为YES. 如果证书的域名与请求的域名不一致，需设置为NO;即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险,建议打开.validatesDomainName=NO,主要用于这种情况:客户端请求的是子域名,而证书上的是另外一个域名。因为SSL证书上的域名是独立的,假如证书上注册的域名是www.google.com, 那么mail.google.com是无法验证通过的.
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    return securityPolicy;
}*/

@end

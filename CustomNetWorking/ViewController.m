//
//  ViewController.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "ViewController.h"
#import "CustomNetWork.h"
#import <YYModel.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *NetStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *judgeNetStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *cacheSizeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [CustomNetWork netWorkStatusWithBlock:^(CustomNetWorkNetStatus netWorkStatus) {
        switch (netWorkStatus) {
            case NetWorkStatusUnknow:
                self.NetStatusLabel.text = @"未知网络";
                break;
            case NetWorkStatusNotReachable:
                self.NetStatusLabel.text = @"无网络";
                break;
            case NetWorkStatusReachableViaWWAN:
                self.NetStatusLabel.text = @"手机网络";
                break;
            case NetWorkStatusReachableViaWiFi:
                self.NetStatusLabel.text = @"WiFi网络";
                break;
            
            default:
                break;
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.judgeNetStatusLabel.text = [NSString stringWithFormat:@"是否有网络-%@/手机网络-%@/WiFi网络-%@",([CustomNetWork isNetwork]?@"YES":@"NO"),([CustomNetWork isWWANNetwork]?@"YES":@"NO"),([CustomNetWork isWiFiNetwork]?@"YES":@"NO")];
    });
    
    self.cacheSizeLabel.text = [NSString stringWithFormat:@"当前缓存大小：%@",[CustomNetWorkCache cacheSize]];
    
}


- (IBAction)btnClick:(UIButton *)sender {
    
    
    if (sender.tag == 10) {//无缓存请求
        [CustomNetWork GET:@"http://apis.juhe.cn/simpleWeather/query" parameters:@{@"city":@"北京"} completion:^(CustomNetWorkResponseObject * _Nullable respObj) {
            DLog(@"%@*****GET请求结果*",respObj.result)
        }];
    }else if (sender.tag == 11) {//缓存请求  分开返回
        [CustomNetWork requestWithMethod:RequestMethodGET URL:@"http://apis.juhe.cn/simpleWeather/query" parameters:@{@"city":@"上海"} cachePolicy:CachePolicyOnlyCacheOnceRequest cacheValidTime:10 cacheComp:^(CustomNetWorkResponseObject * _Nullable respObj) {
            DLog(@"%@*****缓存结果*",respObj.result)
        } respComp:^(CustomNetWorkResponseObject * _Nullable respObj) {
            DLog(@"%@*****请求结果*",respObj.result)
        }];
    }else if (sender.tag == 12) {//缓存请求  集合返回
        [CustomNetWork requestWithMethod:RequestMethodGET URL:@"http://apis.juhe.cn/simpleWeather/query" parameters:@{@"city":@"广州"} cachePolicy:CachePolicyOnlyCacheOnceRequest cacheValidTime:CacheValidTimeForever completion:^(CustomNetWorkResponseObject * _Nullable respObj) {
            DLog(@"%@*****数据结果*",respObj.result)
        }];
    }else if (sender.tag == 13) {//缓存请求  集合返回
        [CustomNetWork GET:@"http://apis.juhe.cn/simpleWeather/query" parameters:@{@"city":@"深圳"} cachePolicy:CachePolicyOnlyCacheOnceRequest cacheValidTime:CacheValidTimeDay completion:^(CustomNetWorkResponseObject * _Nullable respObj) {
            DLog(@"%@*****GET数据结果*",respObj.result)
        }];
    }
    self.cacheSizeLabel.text = [NSString stringWithFormat:@"当前缓存大小：%@",[CustomNetWorkCache cacheSize]];
}


- (IBAction)removeCache:(UIButton *)sender {
    [CustomNetWorkCache removeAllCache];
    self.cacheSizeLabel.text = [NSString stringWithFormat:@"当前缓存大小：%@",[CustomNetWorkCache cacheSize]];
}


@end

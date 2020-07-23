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
        DLog(@"是否为手机网络->%d\n是否为WiFi网络->%d",[CustomNetWork isWWANNetwork],[CustomNetWork isWiFiNetwork])
    });
    
    [CustomNetWork dataTaskWithRequestMethod:RequestMethodGET URL:@"http://apis.juhe.cn/simpleWeather/query" parameters:@{@"city":@"北京"} completion:^(CustomNetWorkResponseObject * _Nullable respObj) {
//        DLog(@"%@>>>>",respObj.result)
    }];
    
    
}


@end

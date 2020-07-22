//
//  ViewController.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "ViewController.h"
#import "CustomNetWork.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [CustomNetWork netWorkStatusWithBlock:^(CustomNetWorkNetStatus netWorkStatus) {
        DLog(@"%ld->当前网络状态",netWorkStatus)
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DLog(@"%d->是否为手机网络",[CustomNetWork isWWANNetwork])
    });
    
}


@end

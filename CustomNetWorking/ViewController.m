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

#import "NetURLManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *NetStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *judgeNetStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *cacheSizeLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *normalDownLoadProgress;
@property (weak, nonatomic) IBOutlet UILabel *normalDownloadLabel;
@property (nonatomic,copy) NSString *normalDownloadPath;

@property (weak, nonatomic) IBOutlet UIProgressView *resumeDownloadProgress;
@property (weak, nonatomic) IBOutlet UILabel *resumeDownloadLabel;
@property (nonatomic,copy) NSString *resumeDownloadPath;

/** *********断点下载相关********* */
/**  下载历史记录 */
@property (nonatomic,strong) NSMutableDictionary *downLoadHistoryDictionary;
@property (nonatomic,strong) NSString *fileHistoryPath;
/** *********断点下载相关********* */

@end

#define REQUEST_URL @"http://apis.juhe.cn/simpleWeather/query"
#define DOWNLOAD_VIDEO_URL @"https://www.apple.com/105/media/cn/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-cn-20170912_1280x720h.mp4"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resumeDownloadSetting];
    
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
    
    self.cacheSizeLabel.text = [NSString stringWithFormat:@"当前缓存大小：%@",[CustomNetWork cacheSize]];
    
}


- (IBAction)btnClick:(UIButton *)sender {
    
    
    if (sender.tag == 10) {//无缓存请求
        [CustomNetWork GET:REQUEST_URL parameters:@{@"city":@"北京"} completion:^(CustomNetWorkResponseObject * _Nullable respObj) {
            DLog(@"%@*****GET请求结果*",respObj.result)
        }];
    }else if (sender.tag == 11) {//缓存请求  分开返回
        [CustomNetWork requestWithMethod:RequestMethodGET URL:APIString(nil) parameters:@{@"city":@"上海"} cachePolicy:CachePolicyOnlyCacheOnceRequest cacheValidTime:10 cacheComp:^(CustomNetWorkResponseObject * _Nullable respObj) {
            DLog(@"%@*****缓存结果*",respObj.result)
        } respComp:^(CustomNetWorkResponseObject * _Nullable respObj) {
            DLog(@"%@*****请求结果*",respObj.result)
        }];
    }else if (sender.tag == 12) {//缓存请求  集合返回
        [CustomNetWork requestWithMethod:RequestMethodGET URL:REQUEST_URL parameters:@{@"city":@"广州"} cachePolicy:CachePolicyMainCacheSaveRequest cacheValidTime:CacheValidTimeForever completion:^(CustomNetWorkResponseObject * _Nullable respObj) {
            DLog(@"%@*****数据结果（缓存）(源数据)*",respObj.originalData)
        }];
    }else if (sender.tag == 13) {//缓存请求  集合返回
        [CustomNetWork GET:APIString(nil) parameters:@{@"city":@"深圳"} cachePolicy:CachePolicyOnlyCacheOnceRequest cacheValidTime:CacheValidTimeDay completion:^(CustomNetWorkResponseObject * _Nullable respObj) {
            DLog(@"%@*****GET数据结果（缓存）*",respObj.result)
        }];
    }
    self.cacheSizeLabel.text = [NSString stringWithFormat:@"当前缓存大小：%@",[CustomNetWork cacheSize]];
}


- (IBAction)removeCache:(UIButton *)sender {
    [CustomNetWork removeAllCache];
    self.cacheSizeLabel.text = [NSString stringWithFormat:@"当前缓存大小：%@",[CustomNetWorkCache cacheSize]];
}


- (IBAction)normalDownload:(UIButton *)sender {
    static NSURLSessionDownloadTask *downloadTask=nil;
    if (!sender.selected) {
        downloadTask=[CustomNetWork downloadWithURL:DOWNLOAD_VIDEO_URL folderName:nil progress:^(NSProgress * _Nonnull progress, double progressRate) {
            self.normalDownLoadProgress.progress=progressRate;
            self.normalDownloadLabel.text=[NSString stringWithFormat:@"%.f%%",progressRate*100];
        } completion:^(NSURLResponse * _Nullable response, NSString * _Nullable filePath, NSError * _Nullable error) {
            DLog(@"%@*****下载文件路径*",filePath);
            
            self.normalDownloadPath=filePath;
        }];
    }else{
        [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            //停止下载
        }];
//        [task suspend];
        self.normalDownLoadProgress.progress=0;
        self.normalDownloadLabel.text=@"0%";
    }
    sender.selected = !sender.selected;
}


- (IBAction)resumeDownload:(UIButton *)sender {
    static NSURLSessionDownloadTask *resumeTask=nil;
    
    if (!sender.selected) {
        NSData *downLoadHistoryData = [self.downLoadHistoryDictionary objectForKey:DOWNLOAD_VIDEO_URL];
        resumeTask=[CustomNetWork downloadResumeWithURL:DOWNLOAD_VIDEO_URL ResumeData:downLoadHistoryData folderName:nil progress:^(NSProgress * _Nonnull progress, double progressRate) {
            self.resumeDownloadProgress.progress=progressRate;
            self.resumeDownloadLabel.text=[NSString stringWithFormat:@"%.f%%",progressRate*100];
        } completion:^(NSURLResponse * _Nullable response, NSString * _Nullable filePath, NSError * _Nullable error) {
            
            if (error) {
                if (error.code == -1001) {
                    NSLog(@"下载出错,看一下网络是否正常");
                }
                NSData *resumeData = [error.userInfo objectForKey:@"NSURLSessionDownloadTaskResumeData"];
                [self saveDownloadHistoryWithKey:DOWNLOAD_VIDEO_URL downloadTaskResumeData:resumeData];
            }else{
                if ([self.downLoadHistoryDictionary valueForKey:DOWNLOAD_VIDEO_URL]) {
                    [self.downLoadHistoryDictionary removeObjectForKey:DOWNLOAD_VIDEO_URL];
                    [self saveDownLoadHistoryDirectory];
                }
                DLog(@"%@*****下载文件路径*",filePath);
                
                self.resumeDownloadPath=filePath;
            }
        }];
        
    }else{
        [resumeTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            //停止下载
        }];
        
    }
    sender.selected = !sender.selected;
}

#pragma mark - 断点下载相关
- (void)resumeDownloadSetting {
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    self.fileHistoryPath=[path stringByAppendingPathComponent:@"fileDownLoadHistory.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.fileHistoryPath]) {
        self.downLoadHistoryDictionary =[NSMutableDictionary dictionaryWithContentsOfFile:self.fileHistoryPath];
    }else{
        self.downLoadHistoryDictionary =[NSMutableDictionary dictionary];
        //将dictionary中的数据写入plist文件中
        [self.downLoadHistoryDictionary writeToFile:self.fileHistoryPath atomically:YES];
    }
}


- (void)saveDownloadHistoryWithKey:(NSString *)key downloadTaskResumeData:(NSData *)data{
    if (!data) {
        NSString *emptyData = [NSString stringWithFormat:@""];
        [self.downLoadHistoryDictionary setObject:emptyData forKey:key];

    }else{
        [self.downLoadHistoryDictionary setObject:data forKey:key];
    }
    [self.downLoadHistoryDictionary writeToFile:self.fileHistoryPath atomically:NO];
}

- (void)saveDownLoadHistoryDirectory{
    [self.downLoadHistoryDictionary writeToFile:self.fileHistoryPath atomically:YES];
}
#pragma mark  断点下载相关 -


- (IBAction)removeNormalDownloadFile:(UIButton *)sender {
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:self.normalDownloadPath] error:nil];
}

- (IBAction)removeResumeDownloadFile:(UIButton *)sender {
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:self.resumeDownloadPath] error:nil];
}



@end

//
//  CustomNetWorkResumeDownload.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/7/10.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "CustomNetWorkResumeDownload.h"
#import <AFNetworking/AFNetworking.h>

@interface CustomNetWorkResumeDownload ()

@property (nonatomic,strong) AFURLSessionManager *manager;
@property (nonatomic,strong) NSString *fileHistoryPath;

@end

@implementation CustomNetWorkResumeDownload

+ (instancetype)sharedManager {
    static CustomNetWorkResumeDownload *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[CustomNetWorkResumeDownload alloc] init];
    });
    return shareManager;
}

- (instancetype)init{
    self=[super init];
    if (self) {
        NSURLSessionDownloadTask *task;
        //通知需写到前面 否则程序启动的时候 在创建mananger之后  通知收不到
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskDataCompleteDispose:) name:AFNetworkingTaskDidCompleteNotification object:task];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPMaximumConnectionsPerHost = 8;//最大并发数
        configuration.timeoutIntervalForRequest = 15;
        //在蜂窝网络情况下是否继续请求（上传或下载）
        configuration.allowsCellularAccess = YES;
        
        self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
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
    return self;
}

- (NSURLSessionDownloadTask *)downloadFileWithUrl:(NSString*)downloadURL FileName:(NSString *)fileName Progress:(CustomNetWorkDownloadProgress)progress Completion:(CustomNetWorkDownloadCompletion)comp{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadURL]];
    NSURLSessionDownloadTask *downloadTask = nil;
    NSData *downLoadHistoryData = [self.downLoadHistoryDictionary objectForKey:downloadURL];
//    DLog(@"本地是否存储需要续传的数据长度为 %ld",downLoadHistoryData.length);
    if (downLoadHistoryData.length > 0 ) {//使用旧任务
        
        downloadTask = [self.manager downloadTaskWithResumeData:downLoadHistoryData progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.fractionCompleted);
//                progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            }
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            if (fileName) {
                NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                // 要检查的文件目录
                NSString *filePath = [localPath  stringByAppendingPathComponent:fileName];
                return [NSURL fileURLWithPath:filePath isDirectory:NO];
            }else{
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            }
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ([httpResponse statusCode] == 404) {
                [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
            }
            
            if (error) {
                if (comp) {
                    comp(NO,response,nil);
                }
            }else{
                if (comp) {
                    comp(YES,response,filePath);
                }
            }
            
        }];
    }else{//开辟新任务
        downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.fractionCompleted);
            }
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            if (fileName) {
                NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                // 要检查的文件目录
                NSString *filePath = [localPath  stringByAppendingPathComponent:fileName];
                return [NSURL fileURLWithPath:filePath isDirectory:NO];
            }else{
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            }
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ([httpResponse statusCode] == 404) {
                [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
            }
            
            if (error) {
                if (comp) {
                    comp(NO,response,nil);
                }
            }else{
                if (comp) {
                    comp(YES,response,filePath);
                }
            }
            
        }];
    }
    [downloadTask resume];
    return downloadTask;
}


/** 下载模块的关键的代码 包括强退闪退都会有 */
- (void)taskDataCompleteDispose:(NSNotification *)notification{
    if ([notification.object isKindOfClass:[ NSURLSessionDownloadTask class]]) {
        NSURLSessionDownloadTask *task = notification.object;
        //当前下载的url
        NSString *urlHost = [task.currentRequest.URL absoluteString];
        NSError *error  = [notification.userInfo objectForKey:AFNetworkingTaskDidCompleteErrorKey] ;
        if (error) {
            if (error.code == -1001) {
                NSLog(@"下载出错,看一下网络是否正常");
            }
            NSData *resumeData = [error.userInfo objectForKey:@"NSURLSessionDownloadTaskResumeData"];
            [self saveDownloadHistoryWithKey:urlHost DownloadTaskResumeData:resumeData];
            //这个是因为 用户比如强退程序之后 ,再次进来的时候 存进去这个继续的data  需要用户去刷新列表
        }else{
            if ([self.downLoadHistoryDictionary valueForKey:urlHost]) {
                [self.downLoadHistoryDictionary removeObjectForKey:urlHost];
                [self saveDownLoadHistoryDirectory];
            }
        }
    }
}


- (void)saveDownloadHistoryWithKey:(NSString *)key DownloadTaskResumeData:(NSData *)data{
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


- (void)stopAllDownLoadTasks{
    //停止所有的下载
    if ([[self.manager downloadTasks] count]  == 0) {
        return;
    }
    for (NSURLSessionDownloadTask *task in  [self.manager downloadTasks]) {
        if (task.state == NSURLSessionTaskStateRunning) {
            [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                
            }];
        }
    }
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

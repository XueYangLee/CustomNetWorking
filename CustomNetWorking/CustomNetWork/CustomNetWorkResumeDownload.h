//
//  CustomNetWorkResumeDownload.h
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/7/10.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CustomNetWorkDownloadProgress)(double progress);
typedef void(^CustomNetWorkDownloadCompletion)(BOOL success, NSURLResponse * _Nonnull response, NSURL * _Nullable filePath);

@interface CustomNetWorkResumeDownload : NSObject

+ (instancetype)sharedManager;

/**  下载历史记录 */
@property (nonatomic,strong) NSMutableDictionary *downLoadHistoryDictionary;



/// 下载任务  断点下载
/// @param downloadURL 下载地址
/// @param fileName 需要更改的文件名
/// @param progress 下载进度
/// @param comp 完成项
- (NSURLSessionDownloadTask *)downloadFileWithUrl:(NSString*)downloadURL fileName:(NSString *)fileName progress:(CustomNetWorkDownloadProgress)progress completion:(CustomNetWorkDownloadCompletion)comp;


/** 停止所有下载 */
- (void)stopAllDownLoadTasks;

@end

NS_ASSUME_NONNULL_END

//
//  CustomNetWork.m
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "CustomNetWork.h"

@implementation CustomNetWork

#pragma mark - 网络状态
+ (void)netWorkStatusWithBlock:(CustomNetWorkStatusBlock)netWorkStatus {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                netWorkStatus ? netWorkStatus(NetWorkStatusUnknow) : nil;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netWorkStatus ? netWorkStatus(NetWorkStatusNotReachable) : nil;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                netWorkStatus ? netWorkStatus(NetWorkStatusReachableViaWWAN) : nil;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                netWorkStatus ? netWorkStatus(NetWorkStatusReachableViaWiFi) : nil;
                break;
        }
    }];
}

+ (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

#pragma mark - 缓存
+ (NSString *)cacheSize {
    return [CustomNetWorkCache cacheSize];
}

+ (void)removeAllCache {
    [CustomNetWorkCache removeAllCache];
}

+ (void)removeAllCacheWithCompletion:(void(^_Nullable)(void))comp {
    [CustomNetWorkCache removeAllCacheWithCompletion:comp];
}

#pragma mark - 取消请求
+ (void)cancelAllRequest {
    if ([[CustomNetWorkManager sharedManager].sessionManager.tasks count] > 0) {
        [[CustomNetWorkManager sharedManager].sessionManager.tasks makeObjectsPerformSelector:@selector(cancel)];//执行cancel后，tasks就会清空，网络请求会进入失败的状态，然后响应failure block，得到一个error的信息，表示请求已经成功取消了 Error Domain=NSURLErrorDomain Code=-999 "cancelled" NSLocalizedDescription=cancelled
    }
}

+ (void)cancelAllRequestStopSessionWithCancelingTasks:(BOOL)cancelPendingTasks resetSession:(BOOL)resetSession {
    [[CustomNetWorkManager sharedManager].sessionManager invalidateSessionCancelingTasks:YES resetSession:resetSession];//Error Domain=NSURLErrorDomain Code=-999 "cancelled" NSLocalizedDescription=cancelled
}

#pragma mark - 基础数据请求快捷方式
+ (NSURLSessionDataTask *_Nullable)GET:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp {
    return [self dataTaskWithRequestMethod:RequestMethodGET URL:URLString parameters:parameters completion:respComp];
}

+ (NSURLSessionDataTask *_Nullable)POST:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp {
    return [self dataTaskWithRequestMethod:RequestMethodPOST URL:URLString parameters:parameters completion:respComp];
}

+ (NSURLSessionDataTask *_Nullable)HEAD:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp {
    return [self dataTaskWithRequestMethod:RequestMethodHEAD URL:URLString parameters:parameters completion:respComp];
}

+ (NSURLSessionDataTask *_Nullable)PUT:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp {
    return [self dataTaskWithRequestMethod:RequestMethodPUT URL:URLString parameters:parameters completion:respComp];
}

+ (NSURLSessionDataTask *_Nullable)PATCH:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp {
    return [self dataTaskWithRequestMethod:RequestMethodPATCH URL:URLString parameters:parameters completion:respComp];
}

+ (NSURLSessionDataTask *_Nullable)DELETE:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp {
    return [self dataTaskWithRequestMethod:RequestMethodDELETE URL:URLString parameters:parameters completion:respComp];
}

#pragma mark - 基础数据请求快捷方式 支持缓存
+ (void)GET:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp {
    [self requestWithMethod:RequestMethodGET URL:URLString parameters:parameters cachePolicy:cachePolicy cacheValidTime:validTime completion:comp];
}

+ (void)POST:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp {
    [self requestWithMethod:RequestMethodPOST URL:URLString parameters:parameters cachePolicy:cachePolicy cacheValidTime:validTime completion:comp];
}

+ (void)HEAD:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp {
    [self requestWithMethod:RequestMethodHEAD URL:URLString parameters:parameters cachePolicy:cachePolicy cacheValidTime:validTime completion:comp];
}

+ (void)PUT:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp {
    [self requestWithMethod:RequestMethodPUT URL:URLString parameters:parameters cachePolicy:cachePolicy cacheValidTime:validTime completion:comp];
}

+ (void)PATCH:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp {
    [self requestWithMethod:RequestMethodPATCH URL:URLString parameters:parameters cachePolicy:cachePolicy cacheValidTime:validTime completion:comp];
}

+ (void)DELETE:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp {
    [self requestWithMethod:RequestMethodDELETE URL:URLString parameters:parameters cachePolicy:cachePolicy cacheValidTime:validTime completion:comp];
}

#pragma mark - 数据请求+数据缓存 结果统一返回
+ (void)requestWithMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp {
    [self requestWithMethod:method URL:URLString parameters:parameters cachePolicy:cachePolicy cacheValidTime:validTime cacheComp:comp respComp:comp];
}

#pragma mark - 数据请求+数据缓存 核心方法⚠️
+ (void)requestWithMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime cacheComp:(CustomNetWorkCacheComp _Nullable )cacheComp respComp:(CustomNetWorkRespComp _Nullable )respComp {
    
    if (cachePolicy == CachePolicyRequestWithoutCahce) {
        //仅返回网络请求数据不做数据缓存处理
        [self dataTaskWithRequestMethod:method URL:URLString parameters:parameters completion:respComp];
        
    }else if (cachePolicy == CachePolicyMainCacheSaveRequest) {
        //主要返回缓存数据并缓存网络请求的数据，缓存无数据时返回网络数据，第一次请求没有缓存数据时从网络先请求数据
        __weak typeof(self) weakSelf = self;
        [CustomNetWorkCache getRespCacheWithURL:URLString parameters:parameters validTime:validTime completion:^(id  _Nullable cacheData) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (cacheData) {
                cacheComp ? cacheComp([CustomNetWorkResponseObject createDataWithResponse:cacheData], [CustomNetWorkOriginalObject originalDataWithResponse:cacheData]) : nil;
            }
            [strongSelf dataTaskWithRequestMethod:method URL:URLString parameters:parameters completion:^(CustomNetWorkResponseObject * _Nullable respObj, CustomNetWorkOriginalObject * _Nullable originalObj) {
                if (originalObj.requestSuccess) {
                    [CustomNetWorkCache setRespCacheWithData:originalObj.data URL:URLString parameters:parameters validTime:validTime];
                }
                if (!cacheData) {
                    respComp ? respComp(respObj, originalObj) : nil;
                }
            }];
        }];
        
    }else if (cachePolicy == CachePolicyOnlyCacheOnceRequest) {
        //仅返回缓存数据而不请求网络，数据第一次请求或缓存失效的情况下才会从网络请求数据并缓存一次
        __weak typeof(self) weakSelf = self;
        [CustomNetWorkCache getRespCacheWithURL:URLString parameters:parameters validTime:validTime completion:^(id  _Nullable cacheData) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (cacheData) {
                cacheComp ? cacheComp([CustomNetWorkResponseObject createDataWithResponse:cacheData], [CustomNetWorkOriginalObject originalDataWithResponse:cacheData]) : nil;
            }else {
                [strongSelf dataTaskWithRequestMethod:method URL:URLString parameters:parameters completion:^(CustomNetWorkResponseObject * _Nullable respObj, CustomNetWorkOriginalObject * _Nullable originalObj) {
                    if (originalObj.requestSuccess) {
                        [CustomNetWorkCache setRespCacheWithData:originalObj.data URL:URLString parameters:parameters validTime:validTime];
                    }
                    respComp ? respComp(respObj, originalObj) : nil;
                }];
            }
        }];
        
    }else if (cachePolicy == CachePolicyMainRequestFailCache) {
        //主要返回网络请求数据，请求失败或请求超时的情况下再返回请求成功时缓存的数据
        [self dataTaskWithRequestMethod:method URL:URLString parameters:parameters completion:^(CustomNetWorkResponseObject * _Nullable respObj, CustomNetWorkOriginalObject * _Nullable originalObj) {
            if (originalObj.requestSuccess) {
                [CustomNetWorkCache setRespCacheWithData:originalObj.data URL:URLString parameters:parameters validTime:validTime];
                respComp ? respComp(respObj, originalObj) : nil;
            }else {
                [CustomNetWorkCache getRespCacheWithURL:URLString parameters:parameters validTime:validTime completion:^(id  _Nullable cacheData) {
                    cacheComp ? cacheComp([CustomNetWorkResponseObject createDataWithResponse:cacheData], [CustomNetWorkOriginalObject originalDataWithResponse:cacheData]) : nil;
                    if (!cacheData) {//请求失败并没有数据缓存的情况下返回请求失败信息
                        respComp ? respComp(respObj, originalObj) : nil;
                    }
                }];
            }
        }];
        
    }else if (cachePolicy == CachePolicyRequsetAndCache) {
        //网络请求数据和缓存数据共同返回
        [CustomNetWorkCache getRespCacheWithURL:URLString parameters:parameters validTime:validTime completion:^(id  _Nullable cacheData) {
            cacheComp ? cacheComp([CustomNetWorkResponseObject createDataWithResponse:cacheData], [CustomNetWorkOriginalObject originalDataWithResponse:cacheData]) : nil;
        }];
        
        [self dataTaskWithRequestMethod:method URL:URLString parameters:parameters completion:^(CustomNetWorkResponseObject * _Nullable respObj, CustomNetWorkOriginalObject * _Nullable originalObj) {
            if (originalObj.requestSuccess) {
                [CustomNetWorkCache setRespCacheWithData:originalObj.data URL:URLString parameters:parameters validTime:validTime];
            }
            respComp ? respComp(respObj, originalObj) : nil;
        }];
    }
}

#pragma mark - 数据请求 核心方法⚠️
+ (NSURLSessionDataTask *_Nullable)dataTaskWithRequestMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp {
    
    if (!URLString) {
        URLString = @"";
    }
    parameters = [self disposePublicParameters:parameters];//公共参数添加
    
    NSMutableURLRequest *request = [[CustomNetWorkManager sharedManager].sessionManager.requestSerializer requestWithMethod:[self requestTypeWithMethod:method] URLString:URLString parameters:parameters error:nil];
    
    [self disposeRequestMutableHeaderField:request];//可变请求头添加
    
    __block NSURLSessionDataTask *dataTask = [[CustomNetWorkManager sharedManager].sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            [CustomNetWorkRequestLog disposeError:error sessionTask:dataTask];
            [CustomNetWorkRequestLog logWithSessionTask:dataTask responseObj:nil error:error];
            
            respComp ? respComp([CustomNetWorkResponseObject createErrorDataWithError:error], [CustomNetWorkOriginalObject originalErrorDataWithError:error]) : nil;
            
        }else {
            [CustomNetWorkRequestLog logWithSessionTask:dataTask responseObj:responseObject error:nil];
            
            respComp ? respComp([CustomNetWorkResponseObject createDataWithResponse:responseObject], [CustomNetWorkOriginalObject originalDataWithResponse:responseObject]) : nil;
        }
        
    }];
    [dataTask resume];

    return dataTask;
}


#pragma mark - 图片上传
+ (NSURLSessionDataTask *_Nullable)uploadImagesWithMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters images:(NSArray <UIImage *>*_Nullable)images imageScale:(CGFloat)imageScale imageFileName:(NSString *_Nullable)imageFileName name:(NSString *_Nullable)name imageType:(NSString *_Nullable)imageType progress:(CustomNetWorkProgress _Nullable )progress completion:(CustomNetWorkRespComp _Nullable )comp {
    
    if (imageScale == 0 || imageScale > 1) {
        imageScale = 1.0;
    }
    if (!imageFileName) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        imageFileName = dateString;
    }
    return [self uploadWithMethod:method URL:URLString parameters:parameters constructingBody:^(id<AFMultipartFormData>  _Nonnull formData) {
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImageJPEGRepresentation(obj, imageScale);
            [formData appendPartWithFileData:imageData name:name? name : @"file" fileName:[NSString stringWithFormat:@"%@%lu.%@", imageFileName, (unsigned long)idx, imageType ? imageType : @"jpg"] mimeType:[NSString stringWithFormat:@"image/%@", imageType ? imageType : @"jpeg"]];
        }];
        
    } progress:progress completion:comp];
}

#pragma mark - 文件上传 filePath
+ (NSURLSessionDataTask *_Nullable)uploadFileWithMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters name:(NSString *_Nullable)name filePath:(NSString *_Nonnull)filePath progress:(CustomNetWorkProgress _Nullable )progress completion:(CustomNetWorkRespComp _Nullable )comp {
    
    return [self uploadWithMethod:method URL:URLString parameters:parameters constructingBody:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:name ? name : @"file" error:&error];
        if (error) {
            [CustomNetWorkRequestLog logWithSessionTask:nil responseObj:nil error:error];
            comp ? comp([CustomNetWorkResponseObject createErrorDataWithError:error], [CustomNetWorkOriginalObject originalErrorDataWithError:error]) : nil;
        }
        
    } progress:progress completion:comp];
}

#pragma mark - 文件上传 fileData
+ (NSURLSessionDataTask *_Nullable)uploadFileWithMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters name:(NSString *_Nullable)name fileData:(NSData *_Nonnull)fileData fileName:(NSString *_Nonnull)fileName mimeType:(NSString *_Nullable)mimeType progress:(CustomNetWorkProgress _Nullable )progress completion:(CustomNetWorkRespComp _Nullable )comp {
    
    return [self uploadWithMethod:method URL:URLString parameters:parameters constructingBody:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:name ? name : @"file" fileName:fileName mimeType:mimeType ? mimeType : @"form-data"];
        
    } progress:progress completion:comp];
}

#pragma mark - 数据资源上传 核心方法⚠️
+ (NSURLSessionDataTask *_Nullable)uploadWithMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters constructingBody:(CustomNetWorkUploadFormData _Nullable )formData progress:(CustomNetWorkProgress _Nullable )progress completion:(CustomNetWorkRespComp _Nullable )comp {
    
    if (!URLString) {
        URLString = @"";
    }
    parameters = [self disposePublicParameters:parameters];//公共参数添加
    
    NSMutableURLRequest *request = [[CustomNetWorkManager sharedManager].sessionManager.requestSerializer multipartFormRequestWithMethod:[self requestTypeWithMethod:method] URLString:URLString parameters:parameters constructingBodyWithBlock:formData error:nil];
    
    [self disposeRequestMutableHeaderField:request];//可变请求头添加
    
    __block NSURLSessionDataTask *task = [[CustomNetWorkManager sharedManager].sessionManager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress, uploadProgress.fractionCompleted) : nil;
        });
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [CustomNetWorkRequestLog disposeError:error sessionTask:task];
            [CustomNetWorkRequestLog logWithSessionTask:task responseObj:nil error:error];
            
            comp ? comp([CustomNetWorkResponseObject createErrorDataWithError:error], [CustomNetWorkOriginalObject originalErrorDataWithError:error]) : nil;
            
        }else {
            [CustomNetWorkRequestLog logWithSessionTask:task responseObj:responseObject error:nil];
            
            comp ? comp([CustomNetWorkResponseObject createDataWithResponse:responseObject], [CustomNetWorkOriginalObject originalDataWithResponse:responseObject]) : nil;
        }
        
    }];
    [task resume];
    
    return task;
}


#pragma mark - 文件资源下载
+ (NSURLSessionDownloadTask *_Nullable)downloadWithURL:(NSString *_Nullable)URLString folderName:(NSString *_Nullable)folderName progress:(CustomNetWorkProgress _Nullable )progress completion:(CustomNetWorkDownloadComp _Nullable )comp {
    
    if (!URLString) {
        URLString = @"";
    }
    
    NSString *downloadDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:folderName ? folderName : @"Download"];//拼接缓存目录
    NSString *fileName = URLString.lastPathComponent;
    NSString *downloadPath = [downloadDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];//打开文件管理器
    BOOL fileExist = [fileManager fileExistsAtPath:downloadPath];
    if (fileExist) {
        comp ? comp(nil, [NSString stringWithFormat:@"file://%@",downloadPath], nil) : nil;
        return nil;
    }
    BOOL folderExist = [fileManager fileExistsAtPath:downloadDirectory];
    if (!folderExist) {
        [fileManager createDirectoryAtPath:downloadDirectory withIntermediateDirectories:YES attributes:nil error:nil];//创建Download目录
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    __block NSURLSessionDownloadTask *downloadTask = [[CustomNetWorkManager sharedManager].sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress, downloadProgress.fractionCompleted) : nil;
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:downloadPath];//返回文件位置的URL路径
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            [CustomNetWorkRequestLog disposeError:error sessionTask:downloadTask];
            [CustomNetWorkRequestLog logWithSessionTask:downloadTask responseObj:nil error:error];
        }else {
            [CustomNetWorkRequestLog logWithSessionTask:downloadTask responseObj:[NSString stringWithFormat:@"下载成功：\n文件路径*****\n%@\n*", filePath.absoluteString] error:nil];
        }
        comp ? comp(response, filePath.absoluteString, error) : nil;
        
    }];
    [downloadTask resume];
    
    return downloadTask;
}

#pragma mark - 文件资源接续下载  根据保存的data数据继续下载
+ (NSURLSessionDownloadTask *_Nullable)downloadWithResumeData:(NSData *_Nonnull)resumeData folderName:(NSString *_Nullable)folderName progress:(CustomNetWorkProgress _Nullable )progress completion:(CustomNetWorkDownloadComp _Nullable )comp {
    
    __block NSURLSessionDownloadTask *downloadTask = [[CustomNetWorkManager sharedManager].sessionManager downloadTaskWithResumeData:resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress, downloadProgress.fractionCompleted) : nil;
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *downloadDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:folderName ? folderName : @"Download"];
        NSFileManager *fileManager = [NSFileManager defaultManager];//打开文件管理器
        BOOL folderExist = [fileManager fileExistsAtPath:downloadDirectory];
        if (folderExist) {
            [fileManager createDirectoryAtPath:downloadDirectory withIntermediateDirectories:YES attributes:nil error:nil];//创建Download目录
        }
        NSString *filePath = [downloadDirectory stringByAppendingPathComponent:response.suggestedFilename];//拼接文件路径
        return [NSURL fileURLWithPath:filePath];//返回文件位置的URL路径
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            [CustomNetWorkRequestLog disposeError:error sessionTask:downloadTask];
            [CustomNetWorkRequestLog logWithSessionTask:downloadTask responseObj:nil error:error];
        }else {
            [CustomNetWorkRequestLog logWithSessionTask:downloadTask responseObj:[NSString stringWithFormat:@"下载成功：\n文件路径*****\n%@\n*", filePath.absoluteString] error:nil];
        }
        comp ? comp(response, filePath.absoluteString, error) : nil;
        
    }];
    [downloadTask resume];
    
    return downloadTask;
}

#pragma mark 断点下载
+ (NSURLSessionDownloadTask *_Nullable)downloadResumeWithURL:(NSString *_Nullable)URLString ResumeData:(NSData *_Nullable)resumeData folderName:(NSString *_Nullable)folderName progress:(CustomNetWorkProgress _Nullable )progress completion:(CustomNetWorkDownloadComp _Nullable )comp {
    
    if (!URLString) {
        URLString = @"";
    }
    
    NSURLSessionDownloadTask *downloadTask = nil;
    if (resumeData.length > 0) {//存在已下载任务 继续下载
        downloadTask = [self downloadWithResumeData:resumeData folderName:folderName progress:progress completion:comp];
    }else {//新任务下载
        downloadTask= [self downloadWithURL:URLString folderName:folderName progress:progress completion:comp];
    }
    
    return downloadTask;
}


#pragma mark - 参数处理 添加公共参数♻️
+ (NSDictionary *)disposePublicParameters:(NSDictionary *)parameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if ([CustomNetWorkManager sharedManager].config.publicParams && [CustomNetWorkManager sharedManager].config.publicParams.count > 0) {
        [params addEntriesFromDictionary:[CustomNetWorkManager sharedManager].config.publicParams];//添加公共参数
    }
    return params.copy;
}

#pragma mark - 请求头处理 添加可变请求头 （如token、时间及用户信息）♻️
+ (void)disposeRequestMutableHeaderField:(NSMutableURLRequest *)request {
    if ([CustomNetWorkManager sharedManager].config.requestMutableHeader && [CustomNetWorkManager sharedManager].config.requestMutableHeader.count > 0) {
        for (NSString *key in [CustomNetWorkManager sharedManager].config.requestMutableHeader) {
            id value = [CustomNetWorkManager sharedManager].config.requestMutableHeader[key];
            [request setValue:value forHTTPHeaderField:key];
        }
    }
}

#pragma mark - 请求方式处理♻️
+ (NSString *)requestTypeWithMethod:(CustomNetWorkRequestMethod)method {
    NSString *requestMethod = @"GET";
    switch (method) {
        case RequestMethodGET:
            requestMethod = @"GET";
            break;
        case RequestMethodPOST:
            requestMethod = @"POST";
            break;
        case RequestMethodHEAD:
            requestMethod = @"HEAD";
            break;
        case RequestMethodPUT:
            requestMethod = @"PUT";
            break;
        case RequestMethodPATCH:
            requestMethod = @"PATCH";
            break;
        case RequestMethodDELETE:
            requestMethod = @"DELETE";
            break;
            
        default:
            break;
    }
    return requestMethod;
}

@end

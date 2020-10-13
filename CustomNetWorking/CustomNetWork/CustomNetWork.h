//
//  CustomNetWork.h
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/26.
//  Copyright © 2020 XueYangLee. All rights reserved.
//
/**
 注意 info.plist 不要忘记添加
 <key>NSAppTransportSecurity</key>
 <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
 </dict>
 */

#import <Foundation/Foundation.h>
#import "CustomNetWorkManager.h"
#import "CustomNetWorkResponseObject.h"
#import "CustomNetWorkOriginalObject.h"
#import "CustomNetWorkCache.h"
#import "CustomNetWorkRequestLog.h"

/** 网络状态 */
typedef NS_ENUM(NSUInteger, CustomNetWorkNetStatus) {
    /** 未知网络 */
    NetWorkStatusUnknow,
    /** 无网络 */
    NetWorkStatusNotReachable,
    /** 手机网络 */
    NetWorkStatusReachableViaWWAN,
    /** WiFi网络 */
    NetWorkStatusReachableViaWiFi,
};

/** 请求方式 */
typedef NS_ENUM(NSUInteger, CustomNetWorkRequestMethod) {
    /** GET请求 */
    RequestMethodGET = 0,
    /** POST请求 */
    RequestMethodPOST,
    /** HEAD请求 */
    RequestMethodHEAD,
    /** PUT请求 */
    RequestMethodPUT,
    /** PATCH请求 */
    RequestMethodPATCH,
    /** DELETE请求 */
    RequestMethodDELETE,
};

/** 缓存策略 */
typedef NS_ENUM(NSUInteger, CustomNetWorkCachePolicy) {
    /** 仅返回网络请求数据不做数据缓存处理 */
    CachePolicyRequestWithoutCahce = 0,
    /** 主要返回缓存数据并缓存网络请求的数据，缓存无数据时返回网络数据，第一次请求没有缓存数据时从网络先请求数据 */
    CachePolicyMainCacheSaveRequest,
    /** 仅返回缓存数据而不请求网络，数据第一次请求或缓存失效的情况下才会从网络请求数据并缓存一次 */
    CachePolicyOnlyCacheOnceRequest,
    /** 主要返回网络请求数据，请求失败或请求超时的情况下再返回请求成功时缓存的数据 */
    CachePolicyMainRequestFailCache,
    /** 网络请求数据和缓存数据共同返回 */
    CachePolicyRequsetAndCache,
};

/** 网络状态block */
typedef void(^CustomNetWorkStatusBlock)(CustomNetWorkNetStatus netWorkStatus);

/** 网络数据结果block返回 */
typedef void(^CustomNetWorkRespComp)(CustomNetWorkResponseObject * _Nullable respObj, CustomNetWorkOriginalObject * _Nullable originalObj);

/** 缓存数据结果block返回 */
typedef void(^CustomNetWorkCacheComp)(CustomNetWorkResponseObject * _Nullable respObj, CustomNetWorkOriginalObject * _Nullable originalObj);

/** 网络数据及缓存数据结果block返回 */
typedef void(^CustomNetWorkResultComp)(CustomNetWorkResponseObject * _Nullable respObj, CustomNetWorkOriginalObject * _Nullable originalObj);

/** 数据下载或上传进度及比例 */
typedef void(^CustomNetWorkProgress)(NSProgress * _Nonnull progress, double progressRate);

/** 数据上传资源类型回调 */
typedef void(^CustomNetWorkUploadFormData)(id<AFMultipartFormData>  _Nonnull formData);

/** 文件资源下载结果回调 */
typedef void(^CustomNetWorkDownloadComp)(NSURLResponse * _Nullable response, NSString * _Nullable filePath, NSError * _Nullable error);


NS_ASSUME_NONNULL_BEGIN

@interface CustomNetWork : NSObject

/** 获取当前网络状态 */
+ (void)netWorkStatusWithBlock:(CustomNetWorkStatusBlock)netWorkStatus;

/** 当前是否有网络 */
+ (BOOL)isNetwork;
/** 当前网络是否为手机网络 */
+ (BOOL)isWWANNetwork;
/** 当前网络是否为WiFi网络 */
+ (BOOL)isWiFiNetwork;

/** 获取网络缓存的总大小  直接返回计算好的KB MB GB */
+ (NSString *)cacheSize;
/** 移除所有请求的数据缓存 */
+ (void)removeAllCache;
/** 移除所有网络请求数据缓存带结果回调 */
+ (void)removeAllCacheWithCompletion:(void(^_Nullable)(void))comp;


/** 取消调用此方法前所有的网络请求 */
+ (void)cancelAllRequest;

/**
 取消所有网络请求并关闭session 不可再发请求（一般情况下无此方法调用需求 取消请求调用cancelAllRequest即可）
 
 @param cancelPendingTasks 是否结束所有未完成的请求会话 YES取消所有会话并使session失效 NO允许未完成的请求结束并使session失效
 @param resetSession 是否重置session会话，无特殊需求不需重置 设置NO即可
 */
+ (void)cancelAllRequestStopSessionWithCancelingTasks:(BOOL)cancelPendingTasks resetSession:(BOOL)resetSession;


/** GET 数据请求 */
+ (NSURLSessionDataTask *_Nullable)GET:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp;
/** POST 数据请求 */
+ (NSURLSessionDataTask *_Nullable)POST:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp;
/** HEAD 数据请求 */
+ (NSURLSessionDataTask *_Nullable)HEAD:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp;
/** PUT 数据请求 */
+ (NSURLSessionDataTask *_Nullable)PUT:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp;
/** PATCH 数据请求 */
+ (NSURLSessionDataTask *_Nullable)PATCH:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp;
/** DELETE 数据请求 */
+ (NSURLSessionDataTask *_Nullable)DELETE:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp;

/** GET 数据请求 支持缓存 */
+ (void)GET:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp;
/** POST 数据请求 支持缓存 */
+ (void)POST:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp;
/** HEAD 数据请求 支持缓存 */
+ (void)HEAD:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp;
/** PUT 数据请求 支持缓存 */
+ (void)PUT:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp;
/** PATCH 数据请求 支持缓存 */
+ (void)PATCH:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp;
/** DELETE 数据请求 支持缓存 */
+ (void)DELETE:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp;


/**
 数据请求+数据缓存 数据结果统一返回
 
 @param method 请求方式
 @param URLString 请求URL
 @param parameters 请求参数
 @param cachePolicy 缓存策略  CachePolicyOnlyCacheOnceRequest时validTime才有短时效(非永久有效)意义
 @param validTime 缓存有效时间(秒)  0或CacheValidTimeForever为永久有效
 @param comp 网络请求或缓存的数据结果  CachePolicyRequsetAndCache时结果返回两次
 */
+ (void)requestWithMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime completion:(CustomNetWorkResultComp _Nullable )comp;

/**
 数据请求+数据缓存 （核心方法）  数据结果分开返回
 
 @param method 请求方式
 @param URLString 请求URL
 @param parameters 请求参数
 @param cachePolicy 缓存策略  CachePolicyOnlyCacheOnceRequest时validTime才有短时效(非永久有效)意义
 @param validTime 缓存有效时间(秒)  0或CacheValidTimeForever为永久有效
 @param cacheComp 缓存数据结果
 @param respComp 网络请求数据结果
 */
+ (void)requestWithMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters cachePolicy:(CustomNetWorkCachePolicy)cachePolicy cacheValidTime:(NSTimeInterval)validTime cacheComp:(CustomNetWorkCacheComp _Nullable )cacheComp respComp:(CustomNetWorkRespComp _Nullable )respComp;

/**
 数据请求 （核心方法）
 
 @param method 请求方式
 @param URLString 请求URL
 @param parameters 请求参数
 @param respComp 网络请求数据结果
 */
+ (NSURLSessionDataTask *_Nullable)dataTaskWithRequestMethod:(CustomNetWorkRequestMethod)method URL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters completion:(CustomNetWorkRespComp _Nullable )respComp;




/**
 图片上传
 
 @param URLString 上传URL
 @param parameters 上传参数
 @param images 图片数组
 @param imageScale 图片压缩比例  0-1  默认1
 @param imageFileName 图片文件名 不传默认为当前时间 最终处理为名称+当前图片的index
 @param name 图片对应服务器上的字段 不传默认file
 @param imageType 图片文件类型  png/jpg/jpeg等  不传默认jpeg
 @param progress 上传进度
 @param comp 上传结果
 */
+ (NSURLSessionDataTask *_Nullable)uploadImagesWithURL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters images:(NSArray <UIImage *>*_Nullable)images imageScale:(CGFloat)imageScale imageFileName:(NSString *_Nullable)imageFileName name:(NSString *_Nullable)name imageType:(NSString *_Nullable)imageType progress:(CustomNetWorkProgress _Nullable )progress completion:(CustomNetWorkRespComp _Nullable )comp;

/**
 文件上传 根据文件路径 filePath
 
 @param URLString 上传URL
 @param parameters 上传参数
 @param name 文件对应服务器上的字段 不传默认file
 @param filePath 文件路径 必须传
 @param progress 上传进度
 @param comp 上传结果
 */
+ (NSURLSessionDataTask *_Nullable)uploadFileWithURL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters name:(NSString *_Nullable)name filePath:(NSString *_Nonnull)filePath progress:(CustomNetWorkProgress _Nullable )progress completion:(CustomNetWorkRespComp _Nullable )comp;

/**
 文件上传 根据文件资源data fileData
 
 @param URLString 上传URL
 @param parameters 上传参数
 @param name 文件对应服务器上的字段 不传默认file
 @param fileData 文件资源 data 必须传
 @param fileName 文件名 注意添加后缀 若为图片则.png/.jpg 若为视频则.mp4
 @param mimeType 文件类型 不传默认@"form-data"
 @param progress 上传进度
 @param comp 上传结果
 */
+ (NSURLSessionDataTask *_Nullable)uploadFileWithURL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters name:(NSString *_Nullable)name fileData:(NSData *_Nonnull)fileData fileName:(NSString *_Nonnull)fileName mimeType:(NSString *_Nullable)mimeType progress:(CustomNetWorkProgress _Nullable )progress completion:(CustomNetWorkRespComp _Nullable )comp;

/**
 数据资源上传 （核心方法）
 
 @param URLString 上传URL
 @param parameters 上传参数
 @param formData 上传资源回调
 @param progress 上传进度
 @param comp 上传结果
 */
+ (NSURLSessionDataTask *_Nullable)uploadWithURL:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters constructingBody:(CustomNetWorkUploadFormData _Nullable )formData progress:(CustomNetWorkProgress _Nullable )progress completion:(CustomNetWorkRespComp _Nullable )comp;




/**
 文件资源下载
 
 @param URLString 下载资源的URL
 @param folderName 下载资源的自定义保存目录文件夹名  传nil则保存至默认目录
 @param progress 下载进度
 @param comp 下载结果 error存在即代表下载停止或失败
 */
+ (NSURLSessionDownloadTask *_Nullable)downloadWithURL:(NSString *_Nullable)URLString folderName:(NSString *_Nullable)folderName progress:(CustomNetWorkProgress _Nullable )progress completion:(CustomNetWorkDownloadComp _Nullable )comp;

/**
 文件资源接续下载  根据保存的data数据继续下载
 
 @param resumeData 用于继续下载的data数据
 @param folderName 下载资源的自定义保存目录文件夹名  传nil则保存至默认目录
 @param progress 下载进度
 @param comp 下载结果 error存在即代表下载停止或失败
 */
+ (NSURLSessionDownloadTask *_Nullable)downloadWithResumeData:(NSData *_Nonnull)resumeData folderName:(NSString *_Nullable)folderName progress:(CustomNetWorkProgress _Nullable )progress completion:(CustomNetWorkDownloadComp _Nullable )comp;

/**
 文件资源断点下载
 
 @param URLString 下载资源的URL
 @param resumeData 用于断点继续下载的data数据
 @param folderName 下载资源的自定义保存目录文件夹名  传nil则保存至默认目录
 @param progress 下载进度
 @param comp 下载结果 error存在即代表下载停止或失败
 */
+ (NSURLSessionDownloadTask *_Nullable)downloadResumeWithURL:(NSString *_Nullable)URLString ResumeData:(NSData *_Nullable)resumeData folderName:(NSString *_Nullable)folderName progress:(CustomNetWorkProgress _Nullable )progress completion:(CustomNetWorkDownloadComp _Nullable )comp;

@end

NS_ASSUME_NONNULL_END

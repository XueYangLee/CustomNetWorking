# CustomNetWorking
** AFNetWorking二次封装，可利用方法替换 Swizzle Method在外部进行高度自定义处理，支持YYCache进行数据缓存处理 **

##### 使用方法
初始网络统一配置，若不做网络配置初始化则一切按照默认设置运行
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [CustomNetWorkManager sharedManager].config=[NetRequestConfig new];
    return YES;
}
```

---
##### 配置 数据处理 打印相关处理提示
> 如果 ` CustomNetWorking ` 从pods导入时，需创建配置、数据处理及打印相关的分类自定义处理文件，如示例代码中 ` NetRequestConfig `   ` CustomNetWorkResponseObject+RespDecode `  ` CustomNetWorkRequestLog+LogDecode ` 的文件示例。 若手动拖拽导入则可以在 ` CustomNetWorkConfig `   ` CustomNetWorkResponseObject `  ` CustomNetWorkRequestLog `文件中直接处理相关数据




#### CustomNetWork
```
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
 @param comp 下载结果
 */
+ (NSURLSessionDownloadTask *_Nullable)downloadWithURL:(NSString *_Nullable)URLString folderName:(NSString *_Nullable)folderName progress:(CustomNetWorkProgress _Nullable )progress completion:(CustomNetWorkDownloadComp _Nullable )comp;

/**
 文件资源接续下载  根据保存的data数据继续下载
 
 @param resumeData 用于继续下载的data数据
 @param folderName 下载资源的自定义保存目录文件夹名  传nil则保存至默认目录
 @param progress 下载进度
 @param comp 下载结果
 */
+ (NSURLSessionDownloadTask *_Nullable)downloadWithResumeData:(NSData *)resumeData folderName:(NSString *_Nullable)folderName progress:(CustomNetWorkProgress _Nullable )progress completion:(CustomNetWorkDownloadComp _Nullable )comp;


```

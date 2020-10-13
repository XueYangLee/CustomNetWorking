# CustomNetWorking
 **AFNetWorking二次封装（数据请求、数据缓存、数据文件上传、数据文件下载、数据文件断点下载），支持自定义配置，支持YYCache进行数据缓存处理** 

![https://github.com/XueYangLee/CustomNetWorking/blob/master/example.png](https://github.com/XueYangLee/CustomNetWorking/blob/master/example.png)

##### 导入方式
+ pods导入
```
pod 'CustomNetWorking'
```
+ 手动导入

直接拖拽 ` CustomNetWork ` 文件夹至你的项目

* 项目中需要添加请求头或请求公共参数是必须新建 ` CustomNetWorkConfig ` 的继承方法，或直接拖入 ` NetRequestConfig ` 到你的项目中
* 对请求结果统一处理和打印相关可以直接拖入 ` CustomNetWorkResponseObject+RespDecode ` ` CustomNetWorkRequestLog+LogDecode `文件到你的项目，或直接拖入 ` NetRequest ` 文件夹到你的项目


##### 引用
```
#import "CustomNetWork.h"
```
 
##### 使用方法
初始网络统一配置，若不做网络配置初始化则一切按照默认设置运行
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [CustomNetWorkManager sharedManager].config=[NetRequestConfig new];
    return YES;
}
```

###### 数据请求示例
```
if (sender.tag == 10) {//无缓存请求 //便捷方式
    [CustomNetWork GET:REQUEST_URL parameters:@{@"city":@"北京"} completion:^(CustomNetWorkResponseObject * _Nullable respObj, CustomNetWorkOriginalObject * _Nullable originalObj) {
        DLog(@"%@*****GET请求结果*",respObj.result)
        DLog(@"%@*****GET源结果*",originalObj.data)
    }];
}else if (sender.tag == 11) {//缓存请求(缓存保留10秒)  分开返回
    [CustomNetWork requestWithMethod:RequestMethodGET URL:APIString(nil) parameters:@{@"city":@"上海"} cachePolicy:CachePolicyOnlyCacheOnceRequest cacheValidTime:10 cacheComp:^(CustomNetWorkResponseObject * _Nullable respObj, CustomNetWorkOriginalObject * _Nullable originalObj) {
        DLog(@"%@*****缓存结果*",respObj.result)
        DLog(@"%@*****缓存源结果*",originalObj.data)
    } respComp:^(CustomNetWorkResponseObject * _Nullable respObj, CustomNetWorkOriginalObject * _Nullable originalObj) {
        DLog(@"%@*****请求结果*",respObj.result)
    }];
}else if (sender.tag == 12) {//缓存请求  集合返回
    [CustomNetWork requestWithMethod:RequestMethodGET URL:REQUEST_URL parameters:@{@"city":@"广州"} cachePolicy:CachePolicyMainCacheSaveRequest cacheValidTime:CacheValidTimeForever completion:^(CustomNetWorkResponseObject * _Nullable respObj, CustomNetWorkOriginalObject * _Nullable originalObj) {
        DLog(@"%@*****数据结果（缓存）(源数据)*",originalObj.data)
    }];
}else if (sender.tag == 13) {//缓存请求  集合返回 //便捷方式
    [CustomNetWork GET:APIString(nil) parameters:@{@"city":@"深圳"} cachePolicy:CachePolicyOnlyCacheOnceRequest cacheValidTime:CacheValidTimeDay completion:^(CustomNetWorkResponseObject * _Nullable respObj, CustomNetWorkOriginalObject * _Nullable originalObj) {
        DLog(@"%@*****GET数据结果（缓存）*",respObj.result)
    }];
}
```


---
#### 配置 数据处理 打印相关处理提示
> 如果 ` CustomNetWorking ` 从pods导入时，需创建配置、数据处理及打印相关的分类自定义处理文件，如示例代码中 ` NetRequestConfig `   ` CustomNetWorkResponseObject+RespDecode `  ` CustomNetWorkRequestLog+LogDecode ` 的文件示例。 若手动拖拽导入不想新建分类也可以在 ` CustomNetWorkConfig `   ` CustomNetWorkResponseObject `  ` CustomNetWorkRequestLog `文件中直接处理相关数据



#
#  Be sure to run `pod spec lint CustomNetWorking.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|


  spec.name         = "CustomNetWorking"
  spec.version      = "0.0.1"
  spec.summary      = "AFNetWorking二次封装（数据请求、数据缓存、数据文件上传、数据文件下载、数据文件断点下载）"

  spec.description  = <<-DESC
    AFNetWorking二次封装（数据请求、数据缓存、数据文件上传、数据文件下载、数据文件断点下载），支持自定义配置，支持YYCache进行数据缓存处理
    DESC
  spec.homepage     = "https://github.com/XueYangLee/CustomNetWorking"

  spec.license      = "MIT"

  spec.author       = { "Singularity_Lee" => "496736912@qq.com" }

  spec.ios.deployment_target = "9.0"
 
  spec.source       = { :git => "https://github.com/XueYangLee/CustomNetWorking.git", :tag => "#{spec.version}" }

  spec.source_files  = "CustomNetWorking/CustomNetWork/*.{h,m}"
  

  spec.requires_arc = true

  spec.dependency "YYCache"
  spec.dependency "AFNetworking"

end
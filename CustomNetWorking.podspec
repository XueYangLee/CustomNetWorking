#
#  Be sure to run `pod spec lint CustomNetWorking.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "CustomNetWorking"
  spec.version      = "1.2.2"
  spec.summary      = "基于AFNetWorking二次封装（数据请求、数据缓存、数据文件上传、数据文件下载、数据文件断点下载、自定义配置）"
  spec.homepage     = "https://github.com/XueYangLee/CustomNetWorking"
  spec.license      = "MIT"
  spec.author       = { "Singularity_Lee" => "496736912@qq.com" }
  spec.ios.deployment_target = "9.0"
  spec.source       = { :git => "https://github.com/XueYangLee/CustomNetWorking.git", :tag => "#{spec.version}" }
  spec.source_files  = "CustomNetWorking/CustomNetWork/*.{h,m}"
  spec.requires_arc = true
  spec.dependency 'AFNetworking'
  spec.dependency 'YYCache'

end

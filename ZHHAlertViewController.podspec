#
# 提交前，请确保运行 `pod lib lint ZHHAlertViewController.podspec` 来验证该规范文件是否有效。
#
# 以 # 开头的行是可选的，但建议使用。
# 关于 Podspec 文件的更多信息，请参阅 https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZHHAlertViewController'
  s.version          = '0.1.0'
  s.summary          = 'ZHHAlertViewController 是 UIKit 的 UIAlertView 的最佳替代方案'

  # 项目的详细描述信息，注意这里的文字长度要比 s.summary 长，否则会被认为格式不合格
  s.description      = <<-DESC
  ZHHAlertViewController 是 UIKit 的 UIAlertView 的最佳替代方案。使用 ZHHAlertViewController，您可以用几行代码轻松创建所需的 AlertView 视图。
                       DESC

  # 项目的主页地址，这里可以直接写远程仓库主页地址
  s.homepage         = 'https://github.com/yue5yueliang/ZHHAlertViewController'
  
  # 截图（可选）
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  
  # 开源协议
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  
  # 作者信息
  s.author           = { '宁小陌y' => '136769890@qq.com' }
  
  # Git 仓库地址及版本号，版本号直接使用 s.version
  s.source           = { :git => 'https://github.com/yue5yueliang/ZHHAlertViewController.git', :tag => s.version.to_s }
  
  # 多媒体介绍地址（可选）
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  # 支持的平台及版本
  s.ios.deployment_target = '12.0'
  
  # 代码原文件地址，/**/* 表示 Classes 目录及其子目录下的所有文件，如果有多个目录用逗号分隔
  s.source_files = 'ZHHAlertViewController/Classes/**/*'
  
  # 资源文件地址
  s.resource_bundles = {
      'ZHHAlertViewController' => ['ZHHAlertViewController/Assets/*.png']
  }

  # 公开头文件地址（可选）
  # s.public_header_files = 'Pod/Classes/**/*.h'
  
  # 所需的框架（可选，多个框架用逗号隔开）
  # s.frameworks = 'UIKit', 'MapKit'
  
  # 依赖关系，该项目所依赖的其他库，加载时会一并加载这些库（如果有多个依赖，填写多个）
  # s.dependency 'AFNetworking', '~> 2.3'
end

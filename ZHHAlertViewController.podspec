#
# 提交前，请确保运行 `pod lib lint ZHHAlertViewController.podspec` 来验证该规范文件是否有效。
#
# 关于 Podspec 文件的更多信息，请参阅 https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZHHAlertViewController'
  s.version          = '0.1.5'
  s.summary          = 'ZHHAlertViewController 是 UIKit 的 UIAlertView 的最佳替代方案'

  # 项目的详细描述信息，注意这里的文字长度要比 s.summary 长，否则会被认为格式不合格
  s.description      = <<-DESC
  ZHHAlertViewController 是 UIKit 的 UIAlertView 的最佳替代方案。使用 ZHHAlertViewController，您可以用几行代码轻松创建所需的 AlertView 视图。
  
  主要特性：
  - 高度可定制：支持自定义样式、布局、动画等
  - 灵活布局：支持自定义间距、尺寸、圆角等
  - 代理和 Block 回调：支持代理模式和 Block 回调两种方式
  - 模糊背景：支持自定义背景模糊效果
  - Auto Layout：基于 Auto Layout 实现，适配各种屏幕尺寸
  - 简单易用：API 设计简洁，易于集成和使用
  - 滚动阴影：长文本内容支持滚动阴影效果，提升用户体验
                       DESC

  # 项目的主页地址
  s.homepage         = 'https://github.com/yue5yueliang/ZHHAlertViewController'
  
  # 截图（需要上传到 GitHub 或 CDN 后使用完整 URL）
  # s.screenshots     = [
  #   'https://raw.githubusercontent.com/yue5yueliang/ZHHAlertViewController/master/screenshots/screenshot_main.png',
  #   'https://raw.githubusercontent.com/yue5yueliang/ZHHAlertViewController/master/screenshots/screenshot_basic.png',
  #   'https://raw.githubusercontent.com/yue5yueliang/ZHHAlertViewController/master/screenshots/screenshot_custom.png',
  #   'https://raw.githubusercontent.com/yue5yueliang/ZHHAlertViewController/master/screenshots/screenshot_long_text.png'
  # ]
  
  # 开源协议
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  
  # 作者信息
  s.author           = { '桃色三岁' => '136769890@qq.com' }
  
  # Git 仓库地址及版本号
  s.source           = { :git => 'https://github.com/yue5yueliang/ZHHAlertViewController.git', :tag => s.version.to_s }
  
  # 支持的平台及版本
  s.ios.deployment_target = '13.0'
  
  # 需要的 Swift 版本（如果使用 Swift）
  # s.swift_version = '5.0'
  
  # 默认子规格
  s.default_subspec  = 'Core'
  
  # Core 子规格
  s.subspec 'Core' do |core|
    core.source_files = 'ZHHAlertViewController/Classes/**/*'
    core.public_header_files = 'ZHHAlertViewController/Classes/**/*.h'
    core.resource = 'ZHHAlertViewController/Assets/*.*'
  end
  
  # 所需的框架
  s.frameworks = 'UIKit'
  
  # 依赖关系（目前无外部依赖）
  # s.dependency 'SomeOtherPod', '~> 1.0'
end

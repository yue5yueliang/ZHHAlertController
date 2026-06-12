#
# 提交前，请确保运行 `pod lib lint ZHHAlertController.podspec` 来验证该规范文件是否有效。
#
# 关于 Podspec 文件的更多信息，请参阅 https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZHHAlertController'
  s.version          = '1.0.0'
  s.summary          = '基于 UIKit 的可定制 Alert 弹窗组件'

  # 项目的详细描述信息，注意这里的文字长度要比 s.summary 长，否则会被认为格式不合格
  s.description      = <<-DESC
  ZHHAlertController 是基于 UIKit 的可定制 Alert 弹窗组件，API 贴近系统 UIAlertController 的双按钮模型。

  主要特性：
  - 高度可定制：支持自定义样式、布局、动画等
  - 平滑动画：支持默认缩放动画和无动画两种模式
  - 灵活布局：支持自定义间距、尺寸、圆角等
  - 代理和 Block 回调：支持代理模式和 Block 回调两种方式
  - 半透明遮罩：支持窗口/视图级背景遮罩，可配置透明度
  - 滚动阴影：长文本内容支持滚动阴影效果
  - Auto Layout：基于 Auto Layout 实现，适配各种屏幕尺寸
  - 简单易用：API 设计简洁，易于集成和使用
                       DESC

  # 项目的主页地址
  s.homepage         = 'https://github.com/yue5yueliang/ZHHAlertController'

  # 开源协议
  s.license          = { :type => 'MIT', :file => 'LICENSE' }

  # 作者信息
  s.author           = { '桃色三岁' => '136769890@qq.com' }

  # Git 仓库地址及版本号
  s.source           = { :git => 'https://github.com/yue5yueliang/ZHHAlertController.git', :tag => s.version.to_s }

  # 支持的平台及版本
  s.ios.deployment_target = '15.0'

  # 需要的 Swift 版本
  s.swift_version = '5.0'

  # Swift 源码文件（纯 Swift 版，无需 subspec 和 public_header_files）
  s.source_files = 'ZHHAlertController/Classes/**/*'

  # 所需的框架
  s.frameworks = 'UIKit'
end

# ZHHAlertController

`ZHHAlertController` 是基于 UIKit 的可定制 Alert 弹窗组件，API 贴近系统 `UIAlertController` 的双按钮模型。

## 特性

- **高度可定制**：支持自定义样式、布局、动画等
- **平滑动画**：支持默认缩放动画和无动画两种模式
- **灵活布局**：支持自定义间距、尺寸、圆角等
- **代理和 Block 回调**：支持代理模式和 Block 回调两种方式
- **半透明遮罩**：支持窗口/视图级背景遮罩，可配置透明度
- **滚动阴影**：长文本内容支持滚动阴影效果
- **Auto Layout**：基于 Auto Layout 实现，适配各种屏幕尺寸
- **简单易用**：API 设计简洁，易于集成和使用

## 截图

<div align="center">
  <img src="screenshots/screenshot_main.png" width="23%" alt="主界面" />
  <img src="screenshots/screenshot_basic.png" width="23%" alt="基础示例" />
  <img src="screenshots/screenshot_custom.png" width="23%" alt="自定义样式" />
  <img src="screenshots/screenshot_long_text.png" width="23%" alt="长文本示例" />
</div>

## 安装

### CocoaPods

在 `Podfile` 中添加：

```ruby
pod 'ZHHAlertController'
```

然后运行：

```bash
pod install
```

## 快速开始

### 基础用法

```swift
import ZHHAlertController

let alert = ZHHAlertController()
alert.title = "提示"
alert.content = "这是一个简单的提示框"
alert.cancelButtonTitle = "取消"
alert.otherButtonTitle = "确定"
alert.show()
```

### 使用 Block 回调

```swift
let alert = ZHHAlertController()
alert.title = "确认"
alert.content = "确定要删除这条记录吗？"
alert.cancelButtonTitle = "取消"
alert.otherButtonTitle = "删除"

alert.cancelButtonAction = {
    print("点击了取消按钮")
}

alert.otherButtonAction = {
    print("点击了删除按钮")
}

alert.show()
```

### 使用 Delegate

```swift
class MyViewController: UIViewController, ZHHAlertControllerDelegate {

    func showAlert() {
        let alert = ZHHAlertController()
        alert.title = "提示"
        alert.content = "这是一条提示信息"
        alert.cancelButtonTitle = "确定"
        alert.delegate = self
        alert.show()
    }

    func alertViewDidClickCancelButton(_ alertView: ZHHAlertController) {
        print("点击了取消按钮")
    }

    func alertViewDidClickOtherButton(_ alertView: ZHHAlertController) {
        print("点击了其他按钮")
    }
}
```

## API 文档

### 动画类型

`ZHHAlertAnimationStyle` 枚举：

```swift
public enum ZHHAlertAnimationStyle: Int {
    case fromTop = 0   // 从上方滑入/滑出
    case fromBottom    // 从下方滑入/滑出
    case fromLeft      // 从左侧滑入/滑出
    case fromRight     // 从右侧滑入/滑出
    case fade          // 透明度渐变
    case transform     // 缩放变换
}
```

### 主要属性

#### 视图相关属性

- `customContentView`：自定义内容视图，设置后替换默认标题 + 正文布局
- `cancelButton`：取消按钮（可自定义样式）
- `otherButton`：其他按钮（可自定义样式）
- `titleLabel`：标题标签（可自定义样式）
- `contentLabel`：正文标签（可自定义样式）

#### 布局相关属性

- `titleTopPadding`：标题距顶部间距（默认 15pt）
- `titleBottomPadding`：标题与正文间距（默认 10pt）
- `contentHorizontalPadding`：标题和正文水平内边距（默认 20pt）
- `contentButtonSpacing`：正文与按钮区间距（默认 15pt）
- `buttonBottomPadding`：按钮区底部内边距（默认 0pt）
- `buttonHorizontalPadding`：按钮区水平内边距（默认 0pt）
- `buttonSpacing`：按钮水平间距，为 0 时显示分隔线（默认 0pt）
- `buttonHeight`：按钮高度（默认 44pt）
- `popupWidth`：弹窗宽度（默认 284pt）
- `popupHeight`：弹窗最小高度（默认 135pt）
- `cornerRadius`：弹窗圆角（默认 8pt）

#### 文字内容相关属性

- `title`：标题文本
- `content`：正文文本
- `cancelButtonTitle`：取消按钮文字，为空则不显示
- `otherButtonTitle`：其他按钮文字，为空则不显示

#### 样式配置

- `separatorColor`：分隔线颜色，默认与系统一致

#### 动画配置

- `presentationStyle`：展示动画类型（默认 `.transform`）
- `dismissalStyle`：消失动画类型，为 `nil` 时沿用 `presentationStyle`
- `presentationTransformScale`：transform 展示动画起始缩放（默认 0.5）
- `dismissalTransformScale`：transform 消失动画结束缩放（默认 0.5）
- `fadeInDuration`：淡入时长（默认 0.2 秒）
- `fadeOutDuration`：淡出时长（默认 0.1 秒）

#### 行为配置

- `cancelButtonPositionRight`：取消按钮是否显示在右侧（默认 `false`）
- `shouldHighlightButtonOnClick`：点击按钮是否短暂高亮（默认 `true`）
- `shouldDismissOnActionButtonClicked`：点击操作按钮是否自动关闭（默认 `true`）
- `shouldDismissOnOutsideTapped`：点击遮罩是否关闭（默认 `false`，需开启遮罩）

#### 背景遮罩配置

- `shouldDimBackgroundWhenShowInWindow`：`show()` 时是否显示遮罩（默认 `true`）
- `shouldDimBackgroundWhenShowInView`：`show(in:)` 时是否显示遮罩（默认 `false`）
- `dimAlpha`：遮罩透明度（默认 0.4）

#### 事件处理

- `delegate`：代理对象
- `cancelButtonAction`：取消按钮回调
- `otherButtonAction`：其他按钮回调

### 主要方法

```swift
alert.show()           // 显示在 keyWindow
alert.show(in: view)   // 显示在指定视图
alert.dismiss()        // 关闭弹窗
```

### Delegate 方法

```swift
protocol ZHHAlertControllerDelegate: AnyObject {
    func alertViewWillAppear(_ alertView: ZHHAlertController)
    func alertViewDidAppear(_ alertView: ZHHAlertController)
    func alertViewDidClickCancelButton(_ alertView: ZHHAlertController)
    func alertViewDidClickOtherButton(_ alertView: ZHHAlertController)
}
```

以上方法均有默认空实现，可按需重写。

## 使用示例

### 自定义动画

```swift
let alert = ZHHAlertController()
alert.title = "提示"
alert.content = "使用默认动画"
alert.cancelButtonTitle = "确定"
alert.presentationStyle = .transform
alert.dismissalStyle = .fade
alert.presentationTransformScale = 0.5
alert.dismissalTransformScale = 0.5
alert.fadeInDuration = 0.5
alert.fadeOutDuration = 0.3
alert.show()
```

### 自定义样式

```swift
let alert = ZHHAlertController()
alert.title = "自定义样式"
alert.content = "这是一个自定义样式的 Alert"
alert.cancelButtonTitle = "取消"
alert.otherButtonTitle = "确定"
alert.popupWidth = 320
alert.popupHeight = 200
alert.cornerRadius = 12
alert.titleTopPadding = 20
alert.contentButtonSpacing = 30
alert.cancelButton.backgroundColor = .systemBlue
alert.cancelButton.setTitleColor(.white, for: .normal)
alert.show()
```

### 单按钮 Alert

```swift
let alert = ZHHAlertController()
alert.title = "提示"
alert.content = "这是一条提示信息"
alert.otherButtonTitle = "确定"
// 不设置 cancelButtonTitle，将只显示一个按钮
alert.show()
```

### 无标题 Alert

```swift
let alert = ZHHAlertController()
alert.content = "这是一条无标题的提示信息"
alert.otherButtonTitle = "确定"
alert.titleTopPadding = 40
alert.contentButtonSpacing = 0
alert.show()
```

### 仅标题 Alert

```swift
let alert = ZHHAlertController()
alert.title = "仅标题"
alert.otherButtonTitle = "确定"
alert.titleTopPadding = 40
alert.contentButtonSpacing = 0
alert.show()
```

### 在指定视图中显示

```swift
let alert = ZHHAlertController()
alert.title = "提示"
alert.content = "在指定视图中显示"
alert.otherButtonTitle = "确定"
alert.shouldDimBackgroundWhenShowInView = true
alert.show(in: view)
```

### 自定义内容视图

```swift
let alert = ZHHAlertController()

let customView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
customView.backgroundColor = .white

let label = UILabel()
label.text = "这是自定义内容"
label.textAlignment = .center
label.translatesAutoresizingMaskIntoConstraints = false
customView.addSubview(label)
NSLayoutConstraint.activate([
    label.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
    label.centerYAnchor.constraint(equalTo: customView.centerYAnchor)
])

alert.customContentView = customView
alert.otherButtonTitle = "确定"
alert.show()
```

## 系统要求

- iOS 15.0+
- Swift 5.0+
- Xcode 14.0+

## 许可证

MIT License

## 作者

桃色三岁 (136769890@qq.com)

## 链接

- [GitHub](https://github.com/yue5yueliang/ZHHAlertController)

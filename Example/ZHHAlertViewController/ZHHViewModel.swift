//
//  ZHHViewModel.swift
//  ZHHAlertViewController_Example
//
//  Created by 桃色三岁 on 2022/7/27.
//  Copyright © 2022 桃色三岁y. All rights reserved.
//

import UIKit
import ZHHAlertViewController

// MARK: - 示例类型

/// 所有 Demo 示例的枚举标识
enum ZHHDemoType {
    case basicAlert              // 基础双按钮提示
    case longTextAlert           // 长文本可滚动
    case noTitleAlert            // 无标题
    case titleOnlyAlert          // 仅标题
    case singleButtonAlert       // 单按钮
    case customButtonStyle       // 自定义按钮样式
    case customBackgroundColor   // 自定义背景色
    case customSize              // 自定义宽高
    case customCornerRadius      // 自定义圆角
    case buttonPositionRight     // 取消按钮居右
    case defaultAnimation        // 默认动画
    case dismissOnOutsideTap     // 点击遮罩关闭
    case noAutoDismiss           // 点击按钮不自动关闭
    case showInCustomView        // 指定父视图展示
    case customContentView       // 自定义内容区域
    case withDelegate            // 代理回调
    case withBlockCallback       // Block 回调

    /// 列表中显示的标题
    var title: String {
        switch self {
        case .basicAlert: return "基础提示框"
        case .longTextAlert: return "长文本提示（可滚动）"
        case .noTitleAlert: return "无标题提示"
        case .titleOnlyAlert: return "只有标题提示"
        case .singleButtonAlert: return "单按钮提示"
        case .customButtonStyle: return "自定义按钮样式"
        case .customBackgroundColor: return "自定义背景颜色"
        case .customSize: return "自定义尺寸"
        case .customCornerRadius: return "自定义圆角"
        case .buttonPositionRight: return "按钮位置调整"
        case .defaultAnimation: return "默认动画"
        case .dismissOnOutsideTap: return "点击外部关闭"
        case .noAutoDismiss: return "点击不自动关闭"
        case .showInCustomView: return "在视图中显示"
        case .customContentView: return "自定义内容视图"
        case .withDelegate: return "使用代理回调"
        case .withBlockCallback: return "使用 Block 回调"
        }
    }
}

/// 分组数据结构：组标题 + 组内示例项
struct ZHHDemoSection {
    let title: String
    let items: [ZHHDemoType]
}

// MARK: - ViewModel

/// 示例 ViewModel，负责数据分组与弹窗展示逻辑
final class ZHHViewModel: NSObject, ZHHAlertViewControllerDelegate {

    /// 分组示例数据
    let sections: [ZHHDemoSection] = [
        ZHHDemoSection(title: "基础示例", items: [
            .basicAlert, .longTextAlert, .noTitleAlert, .titleOnlyAlert, .singleButtonAlert
        ]),
        ZHHDemoSection(title: "样式自定义", items: [
            .customButtonStyle, .customBackgroundColor, .customSize, .customCornerRadius, .buttonPositionRight
        ]),
        ZHHDemoSection(title: "动画示例", items: [.defaultAnimation]),
        ZHHDemoSection(title: "交互行为", items: [
            .dismissOnOutsideTap, .noAutoDismiss, .showInCustomView
        ]),
        ZHHDemoSection(title: "自定义视图", items: [
            .customContentView, .withDelegate, .withBlockCallback
        ])
    ]

    /// 处理列表点击，展示对应示例
    func didSelectItem(at indexPath: IndexPath) {
        let type = sections[indexPath.section].items[indexPath.row]
        showDemo(type)
    }

    /// 根据类型分发到具体示例方法
    private func showDemo(_ type: ZHHDemoType) {
        switch type {
        case .basicAlert: showBasicAlert()
        case .longTextAlert: showLongTextAlert()
        case .noTitleAlert: showNoTitleAlert()
        case .titleOnlyAlert: showTitleOnlyAlert()
        case .singleButtonAlert: showSingleButtonAlert()
        case .customButtonStyle: showCustomButtonStyle()
        case .customBackgroundColor: showCustomBackgroundColor()
        case .customSize: showCustomSize()
        case .customCornerRadius: showCustomCornerRadius()
        case .buttonPositionRight: showButtonPositionRight()
        case .defaultAnimation: showDefaultAnimation()
        case .dismissOnOutsideTap: showDismissOnOutsideTap()
        case .noAutoDismiss: showNoAutoDismiss()
        case .showInCustomView: showInCustomView()
        case .customContentView: showCustomContentView()
        case .withDelegate: showWithDelegate()
        case .withBlockCallback: showWithBlockCallback()
        }
    }

    // MARK: - 基础示例

    /// 标准双按钮提示框，演示间距与标题颜色配置
    private func showBasicAlert() {
        let popup = ZHHAlertViewController()
        popup.titleTopPadding = 15
        popup.contentLeftRightPadding = 20
        popup.titleBottomPadding = 10
        popup.buttonTopPadding = 15
        popup.buttonHeight = 44
        popup.title = "退出登录"
        popup.content = "退出登录后不会删除任何历史数据\n下次登录依然可使用"
        popup.cancelButtonTitle = "取消"
        popup.otherButtonTitle = "退出"
        popup.titleLabel.textColor = .red
        popup.show()
    }

    /// 超长正文，超出高度后内容区可滚动
    private func showLongTextAlert() {
        let popup = ZHHAlertViewController()
        popup.title = "提示"
        popup.content = "秋天的风轻轻拂过，带着一丝微凉，拂落了树梢上最后一片金黄的叶子。那叶子在空中悠悠地旋转，仿佛在和大地做最后的告别。它曾在春日里伴随着嫩芽一同生长，在夏日里享受着阳光的温暖，而今，它完成了它的使命，带着满满的回忆，归于尘土。夕阳的余晖洒在静谧的湖面上，湖水波光粼粼，犹如无数颗璀璨的星星闪耀。天空中，几只归巢的鸟儿划过天际，鸣叫声在空旷的原野中回荡。远处的山峦笼罩在薄薄的雾气中，仿佛披上了一层神秘的面纱。这一刻，大自然仿佛在低声吟唱着一首古老的诗歌。那诗句里，有着草木的清香，有着流年的印记，更有着人们心中的眷恋与不舍。一阵清风吹过，湖边的芦苇轻轻摇曳，发出沙沙的声响，仿佛在低声细语。那声音轻柔而温暖，如同母亲的呢喃，抚慰着人们的心灵。夜幕渐渐降临，星星一颗颗点缀在深蓝的天幕上。此时，天地万物都进入了宁静的时刻，唯有那颗心，还在追寻着诗意的远方。在这个秋夜里，万物归于沉寂，而心中那抹不灭的诗意，却如同夜空中的星星，永远闪烁在我们心底，照亮着前行的路秋天的风轻轻拂过，带着一丝微凉，拂落了树梢上最后一片金黄的叶子。那叶子在空中悠悠地旋转，仿佛在和大地做最后的告别。它曾在春日里伴随着嫩芽一同生长，在夏日里享受着阳光的温暖，而今，它完成了它的使命，带着满满的回忆，归于尘土。"
        popup.otherButtonTitle = "确定"
        popup.cancelButtonTitle = "取消"
        popup.buttonTopPadding = 5
        popup.shouldDimBackgroundWhenShowInWindow = true
        popup.shouldDismissOnOutsideTapped = true
        popup.show()
    }

    /// 不设置 title，仅展示正文
    private func showNoTitleAlert() {
        let popup = ZHHAlertViewController()
        popup.content = "这是一个无标题的提示框"
        popup.otherButtonTitle = "确定"
        popup.cancelButtonTitle = "取消"
        popup.titleTopPadding = 40
        popup.buttonTopPadding = 0
        popup.shouldDimBackgroundWhenShowInWindow = true
        popup.shouldDismissOnOutsideTapped = true
        popup.show()
    }

    /// 不设置 content，仅展示标题
    private func showTitleOnlyAlert() {
        let popup = ZHHAlertViewController()
        popup.title = "提示"
        popup.otherButtonTitle = "确定"
        popup.cancelButtonTitle = "取消"
        popup.titleTopPadding = 40
        popup.buttonTopPadding = 0
        popup.shouldDimBackgroundWhenShowInWindow = true
        popup.shouldDismissOnOutsideTapped = true
        popup.show()
    }

    /// 只配置 otherButtonTitle，隐藏取消按钮
    private func showSingleButtonAlert() {
        let popup = ZHHAlertViewController()
        popup.title = "提示"
        popup.content = "偶尔欣赏一下窗外的景色"
        popup.otherButtonTitle = "确定"
        popup.titleBottomPadding = 15
        popup.buttonTopPadding = 20
        popup.buttonBottomPadding = 0
        popup.show()
    }

    // MARK: - 样式自定义

    /// 自定义按钮背景色、圆角及间距
    private func showCustomButtonStyle() {
        let popup = ZHHAlertViewController()
        popup.titleTopPadding = 25
        popup.titleBottomPadding = 15
        popup.buttonSpacing = 10
        popup.buttonHeight = 40
        popup.buttonBottomPadding = 20
        popup.buttonLeftRightPadding = 20
        popup.buttonTopPadding = 20
        popup.title = "退出登录"
        popup.content = "退出登录后不会删除任何历史数据\n下次登录依然可使用"
        popup.cancelButtonTitle = "取消"
        popup.otherButtonTitle = "退出"
        popup.titleLabel.textColor = .red

        popup.otherButton.setTitleColor(.white, for: .normal)
        popup.otherButton.setBackgroundImage(.zhh_image(with: .zhh_textColorF55B63), for: .normal)
        popup.otherButton.setBackgroundImage(.zhh_image(with: UIColor.zhh_hexRGB(0xF5474F)), for: .highlighted)
        popup.otherButton.layer.cornerRadius = 8
        popup.otherButton.clipsToBounds = true

        popup.cancelButton.setTitleColor(.black, for: .normal)
        popup.cancelButton.setBackgroundImage(.zhh_image(with: .zhh_enableBtnColor), for: .normal)
        popup.cancelButton.setBackgroundImage(.zhh_image(with: .zhh_highlightBtnColor), for: .highlighted)
        popup.cancelButton.layer.cornerRadius = 8
        popup.cancelButton.clipsToBounds = true

        popup.delegate = self
        popup.show()
    }

    /// 修改弹窗容器背景色
    private func showCustomBackgroundColor() {
        let popup = ZHHAlertViewController()
        popup.title = "提示"
        popup.content = "偶尔欣赏一下窗外的景色"
        popup.otherButtonTitle = "好的"
        popup.cancelButtonTitle = "取消"
        popup.backgroundColor = .orange
        popup.show()
    }

    /// 固定弹窗宽高
    private func showCustomSize() {
        let popup = ZHHAlertViewController()
        popup.title = "提示"
        popup.content = "这是一个自定义尺寸的提示框"
        popup.otherButtonTitle = "好的"
        popup.cancelButtonTitle = "取消"
        popup.width = 320
        popup.height = 200
        popup.show()
    }

    /// 调整弹窗圆角半径
    private func showCustomCornerRadius() {
        let popup = ZHHAlertViewController()
        popup.title = "提示"
        popup.content = "这是一个大圆角的提示框"
        popup.otherButtonTitle = "确定"
        popup.cancelButtonTitle = "取消"
        popup.cornerRadius = 20
        popup.show()
    }

    /// 取消按钮显示在右侧（other 在左）
    private func showButtonPositionRight() {
        let popup = ZHHAlertViewController()
        popup.title = "提示"
        popup.content = "取消按钮显示在右侧"
        popup.otherButtonTitle = "确定"
        popup.cancelButtonTitle = "取消"
        popup.cancelButtonPositionRight = true
        popup.show()
    }

    // MARK: - 动画示例

    /// 使用默认出现/消失动画
    private func showDefaultAnimation() {
        let popup = ZHHAlertViewController()
        popup.title = "提示"
        popup.content = "默认动画效果"
        popup.otherButtonTitle = "确定"
        popup.cancelButtonTitle = "取消"
        popup.appearAnimationType = .default
        popup.disappearAnimationType = .default
        popup.show()
    }

    // MARK: - 交互行为

    /// 开启遮罩层，点击外部区域关闭
    private func showDismissOnOutsideTap() {
        let popup = ZHHAlertViewController()
        popup.title = "提示"
        popup.content = "点击外部区域可以关闭此弹窗"
        popup.otherButtonTitle = "确定"
        popup.cancelButtonTitle = "取消"
        popup.shouldDimBackgroundWhenShowInWindow = true
        popup.shouldDismissOnOutsideTapped = true
        popup.show()
    }

    /// 点击按钮不自动关闭，延迟手动 dismiss
    private func showNoAutoDismiss() {
        let popup = ZHHAlertViewController()
        popup.title = "提示"
        popup.content = "点击按钮不会自动关闭，需要手动调用 dismiss"
        popup.otherButtonTitle = "确定"
        popup.cancelButtonTitle = "取消"
        popup.shouldDismissOnActionButtonClicked = false
        popup.otherButtonAction = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                popup.dismiss()
            }
        }
        popup.show()
    }

    /// 在指定父视图中展示，而非 keyWindow
    private func showInCustomView() {
        let popup = ZHHAlertViewController()
        popup.title = "提示"
        popup.content = "这个弹窗显示在指定的视图中，而不是窗口中"
        popup.otherButtonTitle = "确定"
        popup.cancelButtonTitle = "取消"
        popup.shouldDimBackgroundWhenShowInView = true
        popup.shouldDismissOnOutsideTapped = true

        if let view = topViewController?.view {
            popup.show(in: view)
        } else {
            popup.show()
        }
    }

    // MARK: - 自定义视图

    /// 替换默认 title/content 区域为自定义 UIView
    private func showCustomContentView() {
        let popup = ZHHAlertViewController()
        popup.cancelButtonTitle = "取消"
        popup.otherButtonTitle = "退出"

        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)

        let customLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 260, height: 260))
        customLabel.text = "这是一个自定义的内容视图\n你可以在这里放置任何你想要的视图元素\n比如图片、按钮、输入框等"
        customLabel.numberOfLines = 0
        customLabel.textAlignment = .center
        customLabel.textColor = .black
        customLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(customLabel)

        popup.customContentView = contentView
        popup.show()
    }

    /// 通过 ZHHAlertViewControllerDelegate 接收按钮事件
    private func showWithDelegate() {
        let popup = ZHHAlertViewController()
        popup.title = "提示"
        popup.content = "这个弹窗使用代理来处理按钮点击事件"
        popup.otherButtonTitle = "确定"
        popup.cancelButtonTitle = "取消"
        popup.delegate = self
        popup.show()
    }

    /// 通过 cancelButtonAction / otherButtonAction 接收按钮事件
    private func showWithBlockCallback() {
        let popup = ZHHAlertViewController()
        popup.title = "提示"
        popup.content = "这个弹窗使用 Block 来处理按钮点击事件"
        popup.otherButtonTitle = "确定"
        popup.cancelButtonTitle = "取消"
        popup.show()
    }

    // MARK: - 工具

    /// 获取当前最顶层可见控制器，用于 show(in:) 示例
    private var topViewController: UIViewController? {
        var topVC: UIViewController?
        for scene in UIApplication.shared.connectedScenes {
            if scene.activationState == .foregroundActive,
               let windowScene = scene as? UIWindowScene {
                topVC = windowScene.windows.first?.rootViewController
                break
            }
        }
        while let presented = topVC?.presentedViewController {
            topVC = presented
        }
        return topVC
    }

    // MARK: - ZHHAlertViewControllerDelegate

    func alertViewDidClickCancelButton(_ alertView: ZHHAlertViewController) {}

    func alertViewDidClickOtherButton(_ alertView: ZHHAlertViewController) {}
}

// MARK: - 颜色工具

private extension UIColor {
    /// 十六进制 RGB 转 UIColor
    static func zhh_hexRGB(_ rgb: UInt32, alpha: CGFloat = 1.0) -> UIColor {
        UIColor(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0xFF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: alpha
        )
    }

    static var zhh_textColorF55B63: UIColor { zhh_hexRGB(0xF55B63) }
    static var zhh_enableBtnColor: UIColor { zhh_hexRGB(0xFFDF0F) }
    static var zhh_highlightBtnColor: UIColor { zhh_hexRGB(0xFFD500) }
}

private extension UIImage {
    /// 生成纯色图片，用作按钮背景
    static func zhh_image(with color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }
}

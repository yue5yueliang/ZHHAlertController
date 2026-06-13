//
//  ZHHExampleStyle.swift
//  ZHHAlertController_Example
//
//  Created by 桃色三岁 on 2022/7/27.
//  Copyright © 2022 桃色三岁y. All rights reserved.
//

import UIKit
import ZHHAlertController

/// 样式示例枚举：内容组合 + 特殊样式，每项对应一个预设弹窗
enum ZHHExampleStyle: Int, CaseIterable {
    /// 无标题，仅正文
    case noTitle
    /// 无正文，仅标题
    case titleOnly
    /// 标题两行换行
    case titleMultiLine
    /// 正文单行短文案
    case contentSingleLine
    /// 正文超长，超出后滚动
    case longText
    /// 彩色圆角自定义按钮
    case customButton
    /// 自定义宽高与标题底距
    case customSize
    /// 大圆角弹窗
    case customCornerRadius
    /// 取消按钮排在右侧
    case buttonPositionRight
    /// 点击遮罩区域关闭
    case dismissOnOutsideTap
    /// 点击按钮不自动关闭
    case noAutoDismiss
    /// 替换为自定义 UIView 内容区
    case customContentView

    /// 列表展示标题
    var title: String {
        switch self {
        case .noTitle: return "无标题提示"
        case .titleOnly: return "仅标题提示"
        case .titleMultiLine: return "标题多行"
        case .contentSingleLine: return "正文单行"
        case .longText: return "长文本可滚动"
        case .customButton: return "自定义按钮样式"
        case .customSize: return "自定义弹窗尺寸"
        case .customCornerRadius: return "自定义圆角"
        case .buttonPositionRight: return "取消按钮居右"
        case .dismissOnOutsideTap: return "点击外部关闭"
        case .noAutoDismiss: return "点击按钮不自动关闭"
        case .customContentView: return "自定义内容视图"
        }
    }

    func makeAlert(presentingView: UIView?) -> ZHHAlertController {
        switch self {
        case .noTitle: return Self.noTitleAlert()
        case .titleOnly: return Self.titleOnlyAlert()
        case .titleMultiLine: return Self.titleMultiLineAlert()
        case .contentSingleLine: return Self.contentSingleLineAlert()
        case .longText: return Self.longTextAlert()
        case .customButton: return Self.customButtonStyle()
        case .customSize: return Self.customSize()
        case .customCornerRadius: return Self.customCornerRadius()
        case .buttonPositionRight: return Self.buttonPositionRight()
        case .dismissOnOutsideTap: return Self.dismissOnOutsideTap()
        case .noAutoDismiss: return Self.noAutoDismiss()
        case .customContentView: return Self.customContentView()
        }
    }

    // MARK: - 内容组合

    private static func noTitleAlert() -> ZHHAlertController {
        let popup = baseAlert()
        popup.title = nil
        popup.content = "这是一个无标题的提示框"
        return popup
    }

    private static func titleOnlyAlert() -> ZHHAlertController {
        let popup = baseAlert()
        popup.title = "提示"
        popup.content = nil
        return popup
    }

    private static func titleMultiLineAlert() -> ZHHAlertController {
        let popup = baseAlert()
        popup.title = "退出登录\n请确认操作"
        popup.content = ZHHExampleAppearance.defaultContent
        return popup
    }

    private static func contentSingleLineAlert() -> ZHHAlertController {
        let popup = baseAlert()
        popup.title = "提示"
        popup.content = "偶尔欣赏一下窗外的景色"
        return popup
    }

    /// 正文超出屏高 2/3 后可滚动
    private static func longTextAlert() -> ZHHAlertController {
        let popup = baseAlert()
        popup.title = "提示"
        popup.content = Self.contentLongText
        popup.contentButtonSpacing = 5
        popup.shouldDimBackgroundWhenShowInWindow = true
        popup.shouldDismissOnOutsideTapped = true
        return popup
    }

    // MARK: - 特殊样式

    /// 圆角彩色按钮 + 加大间距
    private static func customButtonStyle() -> ZHHAlertController {
        let popup = ZHHAlertController()
        popup.titleTopPadding = 25
        popup.titleBottomPadding = 15
        popup.buttonSpacing = 10
        popup.buttonHeight = 44
        popup.buttonBottomPadding = 20
        popup.buttonHorizontalPadding = 20
        popup.contentButtonSpacing = 20
        popup.title = ZHHExampleAppearance.defaultTitle
        popup.content = ZHHExampleAppearance.defaultContent
        popup.cancelButtonTitle = "取消"
        popup.otherButtonTitle = "退出"
        popup.titleLabel.textColor = .red

        popup.otherButton.setTitleColor(.white, for: .normal)
        popup.otherButton.setBackgroundImage(.zhh_image(with: .zhh_hexRGB(0xF55B63)), for: .normal)
        popup.otherButton.setBackgroundImage(.zhh_image(with: .zhh_hexRGB(0xF5474F)), for: .highlighted)
        popup.otherButton.layer.cornerRadius = 8
        popup.otherButton.clipsToBounds = true

        popup.cancelButton.setTitleColor(.black, for: .normal)
        popup.cancelButton.setBackgroundImage(.zhh_image(with: .zhh_enableBtnColor), for: .normal)
        popup.cancelButton.setBackgroundImage(.zhh_image(with: .zhh_highlightBtnColor), for: .highlighted)
        popup.cancelButton.layer.cornerRadius = 8
        popup.cancelButton.clipsToBounds = true
        return popup
    }

    private static func customSize() -> ZHHAlertController {
        let popup = baseAlert()
        popup.popupWidth = 320
        popup.popupHeight = 200
        popup.titleBottomPadding = 25
        return popup
    }

    private static func customCornerRadius() -> ZHHAlertController {
        let popup = baseAlert()
        popup.content = "这是一个大圆角的提示框"
        popup.cornerRadius = 20
        return popup
    }

    private static func buttonPositionRight() -> ZHHAlertController {
        let popup = baseAlert()
        popup.content = "取消按钮显示在右侧"
        popup.cancelButtonPositionRight = true
        return popup
    }

    private static func dismissOnOutsideTap() -> ZHHAlertController {
        let popup = baseAlert()
        popup.content = "点击外部区域可以关闭此弹窗"
        popup.shouldDimBackgroundWhenShowInWindow = true
        popup.shouldDismissOnOutsideTapped = true
        return popup
    }

    /// 点击按钮不关闭，1 秒后手动 dismiss
    private static func noAutoDismiss() -> ZHHAlertController {
        let popup = baseAlert()
        popup.content = "点击按钮不会自动关闭，需要手动调用 dismiss"
        popup.shouldDismissOnActionButtonClicked = false
        popup.otherButtonAction = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                popup.dismiss()
            }
        }
        return popup
    }

    /// 用 customContentView 替换默认标题 + 正文区域
    private static func customContentView() -> ZHHAlertController {
        let popup = ZHHAlertController()
        popup.cancelButtonTitle = "取消"
        popup.otherButtonTitle = "退出"

        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)

        let customLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 220, height: 260))
        customLabel.text = "这是一个自定义的内容视图\n你可以在这里放置任何你想要的视图元素\n比如图片、按钮、输入框等"
        customLabel.numberOfLines = 0
        customLabel.textAlignment = .center
        customLabel.textColor = .white
        customLabel.font = UIFont.systemFont(ofSize: 16)
        customLabel.backgroundColor = .orange
        contentView.addSubview(customLabel)

        popup.customContentView = contentView
        return popup
    }

    /// 标准双按钮弹窗基座
    private static func baseAlert() -> ZHHAlertController {
        let popup = ZHHAlertController()
        popup.title = ZHHExampleAppearance.defaultTitle
        popup.content = ZHHExampleAppearance.defaultContent
        popup.otherButtonTitle = "确定"
        popup.cancelButtonTitle = "取消"
        return popup
    }

    /// 长文本正文
    private static let contentLongText = """
秋天的风轻轻拂过，带着一丝微凉，拂落了树梢上最后一片金黄的叶子。那叶子在空中悠悠地旋转，仿佛在和大地做最后的告别。它曾在春日里伴随着嫩芽一同生长，在夏日里享受着阳光的温暖，而今，它完成了它的使命，带着满满的回忆，归于尘土。夕阳的余晖洒在静谧的湖面上，湖水波光粼粼，犹如无数颗璀璨的星星闪耀。天空中，几只归巢的鸟儿划过天际，鸣叫声在空旷的原野中回荡。远处的山峦笼罩在薄薄的雾气中，仿佛披上了一层神秘的面纱。这一刻，大自然仿佛在低声吟唱着一首古老的诗歌。那诗句里，有着草木的清香，有着流年的印记，更有着人们心中的眷恋与不舍。一阵清风吹过，湖边的芦苇轻轻摇曳，发出沙沙的声响，仿佛在低声细语。那声音轻柔而温暖，如同母亲的呢喃，抚慰着人们的心灵。夜幕渐渐降临，星星一颗颗点缀在深蓝的天幕上。此时，天地万物都进入了宁静的时刻，唯有那颗心，还在追寻着诗意的远方。在这个秋夜里，万物归于沉寂，而心中那抹不灭的诗意，却如同夜空中的星星，永远闪烁在我们心底，照亮着前行的路秋天的风轻轻拂过，带着一丝微凉，拂落了树梢上最后一片金黄的叶子。那叶子在空中悠悠地旋转，仿佛在和大地做最后的告别。它曾在春日里伴随着嫩芽一同生长，在夏日里享受着阳光的温暖，而今，它完成了它的使命，带着满满的回忆，归于尘土。
"""
}

// MARK: - 颜色工具（自定义按钮样式用）

private extension UIColor {
    static func zhh_hexRGB(_ rgb: UInt32, alpha: CGFloat = 1.0) -> UIColor {
        UIColor(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0xFF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: alpha
        )
    }

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

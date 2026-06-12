//
//  ZHHExampleViewModel.swift
//  ZHHAlertController_Example
//
//  Created by 桃色三岁 on 2022/7/27.
//  Copyright © 2022 桃色三岁y. All rights reserved.
//

import UIKit
import ZHHAlertController

// MARK: - 表单模型

/// 配置行控件类型
enum ZHHExampleItemType {
    /// 文本输入，绑定 String 配置项
    case text(keyPath: WritableKeyPath<ZHHExampleAppearance, String>, placeholder: String)
    /// 加减步进，绑定 CGFloat 配置项，含最小/最大/步长
    case slider(keyPath: WritableKeyPath<ZHHExampleAppearance, CGFloat>, min: CGFloat, max: CGFloat, step: CGFloat)
    /// 分段选择，绑定 Int 索引，options 为各段标题
    case segment(keyPath: WritableKeyPath<ZHHExampleAppearance, Int>, options: [String])
}

/// 单行配置项
struct ZHHExampleItem {
    let title: String
    let type: ZHHExampleItemType
}

/// 分组配置区
struct ZHHExampleSection {
    let title: String
    let items: [ZHHExampleItem]
}

// MARK: - ViewModel

/// 配置示例的数据源与弹窗构建
final class ZHHExampleViewModel: NSObject, ZHHAlertControllerDelegate {

    var config = ZHHExampleAppearance()
    /// 用于 show(in:) 时获取当前页面视图
    weak var presentingViewController: UIViewController?

    /// 配置表单分组（布局间距 / 尺寸样式 / 动画与展示）
    let sections: [ZHHExampleSection] = [
        ZHHExampleSection(title: "布局间距", items: [
            ZHHExampleItem(title: "标题顶距", type: .slider(keyPath: \.titleTopPadding, min: 0, max: 60, step: 1)),
            ZHHExampleItem(title: "标题底距", type: .slider(keyPath: \.titleBottomPadding, min: 0, max: 40, step: 1)),
            ZHHExampleItem(title: "内容左右距", type: .slider(keyPath: \.contentHorizontalPadding, min: 0, max: 40, step: 1)),
            ZHHExampleItem(title: "按钮顶距", type: .slider(keyPath: \.contentButtonSpacing, min: 0, max: 40, step: 1)),
            ZHHExampleItem(title: "按钮底距", type: .slider(keyPath: \.buttonBottomPadding, min: 0, max: 40, step: 1)),
            ZHHExampleItem(title: "按钮左右距", type: .slider(keyPath: \.buttonHorizontalPadding, min: 0, max: 40, step: 1)),
            ZHHExampleItem(title: "按钮间距", type: .slider(keyPath: \.buttonSpacing, min: 0, max: 30, step: 1))
        ]),
        ZHHExampleSection(title: "尺寸样式", items: [
            ZHHExampleItem(title: "按钮高度", type: .slider(keyPath: \.buttonHeight, min: 44, max: 60, step: 1)),
            ZHHExampleItem(title: "弹窗宽度", type: .slider(keyPath: \.popupWidth, min: 284, max: 360, step: 1)),
            ZHHExampleItem(title: "最小高度", type: .slider(keyPath: \.popupHeight, min: 135, max: 300, step: 1)),
            ZHHExampleItem(title: "圆角", type: .slider(keyPath: \.cornerRadius, min: 0, max: 30, step: 1))
        ]),
        ZHHExampleSection(title: "动画与展示", items: [
            ZHHExampleItem(title: "动画", type: .segment(keyPath: \.appearAnimationIndex, options: ["无", "默认"])),
            ZHHExampleItem(title: "展示方式", type: .segment(keyPath: \.showModeIndex, options: ["窗口", "当前视图"]))
        ])
    ]

    /// 更新文本输入项，写入 config 对应字段
    func updateText(at indexPath: IndexPath, text: String) {
        guard let item = item(at: indexPath),
              case .text(let keyPath, _) = item.type else { return }
        config[keyPath: keyPath] = text
    }

    /// 更新步进项，按 step 取整后写入 config
    func updateSlider(at indexPath: IndexPath, value: CGFloat) {
        guard let item = item(at: indexPath),
              case .slider(let keyPath, _, _, let step) = item.type else { return }
        let stepped = (value / step).rounded() * step
        config[keyPath: keyPath] = stepped
    }

    /// 更新分段选择项，写入选中索引
    func updateSegment(at indexPath: IndexPath, index: Int) {
        guard let item = item(at: indexPath),
              case .segment(let keyPath, _) = item.type else { return }
        config[keyPath: keyPath] = index
    }

    /// 读取步进项当前值
    func sliderValue(at indexPath: IndexPath) -> CGFloat? {
        guard let item = item(at: indexPath),
              case .slider(let keyPath, _, _, _) = item.type else { return nil }
        return config[keyPath: keyPath]
    }

    /// 读取文本输入项当前值
    func textValue(at indexPath: IndexPath) -> String? {
        guard let item = item(at: indexPath),
              case .text(let keyPath, _) = item.type else { return nil }
        return config[keyPath: keyPath]
    }

    /// 读取分段选择项当前索引
    func segmentValue(at indexPath: IndexPath) -> Int? {
        guard let item = item(at: indexPath),
              case .segment(let keyPath, _) = item.type else { return nil }
        return config[keyPath: keyPath]
    }

    /// 读取分段选择项各段标题
    func segmentOptions(at indexPath: IndexPath) -> [String]? {
        guard let item = item(at: indexPath),
              case .segment(_, let options) = item.type else { return nil }
        return options
    }

    /// 读取文本输入项占位文案
    func placeholder(at indexPath: IndexPath) -> String? {
        guard let item = item(at: indexPath),
              case .text(_, let placeholder) = item.type else { return nil }
        return placeholder
    }

    /// 按当前配置展示弹窗
    func showAlert() {
        let popup = buildAlert()
        if config.showModeIndex == 1, let view = presentingViewController?.view {
            popup.shouldDimBackgroundWhenShowInView = true
            popup.show(in: view)
        } else {
            popup.show()
        }
    }

    /// 将 ZHHExampleAppearance 映射为 ZHHAlertController 实例
    func buildAlert() -> ZHHAlertController {
        let popup = ZHHAlertController()
        let c = config

        popup.title = ZHHExampleAppearance.defaultTitle
        popup.content = ZHHExampleAppearance.defaultContent
        popup.cancelButtonTitle = ZHHExampleAppearance.defaultCancelButtonTitle
        popup.otherButtonTitle = ZHHExampleAppearance.defaultOtherButtonTitle

        popup.titleTopPadding = c.titleTopPadding
        popup.titleBottomPadding = c.titleBottomPadding
        popup.contentHorizontalPadding = c.contentHorizontalPadding
        popup.contentButtonSpacing = c.contentButtonSpacing
        popup.buttonBottomPadding = c.buttonBottomPadding
        popup.buttonHorizontalPadding = c.buttonHorizontalPadding
        popup.buttonSpacing = c.buttonSpacing
        popup.buttonHeight = c.buttonHeight
        popup.popupWidth = c.popupWidth
        popup.popupHeight = c.popupHeight
        popup.cornerRadius = c.cornerRadius

        popup.appearAnimationType = c.appearAnimationType
        popup.disappearAnimationType = c.appearAnimationType

        popup.delegate = self
        return popup
    }

    /// 根据 indexPath 取对应配置行
    private func item(at indexPath: IndexPath) -> ZHHExampleItem? {
        let section = sections[indexPath.section]
        guard indexPath.row < section.items.count else { return nil }
        return section.items[indexPath.row]
    }

    // MARK: - ZHHAlertControllerDelegate

    func alertViewDidClickCancelButton(_ alertView: ZHHAlertController) {}

    func alertViewDidClickOtherButton(_ alertView: ZHHAlertController) {}
}

//
//  ZHHExampleAppearance.swift
//  ZHHAlertController_Example
//
//  Created by 桃色三岁 on 2022/7/27.
//  Copyright © 2022 桃色三岁y. All rights reserved.
//

import UIKit
import ZHHAlertController

/// 配置示例的外观参数，固定「标题 + 正文 + 双按钮」标准场景
struct ZHHExampleAppearance {

    // MARK: 固定文案（不在配置页调整，边界场景见样式示例）

    static let defaultTitle = "退出登录"
    static let defaultContent = "退出登录后不会删除任何历史数据\n下次登录依然可使用"
    static let defaultCancelButtonTitle = "取消"
    static let defaultOtherButtonTitle = "退出"

    // MARK: 布局间距

    /// 标题距内容区顶部
    var titleTopPadding: CGFloat = 15
    /// 标题与正文间距
    var titleBottomPadding: CGFloat = 10
    /// 标题和正文水平内边距
    var contentHorizontalPadding: CGFloat = 20
    /// 正文与按钮区间距
    var contentButtonSpacing: CGFloat = 15
    /// 按钮区底部内边距
    var buttonBottomPadding: CGFloat = 0
    /// 按钮区水平内边距
    var buttonHorizontalPadding: CGFloat = 0
    /// 多按钮水平间距（为 0 时显示分隔线）
    var buttonSpacing: CGFloat = 0

    // MARK: 尺寸样式

    var buttonHeight: CGFloat = 44
    var popupWidth: CGFloat = 284
    /// 弹窗最小高度
    var popupHeight: CGFloat = 135
    var cornerRadius: CGFloat = 8

    // MARK: 动画与展示

    /// 0 无动画，1 默认动画
    var appearAnimationIndex: Int = 1
    /// 0 窗口，1 当前视图
    var showModeIndex: Int = 0

    var appearAnimationType: ZHHAlertAnimationType {
        appearAnimationIndex == 0 ? .none : .default
    }
}

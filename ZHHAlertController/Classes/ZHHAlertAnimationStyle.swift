//
//  ZHHAlertAnimationStyle.swift
//  ZHHAlertController
//
//  Created by 桃色三岁 on 2022/4/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

import UIKit

/// 弹窗展示/消失的动画类型
public enum ZHHAlertAnimationStyle: Int {
    /// 从上方滑入/滑出
    case fromTop = 0
    /// 从下方滑入/滑出
    case fromBottom
    /// 从左侧滑入/滑出
    case fromLeft
    /// 从右侧滑入/滑出
    case fromRight
    /// 透明度渐变
    case fade
    /// 缩放变换（配合 transformScale）
    case transform
}

extension ZHHAlertAnimationStyle {

    /// 实际消失动画：优先 dismissalStyle，否则沿用 presentationStyle
    static func effectiveDismissal(presentation: ZHHAlertAnimationStyle, dismissal: ZHHAlertAnimationStyle?) -> ZHHAlertAnimationStyle {
        dismissal ?? presentation
    }

    /// 滑入/滑出动画的初始位移偏移（基于 transform，不破坏 Auto Layout 约束）
    func translationOffset(in containerBounds: CGRect, alertSize: CGSize) -> CGSize {
        switch self {
        case .fromTop:
            return CGSize(width: 0, height: -(containerBounds.height / 2 + alertSize.height / 2))
        case .fromBottom:
            return CGSize(width: 0, height: containerBounds.height / 2 + alertSize.height / 2)
        case .fromLeft:
            return CGSize(width: -(containerBounds.width / 2 + alertSize.width / 2), height: 0)
        case .fromRight:
            return CGSize(width: containerBounds.width / 2 + alertSize.width / 2, height: 0)
        case .fade, .transform:
            return .zero
        }
    }
}

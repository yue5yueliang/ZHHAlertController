//
//  ZHHAlertController+Animation.swift
//  ZHHAlertController
//
//  Created by 桃色三岁 on 2022/4/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

import UIKit

extension ZHHAlertController {

    // MARK: - 展示动画

    /// 执行展示动画
    func performPresentAnimation(in containerView: UIView) {
        layoutIfNeeded()
        backgroundDimView?.alpha = 0

        let duration = fadeInDuration > 0 ? fadeInDuration : 0.2
        let alertSize = currentAlertSize()
        let offset = presentationStyle.translationOffset(in: containerView.bounds, alertSize: alertSize)
        applyInitialAnimationState(style: presentationStyle, scale: presentationTransformScale, offset: offset)

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.backgroundDimView?.alpha = 1
            self.applyFinalAnimationState()
        }, completion: { _ in
            self.alertViewDidAppear()
        })
    }

    // MARK: - 消失动画

    /// 执行消失动画
    func performDismissAnimation(duration: TimeInterval, delay: TimeInterval) {
        let dismissStyle = ZHHAlertAnimationStyle.effectiveDismissal(
            presentation: presentationStyle,
            dismissal: dismissalStyle
        )
        let containerBounds = superview?.bounds ?? .zero
        let alertSize = currentAlertSize()
        let offset = dismissStyle.translationOffset(in: containerBounds, alertSize: alertSize)

        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.backgroundDimView?.alpha = 0
            self.applyDismissAnimationState(style: dismissStyle, scale: self.dismissalTransformScale, offset: offset)
        }, completion: { _ in
            self.resetAnimationState()
            self.cleanupAfterDismiss()
        })
    }

    // MARK: - 动画状态

    /// 当前弹窗尺寸（布局完成后取约束常量）
    private func currentAlertSize() -> CGSize {
        CGSize(
            width: widthConstraint?.constant ?? popupWidth,
            height: heightConstraint?.constant ?? popupHeight
        )
    }

    /// 设置展示动画初始状态
    private func applyInitialAnimationState(style: ZHHAlertAnimationStyle, scale: CGFloat, offset: CGSize) {
        switch style {
        case .fade:
            alpha = 0
            transform = .identity
        case .transform:
            alpha = 0
            transform = CGAffineTransform(scaleX: scale, y: scale)
        case .fromTop, .fromBottom, .fromLeft, .fromRight:
            alpha = 1
            transform = CGAffineTransform(translationX: offset.width, y: offset.height)
        }
    }

    /// 设置展示动画结束状态
    private func applyFinalAnimationState() {
        alpha = 1
        transform = .identity
    }

    /// 设置消失动画结束状态
    private func applyDismissAnimationState(style: ZHHAlertAnimationStyle, scale: CGFloat, offset: CGSize) {
        switch style {
        case .fade:
            alpha = 0
            transform = .identity
        case .transform:
            alpha = 0
            transform = CGAffineTransform(scaleX: scale, y: scale)
        case .fromTop, .fromBottom, .fromLeft, .fromRight:
            alpha = 1
            transform = CGAffineTransform(translationX: offset.width, y: offset.height)
        }
    }

    /// 重置 transform 与透明度
    private func resetAnimationState() {
        alpha = 1
        transform = .identity
    }
}

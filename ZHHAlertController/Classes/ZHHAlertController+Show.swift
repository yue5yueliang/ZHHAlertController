//
//  ZHHAlertController+Show.swift
//  ZHHAlertController
//
//  Created by 桃色三岁 on 2022/4/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

import UIKit

extension ZHHAlertController {

    // MARK: - 显示与关闭

    /// 显示在当前 keyWindow 中
    public func show() {
        guard let window = keyWindow else { return }
        // 在 window 上显示时，按需添加背景遮罩
        if shouldDimBackgroundWhenShowInWindow {
            addBackgroundDimView(to: window)
        }
        show(in: window)
    }

    /// 显示在指定父视图中
    public func show(in view: UIView) {
        // 重复调用 show 时，先清理上一次的视图和约束
        if isShowing {
            removeFromSuperview()
            backgroundDimView?.removeFromSuperview()
            backgroundDimView = nil
            deactivateConstraints()
        }

        // 清除旧按钮，避免重复添加
        for subview in buttonStackView.arrangedSubviews {
            buttonStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        titleLabel.text = title
        contentLabel.text = content

        // 布局完成后更新滚动阴影
        DispatchQueue.main.async { [weak self] in
            self?.updateShadowLayers()
        }

        configureButtons()

        view.addSubview(self)

        // 居中约束，宽高由 popupWidth / popupHeight 决定
        widthConstraint = widthAnchor.constraint(equalToConstant: popupWidth)
        heightConstraint = heightAnchor.constraint(equalToConstant: popupHeight)
        centerXConstraint = centerXAnchor.constraint(equalTo: view.centerXAnchor)
        centerYConstraint = centerYAnchor.constraint(equalTo: view.centerYAnchor)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([centerXConstraint!, centerYConstraint!, widthConstraint!, heightConstraint!])

        isShowing = true
        updateAlertLayout()

        // 非 window 场景下，按需添加背景遮罩
        if shouldDimBackgroundWhenShowInView && view !== keyWindow {
            addBackgroundDimView(to: view)
        }

        alertViewWillAppear()
        performPresentAnimation(in: view)
    }

    /// 关闭弹窗
    public func dismiss() {
        guard isShowing else { return }

        isShowing = false
        let duration = fadeOutDuration > 0 ? fadeOutDuration : 0.1
        performDismissAnimation(duration: duration, delay: 0.02)
    }

    /// 关闭后移除视图、约束、阴影层和按钮
    func cleanupAfterDismiss() {
        removeFromSuperview()
        deactivateConstraints()

        topShadowLayer?.removeFromSuperlayer()
        topShadowLayer = nil
        bottomShadowLayer?.removeFromSuperlayer()
        bottomShadowLayer = nil

        for subview in buttonStackView.arrangedSubviews {
            buttonStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        backgroundDimView?.removeFromSuperview()
        backgroundDimView = nil
    }

    // MARK: - 交互

    /// 取消按钮点击（始终关闭弹窗）
    func handleCancelButtonClick() {
        if shouldHighlightButtonOnClick {
            setButtonHighlightEffect(cancelButton)
        }
        dismiss()
        cancelButtonAction?()
        delegate?.alertViewDidClickCancelButton(self)
    }

    /// 其他按钮点击（是否关闭由 shouldDismissOnActionButtonClicked 控制）
    func handleOtherButtonClick() {
        if shouldHighlightButtonOnClick {
            setButtonHighlightEffect(otherButton)
        }
        if shouldDismissOnActionButtonClicked {
            dismiss()
        }
        otherButtonAction?()
        delegate?.alertViewDidClickOtherButton(self)
    }

    /// 点击遮罩区域，按需关闭弹窗
    @objc func outsideTap(_ recognizer: UITapGestureRecognizer) {
        if shouldDismissOnOutsideTapped {
            dismiss()
        }
    }

    /// 按钮点击后的短暂背景高亮，0.2 秒后恢复
    func setButtonHighlightEffect(_ button: UIButton) {
        let originColor = button.backgroundColor ?? .clear
        button.backgroundColor = UIColor(white: 0, alpha: 0.1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            button.backgroundColor = originColor
        }
    }

    // MARK: - 私有辅助

    /// 根据按钮标题和 cancelButtonPositionRight 配置按钮顺序
    func configureButtons() {
        let hasCancelButton = !(cancelButtonTitle?.isEmpty ?? true)
        let hasOtherButton = !(otherButtonTitle?.isEmpty ?? true)

        // 双按钮：按 cancelButtonPositionRight 决定左右顺序
        if hasCancelButton && hasOtherButton {
            if cancelButtonPositionRight {
                // 取消按钮在右侧：先 other，后 cancel
                otherButton.setTitle(otherButtonTitle, for: .normal)
                buttonStackView.addArrangedSubview(otherButton)
                cancelButton.setTitle(cancelButtonTitle, for: .normal)
                buttonStackView.addArrangedSubview(cancelButton)
            } else {
                // 取消按钮在左侧：先 cancel，后 other
                cancelButton.setTitle(cancelButtonTitle, for: .normal)
                buttonStackView.addArrangedSubview(cancelButton)
                otherButton.setTitle(otherButtonTitle, for: .normal)
                buttonStackView.addArrangedSubview(otherButton)
            }
        } else {
            // 单按钮：只添加有标题的按钮
            if hasCancelButton {
                cancelButton.setTitle(cancelButtonTitle, for: .normal)
                buttonStackView.addArrangedSubview(cancelButton)
            }
            if hasOtherButton {
                otherButton.setTitle(otherButtonTitle, for: .normal)
                buttonStackView.addArrangedSubview(otherButton)
            }
        }
    }

    /// 添加半透明背景遮罩，支持点击外部关闭
    func addBackgroundDimView(to view: UIView) {
        let dimView = UIView(frame: view.bounds)
        dimView.backgroundColor = UIColor(white: 0, alpha: dimAlpha)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(outsideTap(_:)))
        dimView.addGestureRecognizer(tapGesture)

        if view === keyWindow {
            view.addSubview(dimView)
        } else {
            // 插入到弹窗下方，避免遮挡弹窗本身
            view.insertSubview(dimView, belowSubview: self)
        }
        backgroundDimView = dimView
    }

    /// 移除 show 时创建的约束，避免重复 show 时冲突
    func deactivateConstraints() {
        widthConstraint?.isActive = false
        widthConstraint = nil
        heightConstraint?.isActive = false
        heightConstraint = nil
        centerXConstraint?.isActive = false
        centerXConstraint = nil
        centerYConstraint?.isActive = false
        centerYConstraint = nil
        scrollHeightConstraint?.isActive = false
        scrollHeightConstraint = nil
    }

    /// 通知代理：弹窗已显示
    func alertViewDidAppear() {
        delegate?.alertViewDidAppear(self)
    }

    /// 通知代理：弹窗即将显示
    func alertViewWillAppear() {
        delegate?.alertViewWillAppear(self)
    }

    /// 获取当前前台活跃的 keyWindow
    var keyWindow: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            if scene.activationState == .foregroundActive,
               let windowScene = scene as? UIWindowScene {
                return windowScene.windows.first
            }
        }
        return nil
    }
}

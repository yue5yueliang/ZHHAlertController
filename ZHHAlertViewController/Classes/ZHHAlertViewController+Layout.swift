//
//  ZHHAlertViewController+Layout.swift
//  ZHHAlertViewController
//
//  布局与滚动阴影
//

import UIKit

extension ZHHAlertViewController {

    // MARK: - 布局

    /// 构建弹窗内部布局，并根据内容动态调整高度
    func layoutContent() {
        layer.cornerRadius = cornerRadius

        if buttonStackView.superview == nil {
            addSubview(buttonStackView)
        }

        let hasCancelButton = !(cancelButtonTitle?.isEmpty ?? true)
        let hasOtherButton = !(otherButtonTitle?.isEmpty ?? true)

        // 按钮间距为 0 且有按钮时，添加按钮上方水平分隔线
        if buttonSpacing <= 0 && (hasCancelButton || hasOtherButton) {
            if horizontalSeparator.superview == nil {
                addSubview(horizontalSeparator)
            }
        }

        // 双按钮且间距为 0 时，添加按钮中间垂直分隔线
        if buttonSpacing <= 0 && hasCancelButton && hasOtherButton {
            if verticalSeparator.superview == nil {
                addSubview(verticalSeparator)
            }
        }

        let sepColor = separatorColor
        horizontalSeparator.backgroundColor = sepColor
        verticalSeparator.backgroundColor = sepColor

        if !hasCustomContentView {
            // 默认布局：标题 + 正文 + 按钮
            setupDefaultContentLayout(hasCancelButton: hasCancelButton, hasOtherButton: hasOtherButton)
        } else {
            // 自定义内容视图：只布局按钮区域
            setupButtonAreaLayout(hasCancelButton: hasCancelButton, hasOtherButton: hasOtherButton)
        }
    }

    /// 默认标题 + 正文布局
    private func setupDefaultContentLayout(hasCancelButton: Bool, hasOtherButton: Bool) {
        if containerView.superview == nil {
            addSubview(containerView)
        }
        if titleLabel.superview == nil {
            containerView.addSubview(titleLabel)
        }
        if scrollView.superview == nil {
            containerView.addSubview(scrollView)
        }
        scrollView.delegate = self
        if contentLabel.superview == nil {
            scrollView.addSubview(contentLabel)
        }

        setupShadowLayers()

        // scrollView 高度后续由 updateContentHeight 动态计算
        scrollHeightConstraint = scrollView.heightAnchor.constraint(equalToConstant: 100)
        scrollViewTopConstraint = scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: titleBottomPadding)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentLeftRightPadding),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentLeftRightPadding),
            containerView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: titleTopPadding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentLeftRightPadding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentLeftRightPadding),

            scrollViewTopConstraint!,
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentLeftRightPadding),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentLeftRightPadding),
            scrollHeightConstraint!,

            // contentLabel 撑开 scrollView 的 contentSize
            contentLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        layoutIfNeeded()
        updateContentHeight()
        setupButtonAreaLayout(hasCancelButton: hasCancelButton, hasOtherButton: hasOtherButton)
    }

    /// 根据内容尺寸动态计算弹窗高度（最大为屏幕 2/3）
    private func updateContentHeight() {
        // 计算正文可用宽度（首次 layout 前 frame 可能为 0，用弹窗宽度兜底）
        var contentWidth = scrollView.frame.width
        if contentWidth == 0 {
            contentWidth = width - contentLeftRightPadding * 2
        }

        // 测量标题高度，判断是否有有效标题
        let titleSize = titleLabel.sizeThatFits(CGSize(width: contentWidth, height: .greatestFiniteMagnitude))
        let titleHeight = titleSize.height
        let hasTitle = !(title?.isEmpty ?? true) && titleHeight > 0

        // 无标题时，scrollView 直接贴顶，不使用 titleBottomPadding
        if !hasTitle {
            scrollViewTopConstraint?.isActive = false
            scrollViewTopConstraint = scrollView.topAnchor.constraint(equalTo: topAnchor, constant: titleTopPadding)
            scrollViewTopConstraint?.isActive = true
        }

        // 测量正文高度
        let contentSize = contentLabel.sizeThatFits(CGSize(width: contentWidth, height: .greatestFiniteMagnitude))
        let contentHeight = contentSize.height

        // 弹窗总高度上限：屏幕高度的 2/3
        let screenH = UIScreen.main.bounds.height
        let maxTotalHeight = screenH * 2.0 / 3.0

        // 无标题时不计入 titleBottomPadding
        let actualTitleBottomPadding = hasTitle ? titleBottomPadding : 0
        // 总高度 = 标题区 + 正文区 + 按钮区
        let totalHeight = titleTopPadding + titleHeight + actualTitleBottomPadding + contentHeight + buttonTopPadding + buttonHeight + buttonBottomPadding

        if totalHeight > maxTotalHeight {
            // 内容超出：弹窗高度锁定为 maxTotalHeight，scrollView 启用滚动
            scrollView.isScrollEnabled = true
            // 剩余空间全部给 scrollView
            let availableScrollHeight = maxTotalHeight - titleTopPadding - titleHeight - actualTitleBottomPadding - buttonTopPadding - buttonHeight
            scrollHeightConstraint?.constant = availableScrollHeight
            heightConstraint?.constant = maxTotalHeight
        } else if totalHeight < height {
            // 内容偏少：弹窗保持默认 height，不出现大量空白滚动
            scrollView.isScrollEnabled = false
            let availableScrollHeight = height - titleTopPadding - titleHeight - actualTitleBottomPadding - buttonTopPadding - buttonHeight
            // scrollView 高度取内容高度与可用空间的较小值
            scrollHeightConstraint?.constant = min(contentHeight, availableScrollHeight)
            heightConstraint?.constant = height
        } else {
            // 内容适中：弹窗高度随内容自适应，scrollView 高度等于正文高度
            scrollView.isScrollEnabled = false
            scrollHeightConstraint?.constant = contentHeight
            heightConstraint?.constant = totalHeight
        }

        layoutIfNeeded()
        updateShadowLayers()
    }

    /// 按钮区域与分隔线布局
    private func setupButtonAreaLayout(hasCancelButton: Bool, hasOtherButton: Bool) {
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonLeftRightPadding),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -buttonLeftRightPadding),
            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -buttonBottomPadding),
            buttonStackView.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])

        let onePixel = 1.0 / UIScreen.main.scale

        if buttonSpacing <= 0 {
            // 有按钮时，添加按钮上方 1 像素水平线
            if hasCancelButton || hasOtherButton {
                NSLayoutConstraint.activate([
                    horizontalSeparator.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor),
                    horizontalSeparator.heightAnchor.constraint(equalToConstant: onePixel),
                    horizontalSeparator.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor),
                    horizontalSeparator.centerXAnchor.constraint(equalTo: buttonStackView.centerXAnchor)
                ])
            }

            // 双按钮时，添加中间 1 像素垂直线
            if hasCancelButton && hasOtherButton {
                NSLayoutConstraint.activate([
                    verticalSeparator.widthAnchor.constraint(equalToConstant: onePixel),
                    verticalSeparator.heightAnchor.constraint(equalTo: buttonStackView.heightAnchor),
                    verticalSeparator.centerYAnchor.constraint(equalTo: buttonStackView.centerYAnchor),
                    verticalSeparator.centerXAnchor.constraint(equalTo: buttonStackView.centerXAnchor)
                ])
            }
        }
    }

    // MARK: - 滚动阴影

    /// 创建顶部和底部渐变阴影层
    func setupShadowLayers() {
        let backgroundColor = self.backgroundColor ?? .white

        if topShadowLayer == nil {
            let layer = CAGradientLayer()
            layer.colors = [
                backgroundColor.withAlphaComponent(1.0).cgColor,
                backgroundColor.withAlphaComponent(0.0).cgColor
            ]
            layer.startPoint = CGPoint(x: 0.5, y: 0.0)
            layer.endPoint = CGPoint(x: 0.5, y: 1.0)
            layer.opacity = 0
            self.layer.addSublayer(layer)
            topShadowLayer = layer
        } else {
            topShadowLayer?.colors = [
                backgroundColor.withAlphaComponent(1.0).cgColor,
                backgroundColor.withAlphaComponent(0.0).cgColor
            ]
        }

        if bottomShadowLayer == nil {
            let layer = CAGradientLayer()
            layer.colors = [
                backgroundColor.withAlphaComponent(0.0).cgColor,
                backgroundColor.withAlphaComponent(1.0).cgColor
            ]
            layer.startPoint = CGPoint(x: 0.5, y: 0.0)
            layer.endPoint = CGPoint(x: 0.5, y: 1.0)
            layer.opacity = 0
            self.layer.addSublayer(layer)
            bottomShadowLayer = layer
        } else {
            bottomShadowLayer?.colors = [
                backgroundColor.withAlphaComponent(0.0).cgColor,
                backgroundColor.withAlphaComponent(1.0).cgColor
            ]
        }
    }

    /// 根据滚动位置更新阴影层 frame 与透明度
    func updateShadowLayers() {
        guard scrollView.superview != nil else { return }

        let backgroundColor = self.backgroundColor ?? .white
        if let topLayer = topShadowLayer, topLayer.colors?.count ?? 0 >= 2 {
            topLayer.colors = [
                backgroundColor.withAlphaComponent(1.0).cgColor,
                backgroundColor.withAlphaComponent(0.0).cgColor
            ]
        }
        if let bottomLayer = bottomShadowLayer, bottomLayer.colors?.count ?? 0 >= 2 {
            bottomLayer.colors = [
                backgroundColor.withAlphaComponent(0.0).cgColor,
                backgroundColor.withAlphaComponent(1.0).cgColor
            ]
        }

        // 内容不足以滚动时隐藏阴影
        if !scrollView.isScrollEnabled || scrollView.contentSize.height <= scrollView.bounds.height {
            topShadowLayer?.opacity = 0
            bottomShadowLayer?.opacity = 0
            return
        }

        let shadowHeight: CGFloat = 15.0
        let scrollViewFrame = convert(scrollView.frame, from: scrollView.superview)

        topShadowLayer?.frame = CGRect(
            x: scrollViewFrame.origin.x,
            y: scrollViewFrame.origin.y,
            width: scrollViewFrame.width,
            height: shadowHeight
        )

        bottomShadowLayer?.frame = CGRect(
            x: scrollViewFrame.origin.x,
            y: scrollViewFrame.maxY - shadowHeight,
            width: scrollViewFrame.width,
            height: shadowHeight
        )

        let contentOffsetY = scrollView.contentOffset.y
        let maxContentOffsetY = scrollView.contentSize.height - scrollView.bounds.height

        // 顶部阴影：向下滚动时渐显
        if contentOffsetY <= 0 {
            topShadowLayer?.opacity = 0
        } else if contentOffsetY >= maxContentOffsetY {
            topShadowLayer?.opacity = 1.0
        } else {
            let progress = contentOffsetY / maxContentOffsetY
            topShadowLayer?.opacity = Float(min(progress * 2.0, 1.0))
        }

        // 底部阴影：向上滚动时渐显
        if contentOffsetY >= maxContentOffsetY {
            bottomShadowLayer?.opacity = 0
        } else if contentOffsetY <= 0 {
            bottomShadowLayer?.opacity = 1.0
        } else {
            let progress = 1.0 - (contentOffsetY / maxContentOffsetY)
            bottomShadowLayer?.opacity = Float(min(progress * 2.0, 1.0))
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ZHHAlertViewController: UIScrollViewDelegate {

    /// 滚动时同步更新阴影层透明度
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateShadowLayers()
    }
}

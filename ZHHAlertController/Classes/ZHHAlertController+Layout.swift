//
//  ZHHAlertController+Layout.swift
//  ZHHAlertController
//
//  Created by 桃色三岁 on 2022/4/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

import UIKit

extension ZHHAlertController {

    // MARK: - 布局

    /// 构建弹窗内部布局，并根据内容动态调整高度
    func updateAlertLayout() {
        layer.cornerRadius = cornerRadius
        if !isLayoutSetup {
            isLayoutSetup = true
            setupSubviews()
            setupConstraints()
        }

        // 判断按钮显隐
        let hasCancelButton = !(cancelButtonTitle?.isEmpty ?? true)
        let hasOtherButton = !(otherButtonTitle?.isEmpty ?? true)
        let hasButtons = hasCancelButton || hasOtherButton

        buttonStackView.spacing = buttonSpacing
        updateContentVisibility()
        updateButtonAreaVisibility(hasCancelButton: hasCancelButton, hasOtherButton: hasOtherButton)
        updateSeparatorVisibility(hasCancelButton: hasCancelButton, hasOtherButton: hasOtherButton)

        horizontalSeparator.backgroundColor = separatorColor
        verticalSeparator.backgroundColor = separatorColor

        // 自定义内容走独立布局，标准标题+正文走动态高度计算
        if hasCustomContentView {
            setupCustomContentLayout(hasButtons: hasButtons)
        } else {
            setupShadowLayers()
            updateContentHeight(hasCancelButton: hasCancelButton, hasOtherButton: hasOtherButton)
        }
    }

    /// 构建子视图层级
    func setupSubviews() {
        // 视图层级：内容区 + 水平分隔线 + 按钮区
        addSubview(contentContainerView)
        addSubview(horizontalSeparator)
        addSubview(buttonContainerView)

        contentContainerView.addSubview(topSpacerView)
        contentContainerView.addSubview(titleLabel)
        contentContainerView.addSubview(scrollView)
        contentContainerView.addSubview(bottomSpacerView)
        scrollView.delegate = self
        scrollView.addSubview(contentLabel)

        buttonContainerView.addSubview(buttonStackView)
        buttonContainerView.addSubview(verticalSeparator)
    }

    /// 创建并激活布局约束
    func setupConstraints() {
        // 可变高度约束，布局更新时修改 constant
        let onePixel = 1.0 / UIScreen.main.scale
        topSpacerHeightConstraint = topSpacerView.heightAnchor.constraint(equalToConstant: 0)
        scrollHeightConstraint = scrollView.heightAnchor.constraint(equalToConstant: 0)
        separatorHeightConstraint = horizontalSeparator.heightAnchor.constraint(equalToConstant: onePixel)
        buttonAreaHeightConstraint = buttonContainerView.heightAnchor.constraint(equalToConstant: buttonHeight + buttonBottomPadding)
        buttonStackHeightConstraint = buttonStackView.heightAnchor.constraint(equalToConstant: buttonHeight)

        // 正文顶部：有标题时贴标题底部，无标题时贴 topSpacer 底部
        scrollTopToTitleConstraint = scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: titleBottomPadding)
        scrollTopToSpacerConstraint = scrollView.topAnchor.constraint(equalTo: topSpacerView.bottomAnchor)

        NSLayoutConstraint.activate([
            // 内容区底部贴按钮区顶部，水平分隔线叠在交界处
            contentContainerView.topAnchor.constraint(equalTo: topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: buttonContainerView.topAnchor),

            horizontalSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalSeparator.bottomAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            separatorHeightConstraint!,

            buttonContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonAreaHeightConstraint!,

            // topSpacer 撑开内容区顶部留白，bottomSpacer 撑开正文与按钮区间隙
            topSpacerView.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            topSpacerView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            topSpacerView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            topSpacerHeightConstraint!,

            titleLabel.topAnchor.constraint(equalTo: topSpacerView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: contentHorizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -contentHorizontalPadding),

            scrollView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: contentHorizontalPadding),
            scrollView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -contentHorizontalPadding),
            scrollHeightConstraint!,

            bottomSpacerView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            bottomSpacerView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            bottomSpacerView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor),

            contentLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            // 正文宽度与 scrollView 等宽，保证多行换行计算正确
            contentLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // 按钮栈仅约束 top/leading/trailing，高度由 buttonStackHeightConstraint 控制
            buttonStackView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor, constant: buttonHorizontalPadding),
            buttonStackView.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor, constant: -buttonHorizontalPadding),
            buttonStackHeightConstraint!,

            verticalSeparator.widthAnchor.constraint(equalToConstant: onePixel),
            verticalSeparator.heightAnchor.constraint(equalTo: buttonStackView.heightAnchor),
            verticalSeparator.centerYAnchor.constraint(equalTo: buttonStackView.centerYAnchor),
            verticalSeparator.centerXAnchor.constraint(equalTo: buttonStackView.centerXAnchor)
        ])

        // bottomSpacer 默认贴 scrollView 底部，自定义内容时切换为贴 customContentView
        bottomSpacerTopToScrollConstraint = bottomSpacerView.topAnchor.constraint(equalTo: scrollView.bottomAnchor)
        bottomSpacerTopToScrollConstraint?.isActive = true
        scrollTopToTitleConstraint?.isActive = true
    }

    /// 根据标题/正文更新显隐与正文顶部约束
    func updateContentVisibility() {
        guard !hasCustomContentView else {
            titleLabel.isHidden = true
            scrollView.isHidden = true
            return
        }

        let hasTitle = !(title?.isEmpty ?? true)
        let hasContent = !(content?.isEmpty ?? true)
        titleLabel.isHidden = !hasTitle
        scrollView.isHidden = !hasContent

        scrollTopToTitleConstraint?.constant = (hasTitle && hasContent) ? titleBottomPadding : 0
        // 切换正文顶部锚点：有标题挂标题，无标题挂 topSpacer
        if hasTitle {
            scrollTopToTitleConstraint?.isActive = true
            scrollTopToSpacerConstraint?.isActive = false
        } else {
            scrollTopToTitleConstraint?.isActive = false
            scrollTopToSpacerConstraint?.isActive = true
        }
    }

    /// 更新按钮区显隐与高度
    func updateButtonAreaVisibility(hasCancelButton: Bool, hasOtherButton: Bool) {
        let hasButtons = hasCancelButton || hasOtherButton
        buttonContainerView.isHidden = !hasButtons
        buttonAreaHeightConstraint?.constant = hasButtons ? (buttonHeight + buttonBottomPadding) : 0
        buttonStackHeightConstraint?.constant = buttonHeight

        // 双按钮且间距为 0 时显示中间竖线
        let showVerticalSeparator = buttonSpacing <= 0 && hasCancelButton && hasOtherButton
        verticalSeparator.isHidden = !showVerticalSeparator
    }

    /// 更新内容区与按钮区之间的水平分隔线显隐
    func updateSeparatorVisibility(hasCancelButton: Bool, hasOtherButton: Bool) {
        let hasButtons = hasCancelButton || hasOtherButton
        // 有按钮且间距为 0 时显示横线（叠在按钮区顶部，不参与高度计算）
        let showSeparator = buttonSpacing <= 0 && hasButtons
        horizontalSeparator.isHidden = !showSeparator
        separatorHeightConstraint?.constant = showSeparator ? 1.0 / UIScreen.main.scale : 0
    }

    /// 自定义内容视图布局
    func setupCustomContentLayout(hasButtons: Bool) {
        guard let contentView = customContentView else { return }

        titleLabel.isHidden = true
        scrollView.isHidden = true

        let preferredHeight = ceil(max(contentView.frame.height, contentView.bounds.height))

        // 首次添加自定义视图并建立约束
        if contentView.superview !== contentContainerView {
            contentContainerView.addSubview(contentView)
            customContentHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: preferredHeight)
            bottomSpacerTopToCustomConstraint = bottomSpacerView.topAnchor.constraint(equalTo: contentView.bottomAnchor)
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: topSpacerView.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: contentHorizontalPadding),
                contentView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -contentHorizontalPadding),
                customContentHeightConstraint!,
                bottomSpacerTopToCustomConstraint!
            ])
            bottomSpacerTopToScrollConstraint?.isActive = false
        } else {
            // 已添加过则仅更新高度
            customContentHeightConstraint?.constant = preferredHeight
        }

        let buttonZoneHeight = hasButtons ? (buttonHeight + buttonBottomPadding) : 0
        let blockHeight = preferredHeight

        // 自然高度 = 顶距 + 自定义内容 + 正文按钮间距 + 按钮区
        let naturalHeight = titleTopPadding + blockHeight + (hasButtons ? contentButtonSpacing : 0) + buttonZoneHeight
        // 弹窗总高度取自然高度与最小高度的较大值，向上取整避免像素缝
        let alertHeight = ceil(max(naturalHeight, popupHeight))
        // 内容区高度 = 弹窗总高度 - 按钮区高度
        let contentZoneHeight = alertHeight - buttonZoneHeight
        // 计算 topSpacer 高度：内容不足最小高度时垂直居中，否则使用 titleTopPadding
        let topGap = verticalTopGap(contentZoneHeight: contentZoneHeight, blockHeight: blockHeight, hasButtons: hasButtons, useCentering: naturalHeight < popupHeight)
        // 自定义内容无 scrollView，scrollHeight 传 0
        applyContentZoneLayout(topGap: topGap, scrollHeight: 0)
        // 更新弹窗整体高度约束
        heightConstraint?.constant = alertHeight
        layoutIfNeeded()
    }

    /// 根据标题/正文尺寸动态计算弹窗高度（最大为屏幕 2/3）
    func updateContentHeight(hasCancelButton: Bool, hasOtherButton: Bool) {
        let contentWidth = popupWidth - contentHorizontalPadding * 2
        let hasTitle = !(title?.isEmpty ?? true)
        let hasContent = !(content?.isEmpty ?? true)
        let hasButtons = hasCancelButton || hasOtherButton
        let buttonZoneHeight = hasButtons ? (buttonHeight + buttonBottomPadding) : 0

        // 限制多行文本换行宽度后再测量
        titleLabel.preferredMaxLayoutWidth = contentWidth
        contentLabel.preferredMaxLayoutWidth = contentWidth

        let titleHeight = measureTitleHeight(hasTitle: hasTitle, contentWidth: contentWidth)
        let contentHeight = measureContentHeight(hasContent: hasContent, contentWidth: contentWidth)
        let titleContentSpacing = (hasTitle && hasContent) ? titleBottomPadding : 0
        let contentBlockHeight = titleHeight + titleContentSpacing + contentHeight

        // 自然高度 = 顶距 + 标题 + 标题正文间距 + 正文 + 正文按钮间距 + 按钮区
        let naturalHeight = titleTopPadding + contentBlockHeight + (hasButtons ? contentButtonSpacing : 0) + buttonZoneHeight

        // 弹窗总高度上限为屏幕 2/3
        let maxTotalHeight = UIScreen.main.bounds.height * 2.0 / 3.0
        var scrollAreaHeight = contentHeight
        var alertHeight = max(naturalHeight, popupHeight)

        if hasContent && naturalHeight > maxTotalHeight {
            // 超出上限：启用滚动，压缩 scroll 区域高度
            scrollView.isScrollEnabled = true
            // 不可滚动部分高度：顶距 + 标题 + 间距 + 正文按钮间距 + 按钮区
            let fixedWithoutScroll = titleTopPadding + titleHeight + titleContentSpacing + (hasButtons ? contentButtonSpacing : 0) + buttonZoneHeight
            // 剩余空间给 scrollView
            scrollAreaHeight = max(0, maxTotalHeight - fixedWithoutScroll)
            // 弹窗高度锁定为上限
            alertHeight = maxTotalHeight
        } else {
            scrollView.isScrollEnabled = false
            // 未超上限但高于最小高度时，按内容撑开
            if naturalHeight > popupHeight {
                alertHeight = naturalHeight
            }
        }
        alertHeight = ceil(alertHeight)

        // 应用布局：scroll 区域用 scrollAreaHeight（可能被压缩），其余由 spacer 撑开
        let actualBlockHeight = titleHeight + titleContentSpacing + scrollAreaHeight
        // 内容区高度 = 弹窗总高度 - 按钮区高度
        let contentZoneHeight = alertHeight - buttonZoneHeight
        // 计算 topSpacer 高度：内容不足最小高度时垂直居中，否则使用 titleTopPadding
        let topGap = verticalTopGap(contentZoneHeight: contentZoneHeight, blockHeight: actualBlockHeight, hasButtons: hasButtons, useCentering: naturalHeight < popupHeight)

        // 设置 topSpacer 与 scrollView 高度，bottomSpacer 自动填满剩余空间
        applyContentZoneLayout(topGap: topGap, scrollHeight: scrollAreaHeight)
        // 更新弹窗整体高度约束
        heightConstraint?.constant = alertHeight
        layoutIfNeeded()
        updateShadowLayers()
    }

    /// 应用内容区各段高度，bottomSpacer 由底部约束自动撑满至按钮区顶部
    private func applyContentZoneLayout(topGap: CGFloat, scrollHeight: CGFloat) {
        topSpacerHeightConstraint?.constant = ceil(topGap)
        scrollHeightConstraint?.constant = ceil(scrollHeight)
    }

    /// 计算内容区顶部间距（topSpacer 高度）
    /// - Parameters:
    ///   - contentZoneHeight: 内容区总高度（弹窗高度 - 按钮区高度）
    ///   - blockHeight: 标题 + 正文（或自定义内容）实际占用高度
    ///   - hasButtons: 是否有按钮，影响居中时底部间距保护
    ///   - useCentering: 自然高度低于 popupHeight 时为 true，启用垂直居中
    private func verticalTopGap(contentZoneHeight: CGFloat, blockHeight: CGFloat, hasButtons: Bool, useCentering: Bool) -> CGFloat {
        // 内容区剩余可分配高度
        let extra = max(0, contentZoneHeight - blockHeight)

        if useCentering && extra > 0 {
            if hasButtons {
                // 有按钮：居中分配 extra，同时保证顶部 ≥ titleTopPadding、底部 ≥ contentButtonSpacing
                var topGap = extra / 2
                if topGap < titleTopPadding {
                    topGap = titleTopPadding
                }
                if extra - topGap < contentButtonSpacing {
                    topGap = max(0, extra - contentButtonSpacing)
                }
                return topGap
            }
            // 无按钮：剩余高度均分上下
            return extra / 2
        }

        // 不需要居中：顶部固定使用 titleTopPadding
        return titleTopPadding
    }

    /// 测量标题高度，无标题时约束高度为 0
    private func measureTitleHeight(hasTitle: Bool, contentWidth: CGFloat) -> CGFloat {
        guard hasTitle else {
            if let constraint = titleHeightConstraint {
                constraint.constant = 0
            } else {
                let constraint = titleLabel.heightAnchor.constraint(equalToConstant: 0)
                constraint.isActive = true
                titleHeightConstraint = constraint
            }
            return 0
        }

        let measured = ceil(titleLabel.sizeThatFits(CGSize(width: contentWidth, height: .greatestFiniteMagnitude)).height)
        if let constraint = titleHeightConstraint {
            constraint.constant = measured
        } else {
            let constraint = titleLabel.heightAnchor.constraint(equalToConstant: measured)
            constraint.isActive = true
            titleHeightConstraint = constraint
        }
        return measured
    }

    /// 测量正文高度，无正文时返回 0
    private func measureContentHeight(hasContent: Bool, contentWidth: CGFloat) -> CGFloat {
        guard hasContent else { return 0 }
        return ceil(contentLabel.sizeThatFits(CGSize(width: contentWidth, height: .greatestFiniteMagnitude)).height)
    }

    // MARK: - 滚动阴影

    /// 创建正文滚动区顶部/底部渐变阴影层（提示可继续滚动）
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
        guard scrollView.superview != nil, !scrollView.isHidden else { return }

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

        // 不可滚动时隐藏阴影
        if !scrollView.isScrollEnabled || scrollView.contentSize.height <= scrollView.bounds.height {
            topShadowLayer?.opacity = 0
            bottomShadowLayer?.opacity = 0
            return
        }

        let shadowHeight: CGFloat = 15.0
        // 阴影层加在弹窗 layer 上，需转换 scrollView 坐标
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

        // 顶部阴影：未滚动时隐藏，滚到底部时全显，中间按比例渐变
        if contentOffsetY <= 0 {
            topShadowLayer?.opacity = 0
        } else if contentOffsetY >= maxContentOffsetY {
            topShadowLayer?.opacity = 1.0
        } else {
            let progress = contentOffsetY / maxContentOffsetY
            topShadowLayer?.opacity = Float(min(progress * 2.0, 1.0))
        }

        // 底部阴影：在顶部时全显，滚到底部时隐藏，中间按比例渐变
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

extension ZHHAlertController: UIScrollViewDelegate {

    /// 滚动时同步更新阴影层透明度
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateShadowLayers()
    }
}

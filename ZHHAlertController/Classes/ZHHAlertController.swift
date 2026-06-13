//
//  ZHHAlertController.swift
//  ZHHAlertController
//
//  Created by 桃色三岁 on 2022/4/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

import UIKit

/// 按钮点击回调
public typealias ZHHAlertControllerBlock = () -> Void

// MARK: - 代理协议

/// 弹窗生命周期与按钮点击代理
public protocol ZHHAlertControllerDelegate: AnyObject {
    /// 弹窗即将显示
    func alertViewWillAppear(_ alertView: ZHHAlertController)
    /// 弹窗已经显示
    func alertViewDidAppear(_ alertView: ZHHAlertController)
    /// 用户点击了取消按钮
    func alertViewDidClickCancelButton(_ alertView: ZHHAlertController)
    /// 用户点击了其他按钮
    func alertViewDidClickOtherButton(_ alertView: ZHHAlertController)
}

/// 代理方法默认空实现，调用方可按需实现
public extension ZHHAlertControllerDelegate {
    /// 弹窗即将显示
    func alertViewWillAppear(_ alertView: ZHHAlertController) {}
    /// 弹窗已经显示
    func alertViewDidAppear(_ alertView: ZHHAlertController) {}
    /// 用户点击了取消按钮
    func alertViewDidClickCancelButton(_ alertView: ZHHAlertController) {}
    /// 用户点击了其他按钮
    func alertViewDidClickOtherButton(_ alertView: ZHHAlertController) {}
}

// MARK: - 主类

/// 自定义 Alert 弹窗视图（继承 UIView，非 UIViewController）
public class ZHHAlertController: UIView {

    // MARK: 视图相关属性

    /// 自定义内容视图，设置后替换默认的标题 + 正文布局
    public var customContentView: UIView? {
        didSet {
            guard let contentView = customContentView else { return }
            hasCustomContentView = true
            // 弹窗尺寸 = 内容高度 + 按钮区域高度
            popupWidth = contentView.frame.size.width
            popupHeight = contentView.frame.size.height + buttonHeight + contentButtonSpacing + buttonBottomPadding
            contentView.translatesAutoresizingMaskIntoConstraints = false
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: popupWidth, height: popupHeight)
        }
    }

    /// 标题标签，默认粗体 17pt、居中、黑色
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// 正文标签，默认 15pt、居中、灰色，支持多行
    public lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .gray
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// 取消按钮，默认系统蓝色文字
    public lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1.0, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setBackgroundImage(Self.image(with: Self.highlightBackgroundColor), for: .highlighted)
        button.addTarget(self, action: #selector(cancelButtonClicked(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /// 其他按钮，默认系统蓝色文字
    public lazy var otherButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1.0, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setBackgroundImage(Self.image(with: Self.highlightBackgroundColor), for: .highlighted)
        button.addTarget(self, action: #selector(otherButtonClicked(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: 布局相关属性

    /// 标题距顶部间距
    public var titleTopPadding: CGFloat = 15.0
    /// 标题与正文间距
    public var titleBottomPadding: CGFloat = 10.0
    /// 标题和正文水平内边距
    public var contentHorizontalPadding: CGFloat = 20.0
    /// 正文与按钮区间距
    public var contentButtonSpacing: CGFloat = 15.0
    /// 按钮距底部间距
    public var buttonBottomPadding: CGFloat = 0.0
    /// 按钮区域水平内边距
    public var buttonHorizontalPadding: CGFloat = 0.0
    /// 多按钮水平间距（为 0 时显示分隔线）
    public var buttonSpacing: CGFloat = 0.0
    /// 按钮高度
    public var buttonHeight: CGFloat = 44.0
    /// 弹窗宽度
    public var popupWidth: CGFloat = 284.0
    /// 弹窗最小高度
    public var popupHeight: CGFloat = 135.0
    /// 弹窗圆角
    public var cornerRadius: CGFloat = 8.0

    // MARK: 文字内容相关属性

    /// 标题文本
    public var title: String?
    /// 正文文本
    public var content: String?

    // MARK: 按钮文字相关属性

    /// 取消按钮文字，为空则不显示
    public var cancelButtonTitle: String?
    /// 其他按钮文字，为空则不显示
    public var otherButtonTitle: String?

    // MARK: 样式配置相关

    /// 按钮区分隔线颜色
    public var separatorColor: UIColor = .separator

    // MARK: 动画配置

    /// 展示动画类型
    public var presentationStyle: ZHHAlertAnimationStyle = .transform
    /// 消失动画类型，为 nil 时沿用 presentationStyle
    public var dismissalStyle: ZHHAlertAnimationStyle?
    /// transform 展示动画起始缩放
    public var presentationTransformScale: CGFloat = 0.5
    /// transform 消失动画结束缩放
    public var dismissalTransformScale: CGFloat = 0.5
    public var fadeInDuration: TimeInterval = 0.2  /// 淡入时长
    public var fadeOutDuration: TimeInterval = 0.1 /// 淡出时长

    // MARK: 行为配置

    /// 取消按钮是否显示在右侧
    public var cancelButtonPositionRight: Bool = false
    /// 点击按钮是否高亮
    public var shouldHighlightButtonOnClick: Bool = true
    /// 点击其他按钮是否自动关闭
    public var shouldDismissOnActionButtonClicked: Bool = true
    /// 点击外部遮罩是否关闭
    public var shouldDismissOnOutsideTapped: Bool = false

    // MARK: 背景遮罩配置

    /// show() 时是否显示背景遮罩
    public var shouldDimBackgroundWhenShowInWindow: Bool = true
    /// show(in:) 时是否显示背景遮罩
    public var shouldDimBackgroundWhenShowInView: Bool = false
    /// 遮罩透明度
    public var dimAlpha: CGFloat = 0.4

    // MARK: 事件处理相关

    public weak var delegate: ZHHAlertControllerDelegate?
    public var cancelButtonAction: ZHHAlertControllerBlock?
    public var otherButtonAction: ZHHAlertControllerBlock?

    // MARK: 内部状态（供 extension 文件访问）

    /// 是否使用了自定义内容视图
    var hasCustomContentView = false
    /// 弹窗是否正在显示
    var isShowing = false
    /// 内部 StackView 布局是否已构建
    var isLayoutSetup = false

    /// 内容区容器（标题 + 正文，不含按钮）
    lazy var contentContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// 内容区顶部弹性间距
    lazy var topSpacerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// 内容区底部弹性间距
    lazy var bottomSpacerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// 按钮区外层容器，用于左右内边距
    lazy var buttonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// 按钮容器，水平均分排列
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    /// 按钮上方水平分隔线
    lazy var horizontalSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// 双按钮中间垂直分隔线
    lazy var verticalSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// 背景半透明遮罩视图
    var backgroundDimView: UIView?

    /// 正文滚动容器，内容过长时可滚动
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = .zero
        scrollView.backgroundColor = .clear
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    /// 滚动区域顶部渐变阴影
    var topShadowLayer: CAGradientLayer?
    /// 滚动区域底部渐变阴影
    var bottomShadowLayer: CAGradientLayer?

    /// 弹窗自身宽度约束
    var widthConstraint: NSLayoutConstraint?
    /// 弹窗自身高度约束
    var heightConstraint: NSLayoutConstraint?
    /// 标题高度约束（动态更新）
    var titleHeightConstraint: NSLayoutConstraint?
    /// 正文顶部约束（有标题 / 无标题二选一）
    var scrollTopToTitleConstraint: NSLayoutConstraint?
    var scrollTopToSpacerConstraint: NSLayoutConstraint?
    /// scrollView 高度约束（动态更新）
    var scrollHeightConstraint: NSLayoutConstraint?
    /// 内容区顶部/底部间距约束
    var topSpacerHeightConstraint: NSLayoutConstraint?
    /// 自定义内容区高度约束
    var customContentHeightConstraint: NSLayoutConstraint?
    /// bottomSpacer 顶部锚点（正文滚动区 / 自定义内容区二选一）
    var bottomSpacerTopToScrollConstraint: NSLayoutConstraint?
    var bottomSpacerTopToCustomConstraint: NSLayoutConstraint?
    /// 按钮区高度约束
    var buttonAreaHeightConstraint: NSLayoutConstraint?
    /// 按钮栈高度约束
    var buttonStackHeightConstraint: NSLayoutConstraint?
    /// 分隔线高度约束
    var separatorHeightConstraint: NSLayoutConstraint?
    /// 弹窗水平居中约束
    var centerXConstraint: NSLayoutConstraint?
    /// 弹窗垂直居中约束
    var centerYConstraint: NSLayoutConstraint?

    /// 按钮高亮背景色 #F3F3F3
    static let highlightBackgroundColor = UIColor(red: 0xF3 / 255.0, green: 0xF3 / 255.0, blue: 0xF3 / 255.0, alpha: 1.0)

    // MARK: - 初始化

    public override init(frame: CGRect) {
        super.init(frame: frame)
        if frame != .zero {
            popupWidth = frame.size.width
            popupHeight = frame.size.height
        }
        configureDefaultAppearance()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureDefaultAppearance()
    }

    public convenience init() {
        self.init(frame: .zero)
    }

    /// 配置默认外观
    private func configureDefaultAppearance() {
        backgroundColor = .white
        clipsToBounds = true
        insetsLayoutMarginsFromSafeArea = false
    }

    /// 供 #selector 引用，实际逻辑在 +Show extension
    @objc func cancelButtonClicked(_ sender: Any) {
        handleCancelButtonClick()
    }

    /// 供 #selector 引用，实际逻辑在 +Show extension
    @objc func otherButtonClicked(_ sender: Any) {
        handleOtherButtonClick()
    }

    /// 根据纯色生成 1x1 背景图，用于按钮 .highlighted 态
    static func image(with color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }
}

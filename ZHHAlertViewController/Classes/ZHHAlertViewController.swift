//
//  ZHHAlertViewController.swift
//  ZHHAlertViewController
//
//  Created by 桃色三岁 on 2022/4/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

import UIKit

// MARK: - 动画类型

/// 弹窗出现/消失动画类型
public enum ZHHAlertViewAnimationType: Int {
    /// 无动画
    case none = 0
    /// 缩放 + 渐显/渐隐
    case `default` = 1
}

/// 按钮点击回调
public typealias ZHHAlertViewControllerBlock = () -> Void

// MARK: - 代理协议

/// 弹窗生命周期与按钮点击代理
public protocol ZHHAlertViewControllerDelegate: AnyObject {
    /// 弹窗即将显示
    func alertViewWillAppear(_ alertView: ZHHAlertViewController)
    /// 弹窗已经显示
    func alertViewDidAppear(_ alertView: ZHHAlertViewController)
    /// 用户点击了取消按钮
    func alertViewDidClickCancelButton(_ alertView: ZHHAlertViewController)
    /// 用户点击了其他按钮
    func alertViewDidClickOtherButton(_ alertView: ZHHAlertViewController)
}

/// 代理方法默认空实现，调用方可按需实现
public extension ZHHAlertViewControllerDelegate {
    /// 弹窗即将显示
    func alertViewWillAppear(_ alertView: ZHHAlertViewController) {}
    /// 弹窗已经显示
    func alertViewDidAppear(_ alertView: ZHHAlertViewController) {}
    /// 用户点击了取消按钮
    func alertViewDidClickCancelButton(_ alertView: ZHHAlertViewController) {}
    /// 用户点击了其他按钮
    func alertViewDidClickOtherButton(_ alertView: ZHHAlertViewController) {}
}

// MARK: - 主类

/// 自定义 Alert 弹窗视图（继承 UIView，非 UIViewController）
public class ZHHAlertViewController: UIView {

    // MARK: 视图相关属性

    /// 自定义内容视图，设置后替换默认的标题 + 正文布局
    public var customContentView: UIView? {
        didSet {
            guard let contentView = customContentView else { return }
            hasCustomContentView = true
            // 弹窗尺寸 = 内容高度 + 按钮区域高度
            width = contentView.frame.size.width
            height = contentView.frame.size.height + buttonHeight + buttonTopPadding + buttonBottomPadding
            contentView.frame = contentView.bounds
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
            addSubview(contentView)
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
    /// 标题和正文左右内边距
    public var contentLeftRightPadding: CGFloat = 20.0
    /// 按钮区域距正文底部间距
    public var buttonTopPadding: CGFloat = 0.0
    /// 按钮距底部间距
    public var buttonBottomPadding: CGFloat = 0.0
    /// 按钮区域左右内边距
    public var buttonLeftRightPadding: CGFloat = 0.0
    /// 多按钮水平间距（为 0 时显示分隔线）
    public var buttonSpacing: CGFloat = 0.0
    /// 按钮高度
    public var buttonHeight: CGFloat = 44.0
    /// 弹窗宽度
    public var width: CGFloat = 284.0
    /// 弹窗默认高度
    public var height: CGFloat = 135.0
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

    /// 出现动画类型
    public var appearAnimationType: ZHHAlertViewAnimationType = .default
    /// 消失动画类型
    public var disappearAnimationType: ZHHAlertViewAnimationType = .default
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

    public weak var delegate: ZHHAlertViewControllerDelegate?
    public var cancelButtonAction: ZHHAlertViewControllerBlock?
    public var otherButtonAction: ZHHAlertViewControllerBlock?

    // MARK: 内部状态（供 extension 文件访问）

    /// 是否使用了自定义内容视图
    var hasCustomContentView = false
    /// 弹窗是否正在显示
    var isShowing = false

    /// 内容容器，包裹标题和 scrollView
    lazy var containerView: UIView = {
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
    /// scrollView 高度约束（动态更新）
    var scrollHeightConstraint: NSLayoutConstraint?
    /// scrollView 顶部约束（有/无标题时切换）
    var scrollViewTopConstraint: NSLayoutConstraint?
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
            width = frame.size.width
            height = frame.size.height
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

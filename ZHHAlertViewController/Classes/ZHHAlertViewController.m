//
//  ZHHAlertViewController.m
//  ZHHAlertViewController
//
//  Created by 桃色三岁 on 2022/4/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHAlertViewController.h"

@interface ZHHAlertViewController () <UIScrollViewDelegate> {
    // 状态标识
    BOOL hasCustomContentView; ///< 是否自定义设置了 contentView
}

// 弹窗容器视图（包含 titleLabel, scrollView 等内容）
@property (nonatomic, strong) UIView *containerView;

// 按钮视图
@property (nonatomic, strong) UIStackView *buttonStackView; ///< 按钮容器（使用 UIStackView 实现）
@property (nonatomic, strong) UIView *horizontalSeparator;  ///< 水平分隔线（按钮上方）
@property (nonatomic, strong) UIView *verticalSeparator;    ///< 垂直分隔线（按钮中间）

// 背景遮罩（非模糊，黑色透明背景）
@property (nonatomic, strong) UIView *backgroundDimView;

// 内容滚动视图
@property (nonatomic, strong, readwrite) UIScrollView *scrollView;

// 滚动阴影层
@property (nonatomic, strong) CAGradientLayer *topShadowLayer;      ///< 顶部阴影渐变层
@property (nonatomic, strong) CAGradientLayer *bottomShadowLayer;   ///< 底部阴影渐变层

@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;   ///< 自身宽度约束
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;  ///< 自身高度约束
@property (nonatomic, strong) NSLayoutConstraint *scrollHeightConstraint;  ///< content内容高度约束
@property (nonatomic, strong) NSLayoutConstraint *scrollViewTopConstraint; ///< scrollView 顶部约束
@property (nonatomic, strong) NSLayoutConstraint *centerXConstraint; ///< 水平居中约束
@property (nonatomic, strong) NSLayoutConstraint *centerYConstraint; ///< 垂直居中约束
@property (nonatomic, assign) BOOL isShowing; ///< 是否正在显示

@end

@implementation ZHHAlertViewController

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.width = 284.0;  // 弹窗宽度，默认 284
        self.height = 135.0; // 弹窗高度，默认 135
        [self configureDefaultAppearance];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.width = frame.size.width;
        self.height = frame.size.height;
        [self configureDefaultAppearance];
    }
    return self;
}

#pragma mark - 配置默认外观

- (void)configureDefaultAppearance {
    
    /// 布局配置
    self.titleTopPadding = 15.0;          // 标题距顶部，默认 15
    self.titleBottomPadding = 10.0;       // 标题与内容之间垂直间距，默认 10
    self.contentLeftRightPadding = 20.0;  // 标题和内容左右内边距，默认 20
    self.buttonTopPadding = 0.0;          // 按钮上边距，默认 0
    self.buttonBottomPadding = 0.0;       // 按钮距底部，默认 0
    self.buttonLeftRightPadding = 0.0;    // 按钮左右内边距，默认 0
    self.buttonSpacing = 0.0;             // 多按钮水平间距，默认 0
    self.buttonHeight = 44.0;             // 按钮高度，默认 44

    /// 外观配置
    self.cornerRadius = 8.0;              // 圆角半径，默认 8
    self.backgroundColor = UIColor.whiteColor;
    self.separatorColor = UIColor.separatorColor; // 分隔线颜色，默认系统色
    
    /// 动画配置
    self.appearAnimationType = ZHHAlertViewAnimationTypeDefault;
    self.disappearAnimationType = ZHHAlertViewAnimationTypeDefault;
    self.appearTime = 0.2;                // 弹出动画时长，默认 0.2
    self.disappearTime = 0.1;             // 消失动画时长，默认 0.1

    /// 行为配置
    self.shouldHighlightButtonOnClick = YES;            // 点击按钮是否高亮，默认 YES
    self.shouldDismissOnActionButtonClicked = YES;      // 点击按钮是否关闭弹窗，默认 YES
    self.cancelButtonPositionRight = NO;                // 取消按钮是否在右侧，默认 NO
    self.shouldDismissOnOutsideTapped = NO;             // 点击外部是否关闭，默认 NO

    /// 背景配置
    self.shouldDimBackgroundWhenShowInWindow = YES;     // 弹窗在 window 时背景变暗，默认 YES
    self.shouldDimBackgroundWhenShowInView = NO;        // 是否在视图中禁用模糊背景，默认 NO
    self.dimAlpha = 0.4;                                // 背景遮罩透明度，默认 0.4

    /// 基础属性
    self.clipsToBounds = YES;
}

#pragma mark - 设置 Alert View

- (void)setCustomContentView:(UIView *)contentView {
    _customContentView = contentView;
    hasCustomContentView = YES;
    
    // 设置宽高
    self.width = contentView.frame.size.width;
    self.height = contentView.frame.size.height + self.buttonHeight + self.buttonTopPadding + self.buttonBottomPadding;
    
    // 设置 contentView 的 frame 并添加到 self 中
    contentView.frame = contentView.bounds;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.width, self.height);
    [self addSubview:contentView];
}

- (void)setupViews {
    self.layer.cornerRadius = self.cornerRadius;
    
    // 避免重复添加子视图
    if (!self.buttonStackView.superview) {
        [self addSubview:self.buttonStackView];
    }
    
    BOOL hasCancelButton = (self.cancelButtonTitle.length > 0);
    BOOL hasOtherButton = (self.otherButtonTitle.length > 0);
    
    if (self.buttonSpacing <= 0 && (hasCancelButton || hasOtherButton)) {
        if (!self.horizontalSeparator.superview) {
            [self addSubview:self.horizontalSeparator];
        }
    }
    
    if (self.buttonSpacing <= 0 && hasCancelButton && hasOtherButton) {
        if (!self.verticalSeparator.superview) {
            [self addSubview:self.verticalSeparator];
        }
    }

    // 设置分割线颜色
    UIColor *sepColor = self.separatorColor ?: [UIColor separatorColor];
    self.horizontalSeparator.backgroundColor = sepColor;
    self.verticalSeparator.backgroundColor = sepColor;

    // 如果是自定义视图则不添加以下子视图
    if (!hasCustomContentView) {
        
        // 避免重复添加基础子视图
        if (!self.containerView.superview) {
            [self addSubview:self.containerView];
        }
        if (!self.titleLabel.superview) {
            [self.containerView addSubview:self.titleLabel];
        }
        if (!self.scrollView.superview) {
            [self.containerView addSubview:self.scrollView];
        }
        if (!self.contentLabel.superview) {
            [self.scrollView addSubview:self.contentLabel];
        }
        
        // 设置阴影层
        [self setupShadowLayers];

        self.scrollHeightConstraint = [self.scrollView.heightAnchor constraintEqualToConstant:100];
        
        // 创建 scrollView 的顶部约束（将在布局后根据是否有标题动态调整）
        self.scrollViewTopConstraint = [self.scrollView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:self.titleBottomPadding];
        
        [NSLayoutConstraint activateConstraints:@[
            // containerView 约束
            [self.containerView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0],
            [self.containerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:self.contentLeftRightPadding],
            [self.containerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-self.contentLeftRightPadding],
            [self.containerView.bottomAnchor constraintEqualToAnchor:self.buttonStackView.topAnchor constant:-0],
            
            // titleLabel 约束
            [self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:self.titleTopPadding],
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:self.contentLeftRightPadding],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-self.contentLeftRightPadding],
            
            // scrollView 约束（顶部约束将根据是否有标题动态调整）
            self.scrollViewTopConstraint,
            [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:self.contentLeftRightPadding],
            [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-self.contentLeftRightPadding],
            self.scrollHeightConstraint,
            
            // contentLabel 约束（填充 scrollView）
            [self.contentLabel.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
            [self.contentLabel.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
            [self.contentLabel.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
            [self.contentLabel.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
            [self.contentLabel.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor]
        ]];
        
        // 布局后更新 scrollView 高度 & 背景高度
        [self layoutIfNeeded];
        CGFloat contentWidth = CGRectGetWidth(self.scrollView.frame);
        if (contentWidth == 0) contentWidth = self.width - self.contentLeftRightPadding * 2;

        CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        CGFloat titleHeight = titleSize.height;
        BOOL hasTitle = (self.title.length > 0 && titleHeight > 0);
        
        // 如果标题为空，调整 scrollView 的顶部约束，使其直接贴顶（使用 titleTopPadding 作为内容的顶部间距）
        if (!hasTitle) {
            [self.scrollViewTopConstraint setActive:NO];
            self.scrollViewTopConstraint = [self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor constant:self.titleTopPadding];
            [self.scrollViewTopConstraint setActive:YES];
        }
        
        CGSize contentSize = [self.contentLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        CGFloat contentHeight = contentSize.height;

        CGFloat screenH = UIScreen.mainScreen.bounds.size.height;
        CGFloat maxTotalHeight = screenH * 2.0 / 3.0; // 屏幕三分之二高度
        
        // 如果标题为空，不应用 titleBottomPadding，且 titleHeight 为 0
        CGFloat actualTitleBottomPadding = hasTitle ? self.titleBottomPadding : 0;
        CGFloat totalHeight = self.titleTopPadding + titleHeight + actualTitleBottomPadding + contentHeight + self.buttonTopPadding + self.buttonHeight + self.buttonBottomPadding;

        BOOL contentTooLarge = totalHeight > maxTotalHeight;
        BOOL contentTooSmall = totalHeight < self.height;

        if (contentTooLarge) {
            // 内容太大，限制最大高度，scrollView 启动滚动
            self.scrollView.scrollEnabled = YES;
            CGFloat availableScrollHeight = maxTotalHeight - self.titleTopPadding - titleHeight - actualTitleBottomPadding - self.buttonTopPadding - self.buttonHeight;
            self.scrollHeightConstraint.constant = availableScrollHeight;

            self.heightConstraint.constant = maxTotalHeight;
        } else if (contentTooSmall) {
            self.scrollView.scrollEnabled = NO;
            CGFloat availableScrollHeight = self.height - self.titleTopPadding - titleHeight - actualTitleBottomPadding - self.buttonTopPadding - self.buttonHeight;

            if (contentHeight < availableScrollHeight) {
                self.scrollHeightConstraint.constant = contentHeight;
            } else {
                self.scrollHeightConstraint.constant = availableScrollHeight;
            }

            self.heightConstraint.constant = self.height;
        } else {
            // 内容合适，scrollView 高度为 contentHeight
            self.scrollView.scrollEnabled = NO;
            self.scrollHeightConstraint.constant = contentHeight;
            
            self.heightConstraint.constant = totalHeight;
        }
        
        // 布局完成后，更新阴影层的位置和显示状态
        [self layoutIfNeeded];
        [self updateShadowLayers];
    }
        
    // buttonStackView 约束
    [NSLayoutConstraint activateConstraints:@[
        [self.buttonStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:self.buttonLeftRightPadding],
        [self.buttonStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-self.buttonLeftRightPadding],
        [self.buttonStackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-self.buttonBottomPadding],
        // 添加默认高度约束
        [self.buttonStackView.heightAnchor constraintEqualToConstant:self.buttonHeight]
    ]];
    
    // 获取 1 像素高度（根据屏幕 scale 自适应）
    CGFloat onePixel = 1.0 / [UIScreen mainScreen].scale;

    // 当按钮间距为 0 或小于 0 时，需要添加分隔线来分隔按钮区域
    if (self.buttonSpacing <= 0) {
        // 如果有至少一个按钮，添加水平分隔线（位于按钮上方）
        if (hasCancelButton || hasOtherButton) {
            // horizontalSeparator 约束（重写为与 buttonStackView 对齐，保证“1像素线”效果）
            [NSLayoutConstraint activateConstraints:@[
                // 宽度与 buttonStackView 一致
                [self.horizontalSeparator.widthAnchor constraintEqualToAnchor:self.buttonStackView.widthAnchor],
                // 高度为 1 像素
                [self.horizontalSeparator.heightAnchor constraintEqualToConstant:onePixel],
                // 底部对齐到 buttonStackView 顶部
                [self.horizontalSeparator.bottomAnchor constraintEqualToAnchor:self.buttonStackView.topAnchor],
                // 水平居中对齐 buttonStackView
                [self.horizontalSeparator.centerXAnchor constraintEqualToAnchor:self.buttonStackView.centerXAnchor]
            ]];
        }
        
        // 如果同时有两个按钮，添加垂直分隔线（位于两个按钮中间）
        if (hasCancelButton && hasOtherButton) {
            // verticalSeparator 约束（位于 buttonStackView 中间，保证“1像素线”效果）
            [NSLayoutConstraint activateConstraints:@[
                // 宽度为 1 像素
                [self.verticalSeparator.widthAnchor constraintEqualToConstant:onePixel],
                // 高度等于 buttonStackView 高度
                [self.verticalSeparator.heightAnchor constraintEqualToAnchor:self.buttonStackView.heightAnchor],
                // 垂直居中对齐 buttonStackView
                [self.verticalSeparator.centerYAnchor constraintEqualToAnchor:self.buttonStackView.centerYAnchor],
                // 水平居中对齐 buttonStackView
                [self.verticalSeparator.centerXAnchor constraintEqualToAnchor:self.buttonStackView.centerXAnchor]
            ]];
        }
    }
}

#pragma mark - Public Show Methods

/// 显示弹窗（默认显示在 keyWindow 中）
- (void)show {
    UIWindow *window = [self keyWindow];
    if (!window) {
        NSLog(@"⚠️ [ZHHAlertViewController] show: 无法获取 keyWindow");
        return;
    }
    
    // 检查是否需要在窗口中显示背景遮罩（背景变暗效果）
    if (self.shouldDimBackgroundWhenShowInWindow) {
        [self addBackgroundDimViewToView:window];
    }
    
    // 调用核心显示逻辑，显示到 keyWindow 中
    [self showInView:window];
}

/// 显示弹窗到指定视图中
/// @param view 目标父视图
- (void)showInView:(UIView *)view {
    // 空值检查
    if (!view) {
        NSLog(@"⚠️ [ZHHAlertViewController] showInView: view 不能为 nil");
        return;
    }
    
    // 如果已经显示，先移除旧的约束和视图
    if (self.isShowing) {
        [self removeFromSuperview];
        if (self.backgroundDimView) {
            [self.backgroundDimView removeFromSuperview];
            self.backgroundDimView = nil;
        }
        // 移除旧的约束
        if (self.widthConstraint) {
            [self.widthConstraint setActive:NO];
        }
        if (self.heightConstraint) {
            [self.heightConstraint setActive:NO];
        }
        if (self.centerXConstraint) {
            [self.centerXConstraint setActive:NO];
        }
        if (self.centerYConstraint) {
            [self.centerYConstraint setActive:NO];
        }
        if (self.scrollViewTopConstraint) {
            [self.scrollViewTopConstraint setActive:NO];
        }
        if (self.scrollHeightConstraint) {
            [self.scrollHeightConstraint setActive:NO];
        }
    }
    
    // 清除按钮容器中的旧按钮（避免重复添加）
    for (UIView *subview in self.buttonStackView.arrangedSubviews) {
        [self.buttonStackView removeArrangedSubview:subview];
        [subview removeFromSuperview];
    }
    
    // 设置标题和内容
    self.titleLabel.text = self.title;
    self.contentLabel.text = self.content;
    
    // 内容更新后，延迟更新阴影层（等待布局完成）
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateShadowLayers];
    });
    
    // 设置按钮容器的间距
    self.buttonStackView.spacing = self.buttonSpacing;
    
    // 根据 cancelButtonPositionRight 决定按钮顺序
    if (self.cancelButtonTitle.length > 0 && self.otherButtonTitle.length > 0) {
        if (self.cancelButtonPositionRight) {
            // 取消按钮在右侧：先添加 otherButton，再添加 cancelButton
            [self.otherButton setTitle:self.otherButtonTitle forState:UIControlStateNormal];
            [self.buttonStackView addArrangedSubview:self.otherButton];
            [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
            [self.buttonStackView addArrangedSubview:self.cancelButton];
        } else {
            // 取消按钮在左侧：先添加 cancelButton，再添加 otherButton
            [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
            [self.buttonStackView addArrangedSubview:self.cancelButton];
            [self.otherButton setTitle:self.otherButtonTitle forState:UIControlStateNormal];
            [self.buttonStackView addArrangedSubview:self.otherButton];
        }
    } else {
        // 只有一个按钮的情况
        if (self.cancelButtonTitle.length > 0) {
            [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
            [self.buttonStackView addArrangedSubview:self.cancelButton];
        }
        if (self.otherButtonTitle.length > 0) {
            [self.otherButton setTitle:self.otherButtonTitle forState:UIControlStateNormal];
            [self.buttonStackView addArrangedSubview:self.otherButton];
        }
    }
    
    // 添加弹窗视图到目标父视图
    [view addSubview:self];

    // 创建约束
    self.widthConstraint  = [self.widthAnchor constraintEqualToConstant:self.width];
    self.heightConstraint = [self.heightAnchor constraintEqualToConstant:self.height];
    self.centerXConstraint = [self.centerXAnchor constraintEqualToAnchor:view.centerXAnchor];
    self.centerYConstraint = [self.centerYAnchor constraintEqualToAnchor:view.centerYAnchor];
    
    // 设置约束以居中显示弹窗（避免使用 frame）
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        self.centerXConstraint,
        self.centerYConstraint,
        self.widthConstraint,
        self.heightConstraint
    ]];
    
    // 标记为正在显示
    self.isShowing = YES;
    
    // 设置视图布局（调用布局和约束方法）
    [self setupViews];

    // 如果需要背景遮罩（非显示在 window 中时）
    if (self.shouldDimBackgroundWhenShowInView && view != [self keyWindow]) {
        [self addBackgroundDimViewToView:view];
    }
    
    // 弹窗显示前的处理（如动画或初始化）
    [self alertViewWillAppear];
    
    // 以动画形式显示弹窗视图
    [self presentWithAnimation:view];
}

/// 添加背景遮罩视图到指定父视图
- (void)addBackgroundDimViewToView:(UIView *)view {
    self.backgroundDimView = [[UIView alloc] initWithFrame:view.bounds];
    self.backgroundDimView.backgroundColor = [UIColor colorWithWhite:0 alpha:self.dimAlpha];

    UITapGestureRecognizer *outsideTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(outsideTap:)];
    [self.backgroundDimView addGestureRecognizer:outsideTapGesture];

    if (view == [self keyWindow]) {
        [view addSubview:self.backgroundDimView];
    } else {
        [view insertSubview:self.backgroundDimView belowSubview:self];
    }
}

// 处理点击弹窗外部的手势事件
- (void)outsideTap:(UITapGestureRecognizer *)recognizer {
    if (self.shouldDismissOnOutsideTapped) {
        [self dismiss]; // 如果允许点击外部关闭弹窗，则调用dismiss方法
    }
}

// 以动画形式显示弹窗视图
- (void)presentWithAnimation:(UIView *)view {
    NSTimeInterval timeAppear = (self.appearTime > 0) ? self.appearTime : 0.2; // 获取显示动画时间，默认0.2秒
    NSTimeInterval timeDelay = 0; // 动画延迟时间，默认无延迟

    // 根据不同的动画类型执行对应的显示动画
    switch (self.appearAnimationType) {
        case ZHHAlertViewAnimationTypeDefault:
            [self performScaleAnimationWithScale:1.1 duration:timeAppear delay:timeDelay];
            break;
        case ZHHAlertViewAnimationTypeNone:
            [self alertViewDidAppear]; // 无动画，直接显示视图
            break;
        default:
            break;
    }
}

// 执行缩放动画
- (void)performScaleAnimationWithScale:(CGFloat)scale duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    // 显示动画：从放大缩小到正常大小，并渐显
    self.transform = CGAffineTransformMakeScale(scale, scale);
    self.alpha = 0.6;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self alertViewDidAppear];
    }];
}

// 执行消失缩放动画
- (void)performScaleOutAnimationWithScale:(CGFloat)scale duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    // 消失动画：从正常大小放大，并渐隐
    self.transform = CGAffineTransformIdentity;
    self.alpha = 1.0;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeScale(scale, scale);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        // 只有动画完成时才清理视图
        if (finished || self.alpha <= 0.01) {
            [self cleanupAfterDismiss];
        }
    }];
}

// 隐藏并移除弹窗视图
- (void)dismiss {
    if (!self.isShowing) {
        return; // 如果未显示，直接返回
    }
    
    NSTimeInterval timeDisappear = (self.disappearTime > 0) ? self.disappearTime : 0.1; // 获取消失动画时间，默认0.1秒
    NSTimeInterval timeDelay = 0.02; // 动画延迟时间，默认0.02秒

    // 标记为不再显示
    self.isShowing = NO;
    
    // 根据不同的动画类型执行对应的消失动画
    switch (self.disappearAnimationType) {
        case ZHHAlertViewAnimationTypeDefault:
            [self performScaleOutAnimationWithScale:1.1 duration:timeDisappear delay:timeDelay];
            break;
        case ZHHAlertViewAnimationTypeNone:
            [self cleanupAfterDismiss]; // 无动画，直接清理
            break;
        default:
            break;
    }
    
    // 移除黑色不透明背景视图（如果有）
    if (self.backgroundDimView) {
        [UIView animateWithDuration:timeDisappear animations:^{
            self.backgroundDimView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.backgroundDimView removeFromSuperview];
            self.backgroundDimView = nil;
        }];
    }
}

// 清理资源
- (void)cleanupAfterDismiss {
    [self removeFromSuperview];
    
    // 清理约束
    if (self.widthConstraint) {
        [self.widthConstraint setActive:NO];
        self.widthConstraint = nil;
    }
    if (self.heightConstraint) {
        [self.heightConstraint setActive:NO];
        self.heightConstraint = nil;
    }
    if (self.centerXConstraint) {
        [self.centerXConstraint setActive:NO];
        self.centerXConstraint = nil;
    }
    if (self.centerYConstraint) {
        [self.centerYConstraint setActive:NO];
        self.centerYConstraint = nil;
    }
    if (self.scrollViewTopConstraint) {
        [self.scrollViewTopConstraint setActive:NO];
        self.scrollViewTopConstraint = nil;
    }
    if (self.scrollHeightConstraint) {
        [self.scrollHeightConstraint setActive:NO];
        self.scrollHeightConstraint = nil;
    }
    
    // 移除阴影层
    if (self.topShadowLayer) {
        [self.topShadowLayer removeFromSuperlayer];
        self.topShadowLayer = nil;
    }
    if (self.bottomShadowLayer) {
        [self.bottomShadowLayer removeFromSuperlayer];
        self.bottomShadowLayer = nil;
    }
    
    // 清理按钮
    for (UIView *subview in self.buttonStackView.arrangedSubviews) {
        [self.buttonStackView removeArrangedSubview:subview];
        [subview removeFromSuperview];
    }
}

#pragma mark - 按钮点击事件处理

// 处理取消按钮点击事件
- (void)cancelButtonClicked:(id)sender {
    // 如果设置了点击高亮效果，应用高亮效果
    if (self.shouldHighlightButtonOnClick) {
        [self setButtonHighlightEffect:self.cancelButton];
    }

    // 关闭视图
    [self dismiss];
    
    // 回调取消按钮点击事件
    if (self.cancelButtonAction) {
        self.cancelButtonAction();
    }
    
    // 通知代理：取消按钮被点击
    if ([self.delegate respondsToSelector:@selector(alertViewDidClickCancelButton:)]) {
        [self.delegate alertViewDidClickCancelButton:self];
    }
}

/// 其他按钮点击事件
- (void)otherButtonClicked:(id)sender {
    // 如果设置了点击高亮效果，应用高亮效果
    if (self.shouldHighlightButtonOnClick) {
        [self setButtonHighlightEffect:self.otherButton];
    }
    
    // 根据设置判断是否关闭弹窗
    if (self.shouldDismissOnActionButtonClicked) {
        [self dismiss];
    }

    // 回调其他按钮点击事件
    if (self.otherButtonAction) {
        self.otherButtonAction();
    }

    // 通知代理：其他按钮被点击
    if ([self.delegate respondsToSelector:@selector(alertViewDidClickOtherButton:)]) {
        [self.delegate alertViewDidClickOtherButton:self];
    }
}

// 通知委托视图已经出现
- (void)alertViewDidAppear {
    if ([self.delegate respondsToSelector:@selector(alertViewDidAppear:)]) {
        [self.delegate alertViewDidAppear:self];
    }
}

// 通知委托视图即将出现
- (void)alertViewWillAppear {
    if ([self.delegate respondsToSelector:@selector(alertViewWillAppear:)]) {
        [self.delegate alertViewWillAppear:self];
    }
}

#pragma mark - Lazy Load Views

/// 容器视图（承载标题、内容、按钮）
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _containerView;
}

/// 标题标签
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.backgroundColor = UIColor.clearColor;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

/// 内容滚动视图（用于展示较长文本）
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.bounces = YES;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentInset = UIEdgeInsetsZero;
        _scrollView.backgroundColor = UIColor.clearColor;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _scrollView;
}

/// 内容标签
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = UIColor.grayColor;
        _contentLabel.backgroundColor = UIColor.clearColor;
        _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentLabel;
}

/// 按钮容器栈视图
- (UIStackView *)buttonStackView {
    if (!_buttonStackView) {
        _buttonStackView = [[UIStackView alloc] init];
        _buttonStackView.axis = UILayoutConstraintAxisHorizontal;// 水平方向
        _buttonStackView.distribution = UIStackViewDistributionFillEqually;// 均分宽度
        _buttonStackView.alignment = UIStackViewAlignmentFill;// 让子视图填充高度
        _buttonStackView.spacing = 0;// 按钮之间的间距
        _buttonStackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _buttonStackView;
}

/// 取消按钮
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_cancelButton setBackgroundImage:[self imageNamed:@"divider_highlighted"] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _cancelButton;
}

/// 其他按钮
- (UIButton *)otherButton {
    if (!_otherButton) {
        _otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_otherButton setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        _otherButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_otherButton setBackgroundImage:[self imageNamed:@"divider_highlighted"] forState:UIControlStateHighlighted];
        [_otherButton addTarget:self action:@selector(otherButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _otherButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _otherButton;
}

/// 横向分割线（按钮上方）
- (UIView *)horizontalSeparator {
    if (!_horizontalSeparator) {
        _horizontalSeparator = [[UIView alloc] init];
        _horizontalSeparator.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _horizontalSeparator;
}

/// 纵向分割线（两个按钮之间）
- (UIView *)verticalSeparator {
    if (!_verticalSeparator) {
        _verticalSeparator = [[UIView alloc] init];
        _verticalSeparator.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _verticalSeparator;
}

#pragma mark - 滚动阴影

// 设置阴影层
- (void)setupShadowLayers {
    // 获取当前背景色（用于阴影渐变）
    UIColor *backgroundColor = self.backgroundColor ?: UIColor.whiteColor;
    
    // 顶部阴影层
    if (!self.topShadowLayer) {
        self.topShadowLayer = [CAGradientLayer layer];
        self.topShadowLayer.colors = @[
            (id)[backgroundColor colorWithAlphaComponent:1.0].CGColor,
            (id)[backgroundColor colorWithAlphaComponent:0.0].CGColor
        ];
        self.topShadowLayer.startPoint = CGPointMake(0.5, 0.0);
        self.topShadowLayer.endPoint = CGPointMake(0.5, 1.0);
        self.topShadowLayer.opacity = 0;
        [self.layer addSublayer:self.topShadowLayer];
    } else {
        // 更新已存在的阴影层颜色
        self.topShadowLayer.colors = @[
            (id)[backgroundColor colorWithAlphaComponent:1.0].CGColor,
            (id)[backgroundColor colorWithAlphaComponent:0.0].CGColor
        ];
    }
    
    // 底部阴影层
    if (!self.bottomShadowLayer) {
        self.bottomShadowLayer = [CAGradientLayer layer];
        self.bottomShadowLayer.colors = @[
            (id)[backgroundColor colorWithAlphaComponent:0.0].CGColor,
            (id)[backgroundColor colorWithAlphaComponent:1.0].CGColor
        ];
        self.bottomShadowLayer.startPoint = CGPointMake(0.5, 0.0);
        self.bottomShadowLayer.endPoint = CGPointMake(0.5, 1.0);
        self.bottomShadowLayer.opacity = 0;
        [self.layer addSublayer:self.bottomShadowLayer];
    } else {
        // 更新已存在的阴影层颜色
        self.bottomShadowLayer.colors = @[
            (id)[backgroundColor colorWithAlphaComponent:0.0].CGColor,
            (id)[backgroundColor colorWithAlphaComponent:1.0].CGColor
        ];
    }
}

// 更新阴影层的位置和显示状态
- (void)updateShadowLayers {
    if (!self.scrollView || !self.scrollView.superview) {
        return;
    }
    
    // 更新阴影层颜色（如果背景色发生变化）
    UIColor *backgroundColor = self.backgroundColor ?: UIColor.whiteColor;
    if (self.topShadowLayer && self.topShadowLayer.colors.count >= 2) {
        self.topShadowLayer.colors = @[
            (id)[backgroundColor colorWithAlphaComponent:1.0].CGColor,
            (id)[backgroundColor colorWithAlphaComponent:0.0].CGColor
        ];
    }
    if (self.bottomShadowLayer && self.bottomShadowLayer.colors.count >= 2) {
        self.bottomShadowLayer.colors = @[
            (id)[backgroundColor colorWithAlphaComponent:0.0].CGColor,
            (id)[backgroundColor colorWithAlphaComponent:1.0].CGColor
        ];
    }
    
    // 如果内容不足以滚动，隐藏所有阴影
    if (!self.scrollView.scrollEnabled || self.scrollView.contentSize.height <= self.scrollView.bounds.size.height) {
        self.topShadowLayer.opacity = 0;
        self.bottomShadowLayer.opacity = 0;
        return;
    }
    
    // 更新阴影层的位置和大小
    CGFloat shadowHeight = 15.0;
    CGRect scrollViewFrame = [self convertRect:self.scrollView.frame fromView:self.scrollView.superview];
    
    // 顶部阴影层：位于 scrollView 的顶部
    self.topShadowLayer.frame = CGRectMake(
        scrollViewFrame.origin.x,
        scrollViewFrame.origin.y,
        scrollViewFrame.size.width,
        shadowHeight
    );
    
    // 底部阴影层：位于 scrollView 的底部
    self.bottomShadowLayer.frame = CGRectMake(
        scrollViewFrame.origin.x,
        CGRectGetMaxY(scrollViewFrame) - shadowHeight,
        scrollViewFrame.size.width,
        shadowHeight
    );
    
    // 根据滚动位置更新阴影透明度
    CGFloat contentOffsetY = self.scrollView.contentOffset.y;
    CGFloat maxContentOffsetY = self.scrollView.contentSize.height - self.scrollView.bounds.size.height;
    
    // 顶部阴影：滚动到顶部时隐藏，向下滚动时显示
    if (contentOffsetY <= 0) {
        self.topShadowLayer.opacity = 0;
    } else if (contentOffsetY >= maxContentOffsetY) {
        self.topShadowLayer.opacity = 1.0;
    } else {
        // 在中间位置时显示（根据滚动位置调整透明度）
        CGFloat progress = contentOffsetY / maxContentOffsetY;
        self.topShadowLayer.opacity = MIN(progress * 2.0, 1.0);
    }
    
    // 底部阴影：滚动到底部时隐藏，向上滚动时显示
    if (contentOffsetY >= maxContentOffsetY) {
        self.bottomShadowLayer.opacity = 0;
    } else if (contentOffsetY <= 0) {
        self.bottomShadowLayer.opacity = 1.0;
    } else {
        // 在中间位置时显示（根据滚动位置调整透明度）
        CGFloat progress = 1.0 - (contentOffsetY / maxContentOffsetY);
        self.bottomShadowLayer.opacity = MIN(progress * 2.0, 1.0);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateShadowLayers];
}

#pragma mark - 私有方法

- (UIColor *)colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
    return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return darkColor;  // 返回暗黑模式颜色
        } else {
            return lightColor; // 返回浅色模式颜色
        }
    }];
}

// 获取当前的 keyWindow
- (UIWindow *)keyWindow {
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive &&
            [scene isKindOfClass:[UIWindowScene class]]) {
            return scene.windows.firstObject;
        }
    }
    return nil;
}

// 为按钮添加点击高亮效果
- (void)setButtonHighlightEffect:(UIButton *)button {
    // 保存原始背景颜色
    UIColor *originColor = button.backgroundColor ?: UIColor.clearColor;
    
    // 添加点击高亮效果：设置背景颜色透明度为 0.1
    button.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];

    // 延时恢复原始颜色
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.backgroundColor = originColor;
    });
}

- (UIImage *)imageNamed:(NSString *)imageName {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}
@end

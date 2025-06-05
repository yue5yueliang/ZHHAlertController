//
//  ZHHAlertViewController.m
//  ZHHAlertViewController
//
//  Created by 桃色三岁 on 2022/4/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHAlertViewController.h"

// 枚举化方向，避免字符串对比
typedef NS_ENUM(NSInteger, ZHHAlertViewDirection) {
    ZHHAlertViewDirectionTop,
    ZHHAlertViewDirectionBottom,
    ZHHAlertViewDirectionLeft,
    ZHHAlertViewDirectionRight
};

@implementation ZHHAlertAppearance

- (instancetype)init {
    self = [super init];
    if (self) {
        // 标题距顶部（与父视图顶部的距离），默认 15
        _titleTopPadding = 15.0;
        // 标题与内容之间的垂直间距，默认 10
        _titleBottomPadding = 10.0;
        // 内容区域左右内边距（标题和内容共用），默认 20
        _contentLeftRightPadding = 20.0;
        // 按钮上边距（即按钮上方到内容区域下方的距离），默认 0
        _buttonTopPadding = 0.0;
        // 按钮高度，默认 44
        _buttonHeight = 44.0;
        // 按钮距底部（与父视图底部的距离），默认 0
        _buttonBottomPadding = 0.0;
        // 按钮左右内边距，默认 0
        _buttonLeftRightPadding = 0.0;
        // 按钮之间的水平间距（当有多个按钮时），默认 0
        _buttonSpacing = 0.0;
        // 弹窗默认宽高
        _width = 284.0;
        _height = 135.0;
    }
    return self;
}

@end

@interface ZHHAlertViewController () <UIScrollViewDelegate> {
    // 状态标识
    BOOL hasCustomContentView; ///< 是否自定义设置了 contentView
}

// 弹窗容器视图（包含 titleLabel, scrollView 等内容）
@property (nonatomic, strong) UIView *containerView;

// 弹窗尺寸缓存
@property (nonatomic, assign) CGFloat width;    ///< 弹窗宽度
@property (nonatomic, assign) CGFloat height;   ///< 弹窗高度

// 按钮视图
@property (nonatomic, strong) UIStackView *buttonStackView; ///< 按钮容器（使用 UIStackView 实现）
@property (nonatomic, strong) UIView *horizontalSeparator;  ///< 水平分隔线（按钮上方）
@property (nonatomic, strong) UIView *verticalSeparator;    ///< 垂直分隔线（按钮中间）

// 背景遮罩（非模糊，黑色透明背景）
@property (nonatomic, strong) UIView *backgroundDimView;

// 内容滚动视图
@property (nonatomic, strong, readwrite) UIScrollView *scrollView;

// 弹窗外观配置模型
@property (nonatomic, strong) ZHHAlertAppearance *model;

@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;   ///< 自身宽度约束
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;  ///< 自身高度约束
@property (nonatomic, strong) NSLayoutConstraint *scrollHeightConstraint;  ///< content内容高度约束

@end

@implementation ZHHAlertViewController

#pragma mark - Init Methods

/// 初始化方法：传入 model，使用默认 frame
- (instancetype)initWithModel:(ZHHAlertAppearance *)model {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _model = model;

        self.shouldDimBackgroundWhenShowInView = YES;
        [self configureDefaultAppearance];
    }
    return self;
}

#pragma mark - 配置默认外观

- (void)configureDefaultAppearance {
    self.backgroundColor = UIColor.whiteColor;
    
    // 初始化基本属性
    self.clipsToBounds = YES;
    self.cornerRadius = 8; // 圆角半径
    self.shouldHighlightButtonOnClick = YES; // 按钮点击时高亮
    self.shouldDimBackgroundWhenShowInWindow = YES; // 是否显示背景变暗
    self.shouldDismissOnActionButtonClicked = YES; // 点击按钮后是否自动消失
    self.dimAlpha = 0.4; // 背景变暗透明度
    
    // 设置默认动画类型
    self.appearAnimationType = ZHHAlertViewAnimationTypeDefault;
    self.disappearAnimationType = ZHHAlertViewAnimationTypeDefault;
}

#pragma mark - 设置 Alert View

- (void)setCustomContentView:(UIView *)contentView {
    _customContentView = contentView;
    hasCustomContentView = YES;
    
    // 设置宽高
    self.model.width = contentView.frame.size.width;
    self.model.height = contentView.frame.size.height + self.model.buttonHeight + self.model.buttonTopPadding + self.model.buttonBottomPadding;
    
    // 设置 contentView 的 frame 并添加到 self 中
    contentView.frame = contentView.bounds;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.width, self.height);
    [self addSubview:contentView];
}

- (void)setupViews {
    self.layer.cornerRadius = self.cornerRadius;
    [self addSubview:self.buttonStackView];
    if (self.model.buttonSpacing <= 0 && (self.model.cancelButtonTitle.length > 0 || self.model.otherButtonTitle.length > 0)) {
        [self addSubview:self.horizontalSeparator];
    }
    
    if (self.model.buttonSpacing <= 0 && (self.model.cancelButtonTitle.length > 0 && self.model.otherButtonTitle.length > 0)) {
        [self addSubview:self.verticalSeparator];
    }

    // 🔍 打印初始 contentLabel 高度
    NSLog(@"[初始] contentLabel.frame = %@", NSStringFromCGRect(self.frame));

    // 设置分割线颜色
    UIColor *sepColor = self.separatorColor ?: [UIColor separatorColor];
    self.horizontalSeparator.backgroundColor = sepColor;
    self.verticalSeparator.backgroundColor = sepColor;

    // 如果是自定义视图则不添加以下子视图
    if (!hasCustomContentView) {
        
        // 添加基础子视图
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.titleLabel];
        [self.containerView addSubview:self.scrollView];
        [self.scrollView addSubview:self.contentLabel];

        self.scrollHeightConstraint = [self.scrollView.heightAnchor constraintEqualToConstant:100];
        [NSLayoutConstraint activateConstraints:@[
            // containerView 约束
            [self.containerView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0],
            [self.containerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:self.model.contentLeftRightPadding],
            [self.containerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-self.model.contentLeftRightPadding],
            [self.containerView.bottomAnchor constraintEqualToAnchor:self.buttonStackView.topAnchor constant:-0],
            
            // 1️⃣ titleLabel 约束
            [self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:self.model.titleTopPadding],
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:self.model.contentLeftRightPadding],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-self.model.contentLeftRightPadding],
            
            // 2️⃣ scrollView 初始高度约束（会在后面动态更新）
            [self.scrollView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:self.model.titleBottomPadding],
            [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:self.model.contentLeftRightPadding],
            [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-self.model.contentLeftRightPadding],
            self.scrollHeightConstraint,
            
            // 3️⃣ contentLabel 约束（填充 scrollView）
            [self.contentLabel.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
            [self.contentLabel.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
            [self.contentLabel.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
            [self.contentLabel.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
            [self.contentLabel.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor]
        ]];
        
        // 4️⃣ 布局后更新 scrollView 高度 & 背景高度
        [self layoutIfNeeded];
        CGFloat contentWidth = CGRectGetWidth(self.scrollView.frame);
        if (contentWidth == 0) contentWidth = self.model.width - self.model.contentLeftRightPadding * 2;

        CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        CGFloat titleHeight = titleSize.height;
        CGSize contentSize = [self.contentLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        CGFloat contentHeight = contentSize.height;

        CGFloat screenH = UIScreen.mainScreen.bounds.size.height;
        CGFloat maxTotalHeight = screenH * 2.0 / 3.0; // 屏幕三分之二高度
        CGFloat totalHeight = self.model.titleTopPadding + titleHeight + self.model.titleBottomPadding + contentHeight + self.model.buttonTopPadding + self.model.buttonHeight + self.model.buttonBottomPadding;

        BOOL contentTooLarge = totalHeight > maxTotalHeight;
        BOOL contentTooSmall = totalHeight < self.model.height;

        if (contentTooLarge) {
            // 内容太大，限制最大高度，scrollView 启动滚动
            self.scrollView.scrollEnabled = YES;
            CGFloat availableScrollHeight = maxTotalHeight - self.model.titleTopPadding - titleHeight - self.model.titleBottomPadding - self.model.buttonTopPadding - self.model.buttonHeight;
            self.scrollHeightConstraint.constant = availableScrollHeight;

            self.heightConstraint.constant = maxTotalHeight;
        } else if (contentTooSmall) {
            self.scrollView.scrollEnabled = NO;
            CGFloat availableScrollHeight = self.model.height - self.model.titleTopPadding - titleHeight - self.model.titleBottomPadding - self.model.buttonTopPadding - self.model.buttonHeight;

            if (contentHeight < availableScrollHeight) {
                self.scrollHeightConstraint.constant = contentHeight;
            } else {
                self.scrollHeightConstraint.constant = availableScrollHeight;
            }

            self.heightConstraint.constant = self.model.height;
        } else {
            // 内容合适，scrollView 高度为 contentHeight
            self.scrollView.scrollEnabled = NO;
            self.scrollHeightConstraint.constant = contentHeight;
            
            self.heightConstraint.constant = totalHeight;
        }
    }
        
    // buttonStackView 约束
    [NSLayoutConstraint activateConstraints:@[
        [self.buttonStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:self.model.buttonLeftRightPadding],
        [self.buttonStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-self.model.buttonLeftRightPadding],
        [self.buttonStackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-self.model.buttonBottomPadding],
        // 添加默认高度约束
        [self.buttonStackView.heightAnchor constraintEqualToConstant:self.model.buttonHeight]
    ]];
    
    // 获取 1 像素高度（根据屏幕 scale 自适应）
    CGFloat onePixel = 1.0 / [UIScreen mainScreen].scale;

    if (self.model.buttonSpacing <= 0) {
        
        BOOL hasCancelButton = (self.model.cancelButtonTitle.length > 0);
        BOOL hasOtherButton = (self.model.otherButtonTitle.length > 0);
        
        if (hasCancelButton || hasOtherButton) {
            // 3️⃣ horizontalSeparator 约束（重写为与 buttonStackView 对齐，保证“1像素线”效果）
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
        
        if (hasCancelButton && hasOtherButton) {
            // 4️⃣ verticalSeparator 约束（位于 buttonStackView 中间，保证“1像素线”效果）
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

    // 🔍 打印最终 contentLabel 高度
    NSLog(@"[最终] contentLabel.frame = %@", NSStringFromCGRect(self.contentLabel.frame));
}

#pragma mark - Public Show Methods

/// 显示弹窗（默认显示在 keyWindow 中）
- (void)show {
    // 检查是否需要在窗口中显示背景遮罩（背景变暗效果）
    if (self.shouldDimBackgroundWhenShowInWindow) {
        [self addBackgroundDimViewToView:[self keyWindow]];
    }
    
    // 调用核心显示逻辑，显示到 keyWindow 中
    [self showInView:[self keyWindow]];
}

/// 显示弹窗到指定视图中
/// @param view 目标父视图
- (void)showInView:(UIView *)view {
    // 设置标题和内容
    self.titleLabel.text = self.model.title;
    self.contentLabel.text = self.model.content;
    
    // 设置按钮容器的间距
    self.buttonStackView.spacing = self.model.buttonSpacing;
    
    if (self.model.cancelButtonTitle.length > 0) {
        [self.cancelButton setTitle:self.model.cancelButtonTitle forState:UIControlStateNormal];
        [self.buttonStackView addArrangedSubview:self.cancelButton];
    }

    if (self.model.otherButtonTitle.length > 0) {
        [self.otherButton setTitle:self.model.otherButtonTitle forState:UIControlStateNormal];
        [self.buttonStackView addArrangedSubview:self.otherButton];
    }
    
    // 添加弹窗视图到目标父视图
    [view addSubview:self];

    // 创建约束时
    self.widthConstraint  = [self.widthAnchor constraintEqualToConstant:self.model.width];
    self.heightConstraint = [self.heightAnchor constraintEqualToConstant:self.model.height];
    
    // 设置约束以居中显示弹窗（避免使用 frame）
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [self.centerYAnchor constraintEqualToAnchor:view.centerYAnchor],
        self.widthConstraint,
        self.heightConstraint
    ]];
    
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
        case ZHHAlertViewAnimationTypeZoomIn:
            [self performScaleAnimationWithScale:0.01 duration:timeAppear delay:timeDelay];
            break;
        case ZHHAlertViewAnimationTypeFadeIn:
            [self performFadeInAnimationWithDuration:timeAppear delay:timeDelay];
            break;
        case ZHHAlertViewAnimationTypeFlyTop:
            [self performFlyInAnimationWithDirection:ZHHAlertViewDirectionTop view:view duration:timeAppear delay:timeDelay];
            break;
        case ZHHAlertViewAnimationTypeFlyBottom:
            [self performFlyInAnimationWithDirection:ZHHAlertViewDirectionBottom view:view duration:timeAppear delay:timeDelay];
            break;
        case ZHHAlertViewAnimationTypeFlyLeft:
            [self performFlyInAnimationWithDirection:ZHHAlertViewDirectionLeft view:view duration:timeAppear delay:timeDelay];
            break;
        case ZHHAlertViewAnimationTypeFlyRight:
            [self performFlyInAnimationWithDirection:ZHHAlertViewDirectionRight view:view duration:timeAppear delay:timeDelay];
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
    self.transform = CGAffineTransformMakeScale(scale, scale);
    self.alpha = 0.6;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self alertViewDidAppear];
    }];
}

// 执行渐显动画
- (void)performFadeInAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    self.alpha = 0;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self alertViewDidAppear];
    }];
}

// 执行飞入动画（使用 transform 避免 Auto Layout 冲突）
- (void)performFlyInAnimationWithDirection:(ZHHAlertViewDirection)direction view:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    // 计算初始偏移量
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;

    switch (direction) {
        case ZHHAlertViewDirectionTop:
            offsetY = -CGRectGetMaxY(self.frame) - 10;
            break;
        case ZHHAlertViewDirectionBottom:
            offsetY = view.bounds.size.height - CGRectGetMinY(self.frame) + 10;
            break;
        case ZHHAlertViewDirectionLeft:
            offsetX = -CGRectGetMaxX(self.frame) - 10;
            break;
        case ZHHAlertViewDirectionRight:
            offsetX = view.bounds.size.width - CGRectGetMinX(self.frame) + 10;
            break;
        default:
            break;
    }

    // 从初始位置偏移（相对于 Auto Layout）
    self.transform = CGAffineTransformMakeTranslation(offsetX, offsetY);
    self.alpha = 0.0;

    // 执行动画回归原位
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self alertViewDidAppear];
    }];
}

// 隐藏并移除弹窗视图
- (void)dismiss {
    NSTimeInterval timeDisappear = (self.disappearTime > 0) ? self.disappearTime : 0.08; // 获取消失动画时间，默认0.08秒
    NSTimeInterval timeDelay = 0.02; // 动画延迟时间，默认0.02秒

    // 根据不同的动画类型执行对应的消失动画
    switch (self.disappearAnimationType) {
        case ZHHAlertViewAnimationTypeDefault:
            [self performFadeOutAnimationWithDuration:timeDisappear delay:timeDelay];
            break;
        case ZHHAlertViewAnimationTypeZoomOut:
            [self performZoomOutAnimationWithDuration:timeDisappear delay:timeDelay];
            break;
        case ZHHAlertViewAnimationTypeFadeOut:
            [self performFadeOutAnimationWithDuration:timeDisappear delay:timeDelay];
            break;
        case ZHHAlertViewAnimationTypeFlyTop:
            [self performFlyOutAnimationWithDirection:ZHHAlertViewDirectionTop duration:timeDisappear delay:timeDelay];
            break;
        case ZHHAlertViewAnimationTypeFlyBottom:
            [self performFlyOutAnimationWithDirection:ZHHAlertViewDirectionBottom duration:timeDisappear delay:timeDelay];
            break;
        case ZHHAlertViewAnimationTypeFlyLeft:
            [self performFlyOutAnimationWithDirection:ZHHAlertViewDirectionLeft duration:timeDisappear delay:timeDelay];
            break;
        case ZHHAlertViewAnimationTypeFlyRight:
            [self performFlyOutAnimationWithDirection:ZHHAlertViewDirectionRight duration:timeDisappear delay:timeDelay];
            break;
        case ZHHAlertViewAnimationTypeNone:
            [self removeFromSuperview]; // 无动画，直接移除视图
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
        }];
    }
}

#pragma mark - 动画执行

// 执行渐隐动画
- (void)performFadeOutAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    self.alpha = 1;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// 执行缩放动画
- (void)performZoomOutAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// 执行飞出动画
- (void)performFlyOutAnimationWithDirection:(ZHHAlertViewDirection)direction duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    // 计算偏移量
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;

    switch (direction) {
        case ZHHAlertViewDirectionTop:
            offsetY = -CGRectGetMaxY(self.frame) - 10;
            break;
        case ZHHAlertViewDirectionBottom:
            offsetY = self.superview.bounds.size.height - CGRectGetMinY(self.frame) + 10;
            break;
        case ZHHAlertViewDirectionLeft:
            offsetX = -CGRectGetMaxX(self.frame) - 10;
            break;
        case ZHHAlertViewDirectionRight:
            offsetX = self.superview.bounds.size.width - CGRectGetMinX(self.frame) + 10;
            break;
        default:
            break;
    }

    // 开始动画：使用 transform 避免与 Auto Layout 冲突
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeTranslation(offsetX, offsetY);
        self.alpha = 0.0; // 同时淡出更自然
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
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
    // 添加点击高亮效果：设置背景颜色透明度为 0.1，并在 0.2 秒后还原
    UIColor *originColor = [button.backgroundColor colorWithAlphaComponent:0];
    button.backgroundColor = [button.backgroundColor colorWithAlphaComponent:0.1];

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

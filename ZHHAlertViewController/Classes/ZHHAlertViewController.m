//
//  ZHHAlertViewController.m
//  ZHHAlertViewController
//
//  Created by 桃色三岁 on 2022/4/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHAlertViewController.h"

#define DEFAULT_ALERT_WIDTH 270
#define DEFAULT_ALERT_HEIGHT 156
#define DEFAULT_TITLE_HEIGHT 20

@interface ZHHAlertViewController () <UIScrollViewDelegate> {
    // 用于保存标题、消息、取消按钮和其他按钮的框架
    CGRect titleLabelFrame;
    CGRect contentLabelFrame;
    CGRect cancelButtonFrame;
    CGRect otherButtonFrame;
    
    // 分隔线的框架
    CGRect verticalSeparatorFrame;
    CGRect horizontalSeparatorFrame;
    
    // 用于标识是否修改了框架和是否有自定义内容视图
    BOOL hasModifiedFrame;
    BOOL hasContentView;
}

// 弹窗的内容视图
@property (nonatomic, strong) UIView *alertContentView;

// 水平和垂直分隔线视图
@property (nonatomic, strong) UIView *horizontalSeparator;
@property (nonatomic, strong) UIView *verticalSeparator;

// 背景不透明视图，用于实现背景变暗效果
@property (nonatomic, strong) UIView *blackOpaqueView;

// 弹窗的标题和消息文本
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;

// 取消按钮和其他按钮的标题
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSString *otherButtonTitle;

// 滚动视图，用于在内容超出视图时滚动
@property (nonatomic, strong, readwrite) UIScrollView *scrollView;

// 标题的高度，默认为34
@property (nonatomic, assign) CGFloat titleHeight;

// 弹窗的宽度和高度
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

// 原始取消按钮和其他按钮的颜色，用于在需要时还原颜色
@property (nonatomic, strong) UIColor *originCancelButtonColor;
@property (nonatomic, strong) UIColor *originOtherButtonColor;

@end

@implementation ZHHAlertViewController

// 自定义弹窗控制器类

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化代码
    }
    return self;
}

// 初始化方法，支持传递多个按钮标题
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content delegate:(id)delegate cancelButtonTitle:(NSString * _Nullable)cancelButtonTitle otherButtonTitles:(NSString * _Nullable)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    NSString *firstOtherButtonTitle;

    // 使用可变参数列表获取其他按钮标题
    va_list args;
    va_start(args, otherButtonTitles);
    for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*)) {
        if (!firstOtherButtonTitle) {
            firstOtherButtonTitle = arg;
            break;
        }
    }
    va_end(args);
    
    // 初始化弹窗控制器并设置代理
    if ([self initWithTitle:title content:content cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitles]) {
        self.delegate = delegate;
        return self;
    }
    
    return nil;
}

// 初始化方法，设置基本属性
- (instancetype)initWithTitle:(NSString * _Nullable)title content:(NSString * _Nullable)content cancelButtonTitle:(NSString * _Nullable)cancelButtonTitle otherButtonTitle:(NSString * _Nullable)otherButtonTitle {
    self.width = DEFAULT_ALERT_WIDTH;
    self.height = DEFAULT_ALERT_HEIGHT;
    
    self = [super initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    if (self) {
        // 初始化代码
        self.clipsToBounds = YES;
        self.title = title;
        self.content = content;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitle = otherButtonTitle;
        
        // 设置默认动画类型
        self.appearAnimationType = ZHHAlertViewAnimationTypeDefault;
        self.disappearAnimationType = ZHHAlertViewAnimationTypeDefault;
        self.cornerRadius = 8; // 圆角半径
        self.buttonClickedHighlight = YES; // 按钮点击时高亮
        
        // 设置默认布局参数
        self.buttonHeight = 44;
        self.titleTopPadding = 14;
        self.titleHeight = DEFAULT_TITLE_HEIGHT;
        self.titleBottomPadding = 2;
        self.contentBottomPadding = 20;
        self.contentLeftRightPadding = 20;
        
        self.shouldDimBackgroundWhenShowInWindow = YES; // 是否显示背景变暗效果
        self.shouldDismissOnActionButtonClicked = YES; // 点击按钮后是否自动消失
        self.dimAlpha = 0.4; // 背景变暗透明度
        
        // 初始化视图元素
        [self setupItems];
    }
    return self;
}

#pragma mark - 显示弹窗视图

// 在指定视图中显示弹窗
- (void)showInView:(UIView *_Nonnull)view {
    [self calculateFrame]; // 计算视图的布局框架
    [self setupViews]; // 设置视图元素
    
    if (!hasModifiedFrame) {
        // 默认弹窗显示在视图的中心
        self.frame = CGRectMake((view.frame.size.width - self.frame.size.width) / 2,
                                (view.frame.size.height - self.frame.size.height) / 2,
                                self.frame.size.width, self.frame.size.height);
    }
    UIView *window = [[[UIApplication sharedApplication] delegate] window];

    // 如果需要在指定视图中显示背景变暗效果
    if (self.shouldDimBackgroundWhenShowInView && view != window) {
        UIView *window = [[[UIApplication sharedApplication] delegate] window];
        self.blackOpaqueView = [[UIView alloc] initWithFrame:window.bounds];
        self.blackOpaqueView.backgroundColor = [UIColor colorWithWhite:0 alpha:self.dimAlpha];
        
        // 添加手势识别器，用于处理点击弹窗外部关闭弹窗的操作
        UITapGestureRecognizer *outsideTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(outsideTap:)];
        [self.blackOpaqueView addGestureRecognizer:outsideTapGesture];
        [view addSubview:self.blackOpaqueView];
    }
    
    [self willAppearAlertView]; // 弹窗显示前的预处理

    [self addThisViewToView:view]; // 将弹窗视图添加到指定视图中
}

// 在窗口中显示弹窗
- (void)show {
    UIView *window = [[[UIApplication sharedApplication] delegate] window];
        
    // 如果需要在窗口中显示背景变暗效果
    if (self.shouldDimBackgroundWhenShowInWindow) {
        self.blackOpaqueView = [[UIView alloc] initWithFrame:window.bounds];
        self.blackOpaqueView.backgroundColor = [UIColor colorWithWhite:0 alpha:self.dimAlpha];

        // 添加手势识别器，用于处理点击弹窗外部关闭弹窗的操作
        UITapGestureRecognizer *outsideTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(outsideTap:)];
        [self.blackOpaqueView addGestureRecognizer:outsideTapGesture];
        [window addSubview:self.blackOpaqueView];
    }
    
    // 在窗口中显示弹窗视图
    [self showInView:window];
}

// 处理点击弹窗外部的手势事件
- (void)outsideTap:(UITapGestureRecognizer *)recognizer {
    if (self.shouldDismissOnOutsideTapped) {
        [self dismiss]; // 如果允许点击外部关闭弹窗，则调用dismiss方法
    }
}

// 将弹窗视图添加到指定视图中并执行显示动画
- (void)addThisViewToView:(UIView *)view {
    NSTimeInterval timeAppear = (self.appearTime > 0) ? self.appearTime : 0.2; // 获取显示动画时间，默认0.2秒
    NSTimeInterval timeDelay = 0; // 动画延迟时间，默认无延迟

    [view addSubview:self]; // 将弹窗视图添加到指定视图中
    
    // 根据不同的动画类型执行对应的显示动画
    if (self.appearAnimationType == ZHHAlertViewAnimationTypeDefault) {
        // 默认动画：从1.1倍缩放到原始大小，并逐渐显示
        self.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.alpha = 0.6;
        [UIView animateWithDuration:timeAppear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformIdentity;
            self.alpha = 1;
        } completion:^(BOOL finished){
            [self didAppearAlertView]; // 动画完成后的回调
        }];
    } else if (self.appearAnimationType == ZHHAlertViewAnimationTypeZoomIn) {
        // 缩放动画：从0.01倍缩放到原始大小
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:timeAppear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            [self didAppearAlertView];
        }];
    } else if (self.appearAnimationType == ZHHAlertViewAnimationTypeFadeIn) {
        // 渐隐动画：从完全透明到不透明
        self.alpha = 0;
        [UIView animateWithDuration:timeAppear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished){
            [self didAppearAlertView];
        }];
    } else if (self.appearAnimationType == ZHHAlertViewAnimationTypeFlyTop) {
        // 从顶部飞入动画
        CGRect tmpFrame = self.frame;
        self.frame = CGRectMake(self.frame.origin.x, -self.frame.size.height - 10, self.frame.size.width, self.frame.size.height);
        [UIView animateWithDuration:timeAppear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = tmpFrame;
        } completion:^(BOOL finished){
            [self didAppearAlertView];
        }];
    } else if (self.appearAnimationType == ZHHAlertViewAnimationTypeFlyBottom) {
        // 从底部飞入动画
        CGRect tmpFrame = self.frame;
        self.frame = CGRectMake(self.frame.origin.x, view.frame.size.height + 10, self.frame.size.width, self.frame.size.height);
        [UIView animateWithDuration:timeAppear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = tmpFrame;
        } completion:^(BOOL finished){
            [self didAppearAlertView];
        }];
    } else if (self.appearAnimationType == ZHHAlertViewAnimationTypeFlyLeft) {
        // 从左侧飞入动画
        CGRect tmpFrame = self.frame;
        self.frame = CGRectMake(-self.frame.size.width - 10, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        [UIView animateWithDuration:timeAppear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = tmpFrame;
        } completion:^(BOOL finished){
            [self didAppearAlertView];
        }];
    } else if (self.appearAnimationType == ZHHAlertViewAnimationTypeFlyRight) {
        // 从右侧飞入动画
        CGRect tmpFrame = self.frame;
        self.frame = CGRectMake(view.frame.size.width + 10, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        [UIView animateWithDuration:timeAppear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = tmpFrame;
        } completion:^(BOOL finished){
            [self didAppearAlertView];
        }];
    } else if (self.appearAnimationType == ZHHAlertViewAnimationTypeNone) {
        // 无动画，直接显示视图
        [self didAppearAlertView];
    }
}

// 隐藏并移除弹窗视图
- (void)dismiss {
    NSTimeInterval timeDisappear = (self.disappearTime > 0) ? self.disappearTime : 0.08; // 获取消失动画时间，默认0.08秒
    NSTimeInterval timeDelay = 0.02; // 动画延迟时间，默认0.02秒

    // 根据不同的动画类型执行对应的消失动画
    if (self.disappearAnimationType == ZHHAlertViewAnimationTypeDefault) {
        // 默认动画：逐渐淡出
        self.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:timeDisappear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished){
            [self removeFromSuperview]; // 动画完成后移除视图
        }];
    } else if (self.disappearAnimationType == ZHHAlertViewAnimationTypeZoomOut) {
        // 缩放动画：从原始大小缩小到0.01倍
        self.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:timeDisappear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    } else if (self.disappearAnimationType == ZHHAlertViewAnimationTypeFadeOut) {
        // 渐隐动画：从完全不透明到透明
        self.alpha = 1;
        [UIView animateWithDuration:timeDisappear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    } else if (self.disappearAnimationType == ZHHAlertViewAnimationTypeFlyTop) {
        // 向上飞出动画
        [UIView animateWithDuration:timeDisappear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectMake(self.frame.origin.x, -self.frame.size.height - 10, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    } else if (self.disappearAnimationType == ZHHAlertViewAnimationTypeFlyBottom) {
        // 向下飞出动画
        [UIView animateWithDuration:timeDisappear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectMake(self.frame.origin.x, self.superview.frame.size.height + 10, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    } else if (self.disappearAnimationType == ZHHAlertViewAnimationTypeFlyLeft) {
        // 向左飞出动画
        [UIView animateWithDuration:timeDisappear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectMake(-self.frame.size.width - 10, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    } else if (self.disappearAnimationType == ZHHAlertViewAnimationTypeFlyRight) {
        // 向右飞出动画
        [UIView animateWithDuration:timeDisappear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectMake(self.superview.frame.size.width + 10, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    } else if (self.disappearAnimationType == ZHHAlertViewAnimationTypeNone) {
        // 无动画，直接移除视图
        [self removeFromSuperview];
    }
    
    // 移除黑色不透明背景视图（如果有）
    if (self.blackOpaqueView) {
        [UIView animateWithDuration:timeDisappear animations:^{
            self.blackOpaqueView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.blackOpaqueView removeFromSuperview];
        }];
    }
}

#pragma mark - 设置 Alert View

- (void)setContentView:(UIView *)contentView {
    if (!self.title && !self.content) {
        self.buttonHeight = 0;
    }
    self.alertContentView = contentView;
    hasContentView = YES;
    
    // 设置宽高
    self.width = contentView.frame.size.width;
    self.height = contentView.frame.size.height + self.buttonHeight;
    
    // 设置 contentView 的 frame 并添加到 self 中
    contentView.frame = contentView.bounds;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.width, self.height);
    [self addSubview:contentView];
}

- (UIView *)contentView {
    return self.alertContentView;
}

- (void)setCenter:(CGPoint)center {
    [super setCenter:center];
    hasModifiedFrame = YES;
}

- (void)setCustomFrame:(CGRect)frame {
    [super setFrame:frame];
    self.width = frame.size.width;
    self.height = frame.size.height;
    hasModifiedFrame = YES;
    [self calculateFrame];
}

- (void)calculateFrame {
    BOOL hasButton = (self.cancelButtonTitle || self.otherButtonTitle);

    // 计算内容区域的 frame
    if (!hasContentView) {
        if (!hasModifiedFrame) {
            UIFont *titleFont = self.titleLabel.font ? self.titleLabel.font : [UIFont systemFontOfSize:14];
            UIFont *contentFont = self.contentLabel.font ? self.contentLabel.font : [UIFont systemFontOfSize:14];
            
            CGSize maximumLabelSize = CGSizeMake(self.width - self.contentLeftRightPadding * 2, FLT_MAX);
            
            CGRect titleRect = [self.title boundingRectWithSize:maximumLabelSize
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName: titleFont}
                                                        context:nil];
            
            CGRect textRect = [self.content boundingRectWithSize:maximumLabelSize
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName: contentFont}
                                                        context:nil];
            
            CGFloat titleHeight = titleRect.size.height + 16;
            self.titleHeight = titleHeight > DEFAULT_TITLE_HEIGHT ? titleHeight : DEFAULT_TITLE_HEIGHT;
            CGFloat contentHeight = textRect.size.height;
            
            CGFloat newHeight = contentHeight + self.titleHeight + self.buttonHeight + self.titleTopPadding + self.titleBottomPadding + self.contentBottomPadding;
            self.height = newHeight;
            
            CGFloat mainHeight = [UIScreen mainScreen].bounds.size.height;
            CGFloat maxHeight = mainHeight / 3 * 1.5;
            if (newHeight > maxHeight) {
                self.height = maxHeight + self.titleHeight + self.buttonHeight + self.titleTopPadding + self.titleBottomPadding + self.contentBottomPadding;
            }
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.height);
        }
        
        // 标题和消息框的 frame 计算
        if (!self.title) {
            titleLabelFrame = CGRectZero;
        } else {
            if (!self.content || self.content.length == 0) {
                self.titleHeight = 61;
            }
            titleLabelFrame = CGRectMake(self.contentLeftRightPadding,
                                         self.titleTopPadding,
                                         self.width - self.contentLeftRightPadding * 2,
                                         self.titleHeight);
        }
        
        if (!self.content) {
            contentLabelFrame = CGRectZero;
        } else {
            CGFloat titleMaxY = CGRectGetMaxY(titleLabelFrame); // 获取标题标签的最大Y值
            CGFloat contentWidth = self.width - 2 * self.contentLeftRightPadding; // 计算内容宽度
            CGFloat contentHeight = self.height - titleLabelFrame.size.height - self.titleTopPadding - self.titleBottomPadding; // 计算基本的内容高度

            if (hasButton) {
                contentHeight -= self.buttonHeight; // 如果有按钮，减去按钮的高度
            }

            contentLabelFrame = CGRectMake(self.contentLeftRightPadding, titleMaxY + self.titleBottomPadding, contentWidth, contentHeight);
        }
        
        if (!self.title || self.title.length == 0) {
            contentLabelFrame = CGRectMake(self.contentLeftRightPadding, 0, self.width - self.contentLeftRightPadding * 2, self.height - self.buttonHeight);
        }
    }
    
    // 分隔线和按钮的 frame 计算
    if (self.hideSeperator || !hasButton) {
        verticalSeparatorFrame = CGRectZero;
        horizontalSeparatorFrame = CGRectZero;
    } else {
        verticalSeparatorFrame = CGRectMake((self.width-0.5) / 2, self.height - self.buttonHeight, 0.5, self.buttonHeight);
        horizontalSeparatorFrame = CGRectMake(0, self.height - self.buttonHeight, self.width, 0.5);
    }
    
    // 取消按钮和其他按钮的 frame 计算
    if (!self.cancelButtonTitle) {
        cancelButtonFrame = CGRectZero;
    } else if (!self.otherButtonTitle) {
        verticalSeparatorFrame = CGRectZero;
        cancelButtonFrame = CGRectMake(0,
                                       self.height - self.buttonHeight,
                                       self.width,
                                       self.buttonHeight);
    } else if (!self.cancelButtonPositionRight) {
        cancelButtonFrame = CGRectMake(0,
                                       self.height - self.buttonHeight,
                                       self.width / 2,
                                       self.buttonHeight);
    } else {
        cancelButtonFrame = CGRectMake(self.width / 2,
                                       self.height - self.buttonHeight,
                                       self.width / 2,
                                       self.buttonHeight);
    }
    
    if (!self.otherButtonTitle) {
        otherButtonFrame = CGRectZero;
    } else if (!self.cancelButtonTitle) {
        verticalSeparatorFrame = CGRectZero;
        otherButtonFrame = CGRectMake(0,
                                      self.height - self.buttonHeight,
                                      self.width,
                                      self.buttonHeight);
    } else if (!self.cancelButtonPositionRight) {
        otherButtonFrame = CGRectMake(self.width / 2,
                                      self.height - self.buttonHeight,
                                      self.width / 2,
                                      self.buttonHeight);
    } else {
        otherButtonFrame = CGRectMake(0,
                                      self.height - self.buttonHeight,
                                      self.width / 2,
                                      self.buttonHeight);
    }
    
    // 当没有按钮时调整高度
    if (!self.otherButtonTitle && !self.cancelButtonTitle) {
        cancelButtonFrame = CGRectZero;
        otherButtonFrame = CGRectZero;
        
        self.height -= self.buttonHeight;
        self.buttonHeight = 0;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.height);
    }
}

- (void)setupItems {
    // 初始化各个UI组件
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero]; // 标题标签
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero]; // 消息标签
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom]; // 取消按钮
    self.otherButton = [UIButton buttonWithType:UIButtonTypeCustom]; // 其他按钮
    self.scrollView = [[UIScrollView alloc] init]; // 滚动视图

    // 设置标题标签
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.text = self.title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];

    // 设置滚动视图
    self.scrollView.delegate = self;
    self.scrollView.bounces = YES;
    self.scrollView.backgroundColor = UIColor.clearColor;
    self.scrollView.alwaysBounceVertical = YES; // 允许垂直方向上的弹性滚动
    self.scrollView.showsVerticalScrollIndicator = NO; // 隐藏垂直滚动条
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // 设置消息标签
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    if (!self.title) {
        self.contentLabel.font = self.titleLabel.font;
    }
    self.contentLabel.text = self.content;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.backgroundColor = [UIColor clearColor];

    // 设置取消按钮
    self.cancelButton.backgroundColor = [UIColor clearColor];
    [self.cancelButton setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    
    UIImage *image = [self zhh_imageNamed:@"divider_highlighted"];
    [self.cancelButton setBackgroundImage:image forState:UIControlStateHighlighted];
    [self.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    // 设置其他按钮
    self.otherButton.backgroundColor = [UIColor clearColor];
    [self.otherButton setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    self.otherButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.otherButton setTitle:self.otherButtonTitle forState:UIControlStateNormal];
    [self.otherButton setBackgroundImage:image forState:UIControlStateHighlighted];
    [self.otherButton addTarget:self action:@selector(otherButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    // 设置分割线
    self.horizontalSeparator = [[UIView alloc] initWithFrame:CGRectZero]; // 水平分割线
    self.verticalSeparator = [[UIView alloc] initWithFrame:CGRectZero]; // 垂直分割线
}

- (UIImage *)zhh_imageNamed:(NSString *)imageName {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

- (void)setupViews {
    // 设置背景
    if (self.backgroundImage) {
        // 如果有背景图片，使用该图片设置背景
        [self setBackgroundColor:[UIColor colorWithPatternImage:self.backgroundImage]];
    } else if (self.backgroundColor) {
        // 如果有背景颜色，使用该颜色设置背景
        [self setBackgroundColor:self.backgroundColor];
    } else {
        // 否则，使用默认的白色背景
        [self setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    }
    
    // 设置边框宽度
    if (self.borderWidth) {
        self.layer.borderWidth = self.borderWidth;
    }
    // 设置边框颜色
    if (self.borderColor) {
        self.layer.borderColor = self.borderColor.CGColor;
    } else {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
    // 设置圆角半径
    self.layer.cornerRadius = self.cornerRadius;
    
    // 设置各个组件的布局框架
    self.titleLabel.frame = titleLabelFrame;
    self.contentLabel.frame = contentLabelFrame;
    self.cancelButton.frame = cancelButtonFrame;
    self.otherButton.frame = otherButtonFrame;
    
    self.horizontalSeparator.frame = horizontalSeparatorFrame;
    self.verticalSeparator.frame = verticalSeparatorFrame;
    
    // 设置分割线颜色
    if (self.separatorColor) {
        self.horizontalSeparator.backgroundColor = self.separatorColor;
        self.verticalSeparator.backgroundColor = self.separatorColor;
    } else {
        // 使用默认的分割线颜色
        if (@available(iOS 13.0, *)) {
            self.horizontalSeparator.backgroundColor = [UIColor separatorColor];
            self.verticalSeparator.backgroundColor = [UIColor separatorColor];
        } else {
            // Fallback on earlier versions
            self.horizontalSeparator.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:67.0/255 alpha:0.29];
            self.verticalSeparator.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:67.0/255 alpha:0.29];
        }
    }
    
    // 根据标题调整消息标签的大小，使其适应边界
    if (self.title) {
        [self.contentLabel sizeToFit];
        CGRect myFrame = self.contentLabel.frame;
        CGFloat mainHeight = [UIScreen mainScreen].bounds.size.height;
        /// 最大高度
        CGFloat maxHeight = mainHeight/3*1.5;
        if (myFrame.size.height > maxHeight) {
            maxHeight = maxHeight - 10;
            self.scrollView.scrollEnabled = YES; // 当内容超过最大高度时，开启滚动功能
        } else {
            maxHeight = self.contentLabel.frame.size.height;
            self.scrollView.scrollEnabled = NO; // 内容未超过最大高度，禁用滚动
        }
        myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, self.width -  2 * self.contentLeftRightPadding, maxHeight);
        self.scrollView.frame = myFrame;
        self.scrollView.contentSize = CGSizeMake(myFrame.origin.x, self.contentLabel.frame.size.height + 1);
        self.contentLabel.frame = CGRectMake(0, 0, myFrame.size.width, self.contentLabel.frame.size.height);
    }
    
    // 添加子视图
    if (!hasContentView) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.contentLabel];
    }
    
    [self addSubview:self.cancelButton];
    [self addSubview:self.otherButton];
    [self addSubview:self.horizontalSeparator];
    [self addSubview:self.verticalSeparator];
}

#pragma mark - Touch Event

// 处理取消按钮按下事件
- (void)cancelButtonTouchBegan:(id)sender {
    // 保存取消按钮的原始背景颜色，并将其背景颜色设置为透明度为0.1的颜色，以便在按钮被按下时显示效果
    self.originCancelButtonColor = [self.cancelButton.backgroundColor colorWithAlphaComponent:0];
    self.cancelButton.backgroundColor = [self.cancelButton.backgroundColor colorWithAlphaComponent:.1];
}

// 处理取消按钮抬起事件
- (void)cancelButtonTouchEnded:(id)sender {
    // 恢复取消按钮的背景颜色
    self.cancelButton.backgroundColor = self.originCancelButtonColor;
}

// 处理其他按钮按下事件
- (void)otherButtonTouchBegan:(id)sender {
    // 保存其他按钮的原始背景颜色，并将其背景颜色设置为透明度为0.1的颜色，以便在按钮被按下时显示效果
    self.originOtherButtonColor = [self.otherButton.backgroundColor colorWithAlphaComponent:0];
    self.otherButton.backgroundColor = [self.otherButton.backgroundColor colorWithAlphaComponent:.1];
}

// 处理其他按钮抬起事件
- (void)otherButtonTouchEnded:(id)sender {
    // 恢复其他按钮的背景颜色
    self.otherButton.backgroundColor = self.originOtherButtonColor;
}

#pragma mark - Actions

// 设置取消按钮和其他按钮的点击处理块
- (void)actionWithBlocksCancelButtonHandler:(void (^)(void))cancelHandler otherButtonHandler:(void (^)(void))otherHandler {
    self.cancelButtonAction = cancelHandler;
    self.otherButtonAction = otherHandler;
}

// 处理取消按钮点击事件
- (void)cancelButtonClicked:(id)sender {
    if (self.buttonClickedHighlight) {
        // 如果设置了点击高亮效果，将取消按钮的背景颜色设置为透明度为0.1的颜色，并在延迟0.2秒后恢复原始颜色
        UIColor * originColor = [self.cancelButton.backgroundColor colorWithAlphaComponent:0];
        self.cancelButton.backgroundColor = [self.cancelButton.backgroundColor colorWithAlphaComponent:.1];
        double delayInSeconds = .2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.cancelButton.backgroundColor = originColor;
        });
    }

    // 关闭视图
    [self dismiss];
    
    // 执行取消按钮的点击处理块
    if (self.cancelButtonAction) {
        self.cancelButtonAction();
    }
    
    // 通知委托取消按钮被点击
    if ([self.delegate respondsToSelector:@selector(cancelButtonClickedOnAlertView:)]) {
        [self.delegate cancelButtonClickedOnAlertView:self];
    }
}

// 处理其他按钮点击事件
- (void)otherButtonClicked:(id)sender {
    if (self.buttonClickedHighlight) {
        // 如果设置了点击高亮效果，将其他按钮的背景颜色设置为透明度为0.1的颜色，并在延迟0.2秒后恢复原始颜色
        UIColor * originColor = [self.otherButton.backgroundColor colorWithAlphaComponent:0];
        self.otherButton.backgroundColor = [self.otherButton.backgroundColor colorWithAlphaComponent:.1];
        double delayInSeconds = .2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.otherButton.backgroundColor = originColor;
        });
    }
    
    // 根据设置决定是否关闭视图
    if (self.shouldDismissOnActionButtonClicked) {
        [self dismiss];
    }
    
    // 执行其他按钮的点击处理块
    if (self.otherButtonAction) {
        self.otherButtonAction();
    }
    
    // 通知委托其他按钮被点击
    if ([self.delegate respondsToSelector:@selector(otherButtonClickedOnAlertView:)]) {
        [self.delegate otherButtonClickedOnAlertView:self];
    }
}

// 通知委托视图已经出现
- (void)didAppearAlertView {
    if ([self.delegate respondsToSelector:@selector(didAppearAlertView:)]) {
        [self.delegate didAppearAlertView:self];
    }
}

// 通知委托视图即将出现
- (void)willAppearAlertView {
    if ([self.delegate respondsToSelector:@selector(willAppearAlertView:)]) {
        [self.delegate willAppearAlertView:self];
    }
}

@end

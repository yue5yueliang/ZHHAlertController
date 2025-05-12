//
//  ZHHAlertViewController.m
//  ZHHAlertViewController
//
//  Created by 桃色三岁 on 2022/4/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHAlertViewController.h"
#import "ZHHAlertViewHelper.h"

#define DEFAULT_ALERT_WIDTH 270
#define DEFAULT_ALERT_HEIGHT 156
#define DEFAULT_TITLE_HEIGHT 20

// 枚举化方向，避免字符串对比
typedef NS_ENUM(NSInteger, ZHHAlertViewDirection) {
    ZHHAlertViewDirectionTop,
    ZHHAlertViewDirectionBottom,
    ZHHAlertViewDirectionLeft,
    ZHHAlertViewDirectionRight
};

@interface ZHHAlertViewController () <UIScrollViewDelegate> {
    // 元素布局缓存
    CGRect titleLabelFrame;           ///< 标题标签的布局框
    CGRect contentLabelFrame;         ///< 内容标签的布局框
    CGRect cancelButtonFrame;         ///< 取消按钮的布局框
    CGRect otherButtonFrame;          ///< 其他按钮的布局框

    // 分隔线布局缓存
    CGRect verticalSeparatorFrame;    ///< 竖直分隔线的布局框
    CGRect horizontalSeparatorFrame;  ///< 水平分隔线的布局框

    // 状态标识
    BOOL hasCustomFrame;            ///< 标识是否自定义了布局
    BOOL hasCustomContentView;              ///< 标识是否设置了 contentView
}

// 弹窗容器视图
@property (nonatomic, strong) UIView *customContentView;

// 分隔线视图
@property (nonatomic, strong) UIView *horizontalSeparator;
@property (nonatomic, strong) UIView *verticalSeparator;

// 背景遮罩视图（非模糊，纯黑透明背景）
@property (nonatomic, strong) UIView *backgroundDimView;

// 标题与正文内容
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;

// 按钮标题
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSString *otherButtonTitle;

// 内容滚动容器
@property (nonatomic, strong, readwrite) UIScrollView *scrollView;

// 标题区高度（用于布局计算）
@property (nonatomic, assign) CGFloat titleHeight;

// 弹窗整体尺寸缓存
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

// 按钮颜色缓存，用于点击高亮后恢复
@property (nonatomic, strong) UIColor *originalCancelButtonColor;
@property (nonatomic, strong) UIColor *originalOtherButtonColor;

@end

@implementation ZHHAlertViewController

#pragma mark - Init Methods

// 初始化方法：传入 frame 参数
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化代码
    }
    return self;
}

// 初始化方法：支持多个按钮标题
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
    
    // 初始化弹窗控制器
    if ([self initWithTitle:title content:content cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitles]) {
        self.delegate = delegate;
        return self;
    }
    
    return nil;
}

// 初始化方法：基本属性设置
- (instancetype)initWithTitle:(NSString * _Nullable)title content:(NSString * _Nullable)content cancelButtonTitle:(NSString * _Nullable)cancelButtonTitle otherButtonTitle:(NSString * _Nullable)otherButtonTitle {
    self.width = DEFAULT_ALERT_WIDTH;
    self.height = DEFAULT_ALERT_HEIGHT;
    
    self = [super initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    if (self) {
        // 初始化基本属性
        self.clipsToBounds = YES;
        self.title = title;
        self.content = content;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitle = otherButtonTitle;
        
        // 设置默认动画类型
        self.appearAnimationType = ZHHAlertViewAnimationTypeDefault;
        self.disappearAnimationType = ZHHAlertViewAnimationTypeDefault;
        
        // 设置默认布局参数
        self.cornerRadius = 8; // 圆角半径
        self.shouldHighlightButtonOnClick = YES; // 按钮点击时高亮
        self.buttonHeight = 44;// 按钮高度
        self.titleTopPadding = 14;// 标题与内容间距
        self.titleHeight = DEFAULT_TITLE_HEIGHT;// 标题高度
        self.titleBottomPadding = 2;// 内容底部间距
        self.contentBottomPadding = 20;// 内容底部间距
        self.contentLeftRightPadding = 20;// 内容左右间距
        
        self.shouldDimBackgroundWhenShowInWindow = YES; // 是否显示背景变暗
        self.shouldDismissOnActionButtonClicked = YES; // 点击按钮后是否自动消失
        self.dimAlpha = 0.4; // 背景变暗透明度
    }
    return self;
}

#pragma mark - Show & Dismiss Methods

// 显示弹窗视图在指定视图中
- (void)showInView:(UIView *_Nonnull)view {
    [self calculateFrame]; // 计算视图的布局框架
    [self setupViews]; // 设置视图
    
    if (!hasCustomFrame) {
        // 默认居中显示弹窗
        self.frame = CGRectMake((view.frame.size.width - self.frame.size.width) / 2, (view.frame.size.height - self.frame.size.height) / 2, self.frame.size.width, self.frame.size.height);
    }

    // 显示背景变暗效果（如果需要）
    if (self.shouldDimBackgroundWhenShowInView && view != [ZHHAlertViewHelper keyWindow]) {

        self.backgroundDimView = [[UIView alloc] initWithFrame:[ZHHAlertViewHelper keyWindow].bounds];
        self.backgroundDimView.backgroundColor = [UIColor colorWithWhite:0 alpha:self.dimAlpha];
        
        // 添加点击外部关闭弹窗的手势识别器
        UITapGestureRecognizer *outsideTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(outsideTap:)];
        [self.backgroundDimView addGestureRecognizer:outsideTapGesture];
        [view addSubview:self.backgroundDimView];
    }
    
    // 弹窗将要显示时的预处理
    [self alertViewWillAppear];
    
    // 将弹窗视图添加到指定视图
    [self addThisViewToView:view];
}

#pragma mark - 设置 Alert View

- (void)setContentView:(UIView *)contentView {
    if (!self.title && !self.content) {
        self.buttonHeight = 0;
    }
    self.customContentView = contentView;
    hasCustomContentView = YES;
    
    // 设置宽高
    self.width = contentView.frame.size.width;
    self.height = contentView.frame.size.height + self.buttonHeight;
    
    // 设置 contentView 的 frame 并添加到 self 中
    contentView.frame = contentView.bounds;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.width, self.height);
    [self addSubview:contentView];
}

- (UIView *)contentView {
    return self.customContentView;
}

- (void)setCenter:(CGPoint)center {
    [super setCenter:center];
    hasCustomFrame = YES;
}

- (void)setCustomFrame:(CGRect)frame {
    [super setFrame:frame];
    self.width = frame.size.width;
    self.height = frame.size.height;
    hasCustomFrame = YES;
    [self calculateFrame];
}

- (void)calculateFrame {
    BOOL hasButton = (self.cancelButtonTitle || self.otherButtonTitle);

    // 计算内容区域的 frame
    if (!hasCustomContentView) {
        if (!hasCustomFrame) {
            UIFont *titleFont = self.titleLabel.font ?: [UIFont systemFontOfSize:14];
            UIFont *contentFont = self.contentLabel.font ?: [UIFont systemFontOfSize:14];
            
            CGSize maximumLabelSize = CGSizeMake(self.width - self.contentLeftRightPadding * 2, FLT_MAX);
            
            CGRect titleRect = [self.title boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: titleFont} context:nil];
            CGRect textRect = [self.content boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: contentFont} context:nil];
            
            CGFloat titleHeight = titleRect.size.height + 16;
            self.titleHeight = MAX(titleHeight, DEFAULT_TITLE_HEIGHT);
            CGFloat contentHeight = textRect.size.height;
            
            CGFloat newHeight = contentHeight + self.titleHeight + self.buttonHeight + self.titleTopPadding + self.titleBottomPadding + self.contentBottomPadding;
            self.height = newHeight;
            
            // 限制最大高度
            CGFloat mainHeight = [UIScreen mainScreen].bounds.size.height;
            CGFloat maxHeight = mainHeight / 3 * 1.5;
            self.height = MIN(newHeight, maxHeight + self.titleHeight + self.buttonHeight + self.titleTopPadding + self.titleBottomPadding + self.contentBottomPadding);
            
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.height);
        }
        
        // 标题的 frame 计算
        if (self.title.length > 0) {
            titleLabelFrame = CGRectMake(self.contentLeftRightPadding, self.titleTopPadding, self.width - self.contentLeftRightPadding * 2, self.titleHeight);
        } else {
            titleLabelFrame = CGRectZero;
        }
        
        // 内容的 frame 计算
        if (self.content.length > 0) {
            CGFloat titleMaxY = CGRectGetMaxY(titleLabelFrame);
            CGFloat contentHeight = self.height - titleLabelFrame.size.height - self.titleTopPadding - self.titleBottomPadding - (hasButton ? self.buttonHeight : 0);
            NSLog(@"contentHeight -- %F",contentHeight);
            contentLabelFrame = CGRectMake(self.contentLeftRightPadding, titleMaxY + self.titleBottomPadding, self.width - 2 * self.contentLeftRightPadding, contentHeight);
        } else {
            contentLabelFrame = CGRectZero;
        }
    }

    // 计算分隔线的 frame
    if (self.hideSeperator || !hasButton) {
        verticalSeparatorFrame = CGRectZero;
        horizontalSeparatorFrame = CGRectZero;
    } else {
        verticalSeparatorFrame = CGRectMake((self.width - 0.5) / 2, self.height - self.buttonHeight, 0.5, self.buttonHeight);
        horizontalSeparatorFrame = CGRectMake(0, self.height - self.buttonHeight, self.width, 0.5);
    }

    // 计算按钮的 frame
    [self calculateButtonFrames];
    
    // 如果没有按钮，调整高度
    if (!self.cancelButtonTitle && !self.otherButtonTitle) {
        cancelButtonFrame = CGRectZero;
        otherButtonFrame = CGRectZero;
        self.height -= self.buttonHeight;
        self.buttonHeight = 0;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.height);
    }
}

- (void)calculateButtonFrames {
    // 取消按钮 frame
    if (!self.cancelButtonTitle) {
        cancelButtonFrame = CGRectZero;
    } else {
        if (!self.otherButtonTitle) {
            verticalSeparatorFrame = CGRectZero;
            cancelButtonFrame = CGRectMake(0, self.height - self.buttonHeight, self.width, self.buttonHeight);
        } else if (!self.cancelButtonPositionRight) {
            cancelButtonFrame = CGRectMake(0, self.height - self.buttonHeight, self.width / 2, self.buttonHeight);
        } else {
            cancelButtonFrame = CGRectMake(self.width / 2, self.height - self.buttonHeight, self.width / 2, self.buttonHeight);
        }
    }

    // 其他按钮 frame
    if (!self.otherButtonTitle) {
        otherButtonFrame = CGRectZero;
    } else {
        if (!self.cancelButtonTitle) {
            verticalSeparatorFrame = CGRectZero;
            otherButtonFrame = CGRectMake(0, self.height - self.buttonHeight, self.width, self.buttonHeight);
        } else if (!self.cancelButtonPositionRight) {
            otherButtonFrame = CGRectMake(self.width / 2, self.height - self.buttonHeight, self.width / 2, self.buttonHeight);
        } else {
            otherButtonFrame = CGRectMake(0, self.height - self.buttonHeight, self.width / 2, self.buttonHeight);
        }
    }
}

- (void)setupViews {
    
    // 设置背景色
    if (self.backgroundImage) {
        self.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
    } else if (self.backgroundColor) {
        // self.backgroundColor 已存在直接赋值没意义，可保留
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }

    // 设置边框和圆角
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = self.borderColor ? self.borderColor.CGColor : [UIColor clearColor].CGColor;
    self.layer.cornerRadius = self.cornerRadius;

    // 设置初始 frame（用于 sizeToFit 之前的调试）
    self.titleLabel.frame = titleLabelFrame;
    self.contentLabel.frame = contentLabelFrame;
    self.cancelButton.frame = cancelButtonFrame;
    self.otherButton.frame = otherButtonFrame;
    self.horizontalSeparator.frame = horizontalSeparatorFrame;
    self.verticalSeparator.frame = verticalSeparatorFrame;

    // 🔍 打印初始 contentLabel 高度
    NSLog(@"[初始] contentLabel.frame = %@", NSStringFromCGRect(self.contentLabel.frame));

    // 设置分割线颜色
    UIColor *sepColor = self.separatorColor ?: [UIColor separatorColor];
    self.horizontalSeparator.backgroundColor = sepColor;
    self.verticalSeparator.backgroundColor = sepColor;

    // 处理 contentLabel 的 size 和 scrollView（前提是有 title 时）
    if (self.title) {
        
        [self.contentLabel sizeToFit];
        
        CGFloat contentWidth = self.contentLabel.frame.size.width;
        
        CGFloat labelHeight = self.contentLabel.frame.size.height;
//        labelHeight = labelHeight - 40;
//        NSLog(@"[初始] labelHeight = %f contentWidth - %f", labelHeight,contentWidth); // 打印计算出的 labelHeight
        
        CGFloat screenH = UIScreen.mainScreen.bounds.size.height;
        CGFloat maxHeight = screenH / 2.0;

        // 如果 contentLabel 的高度超过最大高度，启用 scrollView
        BOOL enableScroll = labelHeight > maxHeight;
        self.scrollView.scrollEnabled = enableScroll;

        CGFloat finalHeight = enableScroll ? maxHeight - 10 : labelHeight;
        
        // 设置 scrollView 的 frame
        self.scrollView.frame = CGRectMake(self.contentLeftRightPadding, CGRectGetMaxY(self.titleLabel.frame) + 10, contentWidth, finalHeight);

        // 设置 contentLabel 的最终 frame
        self.contentLabel.frame = CGRectMake(0, 0, contentWidth, labelHeight);
        
        // 设置 scrollView 的 contentSize
        self.scrollView.contentSize = CGSizeMake(contentWidth, labelHeight + 1); // 留一点余地
    }

    // 添加子视图
    if (!hasCustomContentView) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.contentLabel];
    }

    [self addSubview:self.cancelButton];
    [self addSubview:self.otherButton];
    [self addSubview:self.horizontalSeparator];
    [self addSubview:self.verticalSeparator];

    // 🔍 打印最终 contentLabel 高度
    NSLog(@"[最终] contentLabel.frame = %@", NSStringFromCGRect(self.contentLabel.frame));
}

// 在窗口中显示弹窗
- (void)show {
        
    // 如果需要在窗口中显示背景变暗效果
    if (self.shouldDimBackgroundWhenShowInWindow) {
        self.backgroundDimView = [[UIView alloc] initWithFrame:[ZHHAlertViewHelper keyWindow].bounds];
        self.backgroundDimView.backgroundColor = [UIColor colorWithWhite:0 alpha:self.dimAlpha];

        // 添加手势识别器，用于处理点击弹窗外部关闭弹窗的操作
        UITapGestureRecognizer *outsideTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(outsideTap:)];
        [self.backgroundDimView addGestureRecognizer:outsideTapGesture];
        [[ZHHAlertViewHelper keyWindow] addSubview:self.backgroundDimView];
    }
    
    // 在窗口中显示弹窗视图
    [self showInView:[ZHHAlertViewHelper keyWindow]];
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

// 执行飞入动画
- (void)performFlyInAnimationWithDirection:(ZHHAlertViewDirection)direction view:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    CGRect tmpFrame = self.frame;
    
    if (direction == ZHHAlertViewDirectionTop) {
        self.frame = CGRectMake(self.frame.origin.x, -self.frame.size.height - 10, self.frame.size.width, self.frame.size.height);
    } else if (direction == ZHHAlertViewDirectionBottom) {
        self.frame = CGRectMake(self.frame.origin.x, view.frame.size.height + 10, self.frame.size.width, self.frame.size.height);
    } else if (direction == ZHHAlertViewDirectionLeft) {
        self.frame = CGRectMake(-self.frame.size.width - 10, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } else if (direction == ZHHAlertViewDirectionRight) {
        self.frame = CGRectMake(view.frame.size.width + 10, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }

    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = tmpFrame;
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
    CGRect frame = self.frame;
    if (direction == ZHHAlertViewDirectionTop) {
        frame.origin.y = -frame.size.height - 10;
    } else if (direction == ZHHAlertViewDirectionBottom) {
        frame.origin.y = self.superview.frame.size.height + 10;
    } else if (direction == ZHHAlertViewDirectionLeft) {
        frame.origin.x = -frame.size.width - 10;
    } else if (direction == ZHHAlertViewDirectionRight) {
        frame.origin.x = self.superview.frame.size.width + 10;
    }

    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Touch Event

// 处理取消按钮按下事件
- (void)cancelButtonTouchBegan:(id)sender {
    // 保存取消按钮的原始背景颜色，并将其背景颜色设置为透明度为0.1的颜色，以便在按钮被按下时显示效果
    self.originalCancelButtonColor = [self.cancelButton.backgroundColor colorWithAlphaComponent:0];
    self.cancelButton.backgroundColor = [self.cancelButton.backgroundColor colorWithAlphaComponent:.1];
}

// 处理取消按钮抬起事件
- (void)cancelButtonTouchEnded:(id)sender {
    // 恢复取消按钮的背景颜色
    self.cancelButton.backgroundColor = self.originalCancelButtonColor;
}

// 处理其他按钮按下事件
- (void)otherButtonTouchBegan:(id)sender {
    // 保存其他按钮的原始背景颜色，并将其背景颜色设置为透明度为0.1的颜色，以便在按钮被按下时显示效果
    self.originalOtherButtonColor = [self.otherButton.backgroundColor colorWithAlphaComponent:0];
    self.otherButton.backgroundColor = [self.otherButton.backgroundColor colorWithAlphaComponent:.1];
}

// 处理其他按钮抬起事件
- (void)otherButtonTouchEnded:(id)sender {
    // 恢复其他按钮的背景颜色
    self.otherButton.backgroundColor = self.originalOtherButtonColor;
}

#pragma mark - 按钮点击事件处理

// 设置取消按钮和其他按钮的点击处理块
- (void)actionWithBlocksCancelButtonHandler:(void (^)(void))cancelHandler otherButtonHandler:(void (^)(void))otherHandler {
    self.cancelButtonAction = cancelHandler;
    self.otherButtonAction = otherHandler;
}

// 处理取消按钮点击事件
- (void)cancelButtonClicked:(id)sender {
    // 如果设置了点击高亮效果，应用高亮效果
    if (self.shouldHighlightButtonOnClick) {
        [ZHHAlertViewHelper applyHighlightEffectToButton:self.cancelButton];
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
        [ZHHAlertViewHelper applyHighlightEffectToButton:self.otherButton];
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.text = self.title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.bounces = YES;
        _scrollView.backgroundColor = UIColor.clearColor;
        _scrollView.alwaysBounceVertical = YES; // 允许垂直方向上的弹性滚动
        _scrollView.showsVerticalScrollIndicator = NO; // 隐藏垂直滚动条
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _scrollView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        // 设置消息标签
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:13];
//        if (!self.title) {
//            self.contentLabel.font = self.titleLabel.font;
//        }
        _contentLabel.text = self.content;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.backgroundColor = [UIColor clearColor];
    }
    return _contentLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        
        [_cancelButton setBackgroundImage:[ZHHAlertViewHelper imageNamed:@"divider_highlighted"] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)otherButton {
    if (!_otherButton) {
        _otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_otherButton setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        _otherButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_otherButton setTitle:self.otherButtonTitle forState:UIControlStateNormal];
        [_otherButton setBackgroundImage:[ZHHAlertViewHelper imageNamed:@"divider_highlighted"] forState:UIControlStateHighlighted];
        [_otherButton addTarget:self action:@selector(otherButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _otherButton;
}

- (UIView *)horizontalSeparator {
    if (!_horizontalSeparator) {
        _horizontalSeparator = [[UIView alloc] init];
    }
    return _horizontalSeparator;
}

- (UIView *)verticalSeparator {
    if (!_verticalSeparator) {
        _verticalSeparator = [[UIView alloc] init];
    }
    return _verticalSeparator;
}

@end

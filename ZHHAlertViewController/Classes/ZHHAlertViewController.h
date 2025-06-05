//
//  ZHHAlertViewController.h
//  ZHHAlertViewController
//
//  Created by 桃色三岁 on 2022/4/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZHHAlertViewControllerDelegate;

typedef NS_ENUM(NSInteger, ZHHAlertViewAnimationType) {
    ZHHAlertViewAnimationTypeNone        = 0,  ///< 无动画
    ZHHAlertViewAnimationTypeDefault     = 1,  ///< 默认动画（淡入淡出）
    ZHHAlertViewAnimationTypeFadeIn      = 2,  ///< 淡入动画
    ZHHAlertViewAnimationTypeFadeOut     = 3,  ///< 淡出动画
    ZHHAlertViewAnimationTypeFlyTop      = 4,  ///< 从顶部飞入
    ZHHAlertViewAnimationTypeFlyBottom   = 5,  ///< 从底部飞入
    ZHHAlertViewAnimationTypeFlyLeft     = 6,  ///< 从左侧飞入
    ZHHAlertViewAnimationTypeFlyRight    = 7,  ///< 从右侧飞入
    ZHHAlertViewAnimationTypeZoomIn      = 8,  ///< 缩放进入
    ZHHAlertViewAnimationTypeZoomOut     = 9   ///< 缩放退出
};

@interface ZHHAlertAppearance : NSObject
/// 标题距父视图顶部的间距（默认 14pt）
@property (nonatomic, assign) CGFloat titleTopPadding;

/// 标题与内容之间的垂直间距（默认 2pt）
@property (nonatomic, assign) CGFloat titleBottomPadding;

/// 内容区域的左右内边距（标题和内容公用，默认 20pt）
@property (nonatomic, assign) CGFloat contentLeftRightPadding;

/// 按钮上方距内容下方的间距（默认 20pt）
@property (nonatomic, assign) CGFloat buttonTopPadding;

/// 按钮高度（默认 44pt）
@property (nonatomic, assign) CGFloat buttonHeight;

/// 按钮距父视图底部的间距（默认 0pt）
@property (nonatomic, assign) CGFloat buttonBottomPadding;

/// 按钮的左右内边距（默认 0pt）
@property (nonatomic, assign) CGFloat buttonLeftRightPadding;

/// 多个按钮之间的水平间距（默认 0pt）
@property (nonatomic, assign) CGFloat buttonSpacing;

// 弹窗尺寸缓存
@property (nonatomic, assign) CGFloat width;    ///< 弹窗宽度
@property (nonatomic, assign) CGFloat height;   ///< 弹窗高度

// 标题与正文内容
@property (nonatomic, strong) NSString *title;  ///< 标题内容
@property (nonatomic, strong) NSString *content;///< 文本内容

// 按钮标题
@property (nonatomic, strong) NSString *cancelButtonTitle;///< 取消按钮文字
@property (nonatomic, strong) NSString *otherButtonTitle; ///< 其他按钮文字
@end

typedef void (^ZHHAlertViewControllerBlock)(void);

@interface ZHHAlertViewController : UIView

#pragma mark - 公共属性

/// 自定义 Alert 的内容视图，大小决定 Alert 尺寸。
@property (nonatomic, strong) UIView *customContentView;// 包裹 titleLabel, scrollView

/// 按钮 & 标签（可自定义样式，文字内容由model去控制）
@property (nonatomic, strong) UIButton *cancelButton;   ///< 默认蓝色文字，系统字体 17
@property (nonatomic, strong) UIButton *otherButton;    ///< 默认蓝色文字，系统字体 17
@property (nonatomic, strong) UILabel *titleLabel;      ///< 默认黑色文字，系统粗体 17
@property (nonatomic, strong) UILabel *contentLabel;    ///< 默认灰色文字，系统字体 15

@property (nonatomic, assign) CGFloat cornerRadius;        ///< 默认 8

@property (nonatomic, strong) UIColor *separatorColor;     ///< 分隔线颜色，默认与系统一致

/// 弹窗动画配置
@property (nonatomic, assign) ZHHAlertViewAnimationType appearAnimationType;      ///< 弹出动画
@property (nonatomic, assign) ZHHAlertViewAnimationType disappearAnimationType;   ///< 消失动画
@property (nonatomic, assign) NSTimeInterval appearTime;       ///< 弹出动画时长，默认 0.2
@property (nonatomic, assign) NSTimeInterval disappearTime;    ///< 消失动画时长，默认 0.1

/// UI 行为配置
@property (nonatomic, assign) BOOL cancelButtonPositionRight;             ///< 是否将取消按钮显示在右侧，默认 NO
@property (nonatomic, assign) BOOL shouldHighlightButtonOnClick;          ///< 按钮点击是否高亮，默认 YES
@property (nonatomic, assign) BOOL shouldDismissOnActionButtonClicked;    ///< 点击按钮是否自动关闭 Alert，默认 YES
@property (nonatomic, assign) BOOL shouldDismissOnOutsideTapped;          ///< 点击外部区域是否关闭 Alert（仅模糊背景生效），默认 NO

/// 模糊背景配置
@property (nonatomic, assign) BOOL shouldDimBackgroundWhenShowInWindow;   ///< 是否在窗口中启用模糊背景，默认 YES
@property (nonatomic, assign) BOOL shouldDimBackgroundWhenShowInView;     ///< 是否在视图中禁用模糊背景，默认 NO
@property (nonatomic, assign) CGFloat dimAlpha;                           ///< 背景透明度，默认 0.4

/// 事件处理
@property (nonatomic, weak) id<ZHHAlertViewControllerDelegate> delegate;
@property (readwrite, copy) ZHHAlertViewControllerBlock cancelButtonAction;
@property (readwrite, copy) ZHHAlertViewControllerBlock otherButtonAction;

#pragma mark - 初始化方法

/// 初始化方法：传入 model，使用默认 frame
- (instancetype)initWithModel:(ZHHAlertAppearance *)model;

#pragma mark - 展示与隐藏

/// 显示在指定视图中
- (void)showInView:(UIView * _Nonnull)view;

/// 显示在当前窗口
- (void)show;

/// 关闭 Alert
- (void)dismiss;

@end

#pragma mark - Delegate 协议

@protocol ZHHAlertViewControllerDelegate <NSObject>

@optional

/// Alert 将要显示
- (void)alertViewWillAppear:(ZHHAlertViewController *)alertView;

/// Alert 已经显示
- (void)alertViewDidAppear:(ZHHAlertViewController *)alertView;

/// 用户点击了取消按钮
- (void)alertViewDidClickCancelButton:(ZHHAlertViewController *)alertView;

/// 用户点击了其他按钮
- (void)alertViewDidClickOtherButton:(ZHHAlertViewController *)alertView;

@end

NS_ASSUME_NONNULL_END

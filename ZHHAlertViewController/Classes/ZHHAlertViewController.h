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


typedef void (^ZHHAlertViewControllerBlock)(void);

@interface ZHHAlertViewController : UIView

#pragma mark - 视图相关属性

/// 自定义 Alert 的内容视图，大小决定 Alert 尺寸。
@property (nonatomic, strong) UIView *customContentView; ///< 包裹 titleLabel, scrollView

/// 按钮 & 标签（可自定义样式）
@property (nonatomic, strong) UIButton *cancelButton;   ///< 默认蓝色文字，系统字体 17
@property (nonatomic, strong) UIButton *otherButton;    ///< 默认蓝色文字，系统字体 17
@property (nonatomic, strong) UILabel *titleLabel;      ///< 默认黑色文字，系统粗体 17
@property (nonatomic, strong) UILabel *contentLabel;    ///< 默认灰色文字，系统字体 15

#pragma mark - 布局相关属性（间距 / 尺寸）

@property (nonatomic, assign) CGFloat titleTopPadding;         ///< 标题距父视图顶部的间距（默认 14pt）
@property (nonatomic, assign) CGFloat titleBottomPadding;      ///< 标题与正文内容之间的垂直间距（默认 2pt）
@property (nonatomic, assign) CGFloat contentLeftRightPadding; ///< 标题和正文共用的左右内边距（默认 20pt）

@property (nonatomic, assign) CGFloat buttonTopPadding;        ///< 按钮区域距正文底部的间距（默认 20pt）
@property (nonatomic, assign) CGFloat buttonBottomPadding;     ///< 按钮距父视图底部的间距（默认 0pt）
@property (nonatomic, assign) CGFloat buttonLeftRightPadding;  ///< 按钮区域左右内边距（默认 0pt）
@property (nonatomic, assign) CGFloat buttonSpacing;           ///< 多个按钮之间的水平间距（默认 0pt）

@property (nonatomic, assign) CGFloat buttonHeight;            ///< 按钮高度（默认 44pt）

@property (nonatomic, assign) CGFloat width;                   ///< 弹窗整体宽度（默认 284pt）
@property (nonatomic, assign) CGFloat height;                  ///< 弹窗整体高度（默认 135pt）

@property (nonatomic, assign) CGFloat cornerRadius;            ///< 弹窗圆角半径（默认 8pt）

#pragma mark - 文字内容相关属性

@property (nonatomic, copy, nullable) NSString *title;         ///< 标题文本
@property (nonatomic, copy, nullable) NSString *content;       ///< 正文内容文本

#pragma mark - 按钮文字相关属性

@property (nonatomic, copy, nullable) NSString *cancelButtonTitle; ///< 取消按钮文字
@property (nonatomic, copy, nullable) NSString *otherButtonTitle;  ///< 其他按钮文字

#pragma mark - 样式配置相关

@property (nonatomic, strong) UIColor *separatorColor;         ///< 分隔线颜色，默认与系统一致

#pragma mark - 动画配置

@property (nonatomic, assign) ZHHAlertViewAnimationType appearAnimationType;      ///< 弹出动画
@property (nonatomic, assign) ZHHAlertViewAnimationType disappearAnimationType;   ///< 消失动画
@property (nonatomic, assign) NSTimeInterval appearTime;       ///< 弹出动画时长，默认 0.2
@property (nonatomic, assign) NSTimeInterval disappearTime;    ///< 消失动画时长，默认 0.1

#pragma mark - 行为配置

@property (nonatomic, assign) BOOL cancelButtonPositionRight;             ///< 是否将取消按钮显示在右侧，默认 NO
@property (nonatomic, assign) BOOL shouldHighlightButtonOnClick;          ///< 按钮点击是否高亮，默认 YES
@property (nonatomic, assign) BOOL shouldDismissOnActionButtonClicked;    ///< 点击按钮是否自动关闭 Alert，默认 YES
@property (nonatomic, assign) BOOL shouldDismissOnOutsideTapped;          ///< 点击外部区域是否关闭 Alert（仅模糊背景生效），默认 NO

#pragma mark - 模糊背景配置

@property (nonatomic, assign) BOOL shouldDimBackgroundWhenShowInWindow;   ///< 是否在窗口中启用模糊背景，默认 YES
@property (nonatomic, assign) BOOL shouldDimBackgroundWhenShowInView;     ///< 是否在视图中禁用模糊背景，默认 NO
@property (nonatomic, assign) CGFloat dimAlpha;                           ///< 背景透明度，默认 0.4

#pragma mark - 事件处理相关

@property (nonatomic, weak) id<ZHHAlertViewControllerDelegate> delegate;   ///< 代理
@property (readwrite, copy) ZHHAlertViewControllerBlock cancelButtonAction; ///< 取消按钮回调
@property (readwrite, copy) ZHHAlertViewControllerBlock otherButtonAction;  ///< 其他按钮回调

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

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

#pragma mark - 公共属性

/// 自定义 Alert 显示区域，未设置时默认居中显示。不要直接使用 [UIView setFrame:]。
@property (nonatomic, assign) CGRect customFrame;

/// Alert 的内容视图，大小决定 Alert 尺寸。设置后无需指定 customFrame。
@property (nonatomic, strong) UIView *contentView;

/// Alert 的滚动容器（只读）
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;   ///< 默认蓝色文字，系统字体 16

/// 按钮 & 标签（可自定义样式）
@property (nonatomic, strong) UIButton *cancelButton;   ///< 默认蓝色文字，系统字体 16
@property (nonatomic, strong) UIButton *otherButton;    ///< 默认蓝色文字，系统字体 16
@property (nonatomic, strong) UILabel *titleLabel;      ///< 默认黑色文字，系统粗体 16
@property (nonatomic, strong) UILabel *contentLabel;    ///< 默认灰色文字，系统字体 14

/// UI 间距 & 尺寸
@property (nonatomic, assign) CGFloat buttonHeight;              ///< 默认 44
@property (nonatomic, assign) CGFloat titleTopPadding;           ///< 默认 14
@property (nonatomic, assign) CGFloat titleBottomPadding;        ///< 默认 2
@property (nonatomic, assign) CGFloat contentBottomPadding;      ///< 默认 20
@property (nonatomic, assign) CGFloat contentLeftRightPadding;   ///< 默认 20

/// 边框 & 圆角 & 背景
@property (nonatomic, strong) UIColor *borderColor;       ///< 默认无边框
@property (nonatomic, assign) CGFloat borderWidth;         ///< 默认 0
@property (nonatomic, assign) CGFloat cornerRadius;        ///< 默认 8
@property (nonatomic, strong) UIImage *backgroundImage;    ///< 自定义背景图，默认 nil

/// 分隔线
@property (nonatomic, assign) BOOL hideSeperator;          ///< 是否隐藏按钮分隔线，默认 NO
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
@property (nonatomic, assign) CGFloat dimAlpha;                           ///< 背景透明度，默认 0.2

/// 事件处理
@property (nonatomic, weak) id<ZHHAlertViewControllerDelegate> delegate;
@property (readwrite, copy) ZHHAlertViewControllerBlock cancelButtonAction;
@property (readwrite, copy) ZHHAlertViewControllerBlock otherButtonAction;

#pragma mark - 初始化方法

/// 标准初始化方法（支持 delegate & 可变按钮）
- (instancetype)initWithTitle:(NSString * _Nullable)title
                      content:(NSString * _Nullable)content
                     delegate:(id)delegate
           cancelButtonTitle:(NSString * _Nullable)cancelButtonTitle
           otherButtonTitles:(NSString *_Nullable)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/// 便捷初始化方法
- (instancetype)initWithTitle:(NSString * _Nullable)title
                      content:(NSString * _Nullable)content
           cancelButtonTitle:(NSString * _Nullable)cancelButtonTitle
            otherButtonTitle:(NSString * _Nullable)otherButtonTitle;

#pragma mark - 事件绑定方法

/// 使用 block 设置按钮回调（替代属性方式）
- (void)actionWithBlocksCancelButtonHandler:(void (^)(void))cancelHandler
                        otherButtonHandler:(void (^)(void))otherHandler;

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

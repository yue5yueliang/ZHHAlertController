//
//  ZHHAlertViewController.h
//  ZHHAlertViewController
//
//  Created by 桃色三岁 on 2022/4/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZHHAlertControllerDelegate;

typedef NS_ENUM(NSInteger, ZHHAlertControllerAnimationType) {
    ZHHAlertControllerAnimationTypeNone        = 0,  // 无动画
    ZHHAlertControllerAnimationTypeDefault     = 1,  // 默认动画
    ZHHAlertControllerAnimationTypeFadeIn      = 2,  // 淡入动画
    ZHHAlertControllerAnimationTypeFadeOut     = 3,  // 淡出动画
    ZHHAlertControllerAnimationTypeFlyTop      = 4,  // 从顶部飞入
    ZHHAlertControllerAnimationTypeFlyBottom   = 5,  // 从底部飞入
    ZHHAlertControllerAnimationTypeFlyLeft     = 6,  // 从左侧飞入
    ZHHAlertControllerAnimationTypeFlyRight    = 7,  // 从右侧飞入
    ZHHAlertControllerAnimationTypeZoomIn      = 8,  // 缩放进入
    ZHHAlertControllerAnimationTypeZoomOut     = 9   // 缩放退出
};

typedef void (^ZHHAlertControllerBlock)(void);

@interface ZHHAlertController : UIView

#pragma mark - 公共属性

// 自定义 Alert View 的显示区域，未设置时，Alert 将显示在视图中心。不要使用默认方法 [UIView setFrame:]
@property (nonatomic, assign) CGRect customFrame; // 默认与 UIAlertView 相同

// 设置 Alert View 的内容视图
// Alert View 的大小会根据内容视图的大小调整，因此无需设置 customFrame。如果不希望 Alert View 显示在中心，只需设置 Alert View 的 center 属性
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

// 可获取按钮和标签，以自定义其外观
@property (nonatomic, strong) UIButton *cancelButton; // 默认蓝色，系统字体 16
@property (nonatomic, strong) UIButton *otherButton; // 默认蓝色，系统字体 16
@property (nonatomic, strong) UILabel *titleLabel; // 默认黑色，系统粗体 16
@property (nonatomic, strong) UILabel *messageLabel; // 默认灰色，系统字体 14

// 设置按钮高度及元素的间距。消息标签的高度根据其文本和字体计算。
@property (nonatomic, assign) CGFloat buttonHeight; // 默认 44
@property (nonatomic, assign) CGFloat titleTopPadding; // 默认 14
@property (nonatomic, assign) CGFloat titleBottomPadding; // 默认 2
@property (nonatomic, assign) CGFloat messageBottomPadding; // 默认 20
@property (nonatomic, assign) CGFloat messageLeftRightPadding; // 默认 20

// 自定义背景和边框
@property (nonatomic, strong) UIColor *borderColor; // 默认无边框
@property (nonatomic, assign) CGFloat borderWidth; // 默认 0
@property (nonatomic, assign) CGFloat cornerRadius; // 默认 8
// 继承自 UIView @property (nonatomic, strong) UIColor *backgroundColor; // 默认与 UIAlertView 相同
@property (nonatomic, strong) UIImage *backgroundImage; // 默认 nil

// 自定义分隔线
@property (nonatomic, assign) BOOL hideSeperator; // 默认 NO
@property (nonatomic, strong) UIColor *separatorColor; // 默认与 UIAlertView 相同

// 自定义出现和消失的动画
@property (nonatomic, assign) ZHHAlertControllerAnimationType appearAnimationType;
@property (nonatomic, assign) ZHHAlertControllerAnimationType disappearAnimationType;
@property (nonatomic, assign) NSTimeInterval appearTime; // 默认 0.2
@property (nonatomic, assign) NSTimeInterval disappearTime; // 默认 0.1

// 设置为 YES 时，取消按钮会显示在右侧
@property (nonatomic, assign) BOOL cancelButtonPositionRight; // 默认 NO

// 设置为 NO 时，按钮点击时不会高亮
@property (nonatomic, assign) BOOL buttonClickedHighlight; // 默认 YES

// 默认情况下，点击其他按钮不会关闭 Alert，设置此属性为 YES 可更改此行为
@property (nonatomic, assign) BOOL shouldDismissOnActionButtonClicked; // 默认 YES

// 如果此属性为 YES，点击外部区域时将关闭 Alert（仅在启用模糊背景时生效）
@property (nonatomic, assign) BOOL shouldDismissOnOutsideTapped; // 默认 NO

// 当显示在窗口中时，模糊背景始终启用
@property (nonatomic, assign) BOOL shouldDimBackgroundWhenShowInWindow; // 默认 YES

// 当显示在视图中时，模糊背景始终禁用
@property (nonatomic, assign) BOOL shouldDimBackgroundWhenShowInView; // 默认 NO

// 模糊背景的默认颜色为黑色，alpha 为 0.2
@property (nonatomic, assign) CGFloat dimAlpha; // 默认与 UIAlertView 相同

// 委托
@property (nonatomic, weak) id<ZHHAlertControllerDelegate> delegate;

// 按钮点击事件处理
@property (readwrite, copy) ZHHAlertControllerBlock cancelButtonAction;
@property (readwrite, copy) ZHHAlertControllerBlock otherButtonAction;

#pragma mark - 公共方法

// 初始化方法，类似 UIAlertView
// 当前版本的 Alert 不支持多个其他按钮
// 如果标题传 nil，Alert 将无标题。如果其他按钮标题传 nil，Alert 将仅有取消按钮。将所有按钮标题设置为 nil 可移除所有按钮。
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString * _Nullable)cancelButtonTitle otherButtonTitles:(NSString *_Nullable)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

// 初始化便捷方法
// 如果标题传 nil，Alert 将无标题。如果其他按钮标题传 nil，Alert 将仅有取消按钮。将所有按钮标题设置为 nil 可移除所有按钮。
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString * _Nullable)cancelButtonTitle otherButtonTitle:(NSString * _Nullable)otherButtonTitle;

// 使用此方法替代直接设置属性:
// @property (readwrite, copy) ZHHAlertControllerBlock cancelButtonAction;
// @property (readwrite, copy) ZHHAlertControllerBlock otherButtonAction;
- (void)actionWithBlocksCancelButtonHandler:(void (^)(void))cancelHandler otherButtonHandler:(void (^)(void))otherHandler;

// 在指定视图中显示
// 如果未设置 customFrame，Alert 将显示在视图中心
- (void)showInView:(UIView *)view;

// 在窗口中显示
// 如果未设置 customFrame，Alert 将显示在窗口中心
- (void)show;

// 关闭 Alert
- (void)dismiss;

@end

// ZHHAlertControllerDelegate 协议
@protocol ZHHAlertControllerDelegate <NSObject>

@optional
- (void)willAppearAlertView:(ZHHAlertController *)alertView;
- (void)didAppearAlertView:(ZHHAlertController *)alertView;

- (void)cancelButtonClickedOnAlertView:(ZHHAlertController *)alertView;
- (void)otherButtonClickedOnAlertView:(ZHHAlertController *)alertView;

@end

NS_ASSUME_NONNULL_END
